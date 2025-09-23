import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import 'package:intl/intl.dart';
import 'package:ssi/ssi.dart';

import '../../themes/app_sizing.dart';
import 'tree_tile.dart';
import 'claimed_credential_node.dart';

class CredentialTreeView extends StatefulWidget {
  final VerifiableCredential verifiableCredential;

  const CredentialTreeView({
    super.key,
    required this.verifiableCredential,
  });

  @override
  State<CredentialTreeView> createState() => _CredentialTreeViewState();
}

class _CredentialTreeViewState extends State<CredentialTreeView> {
  late final TreeController<ClaimedCredentialNode> treeController;

  @override
  void initState() {
    super.initState();
    final vc = widget.verifiableCredential;

    final root = ClaimedCredentialNode(
      key: '',
      value: '',
      isRoot: true,
    );

    if (vc.validFrom != null) {
      root.children.add(
        ClaimedCredentialNode(
          key: 'Issued on',
          value: DateFormat('dd/MM/yyyy').format(vc.validFrom!),
        ),
      );
    }

    root.children.add(
      ClaimedCredentialNode(
        key: 'Issuer',
        value: vc.issuer.id.toString(),
      ),
    );

    for (final subject in vc.credentialSubject) {
      _buildCredentialSubjectNode(root, subject);
    }

    treeController = TreeController<ClaimedCredentialNode>(
      roots: [root],
      childrenProvider: (ClaimedCredentialNode node) => node.children,
      defaultExpansionState: true,
    );
  }

  @override
  void dispose() {
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSizing.paddingMedium, top: 0, bottom: AppSizing.paddingMedium),
          child: Text(widget.verifiableCredential.type.toList()[1]),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingRegular),
              child: LayoutBuilder(builder: (context, constrainedBox) {
                return TreeView<ClaimedCredentialNode>(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  treeController: treeController,
                  nodeBuilder: (BuildContext context, TreeEntry<ClaimedCredentialNode> entry) {
                    return TreeTile(
                      key: ValueKey(entry.node),
                      entry: entry,
                      rightColumnWidth: constrainedBox.maxWidth * 0.5,
                    );
                  },
                );
              }),
            ),
          ],
        )
      ],
    );
  }

  void _buildCredentialSubjectNode(
    ClaimedCredentialNode parent,
    Map<String, dynamic> credentialSubjectEntry,
  ) {
    for (var entry in credentialSubjectEntry.entries) {
      if (entry.value is Map<String, dynamic>) {
        final child = ClaimedCredentialNode(
          key: entry.key,
          value: '',
        );

        parent.children.add(child);
        _buildCredentialSubjectNode(child, entry.value);

        continue;
      }

      final value = entry.value?.toString();

      final child = ClaimedCredentialNode(
        key: entry.key,
        value: value == null || value.isEmpty ? '-' : value,
      );

      parent.children.add(child);
    }
  }
}
