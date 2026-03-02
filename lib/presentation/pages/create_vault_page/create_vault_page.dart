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
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColorScheme.backgroundDark,
                behavior: SnackBarBehavior.fixed,
              ),
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundBlack,
      appBar: TdkAppBar(
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localizations.createYourVault
                  .substring(0, localizations.createYourVault.lastIndexOf(' ')),
              style: AppTheme.headingMedium,
            ),
            const SizedBox(
              width: 6,
            ),
            SimpleInfoWidget(
              text: localizations.createYourVault.split(' ').skip(2).join(' '),
              dialogTitle: localizations.infoVaultAttr,
              dialogContent: localizations.infoVaultAttrDescription,
              textStyle: AppTheme.headingMedium,
            ),
          ],
        ),
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
                          _SeedModeTile(
                            label: localizations.generateRandomSeed,
                            value: SeedMode.generate,
                            selected: state.seedMode == SeedMode.generate,
                            onSelect: (mode) {
                              controller.updateSeedMode(mode);
                              controller.validateForm(
                                vaultName: vaultNameController.text,
                                password: passwordController.text,
                                seed: seedController.text,
                                seedMode: mode,
                              );
                            },
                          ),
                          _SeedModeTile(
                            label: localizations.existingSeed,
                            value: SeedMode.useExisting,
                            selected: state.seedMode == SeedMode.useExisting,
                            infoMessage: localizations.existingSeedMessage,
                            onSelect: (mode) {
                              controller.updateSeedMode(mode);
                              controller.validateForm(
                                vaultName: vaultNameController.text,
                                password: passwordController.text,
                                seed: seedController.text,
                                seedMode: mode,
                              );
                            },
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
                                        color: AppColorScheme.backgroundBlack),
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

class _SeedModeTile extends StatelessWidget {
  const _SeedModeTile({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelect,
    this.infoMessage,
  });

  final String label;
  final SeedMode value;
  final bool selected;
  final void Function(SeedMode) onSelect;
  final String? infoMessage;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final iconColor =
        selected ? AppTheme.colorScheme.primary : AppColorScheme.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizing.paddingXSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => onSelect(value),
            borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
            child: Padding(
              padding: const EdgeInsets.all(AppSizing.paddingXSmall),
              child: Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: iconColor,
                size: AppSizing.iconSmall + 4,
              ),
            ),
          ),
          const SizedBox(width: AppSizing.paddingSmall),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Text(label, style: textStyle)),
                if (infoMessage != null) ...[
                  const SizedBox(width: AppSizing.paddingXSmall),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            infoMessage!,
                            style: const TextStyle(
                              color: AppColorScheme.textPrimary,
                            ),
                          ),
                          backgroundColor: AppColorScheme.backgroundDark,
                          behavior: SnackBarBehavior.fixed,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.info_outline,
                      size: AppSizing.iconSmall,
                      color: AppColorScheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
