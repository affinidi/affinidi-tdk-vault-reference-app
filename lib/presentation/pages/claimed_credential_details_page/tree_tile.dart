import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import 'claimed_credential_node.dart';
import 'tree_entry_body.dart';

class TreeTile extends StatelessWidget {
  final TreeEntry<ClaimedCredentialNode> entry;
  final double rightColumnWidth;

  const TreeTile({
    super.key,
    required this.entry,
    required this.rightColumnWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double indent = 8;

    return TreeIndentation(
      entry: entry,
      guide: IndentGuide.connectingLines(
        indent: indent,
        thickness: 1,
        color: Colors.black12,
      ),
      child: TreeEntryBody(
        fieldName: entry.node.key,
        fieldValue: entry.node.value,
        isHidden: entry.node.isRoot,
        rightColumnWidth: rightColumnWidth,
      ),
    );
  }
}
