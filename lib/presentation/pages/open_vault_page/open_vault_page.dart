import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart' show AppTheme;
import '../../widgets/tdk_app_bar.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import 'open_vault_page_controller.dart';
import '../../../navigation/navigation_provider.dart';

class OpenVaultPage extends HookConsumerWidget {
  static String get routePath => VaultsRoutePath.open;

  const OpenVaultPage({super.key, this.vaultId});

  final String? vaultId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final passwordController = useTextEditingController();
    final controller = ref.read(openVaultPageControllerProvider.notifier);
    final isLoading = ref.watch(openVaultPageControllerProvider);
    final errorText = useState<String?>(null);
    final isPasswordVisible = useState(false);
    final isPassphraseFocused = useState(false);
    final isPassphraseEntered = useState(false);
    final navigation = ref.read(navigationServiceProvider);

    useEffect(() {
      void listener() {
        isPassphraseEntered.value = passwordController.text.trim().isNotEmpty;
      }

      passwordController.addListener(listener);
      return () => passwordController.removeListener(listener);
    }, [passwordController]);

    void proceed() async {
      HapticFeedback.lightImpact();
      await controller.openVault(
          password: passwordController.text,
          onSuccess: () {
            if (!context.mounted) return;
            navigation.go(ProfilesRoutePath.base);
          },
          vaultId: vaultId ?? '',
          onError: (errorMessage) {
            errorText.value = errorMessage;
          });
    }

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundWhite,
      appBar: TdkAppBar(
        showBackButton: true,
        onBackPressed: () => navigation.pop(),
        actions: [
          CodeSnippetWidget(
            title: localizations.lblCSAccessVault,
            codeLocations: CodeSnippetLocations.openVaultSnippets(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSizing.paddingSmall,
                right: AppSizing.paddingLarge,
                top: AppSizing.paddingSmall,
                bottom: AppSizing.paddingRegular,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizing.paddingRegular,
                        top: AppSizing.paddingLarge),
                    child: Text(
                      localizations.login,
                      style: AppTheme.headingXLarge,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: AppColorScheme.divider,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizing.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${localizations.vaultPassphrase}*',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSizing.paddingSmall),
                    FormField<String>(
                      builder: (field) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isPassphraseFocused.value
                                  ? AppColorScheme.formFieldBorderFocused
                                  : AppColorScheme.formFieldBorderUnfocused,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppSizing.paddingSmall),
                          ),
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              isPassphraseFocused.value = hasFocus;
                            },
                            child: TextField(
                              controller: passwordController,
                              obscureText: !isPasswordVisible.value,
                              onChanged: (_) {
                                errorText.value = null;
                                field.didChange(passwordController.text);
                              },
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  proceed();
                                }
                              },
                              decoration: InputDecoration(
                                hintText: localizations.enterPassphrase,
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
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
                    if (errorText.value != null) ...[
                      const SizedBox(height: AppSizing.paddingSmall),
                      Text(
                        errorText.value!,
                        style: TextStyle(
                          color: AppColorScheme.error,
                          fontSize: AppSizing.fontMedium,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSizing.paddingXLarge),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (isPassphraseEntered.value && !isLoading)
                            ? proceed
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              (isPassphraseEntered.value && !isLoading)
                                  ? AppTheme.colorScheme.primary
                                  : Colors.grey.shade300,
                          foregroundColor:
                              (isPassphraseEntered.value && !isLoading)
                                  ? AppColorScheme.backgroundWhite
                                  : const Color(0xFF9CA3AF),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSizing.paddingMedium),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizing.paddingXXLarge),
                          ),
                          splashFactory: InkRipple.splashFactory,
                        ),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    localizations.openingVault,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              )
                            : Text(
                                localizations.accessVaultActionLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
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
