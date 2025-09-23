// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get myFiles => 'My files';

  @override
  String get myCredentials => 'Claimed credentials';

  @override
  String get files => 'Files';

  @override
  String get credentials => 'Credentials';

  @override
  String get driveTitle => 'Storage';

  @override
  String get filesEmptyStateDescription =>
      'You don\'t have any files yet.\nThe Home folder is your root directory.';

  @override
  String get credentialsEmptyStateDescription =>
      'You don\'t have any claimed credentials.';

  @override
  String get retryActionText => 'Retry';

  @override
  String get loading => 'loading';

  @override
  String get okActionText => 'ok';

  @override
  String get renameFileTitle => 'Rename file';

  @override
  String get renameFileDescription => 'Create a name for this file.';

  @override
  String get cancelActionText => 'Cancel';

  @override
  String get fileName => 'File name';

  @override
  String get renameActionText => 'Rename';

  @override
  String option(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'rename': 'Rename',
        'preview': 'Preview',
        'delete': 'Delete',
        'share': 'Share',
        'other': 'Unknown',
      },
    );
    return '$_temp0';
  }

  @override
  String errorMessage(String errorType) {
    String _temp0 = intl.Intl.selectLogic(
      errorType,
      {
        'credential_offer_expired': 'Credential offer is expired',
        'credential_offer_claimed_error': 'Credential offer is already claimed',
        'failed_to_load_credentialOffer': 'Failed to load credentials',
        'invalid_proof': 'The proof in the Credential Request is invalid',
        'unmatched_tx_code': 'Transaction code does not match',
        'folderNotEmpty':
            'We cannot delete this folder because it\'s not empty. Please delete the files and try again.',
        'nameAlreadyInUse':
            'This name is already in use. Please choose a different one.',
        'invalidPassword': 'Invalid password',
        'emptyPassword': 'Password cannot be empty',
        'invalidTransferData': 'Invalid transfer data',
        'emptyTransferData': 'Missing transfer data',
        'missingProfileName': 'Please enter a valid profile name',
        'invalidUrl': 'Please enter a valid URL',
        'getCredentialFailed': 'Failed to get credential data',
        'other': 'Something went wrong',
      },
    );
    return '$_temp0';
  }

  @override
  String get createFolderActionText => 'Create folder';

  @override
  String get createFolderLoadingMessage => 'Creating folder...';

  @override
  String get renameFileLoadingMessage => 'Renaming file...';

  @override
  String get createFolderTitle => 'Add new folder';

  @override
  String get folderName => 'Folder name';

  @override
  String get deleteFolderTitle => 'Delete folder';

  @override
  String get deleteFolderDescription =>
      'Please confirm deletion. This folder will be permanently removed and cannot be restored.';

  @override
  String get deleteFolderActionText => 'Delete';

  @override
  String get deleteFolderLoadingMessage => 'Deleting folder...';

  @override
  String get deleteFileTitle => 'Delete file';

  @override
  String get deleteFileActionText => 'Delete';

  @override
  String get deleteFileLoadingMessage => 'Deleting file...';

  @override
  String get deleteFileDescription =>
      'Please confirm deletion. This file will be permanently removed and cannot be restored.';

  @override
  String get uploadingFileLoadingMessage => 'Uploading...';

  @override
  String fileUploadErrorMessage(String files, int completed, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      completed,
      locale: localeName,
      other: 'files',
      one: 'file',
    );
    return 'Uploaded $completed $_temp0 out of $total.\n\nFiles that failed:\n$files';
  }

  @override
  String get loadingCredentials => 'Preparing your credentials...';

  @override
  String get claimCredentialsTitle => 'Claim credentials';

  @override
  String get verifiedCredentials => 'VERIFIED CREDENTIAL';

  @override
  String get issuanceDate => 'Issuance date';

  @override
  String get expiryDate => 'Expiry date';

  @override
  String get credentialValidationLoadingMessage => 'Validating...';

  @override
  String get neverExpires => 'None';

  @override
  String get deleteCredentialActionText => 'Delete';

  @override
  String get deleteCredentialTitle => 'Delete credential';

  @override
  String get deleteCredentialLoadingMessage => 'Deleting credential...';

  @override
  String get deleteCredentialDescription =>
      'Please confirm deletion. This credential will be permanently removed and cannot be restored.';

  @override
  String get renameFolderDescription => 'Create a name for this folder.';

  @override
  String get renameFolderTitle => 'Rename folder';

  @override
  String get renameFolderLoadingMessage => 'Renaming folder...';

  @override
  String get claimCredentialsValidating => 'Validating...';

  @override
  String get claimCredentialsSaving => 'Saving...';

  @override
  String get claimCredentialsTxCode => ' Transaction code';

  @override
  String get saveActionText => 'Save';

  @override
  String get fetchActionText => 'Fetch';

  @override
  String get verifiedData => 'verified data';

  @override
  String get previewTitle => 'Preview';

  @override
  String get unsupportedPreview =>
      'Preview is not supported for this file type';

  @override
  String get home => 'Home';

  @override
  String get createVaultTitle => 'Create your Vault';

  @override
  String get createVaultDescription =>
      'Use this option to create a brand new Vault.';

  @override
  String get createVaultActionLabel => 'Create';

  @override
  String get vaultExistsErrorMessage =>
      'A vault with this seed already exists on this device';

  @override
  String get seed => 'seed';

  @override
  String get createVaultErrorMessage => 'Failed to create new vault ';

  @override
  String get openVaultTitle => 'Open an existing Vault';

  @override
  String get accessVaultTitle => 'Access your Affinidi Vault';

  @override
  String get login => 'Login';

  @override
  String get openVaultDescription =>
      'Use this option to open a Vault you have already used on this device.';

  @override
  String get accessVaultActionLabel => 'Access';

  @override
  String get transferVaultTitle => 'Complete a Vault transfer';

  @override
  String get transferVaultDescription =>
      'Use this option to start scanning the QR code you received and complete a transfer.';

  @override
  String get transferVaultActionLabel => 'Start';

  @override
  String get scanQrCodeInstructions =>
      'Position the QR code within the frame to scan';

  @override
  String get vaultName => 'Vault Name';

  @override
  String get vaultPassphrase => 'Passphrase';

  @override
  String get enterPassphrase => 'Enter your passphrase';

  @override
  String get generateRandomSeed => 'Generate Random Seed';

  @override
  String get existingSeed => 'Existing Seed';

  @override
  String get enterSeed => 'Enter Seed';

  @override
  String get transferVaultLoadingMessage => 'Transferring vault...';

  @override
  String get transferVaultProceedActionLabel => 'Transfer vault';

  @override
  String get transferVaultScanActionLabel => 'Start scanning';

  @override
  String get creatingNewVault => 'Creating a new Vault';

  @override
  String get openingVault => 'Opening Vault';

  @override
  String get credentialDetails => 'Credential details';

  @override
  String get createProfileTitle => 'Create new profile';

  @override
  String get createProfileActionText => 'Create';

  @override
  String get createProfileLoadingMessage => 'Creating new profile...';

  @override
  String get createProfileDescription => 'Enter the details for a new profile';

  @override
  String get shareProfileTitle => 'Profile Sharing';

  @override
  String get shareProfileSuccessMessage => 'Profile shared successfully';

  @override
  String shareProfileErrorMessage(Object errorMessage) {
    return 'Error sharing profile: $errorMessage';
  }

  @override
  String get shareProfileAcceptSuccessMessage =>
      'Shared profile accepted successfully!';

  @override
  String shareProfileAcceptErrorMessage(Object errorMessage) {
    return 'Error accepting shared profile: $errorMessage';
  }

  @override
  String get shareProfileAcceptActionText => 'Accept Shared Profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileDescription => 'Description';

  @override
  String get profilesTitle => 'Profiles';

  @override
  String get deleteProfileTitle => 'Delete Profile';

  @override
  String deleteProfileConfirmationMessage(Object profileName) {
    return 'Are you sure you want to delete the profile \"$profileName\"? This action cannot be undone.';
  }

  @override
  String get deleteActionText => 'Delete';

  @override
  String get deleteProfileLoadingMessage => 'Deleting profile...';

  @override
  String get vaultsTitle => 'Vaults';

  @override
  String get copy => 'Copy';

  @override
  String get copiedToClipboard => 'DID copied to clipboard';

  @override
  String get shareProfile => 'Share';

  @override
  String get delete => 'Delete';

  @override
  String get shared => 'Shared';

  @override
  String get openPDF => 'Open PDF in new tab';

  @override
  String get back => 'Back';

  @override
  String get recipientDidLabel => 'Recipient DID';

  @override
  String get pasteSharedProfileDtoJsonTitle => 'Paste SharedProfileDto JSON';

  @override
  String get selectYourProfileLabel => 'Select Your Profile';

  @override
  String get sharedProfileDetails => 'Shared Profile Detail';

  @override
  String get sharedProfileDtoJsonFieldLabel => 'SharedProfileDto JSON';

  @override
  String folderLabel(Object name) {
    return 'Folder: $name';
  }

  @override
  String fileLabel(Object name) {
    return 'File: $name';
  }

  @override
  String idLabel(Object id) {
    return 'ID: $id';
  }

  @override
  String get unknownItemType => 'Unknown item type';

  @override
  String get noFilesOrFoldersFound => 'No files or folders found';

  @override
  String sharedFromLabel(Object storageId) {
    return 'Shared from: $storageId';
  }

  @override
  String storageTypeLabel(Object storageType) {
    return 'Storage Type: $storageType';
  }

  @override
  String get noSharedContentAvailable => 'No shared content available.';

  @override
  String get tdkReferenceAppbarTitle => 'TDK Reference';

  @override
  String get useQrData => 'Use QR Data';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get error => 'Error';

  @override
  String get vaultsEmptyMessage =>
      'No vaults found. Create a new vault to get started.';

  @override
  String get incorrectPassphrase => 'Wrong passphrase.';

  @override
  String get profileTypeLabel => 'Profile Type';

  @override
  String get profileDescriptionPlaceholder => 'Add your profile description...';

  @override
  String get profileNamePlaceholder => 'Give your profile a name';

  @override
  String get profileTypeAffinidiCloud => 'Store in Affinidi Cloud';

  @override
  String get profileTypeDrift => 'Store in Drift (Local Storage)';

  @override
  String get profileNotice =>
      'Profiles created using local storage cannot be shared.';

  @override
  String get profileTypeChooseYourOwn => 'Choose your own';

  @override
  String get paginationPreviousPage => 'Previous Page';

  @override
  String get paginationNextPage => 'Next Page';

  @override
  String paginationPageLabel(Object pageNumber) {
    return 'Page $pageNumber';
  }

  @override
  String get profileSettingsTitle => 'Profile Settings';

  @override
  String get profileUpdateSuccess => 'Profile updated';

  @override
  String get profileUpdateFailure => 'Failed to update profile';

  @override
  String get url => 'url';

  @override
  String get claimInputInstruction => 'Enter claim link to fetch credential';

  @override
  String get profileNotDeletedTitle => 'Profile Not Deleted';

  @override
  String get profileNotDeletedMessage =>
      'This profile contains files/folders. Please delete them before trying again.';

  @override
  String get gotItActionText => 'Got it';

  @override
  String get viewCodeSnippetsActionText => 'View Code Snippets';

  @override
  String get timeoutLoadingCodeMessage => 'Timeout loading code from';

  @override
  String get errorLoadingCodeMessage => 'Error loading code from';

  @override
  String get errorLoadingCodeSnippetsMessage => 'Error loading code snippets';

  @override
  String get profilesEmptyStateDescription =>
      'You don\'t have any profiles yet. Start by creating one.';

  @override
  String get folderNotDeletedTitle => 'Folder Not Deleted';

  @override
  String get folderNotDeletedMessage =>
      'This folder contains files/folders. Please delete them before trying again.';

  @override
  String get sharingProfileMessage =>
      'Sharing your profile. Auto-accepts profile if from the same device.';

  @override
  String get accessPermissionLabel => 'Access Permission';

  @override
  String get canViewOnlyLabel => 'Can view only';

  @override
  String get canWriteLabel => 'Can write';

  @override
  String get recipientDidHint => 'Enter DID here';

  @override
  String get accessManagementLabel => 'Access Management';

  @override
  String get noSharedDidsForProfile => 'No shared DIDs for this profile.';

  @override
  String didLabel(Object did) {
    return 'DID: $did';
  }

  @override
  String profileIdLabel(Object profileId) {
    return 'Profile ID: $profileId';
  }

  @override
  String accessLevelLabel(Object accessLevel) {
    return 'Access: $accessLevel';
  }

  @override
  String get revokeAccessTooltip => 'Revoke access';

  @override
  String get profileSharedMessage => 'Profile has been shared';

  @override
  String get sharedProfileJsonGeneratedMessage =>
      'Shared profile JSON generated';

  @override
  String get autoAcceptingMessage =>
      'Auto-accepting the shared profile. This may take a few seconds.';

  @override
  String genericError(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get setFilePermissions => 'Set File Permissions';

  @override
  String get filePermissions => 'File Permissions';

  @override
  String get fileFormatOptions => 'File Format Options';

  @override
  String get acceptAllFormats => 'Accept all formats';

  @override
  String get specifyAllowedFormats => 'Specify allowed formats';

  @override
  String get typeFileFormatHere => 'Type file format here';

  @override
  String get fileSizeLimit => 'File size limit';

  @override
  String get enterMaxFileSize => 'Enter max file size in bytes';

  @override
  String get settingsSaved => 'Settings saved!';

  @override
  String get invalidFormat => 'Invalid format';

  @override
  String get fileTooLarge => 'File too large';

  @override
  String get reference => 'REFERENCE';

  @override
  String get app => 'APP';

  @override
  String get myVaults => 'My Vaults';

  @override
  String get builtWithAffinidiVaultTdk => 'Built with Affinidi TDK - Vault';

  @override
  String get addVault => 'Create Vault';

  @override
  String get giveYourVaultAName => 'Give your vault a name';

  @override
  String get chooseAPassphrase => 'Choose a passphrase';

  @override
  String get createYourVault => 'Create your vault';

  @override
  String get createVault => 'Create Vault';

  @override
  String get createProfile => 'Create Profile';

  @override
  String get seedGenerationMessage =>
      'A secure 32-byte seed will be generated. It\'s needed to create your Vault.';

  @override
  String get existingSeedMessage =>
      'Provide an existing seed to create your Vault.';

  @override
  String get enterSeedHint => 'Enter your seed';

  @override
  String get profileIdHeader => 'Profile ID';

  @override
  String get didHeader => 'DID (did:key)';

  @override
  String get permissionsHeader => 'Permissions';

  @override
  String get actionHeader => 'Action';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get inputAllowedFileFormats => 'Input allowed file formats';

  @override
  String get fileFormat => 'File format';

  @override
  String get inputFileSizeInMb => 'Enter file size in MB';

  @override
  String get infoVault => 'What is Vault?';

  @override
  String get infoVaultDescription =>
      'Vault is a secure digital wallet that allows you to manage your digital identities, personal documents, and store credentials securely, such as verified identity VC and certificates. It protects the data stored in the vault with end-to-end encryption.\n\nAffinidi TDK - Vault does not track the list of vaults created, including their name and passphrase—it is handled by the app and persisted using the device\'s local storage (the reference app uses Drift for the local storage layer).';

  @override
  String get infoVaultAttr => 'About Vault Name and Passphrase';

  @override
  String get infoVaultAttrDescription =>
      'The reference app manages and persists the vault\'s name and passphrase using local storage (it uses Drift as the local storage layer) as part of its functionality.\n\nAffinidi TDK - Vault does not track or handle these attributes.';

  @override
  String get infoSeed => 'What is a Seed?';

  @override
  String get infoSeedDescription =>
      'A seed is a bit string used as an initial input to generate a sequence of pseudo-random numbers to create cryptographic keys. The Vault TDK uses a 32-byte string to create a vault.\n\nGenerate Random Seed option creates a 32-byte string as input to create and initialise a new vault.\n\nExisting Seed option allows you to create the vault with the same set of cryptographic key pairs created from another device and sync cloud profiles from the same vault.';

  @override
  String get infoProfile => 'What is a Profile?';

  @override
  String get infoProfileDescription =>
      'A profile represents your digital identity. It allows you to manage credentials and personal files related to your profile, including sharing your profile with other users. \n\nEach profile has its own Decentralised Identifier (DID).';

  @override
  String get infoProfileStorage => 'What is a Profile Storage?';

  @override
  String get infoProfileStorageDescription =>
      'Creating a profile requires selecting a storage to store credentials, including personal files. You can create your profile using cloud storage provided by Affinidi or your device\'s local storage. \n\nCloud storage option enables multi-device sync and profile sharing.';

  @override
  String get infoCredential => 'What is a Claimed Credential?';

  @override
  String get infoCredentialDescription =>
      'The claimed credential is a Verifiable Credential (VC) that contains a set of claims about the subject and metadata, including the cryptographical proof of who issued it, ensuring authenticity and tamper-evident. It is a W3C (World Wide Web Consortium) standard for digitally representing and exchanging credentials in a secure, privacy-preserving, and machine-verifiable manner. \n\nAn example of a credential is a university issuing you a completion certificate, attesting that you have completed the course.';

  @override
  String get infoShareContent => 'What is a Shared Content?';

  @override
  String get infoShareContentDescription =>
      'The shared content contains data shared by another user through the profile sharing process using your Decentralised Identifier (DID). Depending on the permission set by the other user who shared it, you can write or read-only on the shared content.';

  @override
  String get infoAccessManagement => 'What is Access Management?';

  @override
  String get infoAccessManagementDescription =>
      'A reference app-specific implementation that tracks the DIDs to whom you shared your profile. It allows you to see the list of DIDs and revoke their access to your profile. It stores the list of DIDs in the device\'s local storage.';

  @override
  String get infoShareRecipientDID => 'What is Receipient DID?';

  @override
  String get infoShareRecipientDIDDescription =>
      'The Recipient DID is the Decentralised Identifier (DID) of the other user\'s profile with whom you want to share your profile.\n\nDepending on your implementation, the DID method may be different to represent each type of user. It could be did:key or did:peer for individuals, or did:web or did:webvh for businesses and organisations.';

  @override
  String get infoSharePermissions => 'What is Access Permission?';

  @override
  String get infoSharePermissionsDescription =>
      'The Access Permission sets the access level of the user to whom you shared your profile. By setting the access level of the user, they can:\n\n- Read-only the content of your shared profile.\n- Read and write data (e.g., upload files) into your shared profile.';

  @override
  String get infoShareFlow => 'Learn more about profile sharing';

  @override
  String get infoShareFlowDescription =>
      'If you are sharing your profile to another profile in the same device, it will auto-accept the profile sharing instead of requesting for consent to accept.\n\nThis is a reference app-specific implementation.';

  @override
  String get infoSetFilePermissions => 'What is Set File Permissions?';

  @override
  String get infoSetFilePermissionsDescription =>
      'The Set File Permissions option enables you to restrict the file formats (e.g., only accept PDF and JPG files) and sizes (e.g., only accept files up to 5MB in size) that users can upload to your profile\'s file system, including when you share your profile with other users.';

  @override
  String get lblCSCreateVault => 'Create Vault Snippets';

  @override
  String get lblCSAccessVault => 'Access Vault Snippets';

  @override
  String get lblCSViewVaultProfile => 'View Vault Profile Snippets';

  @override
  String get lblCSListVaultProfiles => 'List Vault Profiles Snippets';

  @override
  String get lblCSListVaults => 'List Vaults Snippets';

  @override
  String get lblCSCreateProfile => 'Create Vault Profile Snippets';

  @override
  String get infoCSCopiedToClipboard => 'Code snippets copied to clipboard.';

  @override
  String get lblCSShareProfile => 'Share Profile Snippets';

  @override
  String get infoClaimCredential => 'What is Claim Credential?';

  @override
  String get infoClaimCredentialDescription =>
      'The claim credential follows the OpenID for Verifiable Credential Issuance (OID4VCI) protocol that leverages the existing OAuth 2.0 authorisation flow to facilitate the secure claim of a credential offer from the issuer and allow users to store them in their digital wallet (e.g., Affinidi TDK - Vault).';

  @override
  String get lblCSClaimCredential => 'Claim Credential Snippets';

  @override
  String get targetKeywordClaimedCredential => 'claimed credentials';

  @override
  String get targetKeywordProfiles => 'profiles';

  @override
  String get targetKeywordSharedContent => 'shared content';

  @override
  String get snippetDescCreateVault => 'Create Vault';

  @override
  String get snippetDescGenRandSeed => 'Generate Random Seed';

  @override
  String get snippetDescOpenVault => 'Open Vault Instance';

  @override
  String get snippetDescCreateVaultProf => 'Create Profile (Abstract)';

  @override
  String get snippetDescCreateVaultProfVFS => 'Create Vault Profile (Cloud)';

  @override
  String get snippetDescCreateVaultProfDrift =>
      'Create Vault Profile (Local Storage)';

  @override
  String get snippetDescGetFilesFolders => 'Get Files and Folders (Interface)';

  @override
  String get snippetDescGetSharedContents =>
      'Get Shared Content - Retrieves the list of profiles, including the shared storages for the given profile';

  @override
  String get snippetDescGetClaimedVCs => 'Get Claimed Credentials (Interface)';

  @override
  String get snippetDescListVaults =>
      'List Vaults - Ref App-specific implementation';

  @override
  String get snippetDescListVaultsProfs =>
      'List Vault Profiles - Retrieves list of profiles';

  @override
  String get snippetDescShareProfile => 'Share Profile';

  @override
  String get snippetDescRetrieveCredOffer =>
      'Retrieve Credential Offer via Offer URI';

  @override
  String get snippetDescClaimCredOffer => 'Claim Credential Offer';

  @override
  String get snippetDescDeleteProfile => 'Delete Profile (Interface)';

  @override
  String get snippetDescDeleteProfileVFS => 'Delete Profile (Cloud)';

  @override
  String get snippetDescDeleteProfileDrift => 'Delete Profile (Local Storage)';

  @override
  String get snippetDescRevokeAccess => 'Revoked Shared Profile Access';
}
