// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationStateImpl _$$PaginationStateImplFromJson(Map<String, dynamic> json) => _$PaginationStateImpl(
      lastEvaluatedItemIdStack:
          (json['lastEvaluatedItemIdStack'] as List<dynamic>?)?.map((e) => e as String?).toList() ?? const [],
      currentPageIndex: (json['currentPageIndex'] as num?)?.toInt() ?? 0,
    );
