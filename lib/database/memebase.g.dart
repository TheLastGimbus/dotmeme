// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memebase.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Folder extends DataClass implements Insertable<Folder> {
  final int id;
  final bool scanningEnabled;
  final DateTime lastSync;
  Folder(
      {@required this.id,
      @required this.scanningEnabled,
      @required this.lastSync});
  factory Folder.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Folder(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      scanningEnabled: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}scanning_enabled']),
      lastSync: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_sync']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || scanningEnabled != null) {
      map['scanning_enabled'] = Variable<bool>(scanningEnabled);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    return map;
  }

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<int>(json['id']),
      scanningEnabled: serializer.fromJson<bool>(json['scanningEnabled']),
      lastSync: serializer.fromJson<DateTime>(json['lastSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scanningEnabled': serializer.toJson<bool>(scanningEnabled),
      'lastSync': serializer.toJson<DateTime>(lastSync),
    };
  }

  Folder copyWith({int id, bool scanningEnabled, DateTime lastSync}) => Folder(
        id: id ?? this.id,
        scanningEnabled: scanningEnabled ?? this.scanningEnabled,
        lastSync: lastSync ?? this.lastSync,
      );
  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('scanningEnabled: $scanningEnabled, ')
          ..write('lastSync: $lastSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(id.hashCode, $mrjc(scanningEnabled.hashCode, lastSync.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.scanningEnabled == this.scanningEnabled &&
          other.lastSync == this.lastSync);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<int> id;
  final Value<bool> scanningEnabled;
  final Value<DateTime> lastSync;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.scanningEnabled = const Value.absent(),
    this.lastSync = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    @required bool scanningEnabled,
    this.lastSync = const Value.absent(),
  }) : scanningEnabled = Value(scanningEnabled);
  static Insertable<Folder> custom({
    Expression<int> id,
    Expression<bool> scanningEnabled,
    Expression<DateTime> lastSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scanningEnabled != null) 'scanning_enabled': scanningEnabled,
      if (lastSync != null) 'last_sync': lastSync,
    });
  }

  FoldersCompanion copyWith(
      {Value<int> id, Value<bool> scanningEnabled, Value<DateTime> lastSync}) {
    return FoldersCompanion(
      id: id ?? this.id,
      scanningEnabled: scanningEnabled ?? this.scanningEnabled,
      lastSync: lastSync ?? this.lastSync,
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
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    return map;
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

  final VerificationMeta _lastSyncMeta = const VerificationMeta('lastSync');
  GeneratedDateTimeColumn _lastSync;
  @override
  GeneratedDateTimeColumn get lastSync => _lastSync ??= _constructLastSync();
  GeneratedDateTimeColumn _constructLastSync() {
    return GeneratedDateTimeColumn('last_sync', $tableName, false,
        defaultValue: Constant(DateTime.fromMillisecondsSinceEpoch(0)));
  }

  @override
  List<GeneratedColumn> get $columns => [id, scanningEnabled, lastSync];
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
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('scanning_enabled')) {
      context.handle(
          _scanningEnabledMeta,
          scanningEnabled.isAcceptableOrUnknown(
              data['scanning_enabled'], _scanningEnabledMeta));
    } else if (isInserting) {
      context.missing(_scanningEnabledMeta);
    }
    if (data.containsKey('last_sync')) {
      context.handle(_lastSyncMeta,
          lastSync.isAcceptableOrUnknown(data['last_sync'], _lastSyncMeta));
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
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(_db, alias);
  }
}

class Meme extends DataClass implements Insertable<Meme> {
  final int id;
  final int folderId;
  final String scannedText;
  final DateTime modificationDate;
  Meme(
      {@required this.id,
      @required this.folderId,
      this.scannedText,
      @required this.modificationDate});
  factory Meme.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Meme(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      folderId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}folder_id']),
      scannedText:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}text']),
      modificationDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}modification_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<int>(folderId);
    }
    if (!nullToAbsent || scannedText != null) {
      map['text'] = Variable<String>(scannedText);
    }
    if (!nullToAbsent || modificationDate != null) {
      map['modification_date'] = Variable<DateTime>(modificationDate);
    }
    return map;
  }

  factory Meme.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Meme(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
      scannedText: serializer.fromJson<String>(json['scannedText']),
      modificationDate: serializer.fromJson<DateTime>(json['modificationDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
      'scannedText': serializer.toJson<String>(scannedText),
      'modificationDate': serializer.toJson<DateTime>(modificationDate),
    };
  }

  Meme copyWith(
          {int id,
          int folderId,
          String scannedText,
          DateTime modificationDate}) =>
      Meme(
        id: id ?? this.id,
        folderId: folderId ?? this.folderId,
        scannedText: scannedText ?? this.scannedText,
        modificationDate: modificationDate ?? this.modificationDate,
      );
  @override
  String toString() {
    return (StringBuffer('Meme(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('scannedText: $scannedText, ')
          ..write('modificationDate: $modificationDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(folderId.hashCode,
          $mrjc(scannedText.hashCode, modificationDate.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Meme &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.scannedText == this.scannedText &&
          other.modificationDate == this.modificationDate);
}

class MemesCompanion extends UpdateCompanion<Meme> {
  final Value<int> id;
  final Value<int> folderId;
  final Value<String> scannedText;
  final Value<DateTime> modificationDate;
  const MemesCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.scannedText = const Value.absent(),
    this.modificationDate = const Value.absent(),
  });
  MemesCompanion.insert({
    this.id = const Value.absent(),
    @required int folderId,
    this.scannedText = const Value.absent(),
    @required DateTime modificationDate,
  })  : folderId = Value(folderId),
        modificationDate = Value(modificationDate);
  static Insertable<Meme> custom({
    Expression<int> id,
    Expression<int> folderId,
    Expression<String> scannedText,
    Expression<DateTime> modificationDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (scannedText != null) 'text': scannedText,
      if (modificationDate != null) 'modification_date': modificationDate,
    });
  }

  MemesCompanion copyWith(
      {Value<int> id,
      Value<int> folderId,
      Value<String> scannedText,
      Value<DateTime> modificationDate}) {
    return MemesCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      scannedText: scannedText ?? this.scannedText,
      modificationDate: modificationDate ?? this.modificationDate,
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
    if (scannedText.present) {
      map['text'] = Variable<String>(scannedText.value);
    }
    if (modificationDate.present) {
      map['modification_date'] = Variable<DateTime>(modificationDate.value);
    }
    return map;
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

  final VerificationMeta _modificationDateMeta =
      const VerificationMeta('modificationDate');
  GeneratedDateTimeColumn _modificationDate;
  @override
  GeneratedDateTimeColumn get modificationDate =>
      _modificationDate ??= _constructModificationDate();
  GeneratedDateTimeColumn _constructModificationDate() {
    return GeneratedDateTimeColumn(
      'modification_date',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, folderId, scannedText, modificationDate];
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
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id'], _folderIdMeta));
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_scannedTextMeta,
          scannedText.isAcceptableOrUnknown(data['text'], _scannedTextMeta));
    }
    if (data.containsKey('modification_date')) {
      context.handle(
          _modificationDateMeta,
          modificationDate.isAcceptableOrUnknown(
              data['modification_date'], _modificationDateMeta));
    } else if (isInserting) {
      context.missing(_modificationDateMeta);
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
