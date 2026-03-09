import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ssi/ssi.dart';

import '../../themes/app_sizing.dart';

String _getVcDetails(dynamic credentials, String key) {
  Map<String, dynamic> credentialDataMap;
  if (credentials is String) {
    credentialDataMap = jsonDecode(credentials) as Map<String, dynamic>;
  } else if (credentials is Map<String, dynamic>) {
    credentialDataMap = credentials;
  } else {
    try {
      credentialDataMap =
          (credentials as dynamic).toJson() as Map<String, dynamic>;
    } catch (_) {
      credentialDataMap =
          jsonDecode(jsonEncode(credentials)) as Map<String, dynamic>;
    }
  }

  final value = credentialDataMap[key];
  if (value == null) return 'Invalid key';

  if (value is List) {
    if (value.isEmpty) return 'Invalid key';

    final selectedData = value.length > 1 ? value[1] : value[0];
    return selectedData.toString();
  }

  return value.toString();
}

/// Displays a bottom sheet modal which allwos the user to select which VCs to
/// share as response via VDSP.
Future<List<ParsedVerifiableCredential<dynamic>>?> showCredentialSelection(
  BuildContext context,
  List<ParsedVerifiableCredential<dynamic>> parsedVcList,
) {
  final selectedCredentials =
      showModalBottomSheet<List<ParsedVerifiableCredential<dynamic>>>(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          final selectedIndexes = <int>{};
          return StatefulBuilder(
            builder: (ctx, setState) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppSizing.paddingMedium),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSizing.paddingRegular,
                        ),
                        child: Text(
                          'Select credentials to share',
                          style: Theme.of(ctx).textTheme.titleMedium,
                        ),
                      ),

                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: parsedVcList.length,
                          itemBuilder: (c, i) {
                            final cred = parsedVcList[i];
                            final types = _getVcDetails(cred, 'type');
                            final issuer = _getVcDetails(cred, 'issuer');
                            return CheckboxListTile(
                              value: selectedIndexes.contains(i),
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    selectedIndexes.add(i);
                                  } else {
                                    selectedIndexes.remove(i);
                                  }
                                });
                              },
                              title: Text(types),
                              subtitle: issuer.isNotEmpty ? Text(issuer) : null,
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(null),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final selected = selectedIndexes
                                  .map((i) => parsedVcList[i])
                                  .toList();
                              Navigator.of(ctx).pop(selected);
                            },
                            child: const Text('Share'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );

  return selectedCredentials;
}
