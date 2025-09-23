import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/loading_status/modal_async_loading_status.dart';
import '../../widgets/tdk_app_bar.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import '../../widgets/simple_info_widget.dart';

import 'create_vault_page_controller.dart';
import 'create_vault_page_state.dart';
import '../vaults_page/vaults_page_controller.dart';

class CreateVaultPage extends HookConsumerWidget {
  static String get routePath => VaultsRoutePath.create;

  const CreateVaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final passwordController = useTextEditingController();
    final vaultNameController = useTextEditingController();
    final seedController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final isVaultNameFocused = useState(false);
    final isPassphraseFocused = useState(false);
    final isSeedFocused = useState(false);
    final isSeedVisible = useState(false);
    useState(false);
    useState(false);

    final state = ref.watch(createVaultPageControllerProvider);
    final controller = ref.read(createVaultPageControllerProvider.notifier);
    final navigation = ref.read(navigationServiceProvider);

    void proceed() async {
      if (passwordController.text.trim().isNotEmpty &&
          vaultNameController.text.trim().isNotEmpty) {
        await controller.createVault(
          vaultName: vaultNameController.text,
          password: passwordController.text,
          seed: state.seedMode == SeedMode.useExisting
              ? seedController.text
              : null,
          onSuccess: (vault, vaultId) {
            ref
                .read(vaultsPageControllerProvider.notifier)
                .addVault(vaultId, vault);
            if (!context.mounted) return;
            navigation.go(ProfilesRoutePath.base);
          },
          onError: ({errorType}) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorType != null &&
                          errorType == AppExceptionType.vaultAlreadyExists
                      ? localizations.vaultExistsErrorMessage
                      : localizations.createVaultErrorMessage,
                ),
              ),
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundWhite,
      appBar: TdkAppBar(
        showBackButton: true,
        onBackPressed: () {
          navigation.pop(VaultsRoutePath.base);
        },
        actions: [
          CodeSnippetWidget(
            title: localizations.lblCSCreateVault,
            codeLocations: CodeSnippetLocations.createVaultSnippets(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: AppSizing.paddingMedium,
                  right: AppSizing.paddingLarge,
                  top: AppSizing.paddingSmall,
                  bottom: AppSizing.paddingRegular),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: AppSizing.paddingXXLarge,
                        left: AppSizing.paddingSmall),
                    child: Text(
                      localizations.createYourVault.substring(
                          0, localizations.createYourVault.lastIndexOf(' ')),
                      style: AppTheme.headingXLarge,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: AppSizing.paddingSmall),
                    child: SimpleInfoWidget(
                      text: localizations.createYourVault
                          .split(' ')
                          .skip(2)
                          .join(' '),
                      dialogTitle: localizations.infoVaultAttr,
                      dialogContent: localizations.infoVaultAttrDescription,
                      textStyle: AppTheme.headingXLarge,
                    ),
                  ),
                ],
              ),
            ),
            // Separator
            Container(
              height: 1.0,
              color: AppColorScheme.divider,
            ),
            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizing.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ModalAsyncLoadingStatus(
                      controller.loadingController,
                      loadingMessage: localizations.creatingNewVault,
                    ),
                    Form(
                      onChanged: () => controller.validateForm(
                        vaultName: vaultNameController.text,
                        password: passwordController.text,
                        seed: seedController.text,
                        seedMode: state.seedMode,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vault Name field
                          Text(
                            '${localizations.vaultName}*',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppSizing.paddingSmall),
                          FormField<String>(
                            builder: (field) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isVaultNameFocused.value
                                        ? AppColorScheme.formFieldBorderFocused
                                        : AppColorScheme
                                            .formFieldBorderUnfocused,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppSizing.paddingSmall),
                                ),
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    isVaultNameFocused.value = hasFocus;
                                  },
                                  child: TextField(
                                    controller: vaultNameController,
                                    onChanged: (_) => field.didChange(
                                      vaultNameController.text,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          localizations.giveYourVaultAName,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(
                                          AppSizing.paddingRegular),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSizing.paddingLarge),
                          // Passphrase field
                          Text(
                            '${localizations.vaultPassphrase}*',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppSizing.paddingSmall),
                          FormField<String>(
                            builder: (field) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isPassphraseFocused.value
                                        ? AppColorScheme.formFieldBorderFocused
                                        : AppColorScheme
                                            .formFieldBorderUnfocused,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppSizing.paddingSmall),
                                ),
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    isPassphraseFocused.value = hasFocus;
                                  },
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: !isPasswordVisible.value,
                                    onChanged: (_) => field.didChange(
                                      passwordController.text,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: localizations.chooseAPassphrase,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(
                                          AppSizing.paddingRegular),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isPasswordVisible.value
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: Colors.grey.shade600,
                                        ),
                                        onPressed: () {
                                          isPasswordVisible.value =
                                              !isPasswordVisible.value;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSizing.paddingMedium),
                          Row(
                            children: [
                              Radio<SeedMode>(
                                value: SeedMode.generate,
                                key: Key(
                                  'radio_${SeedMode.generate.name}',
                                ),
                                groupValue: state.seedMode,
                                onChanged: (value) {
                                  controller.updateSeedMode(value!);
                                  controller.validateForm(
                                    vaultName: vaultNameController.text,
                                    password: passwordController.text,
                                    seed: seedController.text,
                                    seedMode: value,
                                  );
                                },
                                activeColor: AppTheme.colorScheme.primary,
                              ),
                              Text(
                                localizations.generateRandomSeed,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: AppSizing.paddingSmall),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<SeedMode>(
                                value: SeedMode.useExisting,
                                key: Key(
                                  'radio_${SeedMode.useExisting.name}',
                                ),
                                groupValue: state.seedMode,
                                onChanged: (value) {
                                  controller.updateSeedMode(value!);
                                  controller.validateForm(
                                    vaultName: vaultNameController.text,
                                    password: passwordController.text,
                                    seed: seedController.text,
                                    seedMode: value,
                                  );
                                },
                                activeColor: AppTheme.colorScheme.primary,
                              ),
                              Text(
                                localizations.existingSeed,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: AppSizing.paddingXSmall),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          localizations.existingSeedMessage),
                                      backgroundColor:
                                          AppColorScheme.backgroundDark,
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  size: AppSizing.iconSmall,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizing.paddingXSmall),
                          Center(
                            child: SimpleInfoWidget(
                              text: localizations.infoSeed,
                              dialogTitle: localizations.infoSeed,
                              dialogContent: localizations.infoSeedDescription,
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),

                          if (state.seedMode == SeedMode.useExisting) ...[
                            const SizedBox(height: AppSizing.paddingMedium),
                            Text(
                              '${localizations.enterSeed}*',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppSizing.paddingSmall),
                            FormField<String>(
                              builder: (field) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSeedFocused.value
                                          ? AppColorScheme
                                              .formFieldBorderFocused
                                          : AppColorScheme
                                              .formFieldBorderUnfocused,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppSizing.paddingSmall),
                                  ),
                                  child: Focus(
                                    onFocusChange: (hasFocus) {
                                      isSeedFocused.value = hasFocus;
                                    },
                                    child: TextField(
                                      controller: seedController,
                                      obscureText: !isSeedVisible.value,
                                      onChanged: (_) => field.didChange(
                                        seedController.text,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: localizations.enterSeedHint,
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(
                                            AppSizing.paddingRegular),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isSeedVisible.value
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: Colors.grey.shade600,
                                          ),
                                          onPressed: () {
                                            isSeedVisible.value =
                                                !isSeedVisible.value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: AppSizing.paddingXLarge),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  state.isFormValid ? () => proceed() : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: state.isFormValid
                                    ? AppTheme.colorScheme.primary
                                    : Colors.grey.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSizing.paddingMedium),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSizing.paddingXXLarge),
                                ),
                              ),
                              child: Text(
                                localizations.createVault,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: AppColorScheme.backgroundWhite),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
