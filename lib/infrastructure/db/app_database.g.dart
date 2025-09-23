// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SharedProfileAccessTable extends SharedProfileAccess
    with TableInfo<$SharedProfileAccessTable, SharedProfileAccessData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SharedProfileAccessTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _receiverDidMeta = const VerificationMeta('receiverDid');
  @override
  late final GeneratedColumn<String> receiverDid = GeneratedColumn<String>('receiver_did', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profileIdMeta = const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId =
      GeneratedColumn<String>('profile_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accessLevelMeta = const VerificationMeta('accessLevel');
  @override
  late final GeneratedColumn<String> accessLevel = GeneratedColumn<String>('access_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, receiverDid, profileId, accessLevel];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shared_profile_access';
  @override
  VerificationContext validateIntegrity(Insertable<SharedProfileAccessData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receiver_did')) {
      context.handle(_receiverDidMeta, receiverDid.isAcceptableOrUnknown(data['receiver_did']!, _receiverDidMeta));
    } else if (isInserting) {
      context.missing(_receiverDidMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta, profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('access_level')) {
      context.handle(_accessLevelMeta, accessLevel.isAcceptableOrUnknown(data['access_level']!, _accessLevelMeta));
    } else if (isInserting) {
      context.missing(_accessLevelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SharedProfileAccessData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SharedProfileAccessData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      receiverDid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}receiver_did'])!,
      profileId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      accessLevel: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}access_level'])!,
    );
  }

  @override
  $SharedProfileAccessTable createAlias(String alias) {
    return $SharedProfileAccessTable(attachedDatabase, alias);
  }
}

class SharedProfileAccessData extends DataClass implements Insertable<SharedProfileAccessData> {
  final int id;
  final String receiverDid;
  final String profileId;
  final String accessLevel;
  const SharedProfileAccessData(
      {required this.id, required this.receiverDid, required this.profileId, required this.accessLevel});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receiver_did'] = Variable<String>(receiverDid);
    map['profile_id'] = Variable<String>(profileId);
    map['access_level'] = Variable<String>(accessLevel);
    return map;
  }

  SharedProfileAccessCompanion toCompanion(bool nullToAbsent) {
    return SharedProfileAccessCompanion(
      id: Value(id),
      receiverDid: Value(receiverDid),
      profileId: Value(profileId),
      accessLevel: Value(accessLevel),
    );
  }

  factory SharedProfileAccessData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SharedProfileAccessData(
      id: serializer.fromJson<int>(json['id']),
      receiverDid: serializer.fromJson<String>(json['receiverDid']),
      profileId: serializer.fromJson<String>(json['profileId']),
      accessLevel: serializer.fromJson<String>(json['accessLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receiverDid': serializer.toJson<String>(receiverDid),
      'profileId': serializer.toJson<String>(profileId),
      'accessLevel': serializer.toJson<String>(accessLevel),
    };
  }

  SharedProfileAccessData copyWith({int? id, String? receiverDid, String? profileId, String? accessLevel}) =>
      SharedProfileAccessData(
        id: id ?? this.id,
        receiverDid: receiverDid ?? this.receiverDid,
        profileId: profileId ?? this.profileId,
        accessLevel: accessLevel ?? this.accessLevel,
      );
  SharedProfileAccessData copyWithCompanion(SharedProfileAccessCompanion data) {
    return SharedProfileAccessData(
      id: data.id.present ? data.id.value : this.id,
      receiverDid: data.receiverDid.present ? data.receiverDid.value : this.receiverDid,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      accessLevel: data.accessLevel.present ? data.accessLevel.value : this.accessLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SharedProfileAccessData(')
          ..write('id: $id, ')
          ..write('receiverDid: $receiverDid, ')
          ..write('profileId: $profileId, ')
          ..write('accessLevel: $accessLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, receiverDid, profileId, accessLevel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SharedProfileAccessData &&
          other.id == this.id &&
          other.receiverDid == this.receiverDid &&
          other.profileId == this.profileId &&
          other.accessLevel == this.accessLevel);
}

class SharedProfileAccessCompanion extends UpdateCompanion<SharedProfileAccessData> {
  final Value<int> id;
  final Value<String> receiverDid;
  final Value<String> profileId;
  final Value<String> accessLevel;
  const SharedProfileAccessCompanion({
    this.id = const Value.absent(),
    this.receiverDid = const Value.absent(),
    this.profileId = const Value.absent(),
    this.accessLevel = const Value.absent(),
  });
  SharedProfileAccessCompanion.insert({
    this.id = const Value.absent(),
    required String receiverDid,
    required String profileId,
    required String accessLevel,
  })  : receiverDid = Value(receiverDid),
        profileId = Value(profileId),
        accessLevel = Value(accessLevel);
  static Insertable<SharedProfileAccessData> custom({
    Expression<int>? id,
    Expression<String>? receiverDid,
    Expression<String>? profileId,
    Expression<String>? accessLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiverDid != null) 'receiver_did': receiverDid,
      if (profileId != null) 'profile_id': profileId,
      if (accessLevel != null) 'access_level': accessLevel,
    });
  }

  SharedProfileAccessCompanion copyWith(
      {Value<int>? id, Value<String>? receiverDid, Value<String>? profileId, Value<String>? accessLevel}) {
    return SharedProfileAccessCompanion(
      id: id ?? this.id,
      receiverDid: receiverDid ?? this.receiverDid,
      profileId: profileId ?? this.profileId,
      accessLevel: accessLevel ?? this.accessLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receiverDid.present) {
      map['receiver_did'] = Variable<String>(receiverDid.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (accessLevel.present) {
      map['access_level'] = Variable<String>(accessLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SharedProfileAccessCompanion(')
          ..write('id: $id, ')
          ..write('receiverDid: $receiverDid, ')
          ..write('profileId: $profileId, ')
          ..write('accessLevel: $accessLevel')
          ..write(')'))
        .toString();
  }
}

class $FileSettingsTable extends FileSettings with TableInfo<$FileSettingsTable, FileSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(DatabaseConstants.globalFileSettingsId));
  static const VerificationMeta _maxFileSizeMeta = const VerificationMeta('maxFileSize');
  @override
  late final GeneratedColumn<int> maxFileSize =
      GeneratedColumn<int>('max_file_size', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _allowedExtensionsMeta = const VerificationMeta('allowedExtensions');
  @override
  late final GeneratedColumn<String> allowedExtensions = GeneratedColumn<String>(
      'allowed_extensions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, maxFileSize, allowedExtensions];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_settings';
  @override
  VerificationContext validateIntegrity(Insertable<FileSetting> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('max_file_size')) {
      context.handle(_maxFileSizeMeta, maxFileSize.isAcceptableOrUnknown(data['max_file_size']!, _maxFileSizeMeta));
    }
    if (data.containsKey('allowed_extensions')) {
      context.handle(_allowedExtensionsMeta,
          allowedExtensions.isAcceptableOrUnknown(data['allowed_extensions']!, _allowedExtensionsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FileSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FileSetting(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      maxFileSize: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}max_file_size']),
      allowedExtensions:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}allowed_extensions']),
    );
  }

  @override
  $FileSettingsTable createAlias(String alias) {
    return $FileSettingsTable(attachedDatabase, alias);
  }
}

class FileSetting extends DataClass implements Insertable<FileSetting> {
  final int id;
  final int? maxFileSize;
  final String? allowedExtensions;
  const FileSetting({required this.id, this.maxFileSize, this.allowedExtensions});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || maxFileSize != null) {
      map['max_file_size'] = Variable<int>(maxFileSize);
    }
    if (!nullToAbsent || allowedExtensions != null) {
      map['allowed_extensions'] = Variable<String>(allowedExtensions);
    }
    return map;
  }

  FileSettingsCompanion toCompanion(bool nullToAbsent) {
    return FileSettingsCompanion(
      id: Value(id),
      maxFileSize: maxFileSize == null && nullToAbsent ? const Value.absent() : Value(maxFileSize),
      allowedExtensions: allowedExtensions == null && nullToAbsent ? const Value.absent() : Value(allowedExtensions),
    );
  }

  factory FileSetting.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FileSetting(
      id: serializer.fromJson<int>(json['id']),
      maxFileSize: serializer.fromJson<int?>(json['maxFileSize']),
      allowedExtensions: serializer.fromJson<String?>(json['allowedExtensions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'maxFileSize': serializer.toJson<int?>(maxFileSize),
      'allowedExtensions': serializer.toJson<String?>(allowedExtensions),
    };
  }

  FileSetting copyWith(
          {int? id,
          Value<int?> maxFileSize = const Value.absent(),
          Value<String?> allowedExtensions = const Value.absent()}) =>
      FileSetting(
        id: id ?? this.id,
        maxFileSize: maxFileSize.present ? maxFileSize.value : this.maxFileSize,
        allowedExtensions: allowedExtensions.present ? allowedExtensions.value : this.allowedExtensions,
      );
  FileSetting copyWithCompanion(FileSettingsCompanion data) {
    return FileSetting(
      id: data.id.present ? data.id.value : this.id,
      maxFileSize: data.maxFileSize.present ? data.maxFileSize.value : this.maxFileSize,
      allowedExtensions: data.allowedExtensions.present ? data.allowedExtensions.value : this.allowedExtensions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FileSetting(')
          ..write('id: $id, ')
          ..write('maxFileSize: $maxFileSize, ')
          ..write('allowedExtensions: $allowedExtensions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, maxFileSize, allowedExtensions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FileSetting &&
          other.id == this.id &&
          other.maxFileSize == this.maxFileSize &&
          other.allowedExtensions == this.allowedExtensions);
}

class FileSettingsCompanion extends UpdateCompanion<FileSetting> {
  final Value<int> id;
  final Value<int?> maxFileSize;
  final Value<String?> allowedExtensions;
  const FileSettingsCompanion({
    this.id = const Value.absent(),
    this.maxFileSize = const Value.absent(),
    this.allowedExtensions = const Value.absent(),
  });
  FileSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.maxFileSize = const Value.absent(),
    this.allowedExtensions = const Value.absent(),
  });
  static Insertable<FileSetting> custom({
    Expression<int>? id,
    Expression<int>? maxFileSize,
    Expression<String>? allowedExtensions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maxFileSize != null) 'max_file_size': maxFileSize,
      if (allowedExtensions != null) 'allowed_extensions': allowedExtensions,
    });
  }

  FileSettingsCompanion copyWith({Value<int>? id, Value<int?>? maxFileSize, Value<String?>? allowedExtensions}) {
    return FileSettingsCompanion(
      id: id ?? this.id,
      maxFileSize: maxFileSize ?? this.maxFileSize,
      allowedExtensions: allowedExtensions ?? this.allowedExtensions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (maxFileSize.present) {
      map['max_file_size'] = Variable<int>(maxFileSize.value);
    }
    if (allowedExtensions.present) {
      map['allowed_extensions'] = Variable<String>(allowedExtensions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileSettingsCompanion(')
          ..write('id: $id, ')
          ..write('maxFileSize: $maxFileSize, ')
          ..write('allowedExtensions: $allowedExtensions')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SharedProfileAccessTable sharedProfileAccess = $SharedProfileAccessTable(this);
  late final $FileSettingsTable fileSettings = $FileSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sharedProfileAccess, fileSettings];
}

typedef $$SharedProfileAccessTableCreateCompanionBuilder = SharedProfileAccessCompanion Function({
  Value<int> id,
  required String receiverDid,
  required String profileId,
  required String accessLevel,
});
typedef $$SharedProfileAccessTableUpdateCompanionBuilder = SharedProfileAccessCompanion Function({
  Value<int> id,
  Value<String> receiverDid,
  Value<String> profileId,
  Value<String> accessLevel,
});

class $$SharedProfileAccessTableFilterComposer extends Composer<_$AppDatabase, $SharedProfileAccessTable> {
  $$SharedProfileAccessTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiverDid =>
      $composableBuilder(column: $table.receiverDid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accessLevel =>
      $composableBuilder(column: $table.accessLevel, builder: (column) => ColumnFilters(column));
}

class $$SharedProfileAccessTableOrderingComposer extends Composer<_$AppDatabase, $SharedProfileAccessTable> {
  $$SharedProfileAccessTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiverDid =>
      $composableBuilder(column: $table.receiverDid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accessLevel =>
      $composableBuilder(column: $table.accessLevel, builder: (column) => ColumnOrderings(column));
}

class $$SharedProfileAccessTableAnnotationComposer extends Composer<_$AppDatabase, $SharedProfileAccessTable> {
  $$SharedProfileAccessTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receiverDid =>
      $composableBuilder(column: $table.receiverDid, builder: (column) => column);

  GeneratedColumn<String> get profileId => $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get accessLevel =>
      $composableBuilder(column: $table.accessLevel, builder: (column) => column);
}

class $$SharedProfileAccessTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SharedProfileAccessTable,
    SharedProfileAccessData,
    $$SharedProfileAccessTableFilterComposer,
    $$SharedProfileAccessTableOrderingComposer,
    $$SharedProfileAccessTableAnnotationComposer,
    $$SharedProfileAccessTableCreateCompanionBuilder,
    $$SharedProfileAccessTableUpdateCompanionBuilder,
    (SharedProfileAccessData, BaseReferences<_$AppDatabase, $SharedProfileAccessTable, SharedProfileAccessData>),
    SharedProfileAccessData,
    PrefetchHooks Function()> {
  $$SharedProfileAccessTableTableManager(_$AppDatabase db, $SharedProfileAccessTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SharedProfileAccessTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SharedProfileAccessTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SharedProfileAccessTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> receiverDid = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<String> accessLevel = const Value.absent(),
          }) =>
              SharedProfileAccessCompanion(
            id: id,
            receiverDid: receiverDid,
            profileId: profileId,
            accessLevel: accessLevel,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String receiverDid,
            required String profileId,
            required String accessLevel,
          }) =>
              SharedProfileAccessCompanion.insert(
            id: id,
            receiverDid: receiverDid,
            profileId: profileId,
            accessLevel: accessLevel,
          ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SharedProfileAccessTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SharedProfileAccessTable,
    SharedProfileAccessData,
    $$SharedProfileAccessTableFilterComposer,
    $$SharedProfileAccessTableOrderingComposer,
    $$SharedProfileAccessTableAnnotationComposer,
    $$SharedProfileAccessTableCreateCompanionBuilder,
    $$SharedProfileAccessTableUpdateCompanionBuilder,
    (SharedProfileAccessData, BaseReferences<_$AppDatabase, $SharedProfileAccessTable, SharedProfileAccessData>),
    SharedProfileAccessData,
    PrefetchHooks Function()>;
typedef $$FileSettingsTableCreateCompanionBuilder = FileSettingsCompanion Function({
  Value<int> id,
  Value<int?> maxFileSize,
  Value<String?> allowedExtensions,
});
typedef $$FileSettingsTableUpdateCompanionBuilder = FileSettingsCompanion Function({
  Value<int> id,
  Value<int?> maxFileSize,
  Value<String?> allowedExtensions,
});

class $$FileSettingsTableFilterComposer extends Composer<_$AppDatabase, $FileSettingsTable> {
  $$FileSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxFileSize =>
      $composableBuilder(column: $table.maxFileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allowedExtensions =>
      $composableBuilder(column: $table.allowedExtensions, builder: (column) => ColumnFilters(column));
}

class $$FileSettingsTableOrderingComposer extends Composer<_$AppDatabase, $FileSettingsTable> {
  $$FileSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxFileSize =>
      $composableBuilder(column: $table.maxFileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allowedExtensions =>
      $composableBuilder(column: $table.allowedExtensions, builder: (column) => ColumnOrderings(column));
}

class $$FileSettingsTableAnnotationComposer extends Composer<_$AppDatabase, $FileSettingsTable> {
  $$FileSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get maxFileSize => $composableBuilder(column: $table.maxFileSize, builder: (column) => column);

  GeneratedColumn<String> get allowedExtensions =>
      $composableBuilder(column: $table.allowedExtensions, builder: (column) => column);
}

class $$FileSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FileSettingsTable,
    FileSetting,
    $$FileSettingsTableFilterComposer,
    $$FileSettingsTableOrderingComposer,
    $$FileSettingsTableAnnotationComposer,
    $$FileSettingsTableCreateCompanionBuilder,
    $$FileSettingsTableUpdateCompanionBuilder,
    (FileSetting, BaseReferences<_$AppDatabase, $FileSettingsTable, FileSetting>),
    FileSetting,
    PrefetchHooks Function()> {
  $$FileSettingsTableTableManager(_$AppDatabase db, $FileSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$FileSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$FileSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$FileSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> maxFileSize = const Value.absent(),
            Value<String?> allowedExtensions = const Value.absent(),
          }) =>
              FileSettingsCompanion(
            id: id,
            maxFileSize: maxFileSize,
            allowedExtensions: allowedExtensions,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> maxFileSize = const Value.absent(),
            Value<String?> allowedExtensions = const Value.absent(),
          }) =>
              FileSettingsCompanion.insert(
            id: id,
            maxFileSize: maxFileSize,
            allowedExtensions: allowedExtensions,
          ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FileSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FileSettingsTable,
    FileSetting,
    $$FileSettingsTableFilterComposer,
    $$FileSettingsTableOrderingComposer,
    $$FileSettingsTableAnnotationComposer,
    $$FileSettingsTableCreateCompanionBuilder,
    $$FileSettingsTableUpdateCompanionBuilder,
    (FileSetting, BaseReferences<_$AppDatabase, $FileSettingsTable, FileSetting>),
    FileSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SharedProfileAccessTableTableManager get sharedProfileAccess =>
      $$SharedProfileAccessTableTableManager(_db, _db.sharedProfileAccess);
  $$FileSettingsTableTableManager get fileSettings => $$FileSettingsTableTableManager(_db, _db.fileSettings);
}
