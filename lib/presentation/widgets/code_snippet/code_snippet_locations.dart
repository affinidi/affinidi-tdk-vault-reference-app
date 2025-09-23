import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'code_snippet_reader.dart';

class CodeSnippetLocations {
  static List<CodeSnippetLocation> createVaultSnippets(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/vault.dart',
        startLine: 118,
        endLine: 162,
        description: localizations.snippetDescCreateVault,
      ),
    ];
  }

  static List<CodeSnippetLocation> openVaultSnippets(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/vault.dart',
        startLine: 118,
        endLine: 162,
        description: localizations.snippetDescOpenVault,
      ),
    ];
  }

  static List<CodeSnippetLocation> createProfileSnippets(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/storage_interfaces/profile_repository.dart',
        startLine: 14,
        endLine: 23,
        description: localizations.snippetDescCreateVaultProf,
      ),
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/packages/dart/vault_data_manager/lib/src/storages/vfs_profile_repository.dart',
        startLine: 187,
        endLine: 244,
        description: localizations.snippetDescCreateVaultProfVFS,
      ),
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/packages/dart/vault_edge_drift_provider/lib/src/edge_drift_profile_repository.dart',
        startLine: 15,
        endLine: 29,
        description: localizations.snippetDescCreateVaultProfDrift,
      ),
    ];
  }

  static List<CodeSnippetLocation> viewVaultProfileSnippets(
      BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/vault.dart',
        startLine: 181,
        endLine: 201,
        description: localizations.snippetDescGetSharedContents,
      ),
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/storage_interfaces/file_storage.dart',
        startLine: 14,
        endLine: 24,
        description: localizations.snippetDescGetFilesFolders,
      ),
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/storage_interfaces/credential_storage.dart',
        startLine: 12,
        endLine: 19,
        description: localizations.snippetDescGetClaimedVCs,
      ),
    ];
  }

  static List<CodeSnippetLocation> listVaultsSnippets(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'lib/application/services/vaults_manager/vaults_manager_service.dart',
        startLine: 25,
        endLine: 50,
        description: localizations.snippetDescListVaults,
      ),
    ];
  }

  static List<CodeSnippetLocation> listVaultProfilesSnippets(
      BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/vault.dart',
        startLine: 181,
        endLine: 201,
        description: localizations.snippetDescListVaultsProfs,
      ),
    ];
  }

  static List<CodeSnippetLocation> shareProfileSnippets(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/vault.dart',
        startLine: 203,
        endLine: 265,
        description: localizations.snippetDescShareProfile,
      ),
    ];
  }

  static List<CodeSnippetLocation> claimCredentialSnippets(
      BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/claim_verifiable_credential/lib/src/api_service/oid4vci_claim_verifiable_credential_api_service.dart',
        startLine: 73,
        endLine: 76,
        description: localizations.snippetDescRetrieveCredOffer,
      ),
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/claim_verifiable_credential/lib/src/api_service/oid4vci_claim_verifiable_credential_api_service.dart',
        startLine: 104,
        endLine: 121,
        description: localizations.snippetDescClaimCredOffer,
      ),
    ];
  }

  static List<CodeSnippetLocation> deleteProfileSnippets(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/storage_interfaces/profile_repository.dart',
        startLine: 34,
        endLine: 41,
        description: localizations.snippetDescDeleteProfile,
      ),
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/packages/dart/vault_data_manager/lib/src/services/vault_data_manager_service.dart',
        startLine: 299,
        endLine: 323,
        description: localizations.snippetDescDeleteProfileVFS,
      ),
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/packages/dart/vault_edge_drift_provider/example/lib/services/drift_service.dart',
        startLine: 336,
        endLine: 357,
        description: localizations.snippetDescDeleteProfileDrift,
      ),
    ];
  }

  static List<CodeSnippetLocation> revokedAccessSnippets(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      CodeSnippetLocation(
        filePath:
            'https://github.com/affinidi/affinidi-tdk/blob/main/libs/dart/vault/lib/src/vault.dart',
        startLine: 321,
        endLine: 375,
        description: localizations.snippetDescRevokeAccess,
      ),
    ];
  }
}
