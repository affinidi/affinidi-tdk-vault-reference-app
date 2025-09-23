import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/pages/create_vault_page/create_vault_page.dart';
import '../../presentation/pages/file_preview_page/file_preview_page.dart';
import '../../presentation/pages/my_credentials_page/my_credentials_page.dart';
import '../../presentation/pages/my_files_page/my_files_page.dart';
import '../../presentation/pages/open_vault_page/open_vault_page.dart';
import '../../presentation/pages/profile_page/profile_page.dart';
import '../../presentation/pages/profile_settings_page/profile_settings_page.dart';
import '../../presentation/pages/profiles_page/profiles_page.dart';
import '../../presentation/pages/shared_page/shared_page.dart';
import '../../presentation/pages/splash_page/splash_page.dart';
import '../../presentation/pages/vaults_page/vaults_page.dart';
import '../application/services/vault/vault_service.dart';
import '../presentation/pages/claim_credentials_page/claim_credentials_page.dart';
import '../presentation/pages/error_page/error_page.dart';
import '../presentation/pages/shared_credentials_page/shared_credentials_page.dart';
import '../presentation/pages/shared_files_page/shared_files_page.dart';
import '../presentation/pages/shared_profile_details_page/shared_profile_details_page.dart';

import 'flows/app_routes.dart';
import 'navigation_service.dart';

part 'navigation_provider.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();
String? returnUrl;

String? _guard(
  Ref ref,
  BuildContext context,
  GoRouterState state,
  String defaultRoute,
) {
  log('Guarding: ${state.uri}', name: 'navigationProvider');
  return null;
}

final navigationServiceProvider = Provider<NavigationService>((ref) {
  final router = ref.watch(navigationProvider);
  return NavigationService(router);
});

@Riverpod(keepAlive: true)
GoRouter navigation(Ref ref) {
  final refreshListenable = ValueNotifier<bool>(false);
  ref.onDispose(() {
    refreshListenable.dispose();
  });

  // Listen vaultServiceProvider and trigger a refresh when it changes:
  ref.listen<bool>(
    vaultServiceProvider.select((s) => s.currentVault != null),
    (previous, next) {
      refreshListenable.value = !refreshListenable.value;
    },
  );

  final defaultPath = VaultsRoutePath.base;

  final routes = [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      path: VaultsRoutePath.base,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: VaultsPage(),
      ),
      routes: [
        GoRoute(
          path: ProfilesRouteName.base,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: ProfilesPage(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              redirect: (context, state) {
                return null;
              },
              routes: [
                StatefulShellRoute.indexedStack(
                  builder: (context, state, navigationShell) {
                    final profileId = state.pathParameters[ProfilesRouteParams.id]!;
                    return ProfilePage(
                      profileId: profileId,
                      navigationShell: navigationShell,
                    );
                  },
                  branches: [
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: ProfilesRoutePath.myFiles,
                          builder: (context, state) => MyFilesPage(
                            profileId: state.pathParameters[ProfilesRouteParams.id]!,
                          ),
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: ProfilesRoutePath.myCredentials,
                          builder: (context, state) => MyCredentialsPage(
                            profileId: state.pathParameters[ProfilesRouteParams.id]!,
                          ),
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: ProfilesRoutePath.shared,
                          builder: (context, state) => SharedPage(
                            profileId: state.pathParameters[ProfilesRouteParams.id]!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: ProfilesRoutePath.sharedProfilePath,
                  redirect: (context, state) {
                    return null;
                  },
                  routes: [
                    StatefulShellRoute.indexedStack(
                      builder: (context, state, navigationShell) {
                        final profileId = state.pathParameters[ProfilesRouteParams.id]!;
                        final sharedProfileId = state.pathParameters[ProfilesRouteParams.sharedProfileId]!;
                        return SharedProfileDetailsPage(
                          profileId: profileId,
                          sharedProfileId: sharedProfileId,
                          navigationShell: navigationShell,
                        );
                      },
                      branches: [
                        StatefulShellBranch(
                          routes: [
                            GoRoute(
                              path: ProfilesRoutePath.sharedProfileFiles,
                              builder: (context, state) => SharedFilesPage(
                                profileId: state.pathParameters[ProfilesRouteParams.sharedProfileId]!,
                              ),
                            ),
                          ],
                        ),
                        StatefulShellBranch(
                          routes: [
                            GoRoute(
                              path: ProfilesRoutePath.sharedProfileCredentials,
                              builder: (context, state) => SharedCredentialsPage(
                                profileId: state.pathParameters[ProfilesRouteParams.sharedProfileId]!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: ProfilesRoutePath.settings,
                  builder: (context, state) =>
                      ProfileSettingsPage(profileId: state.pathParameters[ProfilesRouteParams.id]!),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: VaultsRouteName.create,
      path: VaultsRoutePath.create,
      builder: (context, state) => CreateVaultPage(),
    ),
    GoRoute(
      name: VaultsRouteName.open,
      path: VaultsRoutePath.openVaultWithId(':${ProfilesRouteParams.vaultId}'),
      builder: (context, state) => OpenVaultPage(
        vaultId: state.pathParameters[ProfilesRouteParams.vaultId]!,
      ),
    ),
    GoRoute(
      path: '/claim/:${ProfilesRouteParams.profileId}',
      builder: (context, state) => ClaimCredentialsPage(
        profileId: state.pathParameters[ProfilesRouteParams.profileId]!,
      ),
    ),
    GoRoute(
      path: '/vaults/profiles/:${ProfilesRouteParams.profileId}/files/preview/:${ProfilesRouteParams.nodeId}',
      builder: (context, state) => FilePreviewPage(
        profileId: state.pathParameters[ProfilesRouteParams.profileId]!,
        nodeId: state.pathParameters[ProfilesRouteParams.nodeId]!,
      ),
    ),
    GoRoute(
      path: '/vaults/profiles/:${ProfilesRouteParams.profileId}/shared/files/preview/:${ProfilesRouteParams.nodeId}',
      builder: (context, state) => FilePreviewPage(
        profileId: state.pathParameters[ProfilesRouteParams.profileId]!,
        nodeId: state.pathParameters[ProfilesRouteParams.nodeId]!,
        isSharedProfile: true,
      ),
    ),
  ];

  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    redirect: (BuildContext context, GoRouterState state) {
      return _guard(ref, context, state, defaultPath);
    },
    refreshListenable: refreshListenable,
    routes: routes,
    errorBuilder: (context, state) => ErrorPage(
      error: state.error,
      onRetry: () => GoRouter.of(context).go('/'),
    ),
  );

  return router;
}
