import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @myFiles.
  ///
  /// In en, this message translates to:
  /// **'My files'**
  String get myFiles;

  /// No description provided for @myCredentials.
  ///
  /// In en, this message translates to:
  /// **'Claimed credentials'**
  String get myCredentials;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @credentials.
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get credentials;

  /// No description provided for @driveTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get driveTitle;

  /// No description provided for @filesEmptyStateDescription.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any files yet.\nThe Home folder is your root directory.'**
  String get filesEmptyStateDescription;

  /// No description provided for @credentialsEmptyStateDescription.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any claimed credentials.'**
  String get credentialsEmptyStateDescription;

  /// No description provided for @retryActionText.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryActionText;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @okActionText.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get okActionText;

  /// No description provided for @renameFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename file'**
  String get renameFileTitle;

  /// No description provided for @renameFileDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a name for this file.'**
  String get renameFileDescription;

  /// No description provided for @cancelActionText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelActionText;

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get fileName;

  /// No description provided for @renameActionText.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameActionText;

  /// No description provided for @option.
  ///
  /// In en, this message translates to:
  /// **'{option, select, rename{Rename} preview{Preview} delete{Delete} share{Share} other{Unknown}}'**
  String option(String option);

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'{errorType, select, credential_offer_expired{Credential offer is expired} credential_offer_claimed_error{Credential offer is already claimed} failed_to_load_credentialOffer{Failed to load credentials} invalid_proof{The proof in the Credential Request is invalid} unmatched_tx_code{Transaction code does not match} folderNotEmpty{We cannot delete this folder because it\'s not empty. Please delete the files and try again.} nameAlreadyInUse{This name is already in use. Please choose a different one.} invalidPassword{Invalid password} emptyPassword{Password cannot be empty} invalidTransferData{Invalid transfer data} emptyTransferData{Missing transfer data} missingProfileName{Please enter a valid profile name} invalidUrl{Please enter a valid URL} getCredentialFailed{Failed to get credential data}other{Something went wrong}}'**
  String errorMessage(String errorType);

  /// No description provided for @createFolderActionText.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get createFolderActionText;

  /// No description provided for @createFolderLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Creating folder...'**
  String get createFolderLoadingMessage;

  /// No description provided for @renameFileLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Renaming file...'**
  String get renameFileLoadingMessage;

  /// No description provided for @createFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new folder'**
  String get createFolderTitle;

  /// No description provided for @folderName.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderName;

  /// No description provided for @deleteFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get deleteFolderTitle;

  /// No description provided for @deleteFolderDescription.
  ///
  /// In en, this message translates to:
  /// **'Please confirm deletion. This folder will be permanently removed and cannot be restored.'**
  String get deleteFolderDescription;

  /// No description provided for @deleteFolderActionText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteFolderActionText;

  /// No description provided for @deleteFolderLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting folder...'**
  String get deleteFolderLoadingMessage;

  /// No description provided for @deleteFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get deleteFileTitle;

  /// No description provided for @deleteFileActionText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteFileActionText;

  /// No description provided for @deleteFileLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting file...'**
  String get deleteFileLoadingMessage;

  /// No description provided for @deleteFileDescription.
  ///
  /// In en, this message translates to:
  /// **'Please confirm deletion. This file will be permanently removed and cannot be restored.'**
  String get deleteFileDescription;

  /// No description provided for @uploadingFileLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploadingFileLoadingMessage;

  /// No description provided for @fileUploadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {completed} {completed, plural, =1{file} other{files}} out of {total}.\n\nFiles that failed:\n{files}'**
  String fileUploadErrorMessage(String files, int completed, int total);

  /// No description provided for @loadingCredentials.
  ///
  /// In en, this message translates to:
  /// **'Preparing your credentials...'**
  String get loadingCredentials;

  /// No description provided for @claimCredentialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Claim credentials'**
  String get claimCredentialsTitle;

  /// No description provided for @verifiedCredentials.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED CREDENTIAL'**
  String get verifiedCredentials;

  /// No description provided for @issuanceDate.
  ///
  /// In en, this message translates to:
  /// **'Issuance date'**
  String get issuanceDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get expiryDate;

  /// No description provided for @credentialValidationLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get credentialValidationLoadingMessage;

  /// No description provided for @neverExpires.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get neverExpires;

  /// No description provided for @deleteCredentialActionText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteCredentialActionText;

  /// No description provided for @deleteCredentialTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete credential'**
  String get deleteCredentialTitle;

  /// No description provided for @deleteCredentialLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting credential...'**
  String get deleteCredentialLoadingMessage;

  /// No description provided for @deleteCredentialDescription.
  ///
  /// In en, this message translates to:
  /// **'Please confirm deletion. This credential will be permanently removed and cannot be restored.'**
  String get deleteCredentialDescription;

  /// No description provided for @renameFolderDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a name for this folder.'**
  String get renameFolderDescription;

  /// No description provided for @renameFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get renameFolderTitle;

  /// No description provided for @renameFolderLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Renaming folder...'**
  String get renameFolderLoadingMessage;

  /// No description provided for @claimCredentialsValidating.
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get claimCredentialsValidating;

  /// No description provided for @claimCredentialsSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get claimCredentialsSaving;

  /// No description provided for @claimCredentialsTxCode.
  ///
  /// In en, this message translates to:
  /// **' Transaction code'**
  String get claimCredentialsTxCode;

  /// No description provided for @saveActionText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveActionText;

  /// No description provided for @fetchActionText.
  ///
  /// In en, this message translates to:
  /// **'Fetch'**
  String get fetchActionText;

  /// No description provided for @verifiedData.
  ///
  /// In en, this message translates to:
  /// **'verified data'**
  String get verifiedData;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTitle;

  /// No description provided for @unsupportedPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview is not supported for this file type'**
  String get unsupportedPreview;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @createVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your Vault'**
  String get createVaultTitle;

  /// No description provided for @createVaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Use this option to create a brand new Vault.'**
  String get createVaultDescription;

  /// No description provided for @createVaultActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createVaultActionLabel;

  /// No description provided for @vaultExistsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'A vault with this seed already exists on this device'**
  String get vaultExistsErrorMessage;

  /// No description provided for @seed.
  ///
  /// In en, this message translates to:
  /// **'seed'**
  String get seed;

  /// No description provided for @createVaultErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to create new vault '**
  String get createVaultErrorMessage;

  /// No description provided for @openVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Open an existing Vault'**
  String get openVaultTitle;

  /// No description provided for @accessVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Access your Affinidi Vault'**
  String get accessVaultTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @openVaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Use this option to open a Vault you have already used on this device.'**
  String get openVaultDescription;

  /// No description provided for @accessVaultActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get accessVaultActionLabel;

  /// No description provided for @transferVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete a Vault transfer'**
  String get transferVaultTitle;

  /// No description provided for @transferVaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Use this option to start scanning the QR code you received and complete a transfer.'**
  String get transferVaultDescription;

  /// No description provided for @transferVaultActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get transferVaultActionLabel;

  /// No description provided for @scanQrCodeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Position the QR code within the frame to scan'**
  String get scanQrCodeInstructions;

  /// No description provided for @vaultName.
  ///
  /// In en, this message translates to:
  /// **'Vault Name'**
  String get vaultName;

  /// No description provided for @vaultPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get vaultPassphrase;

  /// No description provided for @enterPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Enter your passphrase'**
  String get enterPassphrase;

  /// No description provided for @generateRandomSeed.
  ///
  /// In en, this message translates to:
  /// **'Generate Random Seed'**
  String get generateRandomSeed;

  /// No description provided for @existingSeed.
  ///
  /// In en, this message translates to:
  /// **'Existing Seed'**
  String get existingSeed;

  /// No description provided for @enterSeed.
  ///
  /// In en, this message translates to:
  /// **'Enter Seed'**
  String get enterSeed;

  /// No description provided for @transferVaultLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Transferring vault...'**
  String get transferVaultLoadingMessage;

  /// No description provided for @transferVaultProceedActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer vault'**
  String get transferVaultProceedActionLabel;

  /// No description provided for @transferVaultScanActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Start scanning'**
  String get transferVaultScanActionLabel;

  /// No description provided for @creatingNewVault.
  ///
  /// In en, this message translates to:
  /// **'Creating a new Vault'**
  String get creatingNewVault;

  /// No description provided for @openingVault.
  ///
  /// In en, this message translates to:
  /// **'Opening Vault'**
  String get openingVault;

  /// No description provided for @credentialDetails.
  ///
  /// In en, this message translates to:
  /// **'Credential details'**
  String get credentialDetails;

  /// No description provided for @createProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new profile'**
  String get createProfileTitle;

  /// No description provided for @createProfileActionText.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createProfileActionText;

  /// No description provided for @createProfileLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Creating new profile...'**
  String get createProfileLoadingMessage;

  /// No description provided for @createProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the details for a new profile'**
  String get createProfileDescription;

  /// No description provided for @shareProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Sharing'**
  String get shareProfileTitle;

  /// No description provided for @shareProfileSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile shared successfully'**
  String get shareProfileSuccessMessage;

  /// No description provided for @shareProfileErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error sharing profile: {errorMessage}'**
  String shareProfileErrorMessage(Object errorMessage);

  /// No description provided for @shareProfileAcceptSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Shared profile accepted successfully!'**
  String get shareProfileAcceptSuccessMessage;

  /// No description provided for @shareProfileAcceptErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error accepting shared profile: {errorMessage}'**
  String shareProfileAcceptErrorMessage(Object errorMessage);

  /// No description provided for @shareProfileAcceptActionText.
  ///
  /// In en, this message translates to:
  /// **'Accept Shared Profile'**
  String get shareProfileAcceptActionText;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get profileDescription;

  /// No description provided for @profilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profilesTitle;

  /// No description provided for @deleteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfileTitle;

  /// No description provided for @deleteProfileConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the profile \"{profileName}\"? This action cannot be undone.'**
  String deleteProfileConfirmationMessage(Object profileName);

  /// No description provided for @deleteActionText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteActionText;

  /// No description provided for @deleteProfileLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting profile...'**
  String get deleteProfileLoadingMessage;

  /// No description provided for @vaultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaults'**
  String get vaultsTitle;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'DID copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @shareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareProfile;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @shared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get shared;

  /// No description provided for @openPDF.
  ///
  /// In en, this message translates to:
  /// **'Open PDF in new tab'**
  String get openPDF;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @recipientDidLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient DID'**
  String get recipientDidLabel;

  /// No description provided for @pasteSharedProfileDtoJsonTitle.
  ///
  /// In en, this message translates to:
  /// **'Paste SharedProfileDto JSON'**
  String get pasteSharedProfileDtoJsonTitle;

  /// No description provided for @selectYourProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Your Profile'**
  String get selectYourProfileLabel;

  /// No description provided for @sharedProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Shared Profile Detail'**
  String get sharedProfileDetails;

  /// No description provided for @sharedProfileDtoJsonFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'SharedProfileDto JSON'**
  String get sharedProfileDtoJsonFieldLabel;

  /// No description provided for @folderLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder: {name}'**
  String folderLabel(Object name);

  /// No description provided for @fileLabel.
  ///
  /// In en, this message translates to:
  /// **'File: {name}'**
  String fileLabel(Object name);

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String idLabel(Object id);

  /// No description provided for @unknownItemType.
  ///
  /// In en, this message translates to:
  /// **'Unknown item type'**
  String get unknownItemType;

  /// No description provided for @noFilesOrFoldersFound.
  ///
  /// In en, this message translates to:
  /// **'No files or folders found'**
  String get noFilesOrFoldersFound;

  /// No description provided for @sharedFromLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared from: {storageId}'**
  String sharedFromLabel(Object storageId);

  /// No description provided for @storageTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Storage Type: {storageType}'**
  String storageTypeLabel(Object storageType);

  /// No description provided for @noSharedContentAvailable.
  ///
  /// In en, this message translates to:
  /// **'No shared content available.'**
  String get noSharedContentAvailable;

  /// No description provided for @tdkReferenceAppbarTitle.
  ///
  /// In en, this message translates to:
  /// **'TDK Reference'**
  String get tdkReferenceAppbarTitle;

  /// No description provided for @useQrData.
  ///
  /// In en, this message translates to:
  /// **'Use QR Data'**
  String get useQrData;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @vaultsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No vaults found. Create a new vault to get started.'**
  String get vaultsEmptyMessage;

  /// No description provided for @incorrectPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Wrong passphrase.'**
  String get incorrectPassphrase;

  /// No description provided for @profileTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Type'**
  String get profileTypeLabel;

  /// No description provided for @profileDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add your profile description...'**
  String get profileDescriptionPlaceholder;

  /// No description provided for @profileNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Give your profile a name'**
  String get profileNamePlaceholder;

  /// No description provided for @profileTypeAffinidiCloud.
  ///
  /// In en, this message translates to:
  /// **'Store in Affinidi Cloud'**
  String get profileTypeAffinidiCloud;

  /// No description provided for @profileTypeDrift.
  ///
  /// In en, this message translates to:
  /// **'Store in Drift (Local Storage)'**
  String get profileTypeDrift;

  /// No description provided for @profileNotice.
  ///
  /// In en, this message translates to:
  /// **'Profiles created using local storage cannot be shared.'**
  String get profileNotice;

  /// No description provided for @profileTypeChooseYourOwn.
  ///
  /// In en, this message translates to:
  /// **'Choose your own'**
  String get profileTypeChooseYourOwn;

  /// No description provided for @paginationPreviousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous Page'**
  String get paginationPreviousPage;

  /// No description provided for @paginationNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next Page'**
  String get paginationNextPage;

  /// No description provided for @paginationPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {pageNumber}'**
  String paginationPageLabel(Object pageNumber);

  /// No description provided for @profileSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettingsTitle;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdateSuccess;

  /// No description provided for @profileUpdateFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailure;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'url'**
  String get url;

  /// No description provided for @claimInputInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter claim link to fetch credential'**
  String get claimInputInstruction;

  /// No description provided for @profileNotDeletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Not Deleted'**
  String get profileNotDeletedTitle;

  /// No description provided for @profileNotDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'This profile contains files/folders. Please delete them before trying again.'**
  String get profileNotDeletedMessage;

  /// No description provided for @gotItActionText.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotItActionText;

  /// No description provided for @viewCodeSnippetsActionText.
  ///
  /// In en, this message translates to:
  /// **'View Code Snippets'**
  String get viewCodeSnippetsActionText;

  /// No description provided for @timeoutLoadingCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Timeout loading code from'**
  String get timeoutLoadingCodeMessage;

  /// No description provided for @errorLoadingCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Error loading code from'**
  String get errorLoadingCodeMessage;

  /// No description provided for @errorLoadingCodeSnippetsMessage.
  ///
  /// In en, this message translates to:
  /// **'Error loading code snippets'**
  String get errorLoadingCodeSnippetsMessage;

  /// No description provided for @profilesEmptyStateDescription.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any profiles yet. Start by creating one.'**
  String get profilesEmptyStateDescription;

  /// No description provided for @folderNotDeletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder Not Deleted'**
  String get folderNotDeletedTitle;

  /// No description provided for @folderNotDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'This folder contains files/folders. Please delete them before trying again.'**
  String get folderNotDeletedMessage;

  /// No description provided for @sharingProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Sharing your profile. Auto-accepts profile if from the same device.'**
  String get sharingProfileMessage;

  /// No description provided for @accessPermissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Access Permission'**
  String get accessPermissionLabel;

  /// No description provided for @canViewOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Can view only'**
  String get canViewOnlyLabel;

  /// No description provided for @canWriteLabel.
  ///
  /// In en, this message translates to:
  /// **'Can write'**
  String get canWriteLabel;

  /// No description provided for @recipientDidHint.
  ///
  /// In en, this message translates to:
  /// **'Enter DID here'**
  String get recipientDidHint;

  /// No description provided for @accessManagementLabel.
  ///
  /// In en, this message translates to:
  /// **'Access Management'**
  String get accessManagementLabel;

  /// No description provided for @noSharedDidsForProfile.
  ///
  /// In en, this message translates to:
  /// **'No shared DIDs for this profile.'**
  String get noSharedDidsForProfile;

  /// No description provided for @didLabel.
  ///
  /// In en, this message translates to:
  /// **'DID: {did}'**
  String didLabel(Object did);

  /// No description provided for @profileIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile ID: {profileId}'**
  String profileIdLabel(Object profileId);

  /// No description provided for @accessLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Access: {accessLevel}'**
  String accessLevelLabel(Object accessLevel);

  /// No description provided for @revokeAccessTooltip.
  ///
  /// In en, this message translates to:
  /// **'Revoke access'**
  String get revokeAccessTooltip;

  /// No description provided for @profileSharedMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile has been shared'**
  String get profileSharedMessage;

  /// No description provided for @sharedProfileJsonGeneratedMessage.
  ///
  /// In en, this message translates to:
  /// **'Shared profile JSON generated'**
  String get sharedProfileJsonGeneratedMessage;

  /// No description provided for @autoAcceptingMessage.
  ///
  /// In en, this message translates to:
  /// **'Auto-accepting the shared profile. This may take a few seconds.'**
  String get autoAcceptingMessage;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String genericError(Object error);

  /// No description provided for @setFilePermissions.
  ///
  /// In en, this message translates to:
  /// **'Set File Permissions'**
  String get setFilePermissions;

  /// No description provided for @filePermissions.
  ///
  /// In en, this message translates to:
  /// **'File Permissions'**
  String get filePermissions;

  /// No description provided for @fileFormatOptions.
  ///
  /// In en, this message translates to:
  /// **'File Format Options'**
  String get fileFormatOptions;

  /// No description provided for @acceptAllFormats.
  ///
  /// In en, this message translates to:
  /// **'Accept all formats'**
  String get acceptAllFormats;

  /// No description provided for @specifyAllowedFormats.
  ///
  /// In en, this message translates to:
  /// **'Specify allowed formats'**
  String get specifyAllowedFormats;

  /// No description provided for @typeFileFormatHere.
  ///
  /// In en, this message translates to:
  /// **'Type file format here'**
  String get typeFileFormatHere;

  /// No description provided for @fileSizeLimit.
  ///
  /// In en, this message translates to:
  /// **'File size limit'**
  String get fileSizeLimit;

  /// No description provided for @enterMaxFileSize.
  ///
  /// In en, this message translates to:
  /// **'Enter max file size in bytes'**
  String get enterMaxFileSize;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved!'**
  String get settingsSaved;

  /// No description provided for @invalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get invalidFormat;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File too large'**
  String get fileTooLarge;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'REFERENCE'**
  String get reference;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'APP'**
  String get app;

  /// No description provided for @myVaults.
  ///
  /// In en, this message translates to:
  /// **'My Vaults'**
  String get myVaults;

  /// No description provided for @builtWithAffinidiVaultTdk.
  ///
  /// In en, this message translates to:
  /// **'Built with Affinidi TDK - Vault'**
  String get builtWithAffinidiVaultTdk;

  /// No description provided for @addVault.
  ///
  /// In en, this message translates to:
  /// **'Create Vault'**
  String get addVault;

  /// No description provided for @giveYourVaultAName.
  ///
  /// In en, this message translates to:
  /// **'Give your vault a name'**
  String get giveYourVaultAName;

  /// No description provided for @chooseAPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Choose a passphrase'**
  String get chooseAPassphrase;

  /// No description provided for @createYourVault.
  ///
  /// In en, this message translates to:
  /// **'Create your vault'**
  String get createYourVault;

  /// No description provided for @createVault.
  ///
  /// In en, this message translates to:
  /// **'Create Vault'**
  String get createVault;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get createProfile;

  /// No description provided for @seedGenerationMessage.
  ///
  /// In en, this message translates to:
  /// **'A secure 32-byte seed will be generated. It\'s needed to create your Vault.'**
  String get seedGenerationMessage;

  /// No description provided for @existingSeedMessage.
  ///
  /// In en, this message translates to:
  /// **'Provide an existing seed to create your Vault.'**
  String get existingSeedMessage;

  /// No description provided for @enterSeedHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your seed'**
  String get enterSeedHint;

  /// No description provided for @profileIdHeader.
  ///
  /// In en, this message translates to:
  /// **'Profile ID'**
  String get profileIdHeader;

  /// No description provided for @didHeader.
  ///
  /// In en, this message translates to:
  /// **'DID (did:key)'**
  String get didHeader;

  /// No description provided for @permissionsHeader.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsHeader;

  /// No description provided for @actionHeader.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get actionHeader;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @inputAllowedFileFormats.
  ///
  /// In en, this message translates to:
  /// **'Input allowed file formats'**
  String get inputAllowedFileFormats;

  /// No description provided for @fileFormat.
  ///
  /// In en, this message translates to:
  /// **'File format'**
  String get fileFormat;

  /// No description provided for @inputFileSizeInMb.
  ///
  /// In en, this message translates to:
  /// **'Enter file size in MB'**
  String get inputFileSizeInMb;

  /// No description provided for @infoVault.
  ///
  /// In en, this message translates to:
  /// **'What is Vault?'**
  String get infoVault;

  /// No description provided for @infoVaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Vault is a secure digital wallet that allows you to manage your digital identities, personal documents, and store credentials securely, such as verified identity VC and certificates. It protects the data stored in the vault with end-to-end encryption.\n\nAffinidi TDK - Vault does not track the list of vaults created, including their name and passphrase—it is handled by the app and persisted using the device\'s local storage (the reference app uses Drift for the local storage layer).'**
  String get infoVaultDescription;

  /// No description provided for @infoVaultAttr.
  ///
  /// In en, this message translates to:
  /// **'About Vault Name and Passphrase'**
  String get infoVaultAttr;

  /// No description provided for @infoVaultAttrDescription.
  ///
  /// In en, this message translates to:
  /// **'The reference app manages and persists the vault\'s name and passphrase using local storage (it uses Drift as the local storage layer) as part of its functionality.\n\nAffinidi TDK - Vault does not track or handle these attributes.'**
  String get infoVaultAttrDescription;

  /// No description provided for @infoSeed.
  ///
  /// In en, this message translates to:
  /// **'What is a Seed?'**
  String get infoSeed;

  /// No description provided for @infoSeedDescription.
  ///
  /// In en, this message translates to:
  /// **'A seed is a bit string used as an initial input to generate a sequence of pseudo-random numbers to create cryptographic keys. The Vault TDK uses a 32-byte string to create a vault.\n\nGenerate Random Seed option creates a 32-byte string as input to create and initialise a new vault.\n\nExisting Seed option allows you to create the vault with the same set of cryptographic key pairs created from another device and sync cloud profiles from the same vault.'**
  String get infoSeedDescription;

  /// No description provided for @infoProfile.
  ///
  /// In en, this message translates to:
  /// **'What is a Profile?'**
  String get infoProfile;

  /// No description provided for @infoProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'A profile represents your digital identity. It allows you to manage credentials and personal files related to your profile, including sharing your profile with other users. \n\nEach profile has its own Decentralised Identifier (DID).'**
  String get infoProfileDescription;

  /// No description provided for @infoProfileStorage.
  ///
  /// In en, this message translates to:
  /// **'What is a Profile Storage?'**
  String get infoProfileStorage;

  /// No description provided for @infoProfileStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'Creating a profile requires selecting a storage to store credentials, including personal files. You can create your profile using cloud storage provided by Affinidi or your device\'s local storage. \n\nCloud storage option enables multi-device sync and profile sharing.'**
  String get infoProfileStorageDescription;

  /// No description provided for @infoCredential.
  ///
  /// In en, this message translates to:
  /// **'What is a Claimed Credential?'**
  String get infoCredential;

  /// No description provided for @infoCredentialDescription.
  ///
  /// In en, this message translates to:
  /// **'The claimed credential is a Verifiable Credential (VC) that contains a set of claims about the subject and metadata, including the cryptographical proof of who issued it, ensuring authenticity and tamper-evident. It is a W3C (World Wide Web Consortium) standard for digitally representing and exchanging credentials in a secure, privacy-preserving, and machine-verifiable manner. \n\nAn example of a credential is a university issuing you a completion certificate, attesting that you have completed the course.'**
  String get infoCredentialDescription;

  /// No description provided for @infoShareContent.
  ///
  /// In en, this message translates to:
  /// **'What is a Shared Content?'**
  String get infoShareContent;

  /// No description provided for @infoShareContentDescription.
  ///
  /// In en, this message translates to:
  /// **'The shared content contains data shared by another user through the profile sharing process using your Decentralised Identifier (DID). Depending on the permission set by the other user who shared it, you can write or read-only on the shared content.'**
  String get infoShareContentDescription;

  /// No description provided for @infoAccessManagement.
  ///
  /// In en, this message translates to:
  /// **'What is Access Management?'**
  String get infoAccessManagement;

  /// No description provided for @infoAccessManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'A reference app-specific implementation that tracks the DIDs to whom you shared your profile. It allows you to see the list of DIDs and revoke their access to your profile. It stores the list of DIDs in the device\'s local storage.'**
  String get infoAccessManagementDescription;

  /// No description provided for @infoShareRecipientDID.
  ///
  /// In en, this message translates to:
  /// **'What is Receipient DID?'**
  String get infoShareRecipientDID;

  /// No description provided for @infoShareRecipientDIDDescription.
  ///
  /// In en, this message translates to:
  /// **'The Recipient DID is the Decentralised Identifier (DID) of the other user\'s profile with whom you want to share your profile.\n\nDepending on your implementation, the DID method may be different to represent each type of user. It could be did:key or did:peer for individuals, or did:web or did:webvh for businesses and organisations.'**
  String get infoShareRecipientDIDDescription;

  /// No description provided for @infoSharePermissions.
  ///
  /// In en, this message translates to:
  /// **'What is Access Permission?'**
  String get infoSharePermissions;

  /// No description provided for @infoSharePermissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'The Access Permission sets the access level of the user to whom you shared your profile. By setting the access level of the user, they can:\n\n- Read-only the content of your shared profile.\n- Read and write data (e.g., upload files) into your shared profile.'**
  String get infoSharePermissionsDescription;

  /// No description provided for @infoShareFlow.
  ///
  /// In en, this message translates to:
  /// **'Learn more about profile sharing'**
  String get infoShareFlow;

  /// No description provided for @infoShareFlowDescription.
  ///
  /// In en, this message translates to:
  /// **'If you are sharing your profile to another profile in the same device, it will auto-accept the profile sharing instead of requesting for consent to accept.\n\nThis is a reference app-specific implementation.'**
  String get infoShareFlowDescription;

  /// No description provided for @infoSetFilePermissions.
  ///
  /// In en, this message translates to:
  /// **'What is Set File Permissions?'**
  String get infoSetFilePermissions;

  /// No description provided for @infoSetFilePermissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'The Set File Permissions option enables you to restrict the file formats (e.g., only accept PDF and JPG files) and sizes (e.g., only accept files up to 5MB in size) that users can upload to your profile\'s file system, including when you share your profile with other users.'**
  String get infoSetFilePermissionsDescription;

  /// No description provided for @lblCSCreateVault.
  ///
  /// In en, this message translates to:
  /// **'Create Vault Snippets'**
  String get lblCSCreateVault;

  /// No description provided for @lblCSAccessVault.
  ///
  /// In en, this message translates to:
  /// **'Access Vault Snippets'**
  String get lblCSAccessVault;

  /// No description provided for @lblCSViewVaultProfile.
  ///
  /// In en, this message translates to:
  /// **'View Vault Profile Snippets'**
  String get lblCSViewVaultProfile;

  /// No description provided for @lblCSListVaultProfiles.
  ///
  /// In en, this message translates to:
  /// **'List Vault Profiles Snippets'**
  String get lblCSListVaultProfiles;

  /// No description provided for @lblCSListVaults.
  ///
  /// In en, this message translates to:
  /// **'List Vaults Snippets'**
  String get lblCSListVaults;

  /// No description provided for @lblCSCreateProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Vault Profile Snippets'**
  String get lblCSCreateProfile;

  /// No description provided for @infoCSCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Code snippets copied to clipboard.'**
  String get infoCSCopiedToClipboard;

  /// No description provided for @lblCSShareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share Profile Snippets'**
  String get lblCSShareProfile;

  /// No description provided for @infoClaimCredential.
  ///
  /// In en, this message translates to:
  /// **'What is Claim Credential?'**
  String get infoClaimCredential;

  /// No description provided for @infoClaimCredentialDescription.
  ///
  /// In en, this message translates to:
  /// **'The claim credential follows the OpenID for Verifiable Credential Issuance (OID4VCI) protocol that leverages the existing OAuth 2.0 authorisation flow to facilitate the secure claim of a credential offer from the issuer and allow users to store them in their digital wallet (e.g., Affinidi TDK - Vault).'**
  String get infoClaimCredentialDescription;

  /// No description provided for @lblCSClaimCredential.
  ///
  /// In en, this message translates to:
  /// **'Claim Credential Snippets'**
  String get lblCSClaimCredential;

  /// No description provided for @targetKeywordClaimedCredential.
  ///
  /// In en, this message translates to:
  /// **'claimed credentials'**
  String get targetKeywordClaimedCredential;

  /// No description provided for @targetKeywordProfiles.
  ///
  /// In en, this message translates to:
  /// **'profiles'**
  String get targetKeywordProfiles;

  /// No description provided for @targetKeywordSharedContent.
  ///
  /// In en, this message translates to:
  /// **'shared content'**
  String get targetKeywordSharedContent;

  /// No description provided for @snippetDescCreateVault.
  ///
  /// In en, this message translates to:
  /// **'Create Vault'**
  String get snippetDescCreateVault;

  /// No description provided for @snippetDescGenRandSeed.
  ///
  /// In en, this message translates to:
  /// **'Generate Random Seed'**
  String get snippetDescGenRandSeed;

  /// No description provided for @snippetDescOpenVault.
  ///
  /// In en, this message translates to:
  /// **'Open Vault Instance'**
  String get snippetDescOpenVault;

  /// No description provided for @snippetDescCreateVaultProf.
  ///
  /// In en, this message translates to:
  /// **'Create Profile (Abstract)'**
  String get snippetDescCreateVaultProf;

  /// No description provided for @snippetDescCreateVaultProfVFS.
  ///
  /// In en, this message translates to:
  /// **'Create Vault Profile (Cloud)'**
  String get snippetDescCreateVaultProfVFS;

  /// No description provided for @snippetDescCreateVaultProfDrift.
  ///
  /// In en, this message translates to:
  /// **'Create Vault Profile (Local Storage)'**
  String get snippetDescCreateVaultProfDrift;

  /// No description provided for @snippetDescGetFilesFolders.
  ///
  /// In en, this message translates to:
  /// **'Get Files and Folders (Interface)'**
  String get snippetDescGetFilesFolders;

  /// No description provided for @snippetDescGetSharedContents.
  ///
  /// In en, this message translates to:
  /// **'Get Shared Content - Retrieves the list of profiles, including the shared storages for the given profile'**
  String get snippetDescGetSharedContents;

  /// No description provided for @snippetDescGetClaimedVCs.
  ///
  /// In en, this message translates to:
  /// **'Get Claimed Credentials (Interface)'**
  String get snippetDescGetClaimedVCs;

  /// No description provided for @snippetDescListVaults.
  ///
  /// In en, this message translates to:
  /// **'List Vaults - Ref App-specific implementation'**
  String get snippetDescListVaults;

  /// No description provided for @snippetDescListVaultsProfs.
  ///
  /// In en, this message translates to:
  /// **'List Vault Profiles - Retrieves list of profiles'**
  String get snippetDescListVaultsProfs;

  /// No description provided for @snippetDescShareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share Profile'**
  String get snippetDescShareProfile;

  /// No description provided for @snippetDescRetrieveCredOffer.
  ///
  /// In en, this message translates to:
  /// **'Retrieve Credential Offer via Offer URI'**
  String get snippetDescRetrieveCredOffer;

  /// No description provided for @snippetDescClaimCredOffer.
  ///
  /// In en, this message translates to:
  /// **'Claim Credential Offer'**
  String get snippetDescClaimCredOffer;

  /// No description provided for @snippetDescDeleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile (Interface)'**
  String get snippetDescDeleteProfile;

  /// No description provided for @snippetDescDeleteProfileVFS.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile (Cloud)'**
  String get snippetDescDeleteProfileVFS;

  /// No description provided for @snippetDescDeleteProfileDrift.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile (Local Storage)'**
  String get snippetDescDeleteProfileDrift;

  /// No description provided for @snippetDescRevokeAccess.
  ///
  /// In en, this message translates to:
  /// **'Revoked Shared Profile Access'**
  String get snippetDescRevokeAccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
