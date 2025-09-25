import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:tdk_reference_app/application/services/storage/file_upload_service.dart';

import 'package:tdk_reference_app/infrastructure/utils/constants.dart';
import 'package:tdk_reference_app/domain/models/profile/profile_type.dart';
import 'package:tdk_reference_app/l10n/app_localizations.dart';
import 'package:tdk_reference_app/main.dart' as app;
import 'package:tdk_reference_app/presentation/pages/create_vault_page/create_vault_page_state.dart';

import 'mocks.dart';
import 'test_utils.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> pumpUntilFound(Finder finder,
      {Duration timeout = const Duration(seconds: 10)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
      if (any(finder)) return;
    }
    throw Exception('Widget not found within $timeout');
  }
}

/// ---------------------------------
/// Test Scenario
/// ---------------------------------

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Scenario 1: Vault Creation + Profiles Flow', () {
    setUp(() async {
      await initializeDateFormatting('en');
      await TestUtils.clearAll();
    });

    testWidgets(
        'User can create vaults, profiles, manage files and share profile',
        (tester) async {
      final localizations =
          await AppLocalizations.delegate.load(const Locale('en'));
      final mockFilePicker = MockFilePicker();

      // Launch the app with mock file picker
      await tester.pumpWidget(
        ProviderScope(
          overrides: [filePickerProvider.overrideWithValue(mockFilePicker)],
          child: const app.MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // ----------------------
      // Vault Creation
      // ----------------------
      await _createVaultHelper(
        tester,
        localizations: localizations,
        vaultName: 'Vault 1',
        passphrase: 'mypassword',
      );
      await _createVaultHelper(
        tester,
        localizations: localizations,
        vaultName: 'Vault 3',
        passphrase: 'mypassword',
      );

      // Swipe to delete Vault 3
      await tester.drag(find.text('Vault 3'), const Offset(-300.0, 0.0));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Vault 3'), findsNothing);

      // ----------------------
      // Vault 1 → Login & Profiles
      // ----------------------
      await _loginVault(tester, localizations, 'Vault 1', 'mypassword');

      await _createProfileHelper(
        tester,
        localizations: localizations,
        profileName: 'Cloud Profile',
        description: 'Profile Description',
      );
      await _createProfileHelper(
        tester,
        localizations: localizations,
        profileName: 'Drift Profile',
        description: 'Profile Description',
        type: ProfileType.edge,
      );

      // Delete Drift Profile
      await tester.tap(find.text('Drift Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(KeyConstants.keySettingsButton)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(KeyConstants.keyDeleteProfiletButton)));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.delete));
      await tester.pumpAndSettle();
      expect(find.text('Drift Profile'), findsNothing);

      // Navigate back to VaultsPage
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      // ----------------------
      // Vault 2 → Create with seed
      // ----------------------
      await _createVaultHelper(
        tester,
        localizations: localizations,
        vaultName: 'Vault 2',
        passphrase: 'mypassword',
        seedMode: SeedMode.useExisting,
        seedString: TestUtils.randomString(16),
      );

      await _loginVault(tester, localizations, 'Vault 2', 'mypassword');

      await _createProfileHelper(
        tester,
        localizations: localizations,
        profileName: 'Cloud Profile',
        description: 'Profile Description',
      );

      // Folder & file operations
      await tester.tap(find.text('Cloud Profile'));
      await tester.pumpAndSettle();

      await _createFolder(
          tester: tester, localizations: localizations, name: 'Test Folder 1');
      await _renameFileOrFolder(
        tester: tester,
        localizations: localizations,
        fileName: 'Test Folder 1',
        newFileName: 'Test Folder',
      );
      await _deleteFileOrFolder(
          tester: tester,
          localizations: localizations,
          fileName: 'Test Folder');

      await _createFolder(
          tester: tester, localizations: localizations, name: 'Test Folder 2');
      await _uploadFile(
          tester: tester,
          mockFilePicker: mockFilePicker,
          name: 'test_image.jpg',
          mimeType: 'image/jpeg');
      await _uploadFile(
          tester: tester,
          mockFilePicker: mockFilePicker,
          name: 'file2.txt',
          mimeType: 'text/plain');
      await _renameFileOrFolder(
        tester: tester,
        localizations: localizations,
        fileName: 'file2.txt',
        newFileName: 'file.txt',
      );
      await _deleteFileOrFolder(
          tester: tester, localizations: localizations, fileName: 'file.txt');

      // Navigate back to VaultsPage
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      // ----------------------
      // Profile Sharing
      // ----------------------
      await _loginVault(tester, localizations, 'Vault 1', 'mypassword');
      await tester.tap(find.text('Cloud Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(localizations.copy)); // Copy DID
      await tester.pumpAndSettle();

      // Navigate back to VaultsPage
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      await _loginVault(tester, localizations, 'Vault 2', 'mypassword');
      await tester.tap(find.text('Cloud Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(KeyConstants.keyShareButton)));
      await tester.pumpAndSettle();

      final did = (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
      await tester.enterText(
          find.byKey(Key(KeyConstants.keyEnterDiDTextField)), did);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(KeyConstants.keyCanWriteRadio)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key(KeyConstants.keyShareSubmitButton)));
      await tester.pumpAndSettle();

      // Navigate back to VaultsPage
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      // Verify share in Vault 1
      await _loginVault(tester, localizations, 'Vault 1', 'mypassword');
      await tester.tap(find.text('Cloud Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(localizations.shared));
      await tester.pumpAndSettle();
      await tester.pumpUntilFound(find.textContaining('Shared from'));
      await tester.tap(find.textContaining('Shared from'));
      await tester.pumpAndSettle();
    });
  });
}

Future<void> _createVaultHelper(
  WidgetTester tester, {
  required AppLocalizations localizations,
  required String vaultName,
  required String passphrase,
  SeedMode? seedMode,
  String? seedString,
}) async {
  // Wait for Vaults page
  await tester.pumpUntilFound(find.text(localizations.addVault));

  // Tap + Add Vault
  await tester.tap(find.text(localizations.addVault));
  await tester.pumpUntilFound(find.text(localizations.createVault));

  // Fill in Vault Name & Passphrase
  await tester.enterText(
      find.bySemanticsLabel(localizations.giveYourVaultAName), vaultName);
  await tester.enterText(
      find.bySemanticsLabel(localizations.chooseAPassphrase), passphrase);
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();

  if (seedMode == SeedMode.useExisting) {
    await tester
        .tap(find.byKey(Key('${KeyConstants.keyRadio}_${seedMode?.name}')));
    await tester
        .pumpUntilFound(find.bySemanticsLabel(localizations.enterSeedHint));
    await tester.enterText(find.bySemanticsLabel(localizations.enterSeedHint),
        seedString ?? 'seedString');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
  }

  // Tap Create Vault
  await tester.tap(find.text(localizations.createVault));
  await tester.pumpAndSettle();

  // Verify vault created
  await tester.pumpUntilFound(find.text(vaultName),
      timeout: const Duration(seconds: 15));
  expect(find.text(vaultName), findsOneWidget);

  // Navigate back to VaultsPage
  await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
  await tester.pumpAndSettle();
  expect(find.text(vaultName), findsOneWidget);
}

Future<void> _createProfileHelper(
  WidgetTester tester, {
  required AppLocalizations localizations,
  required String profileName,
  required String description,
  ProfileType? type,
}) async {
  // Tap Create Profile
  await tester.pumpUntilFound(find.text(localizations.createProfile),
      timeout: const Duration(seconds: 15));
  await tester.tap(find.text(localizations.createProfile));
  await tester.pumpAndSettle();

  // Fill in profile details
  await tester.enterText(
      find.bySemanticsLabel(localizations.profileNamePlaceholder), profileName);
  await tester.enterText(
      find.bySemanticsLabel(localizations.profileDescriptionPlaceholder),
      description);
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();

  // Select radio if provided
  if (type != null) {
    await tester.tap(find.byKey(Key('${KeyConstants.keyRadio}_${type.name}')));
    await tester.pumpAndSettle();
  }

  // Tap Create button
  await tester.tap(find.text(localizations.createProfileActionText));
  await tester.pumpAndSettle();

  // Verify profile is created
  await tester.pumpUntilFound(find.text(profileName),
      timeout: const Duration(seconds: 15));
  expect(find.text(profileName), findsOneWidget);
  await tester.pumpAndSettle();
}

Future<void> _createFolder({
  required WidgetTester tester,
  required AppLocalizations localizations,
  String name = 'Default Folder',
}) async {
  // Tap the "create folder" button
  await tester.tap(find.byKey(Key(KeyConstants.keyCreateFolderButton)));
  await tester.pumpAndSettle();

  // Enter folder name
  await tester.enterText(find.byType(TextField), name);
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();

  // Tap confirm (localized action button)
  await tester.tap(find.byKey(Key(KeyConstants.keyCreateFolderSubmitButton)));
  await tester.pumpAndSettle();

  // Verify folder appears
  // await tester.pumpUntilFound(find.text(name), timeout: const Duration(seconds: 15));
  expect(find.text(name), findsOneWidget);
  await tester.pumpAndSettle();
}

Future<void> _uploadFile({
  required WidgetTester tester,
  required MockFilePicker mockFilePicker,
  String name = 'test_image.jpg',
  String mimeType = 'image/jpeg',
}) async {
  mocktail
      .when(() => mockFilePicker.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: [
              'jpg',
              'jpeg',
              'pdf',
              'png',
              'txt',
              'gif',
              'doc',
              'docx',
              'xls',
              'xlsx',
              'json',
              'xml',
              'html',
              'css',
              'js',
              'md',
            ],
          ))
      .thenAnswer((_) async {
    // Create a real temp file
    final file = await TestUtils.createTempXFile(name, mimeType);

    // Wrap into FilePickerResult
    return FilePickerResult([
      PlatformFile(
        name: name,
        size: (await file.length()),
        path: file.path,
        bytes: await file.readAsBytes(),
      ),
    ]);
  });

  // Trigger upload
  await tester.tap(find.byKey(Key(KeyConstants.keyUploadFilesButton)));
  await tester.pumpAndSettle();

  // Verify upload result
  expect(find.text(name), findsOneWidget);
}

Future<void> _renameFileOrFolder({
  required WidgetTester tester,
  required AppLocalizations localizations,
  String fileName = 'test_image.jpg',
  required String newFileName,
}) async {
  await tester
      .tap(find.byKey(Key('${KeyConstants.keyOptionButton}_$fileName')));
  await tester.pumpAndSettle();
  await tester.tap(
      find.widgetWithText(IconButtonTheme, localizations.renameActionText));
  await tester.pumpAndSettle();
  await tester.enterText(
      find.byKey(Key(KeyConstants.keyRenameTextField)), newFileName);
  await tester.tap(find.text(localizations.renameActionText));
  expect(find.text(newFileName), findsOneWidget);
  await tester.pumpAndSettle();
}

Future<void> _deleteFileOrFolder({
  required WidgetTester tester,
  required AppLocalizations localizations,
  String fileName = 'test_image.jpg',
}) async {
  await tester.pumpUntilFound(
      find.byKey(Key('${KeyConstants.keyOptionButton}_$fileName')));
  await tester
      .tap(find.byKey(Key('${KeyConstants.keyOptionButton}_$fileName')));
  await tester.pumpAndSettle();
  await tester.tap(
      find.widgetWithText(IconButtonTheme, localizations.deleteActionText));
  await tester.pumpAndSettle();
  await tester.tap(find.text(localizations.deleteActionText));
  await tester.pumpAndSettle();
  expect(find.text(fileName), findsNothing);
  await tester.pumpAndSettle();
}

/// Factor out repeated login flow
Future<void> _loginVault(
  WidgetTester tester,
  AppLocalizations localizations,
  String vaultName,
  String passphrase,
) async {
  await tester.tap(find.text(vaultName));
  await tester.pumpAndSettle();
  await tester.enterText(
      find.bySemanticsLabel(localizations.enterPassphrase), passphrase);
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.tap(find.text(localizations.accessVaultActionLabel));
  await tester.pumpAndSettle();
}
