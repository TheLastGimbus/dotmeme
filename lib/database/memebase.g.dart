// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memebase.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Folder extends DataClass implements Insertable<Folder> {
  final int id;
  final String name;

  /// Whether to show and scan memes from this folder
  final bool scanningEnabled;

  /// WARNING: Turns out moor returns DateTimes in local time!
  /// This, for example, brakes tests!
  final DateTime lastModified;
  Folder(
      {required this.id,
      required this.name,
      required this.scanningEnabled,
      required this.lastModified});
  factory Folder.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Folder(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      scanningEnabled: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}scanning_enabled'])!,
      lastModified: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_modified'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['scanning_enabled'] = Variable<bool>(scanningEnabled);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      scanningEnabled: Value(scanningEnabled),
      lastModified: Value(lastModified),
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      scanningEnabled: serializer.fromJson<bool>(json['scanningEnabled']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'scanningEnabled': serializer.toJson<bool>(scanningEnabled),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  Folder copyWith(
          {int? id,
          String? name,
          bool? scanningEnabled,
          DateTime? lastModified}) =>
      Folder(
        id: id ?? this.id,
        name: name ?? this.name,
        scanningEnabled: scanningEnabled ?? this.scanningEnabled,
        lastModified: lastModified ?? this.lastModified,
      );
  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scanningEnabled: $scanningEnabled, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(name.hashCode,
          $mrjc(scanningEnabled.hashCode, lastModified.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.name == this.name &&
          other.scanningEnabled == this.scanningEnabled &&
          other.lastModified == this.lastModified);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> scanningEnabled;
  final Value<DateTime> lastModified;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.scanningEnabled = const Value.absent(),
    this.lastModified = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.scanningEnabled = const Value.absent(),
    this.lastModified = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Folder> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? scanningEnabled,
    Expression<DateTime>? lastModified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (scanningEnabled != null) 'scanning_enabled': scanningEnabled,
      if (lastModified != null) 'last_modified': lastModified,
    });
  }

  FoldersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<bool>? scanningEnabled,
      Value<DateTime>? lastModified}) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      scanningEnabled: scanningEnabled ?? this.scanningEnabled,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scanningEnabled.present) {
      map['scanning_enabled'] = Variable<bool>(scanningEnabled.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scanningEnabled: $scanningEnabled, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  final GeneratedDatabase _db;
  final String? _alias;
  $FoldersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _scanningEnabledMeta =
      const VerificationMeta('scanningEnabled');
  late final GeneratedColumn<bool?> scanningEnabled = GeneratedColumn<bool?>(
      'scanning_enabled', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (scanning_enabled IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, scanningEnabled, lastModified];
  @override
  String get aliasedName => _alias ?? 'folders';
  @override
  String get actualTableName => 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<Folder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scanning_enabled')) {
      context.handle(
          _scanningEnabledMeta,
          scanningEnabled.isAcceptableOrUnknown(
              data['scanning_enabled']!, _scanningEnabledMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
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

  /// [MemeType] - image or video
  final int memeType;

  /// WARNING: Turns out moor returns DateTimes in local time!
  /// This, for example, brakes tests!
  final DateTime lastModified;

  /// Text from OCR - can be null if not scanned yet
  final String? scannedText;

  /// Version of OCR scanner. If it's lower than current one, it means we have
  /// some new, better one, and we may want to re-scan those images
  ///
  /// The exception is when it's [-1] - then it means it was labeled by hand
  /// - don't touch this!
  ///
  /// It's nullable, because meme may not be scanned yet
  final int? textScannerVersion;
  Meme(
      {required this.id,
      required this.folderId,
      required this.memeType,
      required this.lastModified,
      this.scannedText,
      this.textScannerVersion});
  factory Meme.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Meme(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      folderId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}folder_id'])!,
      memeType: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}meme_type'])!,
      lastModified: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_modified'])!,
      scannedText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}scanned_text']),
      textScannerVersion: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}text_scanner_version']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['folder_id'] = Variable<int>(folderId);
    map['meme_type'] = Variable<int>(memeType);
    map['last_modified'] = Variable<DateTime>(lastModified);
    if (!nullToAbsent || scannedText != null) {
      map['scanned_text'] = Variable<String?>(scannedText);
    }
    if (!nullToAbsent || textScannerVersion != null) {
      map['text_scanner_version'] = Variable<int?>(textScannerVersion);
    }
    return map;
  }

  MemesCompanion toCompanion(bool nullToAbsent) {
    return MemesCompanion(
      id: Value(id),
      folderId: Value(folderId),
      memeType: Value(memeType),
      lastModified: Value(lastModified),
      scannedText: scannedText == null && nullToAbsent
          ? const Value.absent()
          : Value(scannedText),
      textScannerVersion: textScannerVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(textScannerVersion),
    );
  }

  factory Meme.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Meme(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
      memeType: serializer.fromJson<int>(json['memeType']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      scannedText: serializer.fromJson<String?>(json['scannedText']),
      textScannerVersion: serializer.fromJson<int?>(json['textScannerVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
      'memeType': serializer.toJson<int>(memeType),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'scannedText': serializer.toJson<String?>(scannedText),
      'textScannerVersion': serializer.toJson<int?>(textScannerVersion),
    };
  }

  Meme copyWith(
          {int? id,
          int? folderId,
          int? memeType,
          DateTime? lastModified,
          String? scannedText,
          int? textScannerVersion}) =>
      Meme(
        id: id ?? this.id,
        folderId: folderId ?? this.folderId,
        memeType: memeType ?? this.memeType,
        lastModified: lastModified ?? this.lastModified,
        scannedText: scannedText ?? this.scannedText,
        textScannerVersion: textScannerVersion ?? this.textScannerVersion,
      );
  @override
  String toString() {
    return (StringBuffer('Meme(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('memeType: $memeType, ')
          ..write('lastModified: $lastModified, ')
          ..write('scannedText: $scannedText, ')
          ..write('textScannerVersion: $textScannerVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          folderId.hashCode,
          $mrjc(
              memeType.hashCode,
              $mrjc(lastModified.hashCode,
                  $mrjc(scannedText.hashCode, textScannerVersion.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meme &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.memeType == this.memeType &&
          other.lastModified == this.lastModified &&
          other.scannedText == this.scannedText &&
          other.textScannerVersion == this.textScannerVersion);
}

class MemesCompanion extends UpdateCompanion<Meme> {
  final Value<int> id;
  final Value<int> folderId;
  final Value<int> memeType;
  final Value<DateTime> lastModified;
  final Value<String?> scannedText;
  final Value<int?> textScannerVersion;
  const MemesCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.memeType = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.scannedText = const Value.absent(),
    this.textScannerVersion = const Value.absent(),
  });
  MemesCompanion.insert({
    this.id = const Value.absent(),
    required int folderId,
    required int memeType,
    this.lastModified = const Value.absent(),
    this.scannedText = const Value.absent(),
    this.textScannerVersion = const Value.absent(),
  })  : folderId = Value(folderId),
        memeType = Value(memeType);
  static Insertable<Meme> custom({
    Expression<int>? id,
    Expression<int>? folderId,
    Expression<int>? memeType,
    Expression<DateTime>? lastModified,
    Expression<String?>? scannedText,
    Expression<int?>? textScannerVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (memeType != null) 'meme_type': memeType,
      if (lastModified != null) 'last_modified': lastModified,
      if (scannedText != null) 'scanned_text': scannedText,
      if (textScannerVersion != null)
        'text_scanner_version': textScannerVersion,
    });
  }

  MemesCompanion copyWith(
      {Value<int>? id,
      Value<int>? folderId,
      Value<int>? memeType,
      Value<DateTime>? lastModified,
      Value<String?>? scannedText,
      Value<int?>? textScannerVersion}) {
    return MemesCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      memeType: memeType ?? this.memeType,
      lastModified: lastModified ?? this.lastModified,
      scannedText: scannedText ?? this.scannedText,
      textScannerVersion: textScannerVersion ?? this.textScannerVersion,
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
    if (memeType.present) {
      map['meme_type'] = Variable<int>(memeType.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (scannedText.present) {
      map['scanned_text'] = Variable<String?>(scannedText.value);
    }
    if (textScannerVersion.present) {
      map['text_scanner_version'] = Variable<int?>(textScannerVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemesCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('memeType: $memeType, ')
          ..write('lastModified: $lastModified, ')
          ..write('scannedText: $scannedText, ')
          ..write('textScannerVersion: $textScannerVersion')
          ..write(')'))
        .toString();
  }
}

class $MemesTable extends Memes with TableInfo<$MemesTable, Meme> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MemesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _folderIdMeta = const VerificationMeta('folderId');
  late final GeneratedColumn<int?> folderId = GeneratedColumn<int?>(
      'folder_id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _memeTypeMeta = const VerificationMeta('memeType');
  late final GeneratedColumn<int?> memeType = GeneratedColumn<int?>(
      'meme_type', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _scannedTextMeta =
      const VerificationMeta('scannedText');
  late final GeneratedColumn<String?> scannedText = GeneratedColumn<String?>(
      'scanned_text', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _textScannerVersionMeta =
      const VerificationMeta('textScannerVersion');
  late final GeneratedColumn<int?> textScannerVersion = GeneratedColumn<int?>(
      'text_scanner_version', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, folderId, memeType, lastModified, scannedText, textScannerVersion];
  @override
  String get aliasedName => _alias ?? 'memes';
  @override
  String get actualTableName => 'memes';
  @override
  VerificationContext validateIntegrity(Insertable<Meme> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta));
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('meme_type')) {
      context.handle(_memeTypeMeta,
          memeType.isAcceptableOrUnknown(data['meme_type']!, _memeTypeMeta));
    } else if (isInserting) {
      context.missing(_memeTypeMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('scanned_text')) {
      context.handle(
          _scannedTextMeta,
          scannedText.isAcceptableOrUnknown(
              data['scanned_text']!, _scannedTextMeta));
    }
    if (data.containsKey('text_scanner_version')) {
      context.handle(
          _textScannerVersionMeta,
          textScannerVersion.isAcceptableOrUnknown(
              data['text_scanner_version']!, _textScannerVersionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
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
  _$Memebase.connect(DatabaseConnection c) : super.connect(c);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $MemesTable memes = $MemesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [folders, memes];
}
