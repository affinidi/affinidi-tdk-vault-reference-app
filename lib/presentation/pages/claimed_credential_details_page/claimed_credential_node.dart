class ClaimedCredentialNode {
  final String key;
  final String value;
  final List<ClaimedCredentialNode> children = [];
  final bool isRoot;

  ClaimedCredentialNode({
    required this.key,
    required this.value,
    this.isRoot = false,
  });
}
