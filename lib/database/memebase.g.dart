// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memebase.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Folder extends DataClass implements Insertable<Folder> {
  final int id;
  final bool scanningEnabled;

  Folder({@required this.id, @required this.scanningEnabled});

  factory Folder.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Folder(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      scanningEnabled: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}scanning_enabled']),
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<int>(json['id']),
      scanningEnabled: serializer.fromJson<bool>(json['scanningEnabled']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scanningEnabled': serializer.toJson<bool>(scanningEnabled),
    };
  }

  @override
  FoldersCompanion createCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      scanningEnabled: scanningEnabled == null && nullToAbsent
          ? const Value.absent()
          : Value(scanningEnabled),
    );
  }

  Folder copyWith({int id, bool scanningEnabled}) => Folder(
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
  bool operator ==(dynamic other) =>
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
    @required int id,
    @required bool scanningEnabled,
  })  : id = Value(id),
        scanningEnabled = Value(scanningEnabled);

  FoldersCompanion copyWith({Value<int> id, Value<bool> scanningEnabled}) {
    return FoldersCompanion(
      id: id ?? this.id,
      scanningEnabled: scanningEnabled ?? this.scanningEnabled,
    );
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  final GeneratedDatabase _db;
  final String _alias;

  $FoldersTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;

  @override
  GeneratedIntColumn get id => _id ??= _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  final VerificationMeta _scanningEnabledMeta =
      const VerificationMeta('scanningEnabled');
  GeneratedBoolColumn _scanningEnabled;

  @override
  GeneratedBoolColumn get scanningEnabled =>
      _scanningEnabled ??= _constructScanningEnabled();

  GeneratedBoolColumn _constructScanningEnabled() {
    return GeneratedBoolColumn(
      'scanning_enabled',
      $tableName,
      false,
    );
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
  VerificationContext validateIntegrity(FoldersCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.scanningEnabled.present) {
      context.handle(
          _scanningEnabledMeta,
          scanningEnabled.isAcceptableValue(
              d.scanningEnabled.value, _scanningEnabledMeta));
    } else if (isInserting) {
      context.missing(_scanningEnabledMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Folder map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Folder.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(FoldersCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.scanningEnabled.present) {
      map['scanning_enabled'] =
          Variable<bool, BoolType>(d.scanningEnabled.value);
    }
    return map;
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(_db, alias);
  }
}

class Meme extends DataClass implements Insertable<Meme> {
  final int id;
  final int folderId;
  final String scannedText;

  Meme({@required this.id, @required this.folderId, this.scannedText});

  factory Meme.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Meme(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      folderId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}folder_id']),
      scannedText:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}text']),
    );
  }

  factory Meme.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Meme(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
      scannedText: serializer.fromJson<String>(json['scannedText']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
      'scannedText': serializer.toJson<String>(scannedText),
    };
  }

  @override
  MemesCompanion createCompanion(bool nullToAbsent) {
    return MemesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      scannedText: scannedText == null && nullToAbsent
          ? const Value.absent()
          : Value(scannedText),
    );
  }

  Meme copyWith({int id, int folderId, String scannedText}) => Meme(
        id: id ?? this.id,
        folderId: folderId ?? this.folderId,
        scannedText: scannedText ?? this.scannedText,
      );

  @override
  String toString() {
    return (StringBuffer('Meme(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('scannedText: $scannedText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(folderId.hashCode, scannedText.hashCode)));

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Meme &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.scannedText == this.scannedText);
}

class MemesCompanion extends UpdateCompanion<Meme> {
  final Value<int> id;
  final Value<int> folderId;
  final Value<String> scannedText;

  const MemesCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.scannedText = const Value.absent(),
  });

  MemesCompanion.insert({
    @required int id,
    @required int folderId,
    this.scannedText = const Value.absent(),
  })  : id = Value(id),
        folderId = Value(folderId);

  MemesCompanion copyWith(
      {Value<int> id, Value<int> folderId, Value<String> scannedText}) {
    return MemesCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      scannedText: scannedText ?? this.scannedText,
    );
  }
}

class $MemesTable extends Memes with TableInfo<$MemesTable, Meme> {
  final GeneratedDatabase _db;
  final String _alias;

  $MemesTable(this._db, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;

  @override
  GeneratedIntColumn get id => _id ??= _constructId();

  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  final VerificationMeta _folderIdMeta = const VerificationMeta('folderId');
  GeneratedIntColumn _folderId;

  @override
  GeneratedIntColumn get folderId => _folderId ??= _constructFolderId();

  GeneratedIntColumn _constructFolderId() {
    return GeneratedIntColumn(
      'folder_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _scannedTextMeta =
      const VerificationMeta('scannedText');
  GeneratedTextColumn _scannedText;

  @override
  GeneratedTextColumn get scannedText =>
      _scannedText ??= _constructScannedText();

  GeneratedTextColumn _constructScannedText() {
    return GeneratedTextColumn(
      'text',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, folderId, scannedText];

  @override
  $MemesTable get asDslTable => this;

  @override
  String get $tableName => _alias ?? 'memes';
  @override
  final String actualTableName = 'memes';

  @override
  VerificationContext validateIntegrity(MemesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.folderId.present) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableValue(d.folderId.value, _folderIdMeta));
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (d.scannedText.present) {
      context.handle(_scannedTextMeta,
          scannedText.isAcceptableValue(d.scannedText.value, _scannedTextMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  Meme map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Meme.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(MemesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.folderId.present) {
      map['folder_id'] = Variable<int, IntType>(d.folderId.value);
    }
    if (d.scannedText.present) {
      map['text'] = Variable<String, StringType>(d.scannedText.value);
    }
    return map;
  }

  @override
  $MemesTable createAlias(String alias) {
    return $MemesTable(_db, alias);
  }
}

abstract class _$Memebase extends GeneratedDatabase {
  _$Memebase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FoldersTable _folders;

  $FoldersTable get folders => _folders ??= $FoldersTable(this);
  $MemesTable _memes;

  $MemesTable get memes => _memes ??= $MemesTable(this);

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [folders, memes];
}
