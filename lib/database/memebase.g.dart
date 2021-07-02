// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memebase.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Folder extends DataClass implements Insertable<Folder> {
  final int id;
  final bool scanningEnabled;
  Folder({required this.id, required this.scanningEnabled});
  factory Folder.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Folder(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      scanningEnabled: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}scanning_enabled'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scanning_enabled'] = Variable<bool>(scanningEnabled);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      scanningEnabled: Value(scanningEnabled),
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<int>(json['id']),
      scanningEnabled: serializer.fromJson<bool>(json['scanningEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scanningEnabled': serializer.toJson<bool>(scanningEnabled),
    };
  }

  Folder copyWith({int? id, bool? scanningEnabled}) => Folder(
        id: id ?? this.id,
        scanningEnabled: scanningEnabled ?? this.scanningEnabled,
      );
  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('scanningEnabled: $scanningEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, scanningEnabled.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.scanningEnabled == this.scanningEnabled);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<int> id;
  final Value<bool> scanningEnabled;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.scanningEnabled = const Value.absent(),
  });
  FoldersCompanion.insert({
    required int id,
    this.scanningEnabled = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Folder> custom({
    Expression<int>? id,
    Expression<bool>? scanningEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scanningEnabled != null) 'scanning_enabled': scanningEnabled,
    });
  }

  FoldersCompanion copyWith({Value<int>? id, Value<bool>? scanningEnabled}) {
    return FoldersCompanion(
      id: id ?? this.id,
      scanningEnabled: scanningEnabled ?? this.scanningEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scanningEnabled.present) {
      map['scanning_enabled'] = Variable<bool>(scanningEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('scanningEnabled: $scanningEnabled')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  final GeneratedDatabase _db;
  final String? _alias;
  $FoldersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _scanningEnabledMeta =
      const VerificationMeta('scanningEnabled');
  @override
  late final GeneratedBoolColumn scanningEnabled = _constructScanningEnabled();
  GeneratedBoolColumn _constructScanningEnabled() {
    return GeneratedBoolColumn('scanning_enabled', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, scanningEnabled];
  @override
  $FoldersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'folders';
  @override
  final String actualTableName = 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<Folder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('scanning_enabled')) {
      context.handle(
          _scanningEnabledMeta,
          scanningEnabled.isAcceptableOrUnknown(
              data['scanning_enabled']!, _scanningEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Folder.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(_db, alias);
  }
}

class Meme extends DataClass implements Insertable<Meme> {
  final int id;
  final int folderId;
  Meme({required this.id, required this.folderId});
  factory Meme.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Meme(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      folderId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}folder_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['folder_id'] = Variable<int>(folderId);
    return map;
  }

  MemesCompanion toCompanion(bool nullToAbsent) {
    return MemesCompanion(
      id: Value(id),
      folderId: Value(folderId),
    );
  }

  factory Meme.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Meme(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
    };
  }

  Meme copyWith({int? id, int? folderId}) => Meme(
        id: id ?? this.id,
        folderId: folderId ?? this.folderId,
      );
  @override
  String toString() {
    return (StringBuffer('Meme(')
          ..write('id: $id, ')
          ..write('folderId: $folderId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, folderId.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meme && other.id == this.id && other.folderId == this.folderId);
}

class MemesCompanion extends UpdateCompanion<Meme> {
  final Value<int> id;
  final Value<int> folderId;
  const MemesCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
  });
  MemesCompanion.insert({
    required int id,
    required int folderId,
  })  : id = Value(id),
        folderId = Value(folderId);
  static Insertable<Meme> custom({
    Expression<int>? id,
    Expression<int>? folderId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
    });
  }

  MemesCompanion copyWith({Value<int>? id, Value<int>? folderId}) {
    return MemesCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemesCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId')
          ..write(')'))
        .toString();
  }
}

class $MemesTable extends Memes with TableInfo<$MemesTable, Meme> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MemesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _folderIdMeta = const VerificationMeta('folderId');
  @override
  late final GeneratedIntColumn folderId = _constructFolderId();
  GeneratedIntColumn _constructFolderId() {
    return GeneratedIntColumn(
      'folder_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, folderId];
  @override
  $MemesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'memes';
  @override
  final String actualTableName = 'memes';
  @override
  VerificationContext validateIntegrity(Insertable<Meme> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta));
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Meme map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Meme.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MemesTable createAlias(String alias) {
    return $MemesTable(_db, alias);
  }
}

abstract class _$Memebase extends GeneratedDatabase {
  _$Memebase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $MemesTable memes = $MemesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [folders, memes];
}
