// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 4),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarSeedMeta = const VerificationMeta(
    'avatarSeed',
  );
  @override
  late final GeneratedColumn<int> avatarSeed = GeneratedColumn<int>(
    'avatar_seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
    'school',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _classNameMeta = const VerificationMeta(
    'className',
  );
  @override
  late final GeneratedColumn<String> className = GeneratedColumn<String>(
    'class_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    grade,
    languageCode,
    avatarSeed,
    school,
    className,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('avatar_seed')) {
      context.handle(
        _avatarSeedMeta,
        avatarSeed.isAcceptableOrUnknown(data['avatar_seed']!, _avatarSeedMeta),
      );
    }
    if (data.containsKey('school')) {
      context.handle(
        _schoolMeta,
        school.isAcceptableOrUnknown(data['school']!, _schoolMeta),
      );
    }
    if (data.containsKey('class_name')) {
      context.handle(
        _classNameMeta,
        className.isAcceptableOrUnknown(data['class_name']!, _classNameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      avatarSeed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avatar_seed'],
      )!,
      school: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school'],
      ),
      className: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final int id;
  final String name;
  final int grade;
  final String languageCode;
  final int avatarSeed;

  /// Optional school and class labels. These are the ONLY organisational
  /// fields collected — the app never stores CNIC, address, GPS location,
  /// phone number or family details.
  final String? school;
  final String? className;
  final DateTime createdAt;
  const Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.languageCode,
    required this.avatarSeed,
    this.school,
    this.className,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['grade'] = Variable<int>(grade);
    map['language_code'] = Variable<String>(languageCode);
    map['avatar_seed'] = Variable<int>(avatarSeed);
    if (!nullToAbsent || school != null) {
      map['school'] = Variable<String>(school);
    }
    if (!nullToAbsent || className != null) {
      map['class_name'] = Variable<String>(className);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      name: Value(name),
      grade: Value(grade),
      languageCode: Value(languageCode),
      avatarSeed: Value(avatarSeed),
      school: school == null && nullToAbsent
          ? const Value.absent()
          : Value(school),
      className: className == null && nullToAbsent
          ? const Value.absent()
          : Value(className),
      createdAt: Value(createdAt),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      grade: serializer.fromJson<int>(json['grade']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      avatarSeed: serializer.fromJson<int>(json['avatarSeed']),
      school: serializer.fromJson<String?>(json['school']),
      className: serializer.fromJson<String?>(json['className']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'grade': serializer.toJson<int>(grade),
      'languageCode': serializer.toJson<String>(languageCode),
      'avatarSeed': serializer.toJson<int>(avatarSeed),
      'school': serializer.toJson<String?>(school),
      'className': serializer.toJson<String?>(className),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Student copyWith({
    int? id,
    String? name,
    int? grade,
    String? languageCode,
    int? avatarSeed,
    Value<String?> school = const Value.absent(),
    Value<String?> className = const Value.absent(),
    DateTime? createdAt,
  }) => Student(
    id: id ?? this.id,
    name: name ?? this.name,
    grade: grade ?? this.grade,
    languageCode: languageCode ?? this.languageCode,
    avatarSeed: avatarSeed ?? this.avatarSeed,
    school: school.present ? school.value : this.school,
    className: className.present ? className.value : this.className,
    createdAt: createdAt ?? this.createdAt,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      grade: data.grade.present ? data.grade.value : this.grade,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      avatarSeed: data.avatarSeed.present
          ? data.avatarSeed.value
          : this.avatarSeed,
      school: data.school.present ? data.school.value : this.school,
      className: data.className.present ? data.className.value : this.className,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('grade: $grade, ')
          ..write('languageCode: $languageCode, ')
          ..write('avatarSeed: $avatarSeed, ')
          ..write('school: $school, ')
          ..write('className: $className, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    grade,
    languageCode,
    avatarSeed,
    school,
    className,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.name == this.name &&
          other.grade == this.grade &&
          other.languageCode == this.languageCode &&
          other.avatarSeed == this.avatarSeed &&
          other.school == this.school &&
          other.className == this.className &&
          other.createdAt == this.createdAt);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> grade;
  final Value<String> languageCode;
  final Value<int> avatarSeed;
  final Value<String?> school;
  final Value<String?> className;
  final Value<DateTime> createdAt;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.grade = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.avatarSeed = const Value.absent(),
    this.school = const Value.absent(),
    this.className = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StudentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int grade,
    required String languageCode,
    this.avatarSeed = const Value.absent(),
    this.school = const Value.absent(),
    this.className = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       grade = Value(grade),
       languageCode = Value(languageCode);
  static Insertable<Student> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? grade,
    Expression<String>? languageCode,
    Expression<int>? avatarSeed,
    Expression<String>? school,
    Expression<String>? className,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (grade != null) 'grade': grade,
      if (languageCode != null) 'language_code': languageCode,
      if (avatarSeed != null) 'avatar_seed': avatarSeed,
      if (school != null) 'school': school,
      if (className != null) 'class_name': className,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StudentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? grade,
    Value<String>? languageCode,
    Value<int>? avatarSeed,
    Value<String?>? school,
    Value<String?>? className,
    Value<DateTime>? createdAt,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      languageCode: languageCode ?? this.languageCode,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      school: school ?? this.school,
      className: className ?? this.className,
      createdAt: createdAt ?? this.createdAt,
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
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (avatarSeed.present) {
      map['avatar_seed'] = Variable<int>(avatarSeed.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('grade: $grade, ')
          ..write('languageCode: $languageCode, ')
          ..write('avatarSeed: $avatarSeed, ')
          ..write('school: $school, ')
          ..write('className: $className, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 32),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameUrMeta = const VerificationMeta('nameUr');
  @override
  late final GeneratedColumn<String> nameUr = GeneratedColumn<String>(
    'name_ur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namePsMeta = const VerificationMeta('namePs');
  @override
  late final GeneratedColumn<String> namePs = GeneratedColumn<String>(
    'name_ps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 8),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    grade,
    nameEn,
    nameUr,
    namePs,
    emoji,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ur')) {
      context.handle(
        _nameUrMeta,
        nameUr.isAcceptableOrUnknown(data['name_ur']!, _nameUrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameUrMeta);
    }
    if (data.containsKey('name_ps')) {
      context.handle(
        _namePsMeta,
        namePs.isAcceptableOrUnknown(data['name_ps']!, _namePsMeta),
      );
    } else if (isInserting) {
      context.missing(_namePsMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ur'],
      )!,
      namePs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ps'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final int id;
  final String code;
  final int grade;
  final String nameEn;
  final String nameUr;
  final String namePs;
  final String emoji;
  final int sortOrder;
  const Subject({
    required this.id,
    required this.code,
    required this.grade,
    required this.nameEn,
    required this.nameUr,
    required this.namePs,
    required this.emoji,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['grade'] = Variable<int>(grade);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ur'] = Variable<String>(nameUr);
    map['name_ps'] = Variable<String>(namePs);
    map['emoji'] = Variable<String>(emoji);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      code: Value(code),
      grade: Value(grade),
      nameEn: Value(nameEn),
      nameUr: Value(nameUr),
      namePs: Value(namePs),
      emoji: Value(emoji),
      sortOrder: Value(sortOrder),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      grade: serializer.fromJson<int>(json['grade']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameUr: serializer.fromJson<String>(json['nameUr']),
      namePs: serializer.fromJson<String>(json['namePs']),
      emoji: serializer.fromJson<String>(json['emoji']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'grade': serializer.toJson<int>(grade),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameUr': serializer.toJson<String>(nameUr),
      'namePs': serializer.toJson<String>(namePs),
      'emoji': serializer.toJson<String>(emoji),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Subject copyWith({
    int? id,
    String? code,
    int? grade,
    String? nameEn,
    String? nameUr,
    String? namePs,
    String? emoji,
    int? sortOrder,
  }) => Subject(
    id: id ?? this.id,
    code: code ?? this.code,
    grade: grade ?? this.grade,
    nameEn: nameEn ?? this.nameEn,
    nameUr: nameUr ?? this.nameUr,
    namePs: namePs ?? this.namePs,
    emoji: emoji ?? this.emoji,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      grade: data.grade.present ? data.grade.value : this.grade,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameUr: data.nameUr.present ? data.nameUr.value : this.nameUr,
      namePs: data.namePs.present ? data.namePs.value : this.namePs,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('grade: $grade, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameUr: $nameUr, ')
          ..write('namePs: $namePs, ')
          ..write('emoji: $emoji, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, grade, nameEn, nameUr, namePs, emoji, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.code == this.code &&
          other.grade == this.grade &&
          other.nameEn == this.nameEn &&
          other.nameUr == this.nameUr &&
          other.namePs == this.namePs &&
          other.emoji == this.emoji &&
          other.sortOrder == this.sortOrder);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<int> id;
  final Value<String> code;
  final Value<int> grade;
  final Value<String> nameEn;
  final Value<String> nameUr;
  final Value<String> namePs;
  final Value<String> emoji;
  final Value<int> sortOrder;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.grade = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameUr = const Value.absent(),
    this.namePs = const Value.absent(),
    this.emoji = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  SubjectsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required int grade,
    required String nameEn,
    required String nameUr,
    required String namePs,
    required String emoji,
    this.sortOrder = const Value.absent(),
  }) : code = Value(code),
       grade = Value(grade),
       nameEn = Value(nameEn),
       nameUr = Value(nameUr),
       namePs = Value(namePs),
       emoji = Value(emoji);
  static Insertable<Subject> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<int>? grade,
    Expression<String>? nameEn,
    Expression<String>? nameUr,
    Expression<String>? namePs,
    Expression<String>? emoji,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (grade != null) 'grade': grade,
      if (nameEn != null) 'name_en': nameEn,
      if (nameUr != null) 'name_ur': nameUr,
      if (namePs != null) 'name_ps': namePs,
      if (emoji != null) 'emoji': emoji,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  SubjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<int>? grade,
    Value<String>? nameEn,
    Value<String>? nameUr,
    Value<String>? namePs,
    Value<String>? emoji,
    Value<int>? sortOrder,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      grade: grade ?? this.grade,
      nameEn: nameEn ?? this.nameEn,
      nameUr: nameUr ?? this.nameUr,
      namePs: namePs ?? this.namePs,
      emoji: emoji ?? this.emoji,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameUr.present) {
      map['name_ur'] = Variable<String>(nameUr.value);
    }
    if (namePs.present) {
      map['name_ps'] = Variable<String>(namePs.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('grade: $grade, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameUr: $nameUr, ')
          ..write('namePs: $namePs, ')
          ..write('emoji: $emoji, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleUrMeta = const VerificationMeta(
    'titleUr',
  );
  @override
  late final GeneratedColumn<String> titleUr = GeneratedColumn<String>(
    'title_ur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titlePsMeta = const VerificationMeta(
    'titlePs',
  );
  @override
  late final GeneratedColumn<String> titlePs = GeneratedColumn<String>(
    'title_ps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    titleEn,
    titleUr,
    titlePs,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    } else if (isInserting) {
      context.missing(_titleEnMeta);
    }
    if (data.containsKey('title_ur')) {
      context.handle(
        _titleUrMeta,
        titleUr.isAcceptableOrUnknown(data['title_ur']!, _titleUrMeta),
      );
    } else if (isInserting) {
      context.missing(_titleUrMeta);
    }
    if (data.containsKey('title_ps')) {
      context.handle(
        _titlePsMeta,
        titlePs.isAcceptableOrUnknown(data['title_ps']!, _titlePsMeta),
      );
    } else if (isInserting) {
      context.missing(_titlePsMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      )!,
      titleUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ur'],
      )!,
      titlePs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ps'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final int subjectId;
  final String titleEn;
  final String titleUr;
  final String titlePs;
  final int sortOrder;
  const Unit({
    required this.id,
    required this.subjectId,
    required this.titleEn,
    required this.titleUr,
    required this.titlePs,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_id'] = Variable<int>(subjectId);
    map['title_en'] = Variable<String>(titleEn);
    map['title_ur'] = Variable<String>(titleUr);
    map['title_ps'] = Variable<String>(titlePs);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      titleEn: Value(titleEn),
      titleUr: Value(titleUr),
      titlePs: Value(titlePs),
      sortOrder: Value(sortOrder),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      titleEn: serializer.fromJson<String>(json['titleEn']),
      titleUr: serializer.fromJson<String>(json['titleUr']),
      titlePs: serializer.fromJson<String>(json['titlePs']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'titleEn': serializer.toJson<String>(titleEn),
      'titleUr': serializer.toJson<String>(titleUr),
      'titlePs': serializer.toJson<String>(titlePs),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Unit copyWith({
    int? id,
    int? subjectId,
    String? titleEn,
    String? titleUr,
    String? titlePs,
    int? sortOrder,
  }) => Unit(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    titleEn: titleEn ?? this.titleEn,
    titleUr: titleUr ?? this.titleUr,
    titlePs: titlePs ?? this.titlePs,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleUr: data.titleUr.present ? data.titleUr.value : this.titleUr,
      titlePs: data.titlePs.present ? data.titlePs.value : this.titlePs,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleUr: $titleUr, ')
          ..write('titlePs: $titlePs, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, subjectId, titleEn, titleUr, titlePs, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.titleEn == this.titleEn &&
          other.titleUr == this.titleUr &&
          other.titlePs == this.titlePs &&
          other.sortOrder == this.sortOrder);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<int> subjectId;
  final Value<String> titleEn;
  final Value<String> titleUr;
  final Value<String> titlePs;
  final Value<int> sortOrder;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleUr = const Value.absent(),
    this.titlePs = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required int subjectId,
    required String titleEn,
    required String titleUr,
    required String titlePs,
    this.sortOrder = const Value.absent(),
  }) : subjectId = Value(subjectId),
       titleEn = Value(titleEn),
       titleUr = Value(titleUr),
       titlePs = Value(titlePs);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<int>? subjectId,
    Expression<String>? titleEn,
    Expression<String>? titleUr,
    Expression<String>? titlePs,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (titleEn != null) 'title_en': titleEn,
      if (titleUr != null) 'title_ur': titleUr,
      if (titlePs != null) 'title_ps': titlePs,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  UnitsCompanion copyWith({
    Value<int>? id,
    Value<int>? subjectId,
    Value<String>? titleEn,
    Value<String>? titleUr,
    Value<String>? titlePs,
    Value<int>? sortOrder,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      titleEn: titleEn ?? this.titleEn,
      titleUr: titleUr ?? this.titleUr,
      titlePs: titlePs ?? this.titlePs,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleUr.present) {
      map['title_ur'] = Variable<String>(titleUr.value);
    }
    if (titlePs.present) {
      map['title_ps'] = Variable<String>(titlePs.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleUr: $titleUr, ')
          ..write('titlePs: $titlePs, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleUrMeta = const VerificationMeta(
    'titleUr',
  );
  @override
  late final GeneratedColumn<String> titleUr = GeneratedColumn<String>(
    'title_ur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titlePsMeta = const VerificationMeta(
    'titlePs',
  );
  @override
  late final GeneratedColumn<String> titlePs = GeneratedColumn<String>(
    'title_ps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectiveEnMeta = const VerificationMeta(
    'objectiveEn',
  );
  @override
  late final GeneratedColumn<String> objectiveEn = GeneratedColumn<String>(
    'objective_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectiveUrMeta = const VerificationMeta(
    'objectiveUr',
  );
  @override
  late final GeneratedColumn<String> objectiveUr = GeneratedColumn<String>(
    'objective_ur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectivePsMeta = const VerificationMeta(
    'objectivePs',
  );
  @override
  late final GeneratedColumn<String> objectivePs = GeneratedColumn<String>(
    'objective_ps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationEnMeta = const VerificationMeta(
    'explanationEn',
  );
  @override
  late final GeneratedColumn<String> explanationEn = GeneratedColumn<String>(
    'explanation_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationUrMeta = const VerificationMeta(
    'explanationUr',
  );
  @override
  late final GeneratedColumn<String> explanationUr = GeneratedColumn<String>(
    'explanation_ur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationPsMeta = const VerificationMeta(
    'explanationPs',
  );
  @override
  late final GeneratedColumn<String> explanationPs = GeneratedColumn<String>(
    'explanation_ps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleEnMeta = const VerificationMeta(
    'exampleEn',
  );
  @override
  late final GeneratedColumn<String> exampleEn = GeneratedColumn<String>(
    'example_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleUrMeta = const VerificationMeta(
    'exampleUr',
  );
  @override
  late final GeneratedColumn<String> exampleUr = GeneratedColumn<String>(
    'example_ur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examplePsMeta = const VerificationMeta(
    'examplePs',
  );
  @override
  late final GeneratedColumn<String> examplePs = GeneratedColumn<String>(
    'example_ps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _illustrationMeta = const VerificationMeta(
    'illustration',
  );
  @override
  late final GeneratedColumn<String> illustration = GeneratedColumn<String>(
    'illustration',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 8),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioAssetMeta = const VerificationMeta(
    'audioAsset',
  );
  @override
  late final GeneratedColumn<String> audioAsset = GeneratedColumn<String>(
    'audio_asset',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    unitId,
    titleEn,
    titleUr,
    titlePs,
    objectiveEn,
    objectiveUr,
    objectivePs,
    explanationEn,
    explanationUr,
    explanationPs,
    exampleEn,
    exampleUr,
    examplePs,
    illustration,
    audioAsset,
    sortOrder,
    isDemo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    } else if (isInserting) {
      context.missing(_titleEnMeta);
    }
    if (data.containsKey('title_ur')) {
      context.handle(
        _titleUrMeta,
        titleUr.isAcceptableOrUnknown(data['title_ur']!, _titleUrMeta),
      );
    } else if (isInserting) {
      context.missing(_titleUrMeta);
    }
    if (data.containsKey('title_ps')) {
      context.handle(
        _titlePsMeta,
        titlePs.isAcceptableOrUnknown(data['title_ps']!, _titlePsMeta),
      );
    } else if (isInserting) {
      context.missing(_titlePsMeta);
    }
    if (data.containsKey('objective_en')) {
      context.handle(
        _objectiveEnMeta,
        objectiveEn.isAcceptableOrUnknown(
          data['objective_en']!,
          _objectiveEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_objectiveEnMeta);
    }
    if (data.containsKey('objective_ur')) {
      context.handle(
        _objectiveUrMeta,
        objectiveUr.isAcceptableOrUnknown(
          data['objective_ur']!,
          _objectiveUrMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_objectiveUrMeta);
    }
    if (data.containsKey('objective_ps')) {
      context.handle(
        _objectivePsMeta,
        objectivePs.isAcceptableOrUnknown(
          data['objective_ps']!,
          _objectivePsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_objectivePsMeta);
    }
    if (data.containsKey('explanation_en')) {
      context.handle(
        _explanationEnMeta,
        explanationEn.isAcceptableOrUnknown(
          data['explanation_en']!,
          _explanationEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationEnMeta);
    }
    if (data.containsKey('explanation_ur')) {
      context.handle(
        _explanationUrMeta,
        explanationUr.isAcceptableOrUnknown(
          data['explanation_ur']!,
          _explanationUrMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationUrMeta);
    }
    if (data.containsKey('explanation_ps')) {
      context.handle(
        _explanationPsMeta,
        explanationPs.isAcceptableOrUnknown(
          data['explanation_ps']!,
          _explanationPsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationPsMeta);
    }
    if (data.containsKey('example_en')) {
      context.handle(
        _exampleEnMeta,
        exampleEn.isAcceptableOrUnknown(data['example_en']!, _exampleEnMeta),
      );
    } else if (isInserting) {
      context.missing(_exampleEnMeta);
    }
    if (data.containsKey('example_ur')) {
      context.handle(
        _exampleUrMeta,
        exampleUr.isAcceptableOrUnknown(data['example_ur']!, _exampleUrMeta),
      );
    } else if (isInserting) {
      context.missing(_exampleUrMeta);
    }
    if (data.containsKey('example_ps')) {
      context.handle(
        _examplePsMeta,
        examplePs.isAcceptableOrUnknown(data['example_ps']!, _examplePsMeta),
      );
    } else if (isInserting) {
      context.missing(_examplePsMeta);
    }
    if (data.containsKey('illustration')) {
      context.handle(
        _illustrationMeta,
        illustration.isAcceptableOrUnknown(
          data['illustration']!,
          _illustrationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_illustrationMeta);
    }
    if (data.containsKey('audio_asset')) {
      context.handle(
        _audioAssetMeta,
        audioAsset.isAcceptableOrUnknown(data['audio_asset']!, _audioAssetMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      )!,
      titleUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ur'],
      )!,
      titlePs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ps'],
      )!,
      objectiveEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objective_en'],
      )!,
      objectiveUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objective_ur'],
      )!,
      objectivePs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objective_ps'],
      )!,
      explanationEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_en'],
      )!,
      explanationUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_ur'],
      )!,
      explanationPs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_ps'],
      )!,
      exampleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_en'],
      )!,
      exampleUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_ur'],
      )!,
      examplePs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_ps'],
      )!,
      illustration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}illustration'],
      )!,
      audioAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_asset'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final int id;
  final int unitId;
  final String titleEn;
  final String titleUr;
  final String titlePs;
  final String objectiveEn;
  final String objectiveUr;
  final String objectivePs;
  final String explanationEn;
  final String explanationUr;
  final String explanationPs;
  final String exampleEn;
  final String exampleUr;
  final String examplePs;
  final String illustration;

  /// Optional relative path to a compressed offline audio file bundled with a
  /// downloaded content package. When null the app falls back to on-device TTS.
  final String? audioAsset;
  final int sortOrder;
  final bool isDemo;
  const Lesson({
    required this.id,
    required this.unitId,
    required this.titleEn,
    required this.titleUr,
    required this.titlePs,
    required this.objectiveEn,
    required this.objectiveUr,
    required this.objectivePs,
    required this.explanationEn,
    required this.explanationUr,
    required this.explanationPs,
    required this.exampleEn,
    required this.exampleUr,
    required this.examplePs,
    required this.illustration,
    this.audioAsset,
    required this.sortOrder,
    required this.isDemo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['unit_id'] = Variable<int>(unitId);
    map['title_en'] = Variable<String>(titleEn);
    map['title_ur'] = Variable<String>(titleUr);
    map['title_ps'] = Variable<String>(titlePs);
    map['objective_en'] = Variable<String>(objectiveEn);
    map['objective_ur'] = Variable<String>(objectiveUr);
    map['objective_ps'] = Variable<String>(objectivePs);
    map['explanation_en'] = Variable<String>(explanationEn);
    map['explanation_ur'] = Variable<String>(explanationUr);
    map['explanation_ps'] = Variable<String>(explanationPs);
    map['example_en'] = Variable<String>(exampleEn);
    map['example_ur'] = Variable<String>(exampleUr);
    map['example_ps'] = Variable<String>(examplePs);
    map['illustration'] = Variable<String>(illustration);
    if (!nullToAbsent || audioAsset != null) {
      map['audio_asset'] = Variable<String>(audioAsset);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_demo'] = Variable<bool>(isDemo);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      unitId: Value(unitId),
      titleEn: Value(titleEn),
      titleUr: Value(titleUr),
      titlePs: Value(titlePs),
      objectiveEn: Value(objectiveEn),
      objectiveUr: Value(objectiveUr),
      objectivePs: Value(objectivePs),
      explanationEn: Value(explanationEn),
      explanationUr: Value(explanationUr),
      explanationPs: Value(explanationPs),
      exampleEn: Value(exampleEn),
      exampleUr: Value(exampleUr),
      examplePs: Value(examplePs),
      illustration: Value(illustration),
      audioAsset: audioAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(audioAsset),
      sortOrder: Value(sortOrder),
      isDemo: Value(isDemo),
    );
  }

  factory Lesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<int>(json['id']),
      unitId: serializer.fromJson<int>(json['unitId']),
      titleEn: serializer.fromJson<String>(json['titleEn']),
      titleUr: serializer.fromJson<String>(json['titleUr']),
      titlePs: serializer.fromJson<String>(json['titlePs']),
      objectiveEn: serializer.fromJson<String>(json['objectiveEn']),
      objectiveUr: serializer.fromJson<String>(json['objectiveUr']),
      objectivePs: serializer.fromJson<String>(json['objectivePs']),
      explanationEn: serializer.fromJson<String>(json['explanationEn']),
      explanationUr: serializer.fromJson<String>(json['explanationUr']),
      explanationPs: serializer.fromJson<String>(json['explanationPs']),
      exampleEn: serializer.fromJson<String>(json['exampleEn']),
      exampleUr: serializer.fromJson<String>(json['exampleUr']),
      examplePs: serializer.fromJson<String>(json['examplePs']),
      illustration: serializer.fromJson<String>(json['illustration']),
      audioAsset: serializer.fromJson<String?>(json['audioAsset']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'unitId': serializer.toJson<int>(unitId),
      'titleEn': serializer.toJson<String>(titleEn),
      'titleUr': serializer.toJson<String>(titleUr),
      'titlePs': serializer.toJson<String>(titlePs),
      'objectiveEn': serializer.toJson<String>(objectiveEn),
      'objectiveUr': serializer.toJson<String>(objectiveUr),
      'objectivePs': serializer.toJson<String>(objectivePs),
      'explanationEn': serializer.toJson<String>(explanationEn),
      'explanationUr': serializer.toJson<String>(explanationUr),
      'explanationPs': serializer.toJson<String>(explanationPs),
      'exampleEn': serializer.toJson<String>(exampleEn),
      'exampleUr': serializer.toJson<String>(exampleUr),
      'examplePs': serializer.toJson<String>(examplePs),
      'illustration': serializer.toJson<String>(illustration),
      'audioAsset': serializer.toJson<String?>(audioAsset),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDemo': serializer.toJson<bool>(isDemo),
    };
  }

  Lesson copyWith({
    int? id,
    int? unitId,
    String? titleEn,
    String? titleUr,
    String? titlePs,
    String? objectiveEn,
    String? objectiveUr,
    String? objectivePs,
    String? explanationEn,
    String? explanationUr,
    String? explanationPs,
    String? exampleEn,
    String? exampleUr,
    String? examplePs,
    String? illustration,
    Value<String?> audioAsset = const Value.absent(),
    int? sortOrder,
    bool? isDemo,
  }) => Lesson(
    id: id ?? this.id,
    unitId: unitId ?? this.unitId,
    titleEn: titleEn ?? this.titleEn,
    titleUr: titleUr ?? this.titleUr,
    titlePs: titlePs ?? this.titlePs,
    objectiveEn: objectiveEn ?? this.objectiveEn,
    objectiveUr: objectiveUr ?? this.objectiveUr,
    objectivePs: objectivePs ?? this.objectivePs,
    explanationEn: explanationEn ?? this.explanationEn,
    explanationUr: explanationUr ?? this.explanationUr,
    explanationPs: explanationPs ?? this.explanationPs,
    exampleEn: exampleEn ?? this.exampleEn,
    exampleUr: exampleUr ?? this.exampleUr,
    examplePs: examplePs ?? this.examplePs,
    illustration: illustration ?? this.illustration,
    audioAsset: audioAsset.present ? audioAsset.value : this.audioAsset,
    sortOrder: sortOrder ?? this.sortOrder,
    isDemo: isDemo ?? this.isDemo,
  );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleUr: data.titleUr.present ? data.titleUr.value : this.titleUr,
      titlePs: data.titlePs.present ? data.titlePs.value : this.titlePs,
      objectiveEn: data.objectiveEn.present
          ? data.objectiveEn.value
          : this.objectiveEn,
      objectiveUr: data.objectiveUr.present
          ? data.objectiveUr.value
          : this.objectiveUr,
      objectivePs: data.objectivePs.present
          ? data.objectivePs.value
          : this.objectivePs,
      explanationEn: data.explanationEn.present
          ? data.explanationEn.value
          : this.explanationEn,
      explanationUr: data.explanationUr.present
          ? data.explanationUr.value
          : this.explanationUr,
      explanationPs: data.explanationPs.present
          ? data.explanationPs.value
          : this.explanationPs,
      exampleEn: data.exampleEn.present ? data.exampleEn.value : this.exampleEn,
      exampleUr: data.exampleUr.present ? data.exampleUr.value : this.exampleUr,
      examplePs: data.examplePs.present ? data.examplePs.value : this.examplePs,
      illustration: data.illustration.present
          ? data.illustration.value
          : this.illustration,
      audioAsset: data.audioAsset.present
          ? data.audioAsset.value
          : this.audioAsset,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleUr: $titleUr, ')
          ..write('titlePs: $titlePs, ')
          ..write('objectiveEn: $objectiveEn, ')
          ..write('objectiveUr: $objectiveUr, ')
          ..write('objectivePs: $objectivePs, ')
          ..write('explanationEn: $explanationEn, ')
          ..write('explanationUr: $explanationUr, ')
          ..write('explanationPs: $explanationPs, ')
          ..write('exampleEn: $exampleEn, ')
          ..write('exampleUr: $exampleUr, ')
          ..write('examplePs: $examplePs, ')
          ..write('illustration: $illustration, ')
          ..write('audioAsset: $audioAsset, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    unitId,
    titleEn,
    titleUr,
    titlePs,
    objectiveEn,
    objectiveUr,
    objectivePs,
    explanationEn,
    explanationUr,
    explanationPs,
    exampleEn,
    exampleUr,
    examplePs,
    illustration,
    audioAsset,
    sortOrder,
    isDemo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.unitId == this.unitId &&
          other.titleEn == this.titleEn &&
          other.titleUr == this.titleUr &&
          other.titlePs == this.titlePs &&
          other.objectiveEn == this.objectiveEn &&
          other.objectiveUr == this.objectiveUr &&
          other.objectivePs == this.objectivePs &&
          other.explanationEn == this.explanationEn &&
          other.explanationUr == this.explanationUr &&
          other.explanationPs == this.explanationPs &&
          other.exampleEn == this.exampleEn &&
          other.exampleUr == this.exampleUr &&
          other.examplePs == this.examplePs &&
          other.illustration == this.illustration &&
          other.audioAsset == this.audioAsset &&
          other.sortOrder == this.sortOrder &&
          other.isDemo == this.isDemo);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<int> id;
  final Value<int> unitId;
  final Value<String> titleEn;
  final Value<String> titleUr;
  final Value<String> titlePs;
  final Value<String> objectiveEn;
  final Value<String> objectiveUr;
  final Value<String> objectivePs;
  final Value<String> explanationEn;
  final Value<String> explanationUr;
  final Value<String> explanationPs;
  final Value<String> exampleEn;
  final Value<String> exampleUr;
  final Value<String> examplePs;
  final Value<String> illustration;
  final Value<String?> audioAsset;
  final Value<int> sortOrder;
  final Value<bool> isDemo;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.unitId = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleUr = const Value.absent(),
    this.titlePs = const Value.absent(),
    this.objectiveEn = const Value.absent(),
    this.objectiveUr = const Value.absent(),
    this.objectivePs = const Value.absent(),
    this.explanationEn = const Value.absent(),
    this.explanationUr = const Value.absent(),
    this.explanationPs = const Value.absent(),
    this.exampleEn = const Value.absent(),
    this.exampleUr = const Value.absent(),
    this.examplePs = const Value.absent(),
    this.illustration = const Value.absent(),
    this.audioAsset = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDemo = const Value.absent(),
  });
  LessonsCompanion.insert({
    this.id = const Value.absent(),
    required int unitId,
    required String titleEn,
    required String titleUr,
    required String titlePs,
    required String objectiveEn,
    required String objectiveUr,
    required String objectivePs,
    required String explanationEn,
    required String explanationUr,
    required String explanationPs,
    required String exampleEn,
    required String exampleUr,
    required String examplePs,
    required String illustration,
    this.audioAsset = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDemo = const Value.absent(),
  }) : unitId = Value(unitId),
       titleEn = Value(titleEn),
       titleUr = Value(titleUr),
       titlePs = Value(titlePs),
       objectiveEn = Value(objectiveEn),
       objectiveUr = Value(objectiveUr),
       objectivePs = Value(objectivePs),
       explanationEn = Value(explanationEn),
       explanationUr = Value(explanationUr),
       explanationPs = Value(explanationPs),
       exampleEn = Value(exampleEn),
       exampleUr = Value(exampleUr),
       examplePs = Value(examplePs),
       illustration = Value(illustration);
  static Insertable<Lesson> custom({
    Expression<int>? id,
    Expression<int>? unitId,
    Expression<String>? titleEn,
    Expression<String>? titleUr,
    Expression<String>? titlePs,
    Expression<String>? objectiveEn,
    Expression<String>? objectiveUr,
    Expression<String>? objectivePs,
    Expression<String>? explanationEn,
    Expression<String>? explanationUr,
    Expression<String>? explanationPs,
    Expression<String>? exampleEn,
    Expression<String>? exampleUr,
    Expression<String>? examplePs,
    Expression<String>? illustration,
    Expression<String>? audioAsset,
    Expression<int>? sortOrder,
    Expression<bool>? isDemo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitId != null) 'unit_id': unitId,
      if (titleEn != null) 'title_en': titleEn,
      if (titleUr != null) 'title_ur': titleUr,
      if (titlePs != null) 'title_ps': titlePs,
      if (objectiveEn != null) 'objective_en': objectiveEn,
      if (objectiveUr != null) 'objective_ur': objectiveUr,
      if (objectivePs != null) 'objective_ps': objectivePs,
      if (explanationEn != null) 'explanation_en': explanationEn,
      if (explanationUr != null) 'explanation_ur': explanationUr,
      if (explanationPs != null) 'explanation_ps': explanationPs,
      if (exampleEn != null) 'example_en': exampleEn,
      if (exampleUr != null) 'example_ur': exampleUr,
      if (examplePs != null) 'example_ps': examplePs,
      if (illustration != null) 'illustration': illustration,
      if (audioAsset != null) 'audio_asset': audioAsset,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDemo != null) 'is_demo': isDemo,
    });
  }

  LessonsCompanion copyWith({
    Value<int>? id,
    Value<int>? unitId,
    Value<String>? titleEn,
    Value<String>? titleUr,
    Value<String>? titlePs,
    Value<String>? objectiveEn,
    Value<String>? objectiveUr,
    Value<String>? objectivePs,
    Value<String>? explanationEn,
    Value<String>? explanationUr,
    Value<String>? explanationPs,
    Value<String>? exampleEn,
    Value<String>? exampleUr,
    Value<String>? examplePs,
    Value<String>? illustration,
    Value<String?>? audioAsset,
    Value<int>? sortOrder,
    Value<bool>? isDemo,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      titleEn: titleEn ?? this.titleEn,
      titleUr: titleUr ?? this.titleUr,
      titlePs: titlePs ?? this.titlePs,
      objectiveEn: objectiveEn ?? this.objectiveEn,
      objectiveUr: objectiveUr ?? this.objectiveUr,
      objectivePs: objectivePs ?? this.objectivePs,
      explanationEn: explanationEn ?? this.explanationEn,
      explanationUr: explanationUr ?? this.explanationUr,
      explanationPs: explanationPs ?? this.explanationPs,
      exampleEn: exampleEn ?? this.exampleEn,
      exampleUr: exampleUr ?? this.exampleUr,
      examplePs: examplePs ?? this.examplePs,
      illustration: illustration ?? this.illustration,
      audioAsset: audioAsset ?? this.audioAsset,
      sortOrder: sortOrder ?? this.sortOrder,
      isDemo: isDemo ?? this.isDemo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleUr.present) {
      map['title_ur'] = Variable<String>(titleUr.value);
    }
    if (titlePs.present) {
      map['title_ps'] = Variable<String>(titlePs.value);
    }
    if (objectiveEn.present) {
      map['objective_en'] = Variable<String>(objectiveEn.value);
    }
    if (objectiveUr.present) {
      map['objective_ur'] = Variable<String>(objectiveUr.value);
    }
    if (objectivePs.present) {
      map['objective_ps'] = Variable<String>(objectivePs.value);
    }
    if (explanationEn.present) {
      map['explanation_en'] = Variable<String>(explanationEn.value);
    }
    if (explanationUr.present) {
      map['explanation_ur'] = Variable<String>(explanationUr.value);
    }
    if (explanationPs.present) {
      map['explanation_ps'] = Variable<String>(explanationPs.value);
    }
    if (exampleEn.present) {
      map['example_en'] = Variable<String>(exampleEn.value);
    }
    if (exampleUr.present) {
      map['example_ur'] = Variable<String>(exampleUr.value);
    }
    if (examplePs.present) {
      map['example_ps'] = Variable<String>(examplePs.value);
    }
    if (illustration.present) {
      map['illustration'] = Variable<String>(illustration.value);
    }
    if (audioAsset.present) {
      map['audio_asset'] = Variable<String>(audioAsset.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleUr: $titleUr, ')
          ..write('titlePs: $titlePs, ')
          ..write('objectiveEn: $objectiveEn, ')
          ..write('objectiveUr: $objectiveUr, ')
          ..write('objectivePs: $objectivePs, ')
          ..write('explanationEn: $explanationEn, ')
          ..write('explanationUr: $explanationUr, ')
          ..write('explanationPs: $explanationPs, ')
          ..write('exampleEn: $exampleEn, ')
          ..write('exampleUr: $exampleUr, ')
          ..write('examplePs: $examplePs, ')
          ..write('illustration: $illustration, ')
          ..write('audioAsset: $audioAsset, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDemo: $isDemo')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _promptEnMeta = const VerificationMeta(
    'promptEn',
  );
  @override
  late final GeneratedColumn<String> promptEn = GeneratedColumn<String>(
    'prompt_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptUrMeta = const VerificationMeta(
    'promptUr',
  );
  @override
  late final GeneratedColumn<String> promptUr = GeneratedColumn<String>(
    'prompt_ur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptPsMeta = const VerificationMeta(
    'promptPs',
  );
  @override
  late final GeneratedColumn<String> promptPs = GeneratedColumn<String>(
    'prompt_ps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsEnMeta = const VerificationMeta(
    'optionsEn',
  );
  @override
  late final GeneratedColumn<String> optionsEn = GeneratedColumn<String>(
    'options_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsUrMeta = const VerificationMeta(
    'optionsUr',
  );
  @override
  late final GeneratedColumn<String> optionsUr = GeneratedColumn<String>(
    'options_ur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsPsMeta = const VerificationMeta(
    'optionsPs',
  );
  @override
  late final GeneratedColumn<String> optionsPs = GeneratedColumn<String>(
    'options_ps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctIndexMeta = const VerificationMeta(
    'correctIndex',
  );
  @override
  late final GeneratedColumn<int> correctIndex = GeneratedColumn<int>(
    'correct_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    promptEn,
    promptUr,
    promptPs,
    optionsEn,
    optionsUr,
    optionsPs,
    correctIndex,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('prompt_en')) {
      context.handle(
        _promptEnMeta,
        promptEn.isAcceptableOrUnknown(data['prompt_en']!, _promptEnMeta),
      );
    } else if (isInserting) {
      context.missing(_promptEnMeta);
    }
    if (data.containsKey('prompt_ur')) {
      context.handle(
        _promptUrMeta,
        promptUr.isAcceptableOrUnknown(data['prompt_ur']!, _promptUrMeta),
      );
    } else if (isInserting) {
      context.missing(_promptUrMeta);
    }
    if (data.containsKey('prompt_ps')) {
      context.handle(
        _promptPsMeta,
        promptPs.isAcceptableOrUnknown(data['prompt_ps']!, _promptPsMeta),
      );
    } else if (isInserting) {
      context.missing(_promptPsMeta);
    }
    if (data.containsKey('options_en')) {
      context.handle(
        _optionsEnMeta,
        optionsEn.isAcceptableOrUnknown(data['options_en']!, _optionsEnMeta),
      );
    } else if (isInserting) {
      context.missing(_optionsEnMeta);
    }
    if (data.containsKey('options_ur')) {
      context.handle(
        _optionsUrMeta,
        optionsUr.isAcceptableOrUnknown(data['options_ur']!, _optionsUrMeta),
      );
    } else if (isInserting) {
      context.missing(_optionsUrMeta);
    }
    if (data.containsKey('options_ps')) {
      context.handle(
        _optionsPsMeta,
        optionsPs.isAcceptableOrUnknown(data['options_ps']!, _optionsPsMeta),
      );
    } else if (isInserting) {
      context.missing(_optionsPsMeta);
    }
    if (data.containsKey('correct_index')) {
      context.handle(
        _correctIndexMeta,
        correctIndex.isAcceptableOrUnknown(
          data['correct_index']!,
          _correctIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctIndexMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      promptEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt_en'],
      )!,
      promptUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt_ur'],
      )!,
      promptPs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt_ps'],
      )!,
      optionsEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_en'],
      )!,
      optionsUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_ur'],
      )!,
      optionsPs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_ps'],
      )!,
      correctIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_index'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final int id;
  final int lessonId;
  final String promptEn;
  final String promptUr;
  final String promptPs;
  final String optionsEn;
  final String optionsUr;
  final String optionsPs;
  final int correctIndex;
  final int sortOrder;
  const Question({
    required this.id,
    required this.lessonId,
    required this.promptEn,
    required this.promptUr,
    required this.promptPs,
    required this.optionsEn,
    required this.optionsUr,
    required this.optionsPs,
    required this.correctIndex,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<int>(lessonId);
    map['prompt_en'] = Variable<String>(promptEn);
    map['prompt_ur'] = Variable<String>(promptUr);
    map['prompt_ps'] = Variable<String>(promptPs);
    map['options_en'] = Variable<String>(optionsEn);
    map['options_ur'] = Variable<String>(optionsUr);
    map['options_ps'] = Variable<String>(optionsPs);
    map['correct_index'] = Variable<int>(correctIndex);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      promptEn: Value(promptEn),
      promptUr: Value(promptUr),
      promptPs: Value(promptPs),
      optionsEn: Value(optionsEn),
      optionsUr: Value(optionsUr),
      optionsPs: Value(optionsPs),
      correctIndex: Value(correctIndex),
      sortOrder: Value(sortOrder),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      promptEn: serializer.fromJson<String>(json['promptEn']),
      promptUr: serializer.fromJson<String>(json['promptUr']),
      promptPs: serializer.fromJson<String>(json['promptPs']),
      optionsEn: serializer.fromJson<String>(json['optionsEn']),
      optionsUr: serializer.fromJson<String>(json['optionsUr']),
      optionsPs: serializer.fromJson<String>(json['optionsPs']),
      correctIndex: serializer.fromJson<int>(json['correctIndex']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<int>(lessonId),
      'promptEn': serializer.toJson<String>(promptEn),
      'promptUr': serializer.toJson<String>(promptUr),
      'promptPs': serializer.toJson<String>(promptPs),
      'optionsEn': serializer.toJson<String>(optionsEn),
      'optionsUr': serializer.toJson<String>(optionsUr),
      'optionsPs': serializer.toJson<String>(optionsPs),
      'correctIndex': serializer.toJson<int>(correctIndex),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Question copyWith({
    int? id,
    int? lessonId,
    String? promptEn,
    String? promptUr,
    String? promptPs,
    String? optionsEn,
    String? optionsUr,
    String? optionsPs,
    int? correctIndex,
    int? sortOrder,
  }) => Question(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    promptEn: promptEn ?? this.promptEn,
    promptUr: promptUr ?? this.promptUr,
    promptPs: promptPs ?? this.promptPs,
    optionsEn: optionsEn ?? this.optionsEn,
    optionsUr: optionsUr ?? this.optionsUr,
    optionsPs: optionsPs ?? this.optionsPs,
    correctIndex: correctIndex ?? this.correctIndex,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      promptEn: data.promptEn.present ? data.promptEn.value : this.promptEn,
      promptUr: data.promptUr.present ? data.promptUr.value : this.promptUr,
      promptPs: data.promptPs.present ? data.promptPs.value : this.promptPs,
      optionsEn: data.optionsEn.present ? data.optionsEn.value : this.optionsEn,
      optionsUr: data.optionsUr.present ? data.optionsUr.value : this.optionsUr,
      optionsPs: data.optionsPs.present ? data.optionsPs.value : this.optionsPs,
      correctIndex: data.correctIndex.present
          ? data.correctIndex.value
          : this.correctIndex,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('promptEn: $promptEn, ')
          ..write('promptUr: $promptUr, ')
          ..write('promptPs: $promptPs, ')
          ..write('optionsEn: $optionsEn, ')
          ..write('optionsUr: $optionsUr, ')
          ..write('optionsPs: $optionsPs, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lessonId,
    promptEn,
    promptUr,
    promptPs,
    optionsEn,
    optionsUr,
    optionsPs,
    correctIndex,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.promptEn == this.promptEn &&
          other.promptUr == this.promptUr &&
          other.promptPs == this.promptPs &&
          other.optionsEn == this.optionsEn &&
          other.optionsUr == this.optionsUr &&
          other.optionsPs == this.optionsPs &&
          other.correctIndex == this.correctIndex &&
          other.sortOrder == this.sortOrder);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<int> id;
  final Value<int> lessonId;
  final Value<String> promptEn;
  final Value<String> promptUr;
  final Value<String> promptPs;
  final Value<String> optionsEn;
  final Value<String> optionsUr;
  final Value<String> optionsPs;
  final Value<int> correctIndex;
  final Value<int> sortOrder;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.promptEn = const Value.absent(),
    this.promptUr = const Value.absent(),
    this.promptPs = const Value.absent(),
    this.optionsEn = const Value.absent(),
    this.optionsUr = const Value.absent(),
    this.optionsPs = const Value.absent(),
    this.correctIndex = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  QuestionsCompanion.insert({
    this.id = const Value.absent(),
    required int lessonId,
    required String promptEn,
    required String promptUr,
    required String promptPs,
    required String optionsEn,
    required String optionsUr,
    required String optionsPs,
    required int correctIndex,
    this.sortOrder = const Value.absent(),
  }) : lessonId = Value(lessonId),
       promptEn = Value(promptEn),
       promptUr = Value(promptUr),
       promptPs = Value(promptPs),
       optionsEn = Value(optionsEn),
       optionsUr = Value(optionsUr),
       optionsPs = Value(optionsPs),
       correctIndex = Value(correctIndex);
  static Insertable<Question> custom({
    Expression<int>? id,
    Expression<int>? lessonId,
    Expression<String>? promptEn,
    Expression<String>? promptUr,
    Expression<String>? promptPs,
    Expression<String>? optionsEn,
    Expression<String>? optionsUr,
    Expression<String>? optionsPs,
    Expression<int>? correctIndex,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (promptEn != null) 'prompt_en': promptEn,
      if (promptUr != null) 'prompt_ur': promptUr,
      if (promptPs != null) 'prompt_ps': promptPs,
      if (optionsEn != null) 'options_en': optionsEn,
      if (optionsUr != null) 'options_ur': optionsUr,
      if (optionsPs != null) 'options_ps': optionsPs,
      if (correctIndex != null) 'correct_index': correctIndex,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  QuestionsCompanion copyWith({
    Value<int>? id,
    Value<int>? lessonId,
    Value<String>? promptEn,
    Value<String>? promptUr,
    Value<String>? promptPs,
    Value<String>? optionsEn,
    Value<String>? optionsUr,
    Value<String>? optionsPs,
    Value<int>? correctIndex,
    Value<int>? sortOrder,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      promptEn: promptEn ?? this.promptEn,
      promptUr: promptUr ?? this.promptUr,
      promptPs: promptPs ?? this.promptPs,
      optionsEn: optionsEn ?? this.optionsEn,
      optionsUr: optionsUr ?? this.optionsUr,
      optionsPs: optionsPs ?? this.optionsPs,
      correctIndex: correctIndex ?? this.correctIndex,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (promptEn.present) {
      map['prompt_en'] = Variable<String>(promptEn.value);
    }
    if (promptUr.present) {
      map['prompt_ur'] = Variable<String>(promptUr.value);
    }
    if (promptPs.present) {
      map['prompt_ps'] = Variable<String>(promptPs.value);
    }
    if (optionsEn.present) {
      map['options_en'] = Variable<String>(optionsEn.value);
    }
    if (optionsUr.present) {
      map['options_ur'] = Variable<String>(optionsUr.value);
    }
    if (optionsPs.present) {
      map['options_ps'] = Variable<String>(optionsPs.value);
    }
    if (correctIndex.present) {
      map['correct_index'] = Variable<int>(correctIndex.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('promptEn: $promptEn, ')
          ..write('promptUr: $promptUr, ')
          ..write('promptPs: $promptPs, ')
          ..write('optionsEn: $optionsEn, ')
          ..write('optionsUr: $optionsUr, ')
          ..write('optionsPs: $optionsPs, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTable extends QuizAttempts
    with TableInfo<$QuizAttemptsTable, QuizAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    lessonId,
    score,
    total,
    startedAt,
    finishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
    );
  }

  @override
  $QuizAttemptsTable createAlias(String alias) {
    return $QuizAttemptsTable(attachedDatabase, alias);
  }
}

class QuizAttempt extends DataClass implements Insertable<QuizAttempt> {
  final int id;
  final int studentId;
  final int lessonId;
  final int score;
  final int total;
  final DateTime startedAt;
  final DateTime? finishedAt;
  const QuizAttempt({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.score,
    required this.total,
    required this.startedAt,
    this.finishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['lesson_id'] = Variable<int>(lessonId);
    map['score'] = Variable<int>(score);
    map['total'] = Variable<int>(total);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    return map;
  }

  QuizAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      lessonId: Value(lessonId),
      score: Value(score),
      total: Value(total),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
    );
  }

  factory QuizAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttempt(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      score: serializer.fromJson<int>(json['score']),
      total: serializer.fromJson<int>(json['total']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'lessonId': serializer.toJson<int>(lessonId),
      'score': serializer.toJson<int>(score),
      'total': serializer.toJson<int>(total),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
    };
  }

  QuizAttempt copyWith({
    int? id,
    int? studentId,
    int? lessonId,
    int? score,
    int? total,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
  }) => QuizAttempt(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    lessonId: lessonId ?? this.lessonId,
    score: score ?? this.score,
    total: total ?? this.total,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
  );
  QuizAttempt copyWithCompanion(QuizAttemptsCompanion data) {
    return QuizAttempt(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      score: data.score.present ? data.score.value : this.score,
      total: data.total.present ? data.total.value : this.total,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttempt(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('score: $score, ')
          ..write('total: $total, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, lessonId, score, total, startedAt, finishedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttempt &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId &&
          other.score == this.score &&
          other.total == this.total &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt);
}

class QuizAttemptsCompanion extends UpdateCompanion<QuizAttempt> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<int> lessonId;
  final Value<int> score;
  final Value<int> total;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  const QuizAttemptsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.score = const Value.absent(),
    this.total = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
  });
  QuizAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required int lessonId,
    required int score,
    required int total,
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
  }) : studentId = Value(studentId),
       lessonId = Value(lessonId),
       score = Value(score),
       total = Value(total);
  static Insertable<QuizAttempt> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? lessonId,
    Expression<int>? score,
    Expression<int>? total,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (score != null) 'score': score,
      if (total != null) 'total': total,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
    });
  }

  QuizAttemptsCompanion copyWith({
    Value<int>? id,
    Value<int>? studentId,
    Value<int>? lessonId,
    Value<int>? score,
    Value<int>? total,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
  }) {
    return QuizAttemptsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      score: score ?? this.score,
      total: total ?? this.total,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('score: $score, ')
          ..write('total: $total, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }
}

class $QuizAnswersTable extends QuizAnswers
    with TableInfo<$QuizAnswersTable, QuizAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<int> attemptId = GeneratedColumn<int>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quiz_attempts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES questions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _selectedIndexMeta = const VerificationMeta(
    'selectedIndex',
  );
  @override
  late final GeneratedColumn<int> selectedIndex = GeneratedColumn<int>(
    'selected_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attemptId,
    questionId,
    selectedIndex,
    isCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('selected_index')) {
      context.handle(
        _selectedIndexMeta,
        selectedIndex.isAcceptableOrUnknown(
          data['selected_index']!,
          _selectedIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedIndexMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAnswer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      )!,
      selectedIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_index'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
    );
  }

  @override
  $QuizAnswersTable createAlias(String alias) {
    return $QuizAnswersTable(attachedDatabase, alias);
  }
}

class QuizAnswer extends DataClass implements Insertable<QuizAnswer> {
  final int id;
  final int attemptId;
  final int questionId;
  final int selectedIndex;
  final bool isCorrect;
  const QuizAnswer({
    required this.id,
    required this.attemptId,
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['attempt_id'] = Variable<int>(attemptId);
    map['question_id'] = Variable<int>(questionId);
    map['selected_index'] = Variable<int>(selectedIndex);
    map['is_correct'] = Variable<bool>(isCorrect);
    return map;
  }

  QuizAnswersCompanion toCompanion(bool nullToAbsent) {
    return QuizAnswersCompanion(
      id: Value(id),
      attemptId: Value(attemptId),
      questionId: Value(questionId),
      selectedIndex: Value(selectedIndex),
      isCorrect: Value(isCorrect),
    );
  }

  factory QuizAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAnswer(
      id: serializer.fromJson<int>(json['id']),
      attemptId: serializer.fromJson<int>(json['attemptId']),
      questionId: serializer.fromJson<int>(json['questionId']),
      selectedIndex: serializer.fromJson<int>(json['selectedIndex']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'attemptId': serializer.toJson<int>(attemptId),
      'questionId': serializer.toJson<int>(questionId),
      'selectedIndex': serializer.toJson<int>(selectedIndex),
      'isCorrect': serializer.toJson<bool>(isCorrect),
    };
  }

  QuizAnswer copyWith({
    int? id,
    int? attemptId,
    int? questionId,
    int? selectedIndex,
    bool? isCorrect,
  }) => QuizAnswer(
    id: id ?? this.id,
    attemptId: attemptId ?? this.attemptId,
    questionId: questionId ?? this.questionId,
    selectedIndex: selectedIndex ?? this.selectedIndex,
    isCorrect: isCorrect ?? this.isCorrect,
  );
  QuizAnswer copyWithCompanion(QuizAnswersCompanion data) {
    return QuizAnswer(
      id: data.id.present ? data.id.value : this.id,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      selectedIndex: data.selectedIndex.present
          ? data.selectedIndex.value
          : this.selectedIndex,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAnswer(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, attemptId, questionId, selectedIndex, isCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAnswer &&
          other.id == this.id &&
          other.attemptId == this.attemptId &&
          other.questionId == this.questionId &&
          other.selectedIndex == this.selectedIndex &&
          other.isCorrect == this.isCorrect);
}

class QuizAnswersCompanion extends UpdateCompanion<QuizAnswer> {
  final Value<int> id;
  final Value<int> attemptId;
  final Value<int> questionId;
  final Value<int> selectedIndex;
  final Value<bool> isCorrect;
  const QuizAnswersCompanion({
    this.id = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
  });
  QuizAnswersCompanion.insert({
    this.id = const Value.absent(),
    required int attemptId,
    required int questionId,
    required int selectedIndex,
    required bool isCorrect,
  }) : attemptId = Value(attemptId),
       questionId = Value(questionId),
       selectedIndex = Value(selectedIndex),
       isCorrect = Value(isCorrect);
  static Insertable<QuizAnswer> custom({
    Expression<int>? id,
    Expression<int>? attemptId,
    Expression<int>? questionId,
    Expression<int>? selectedIndex,
    Expression<bool>? isCorrect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attemptId != null) 'attempt_id': attemptId,
      if (questionId != null) 'question_id': questionId,
      if (selectedIndex != null) 'selected_index': selectedIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
    });
  }

  QuizAnswersCompanion copyWith({
    Value<int>? id,
    Value<int>? attemptId,
    Value<int>? questionId,
    Value<int>? selectedIndex,
    Value<bool>? isCorrect,
  }) {
    return QuizAnswersCompanion(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      questionId: questionId ?? this.questionId,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<int>(attemptId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (selectedIndex.present) {
      map['selected_index'] = Variable<int>(selectedIndex.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAnswersCompanion(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTable extends LessonProgress
    with TableInfo<$LessonProgressTable, LessonProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _percentMeta = const VerificationMeta(
    'percent',
  );
  @override
  late final GeneratedColumn<int> percent = GeneratedColumn<int>(
    'percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    lessonId,
    percent,
    completed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('percent')) {
      context.handle(
        _percentMeta,
        percent.isAcceptableOrUnknown(data['percent']!, _percentMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {studentId, lessonId},
  ];
  @override
  LessonProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      percent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}percent'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LessonProgressTable createAlias(String alias) {
    return $LessonProgressTable(attachedDatabase, alias);
  }
}

class LessonProgressData extends DataClass
    implements Insertable<LessonProgressData> {
  final int id;
  final int studentId;
  final int lessonId;
  final int percent;
  final bool completed;
  final DateTime updatedAt;
  const LessonProgressData({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.percent,
    required this.completed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['lesson_id'] = Variable<int>(lessonId);
    map['percent'] = Variable<int>(percent);
    map['completed'] = Variable<bool>(completed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LessonProgressCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressCompanion(
      id: Value(id),
      studentId: Value(studentId),
      lessonId: Value(lessonId),
      percent: Value(percent),
      completed: Value(completed),
      updatedAt: Value(updatedAt),
    );
  }

  factory LessonProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressData(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      percent: serializer.fromJson<int>(json['percent']),
      completed: serializer.fromJson<bool>(json['completed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'lessonId': serializer.toJson<int>(lessonId),
      'percent': serializer.toJson<int>(percent),
      'completed': serializer.toJson<bool>(completed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LessonProgressData copyWith({
    int? id,
    int? studentId,
    int? lessonId,
    int? percent,
    bool? completed,
    DateTime? updatedAt,
  }) => LessonProgressData(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    lessonId: lessonId ?? this.lessonId,
    percent: percent ?? this.percent,
    completed: completed ?? this.completed,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LessonProgressData copyWithCompanion(LessonProgressCompanion data) {
    return LessonProgressData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      percent: data.percent.present ? data.percent.value : this.percent,
      completed: data.completed.present ? data.completed.value : this.completed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('percent: $percent, ')
          ..write('completed: $completed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, lessonId, percent, completed, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId &&
          other.percent == this.percent &&
          other.completed == this.completed &&
          other.updatedAt == this.updatedAt);
}

class LessonProgressCompanion extends UpdateCompanion<LessonProgressData> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<int> lessonId;
  final Value<int> percent;
  final Value<bool> completed;
  final Value<DateTime> updatedAt;
  const LessonProgressCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.percent = const Value.absent(),
    this.completed = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LessonProgressCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required int lessonId,
    this.percent = const Value.absent(),
    this.completed = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : studentId = Value(studentId),
       lessonId = Value(lessonId);
  static Insertable<LessonProgressData> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? lessonId,
    Expression<int>? percent,
    Expression<bool>? completed,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (percent != null) 'percent': percent,
      if (completed != null) 'completed': completed,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LessonProgressCompanion copyWith({
    Value<int>? id,
    Value<int>? studentId,
    Value<int>? lessonId,
    Value<int>? percent,
    Value<bool>? completed,
    Value<DateTime>? updatedAt,
  }) {
    return LessonProgressCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      percent: percent ?? this.percent,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (percent.present) {
      map['percent'] = Variable<int>(percent.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('percent: $percent, ')
          ..write('completed: $completed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DownloadsTable extends Downloads
    with TableInfo<$DownloadsTable, Download> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _isDownloadedMeta = const VerificationMeta(
    'isDownloaded',
  );
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
    'is_downloaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_downloaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    grade,
    subjectId,
    isDownloaded,
    sizeBytes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Download> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
        _isDownloadedMeta,
        isDownloaded.isAcceptableOrUnknown(
          data['is_downloaded']!,
          _isDownloadedMeta,
        ),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {subjectId},
  ];
  @override
  Download map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Download(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      isDownloaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_downloaded'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DownloadsTable createAlias(String alias) {
    return $DownloadsTable(attachedDatabase, alias);
  }
}

class Download extends DataClass implements Insertable<Download> {
  final int id;
  final int grade;
  final int subjectId;
  final bool isDownloaded;
  final int sizeBytes;
  final DateTime updatedAt;
  const Download({
    required this.id,
    required this.grade,
    required this.subjectId,
    required this.isDownloaded,
    required this.sizeBytes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['grade'] = Variable<int>(grade);
    map['subject_id'] = Variable<int>(subjectId);
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DownloadsCompanion toCompanion(bool nullToAbsent) {
    return DownloadsCompanion(
      id: Value(id),
      grade: Value(grade),
      subjectId: Value(subjectId),
      isDownloaded: Value(isDownloaded),
      sizeBytes: Value(sizeBytes),
      updatedAt: Value(updatedAt),
    );
  }

  factory Download.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Download(
      id: serializer.fromJson<int>(json['id']),
      grade: serializer.fromJson<int>(json['grade']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'grade': serializer.toJson<int>(grade),
      'subjectId': serializer.toJson<int>(subjectId),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Download copyWith({
    int? id,
    int? grade,
    int? subjectId,
    bool? isDownloaded,
    int? sizeBytes,
    DateTime? updatedAt,
  }) => Download(
    id: id ?? this.id,
    grade: grade ?? this.grade,
    subjectId: subjectId ?? this.subjectId,
    isDownloaded: isDownloaded ?? this.isDownloaded,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Download copyWithCompanion(DownloadsCompanion data) {
    return Download(
      id: data.id.present ? data.id.value : this.id,
      grade: data.grade.present ? data.grade.value : this.grade,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      isDownloaded: data.isDownloaded.present
          ? data.isDownloaded.value
          : this.isDownloaded,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Download(')
          ..write('id: $id, ')
          ..write('grade: $grade, ')
          ..write('subjectId: $subjectId, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, grade, subjectId, isDownloaded, sizeBytes, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Download &&
          other.id == this.id &&
          other.grade == this.grade &&
          other.subjectId == this.subjectId &&
          other.isDownloaded == this.isDownloaded &&
          other.sizeBytes == this.sizeBytes &&
          other.updatedAt == this.updatedAt);
}

class DownloadsCompanion extends UpdateCompanion<Download> {
  final Value<int> id;
  final Value<int> grade;
  final Value<int> subjectId;
  final Value<bool> isDownloaded;
  final Value<int> sizeBytes;
  final Value<DateTime> updatedAt;
  const DownloadsCompanion({
    this.id = const Value.absent(),
    this.grade = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DownloadsCompanion.insert({
    this.id = const Value.absent(),
    required int grade,
    required int subjectId,
    this.isDownloaded = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : grade = Value(grade),
       subjectId = Value(subjectId);
  static Insertable<Download> custom({
    Expression<int>? id,
    Expression<int>? grade,
    Expression<int>? subjectId,
    Expression<bool>? isDownloaded,
    Expression<int>? sizeBytes,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (grade != null) 'grade': grade,
      if (subjectId != null) 'subject_id': subjectId,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DownloadsCompanion copyWith({
    Value<int>? id,
    Value<int>? grade,
    Value<int>? subjectId,
    Value<bool>? isDownloaded,
    Value<int>? sizeBytes,
    Value<DateTime>? updatedAt,
  }) {
    return DownloadsCompanion(
      id: id ?? this.id,
      grade: grade ?? this.grade,
      subjectId: subjectId ?? this.subjectId,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsCompanion(')
          ..write('id: $id, ')
          ..write('grade: $grade, ')
          ..write('subjectId: $subjectId, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, studentId, lessonId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {studentId, lessonId},
  ];
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;
  final int studentId;
  final int lessonId;
  const Favorite({
    required this.id,
    required this.studentId,
    required this.lessonId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['lesson_id'] = Variable<int>(lessonId);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: Value(id),
      studentId: Value(studentId),
      lessonId: Value(lessonId),
    );
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'lessonId': serializer.toJson<int>(lessonId),
    };
  }

  Favorite copyWith({int? id, int? studentId, int? lessonId}) => Favorite(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    lessonId: lessonId ?? this.lessonId,
  );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, lessonId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<int> lessonId;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required int lessonId,
  }) : studentId = Value(studentId),
       lessonId = Value(lessonId);
  static Insertable<Favorite> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? lessonId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (lessonId != null) 'lesson_id': lessonId,
    });
  }

  FavoritesCompanion copyWith({
    Value<int>? id,
    Value<int>? studentId,
    Value<int>? lessonId,
  }) {
    return FavoritesCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsRowsTable extends AppSettingsRows
    with TableInfo<$AppSettingsRowsTable, AppSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  AppSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRow(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
    );
  }

  @override
  $AppSettingsRowsTable createAlias(String alias) {
    return $AppSettingsRowsTable(attachedDatabase, alias);
  }
}

class AppSettingsRow extends DataClass implements Insertable<AppSettingsRow> {
  final String settingKey;
  final String settingValue;
  const AppSettingsRow({required this.settingKey, required this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  AppSettingsRowsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsRowsCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory AppSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRow(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  AppSettingsRow copyWith({String? settingKey, String? settingValue}) =>
      AppSettingsRow(
        settingKey: settingKey ?? this.settingKey,
        settingValue: settingValue ?? this.settingValue,
      );
  AppSettingsRow copyWithCompanion(AppSettingsRowsCompanion data) {
    return AppSettingsRow(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRow(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRow &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class AppSettingsRowsCompanion extends UpdateCompanion<AppSettingsRow> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const AppSettingsRowsCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsRowsCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue);
  static Insertable<AppSettingsRow> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsRowsCompanion copyWith({
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<int>? rowid,
  }) {
    return AppSettingsRowsCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRowsCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TutorMessagesTable extends TutorMessages
    with TableInfo<$TutorMessagesTable, TutorMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TutorMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromAiMeta = const VerificationMeta('fromAi');
  @override
  late final GeneratedColumn<bool> fromAi = GeneratedColumn<bool>(
    'from_ai',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("from_ai" IN (0, 1))',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    fromAi,
    content,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tutor_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<TutorMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('from_ai')) {
      context.handle(
        _fromAiMeta,
        fromAi.isAcceptableOrUnknown(data['from_ai']!, _fromAiMeta),
      );
    } else if (isInserting) {
      context.missing(_fromAiMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TutorMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TutorMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      fromAi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}from_ai'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TutorMessagesTable createAlias(String alias) {
    return $TutorMessagesTable(attachedDatabase, alias);
  }
}

class TutorMessage extends DataClass implements Insertable<TutorMessage> {
  final int id;
  final int studentId;
  final bool fromAi;
  final String content;
  final DateTime createdAt;
  const TutorMessage({
    required this.id,
    required this.studentId,
    required this.fromAi,
    required this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['from_ai'] = Variable<bool>(fromAi);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TutorMessagesCompanion toCompanion(bool nullToAbsent) {
    return TutorMessagesCompanion(
      id: Value(id),
      studentId: Value(studentId),
      fromAi: Value(fromAi),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory TutorMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TutorMessage(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      fromAi: serializer.fromJson<bool>(json['fromAi']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'fromAi': serializer.toJson<bool>(fromAi),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TutorMessage copyWith({
    int? id,
    int? studentId,
    bool? fromAi,
    String? content,
    DateTime? createdAt,
  }) => TutorMessage(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    fromAi: fromAi ?? this.fromAi,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
  );
  TutorMessage copyWithCompanion(TutorMessagesCompanion data) {
    return TutorMessage(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      fromAi: data.fromAi.present ? data.fromAi.value : this.fromAi,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TutorMessage(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('fromAi: $fromAi, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, fromAi, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TutorMessage &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.fromAi == this.fromAi &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class TutorMessagesCompanion extends UpdateCompanion<TutorMessage> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<bool> fromAi;
  final Value<String> content;
  final Value<DateTime> createdAt;
  const TutorMessagesCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.fromAi = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TutorMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required bool fromAi,
    required String content,
    this.createdAt = const Value.absent(),
  }) : studentId = Value(studentId),
       fromAi = Value(fromAi),
       content = Value(content);
  static Insertable<TutorMessage> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<bool>? fromAi,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (fromAi != null) 'from_ai': fromAi,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TutorMessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? studentId,
    Value<bool>? fromAi,
    Value<String>? content,
    Value<DateTime>? createdAt,
  }) {
    return TutorMessagesCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      fromAi: fromAi ?? this.fromAi,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (fromAi.present) {
      map['from_ai'] = Variable<bool>(fromAi.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TutorMessagesCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('fromAi: $fromAi, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UnderstandingChecksTable extends UnderstandingChecks
    with TableInfo<$UnderstandingChecksTable, UnderstandingCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnderstandingChecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    lessonId,
    isCorrect,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'understanding_checks';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnderstandingCheck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnderstandingCheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnderstandingCheck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      ),
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UnderstandingChecksTable createAlias(String alias) {
    return $UnderstandingChecksTable(attachedDatabase, alias);
  }
}

class UnderstandingCheck extends DataClass
    implements Insertable<UnderstandingCheck> {
  final int id;
  final int studentId;
  final int? lessonId;
  final bool isCorrect;
  final DateTime createdAt;
  const UnderstandingCheck({
    required this.id,
    required this.studentId,
    this.lessonId,
    required this.isCorrect,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    if (!nullToAbsent || lessonId != null) {
      map['lesson_id'] = Variable<int>(lessonId);
    }
    map['is_correct'] = Variable<bool>(isCorrect);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UnderstandingChecksCompanion toCompanion(bool nullToAbsent) {
    return UnderstandingChecksCompanion(
      id: Value(id),
      studentId: Value(studentId),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
      isCorrect: Value(isCorrect),
      createdAt: Value(createdAt),
    );
  }

  factory UnderstandingCheck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnderstandingCheck(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      lessonId: serializer.fromJson<int?>(json['lessonId']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'lessonId': serializer.toJson<int?>(lessonId),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UnderstandingCheck copyWith({
    int? id,
    int? studentId,
    Value<int?> lessonId = const Value.absent(),
    bool? isCorrect,
    DateTime? createdAt,
  }) => UnderstandingCheck(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    lessonId: lessonId.present ? lessonId.value : this.lessonId,
    isCorrect: isCorrect ?? this.isCorrect,
    createdAt: createdAt ?? this.createdAt,
  );
  UnderstandingCheck copyWithCompanion(UnderstandingChecksCompanion data) {
    return UnderstandingCheck(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnderstandingCheck(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, lessonId, isCorrect, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnderstandingCheck &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.lessonId == this.lessonId &&
          other.isCorrect == this.isCorrect &&
          other.createdAt == this.createdAt);
}

class UnderstandingChecksCompanion extends UpdateCompanion<UnderstandingCheck> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<int?> lessonId;
  final Value<bool> isCorrect;
  final Value<DateTime> createdAt;
  const UnderstandingChecksCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UnderstandingChecksCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    this.lessonId = const Value.absent(),
    required bool isCorrect,
    this.createdAt = const Value.absent(),
  }) : studentId = Value(studentId),
       isCorrect = Value(isCorrect);
  static Insertable<UnderstandingCheck> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? lessonId,
    Expression<bool>? isCorrect,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UnderstandingChecksCompanion copyWith({
    Value<int>? id,
    Value<int>? studentId,
    Value<int?>? lessonId,
    Value<bool>? isCorrect,
    Value<DateTime>? createdAt,
  }) {
    return UnderstandingChecksCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      isCorrect: isCorrect ?? this.isCorrect,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnderstandingChecksCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('lessonId: $lessonId, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InstalledPackagesTable extends InstalledPackages
    with TableInfo<$InstalledPackagesTable, InstalledPackage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstalledPackagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta(
    'packageId',
  );
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provinceMeta = const VerificationMeta(
    'province',
  );
  @override
  late final GeneratedColumn<String> province = GeneratedColumn<String>(
    'province',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Khyber Pakhtunkhwa'),
  );
  static const VerificationMeta _isDemoMeta = const VerificationMeta('isDemo');
  @override
  late final GeneratedColumn<bool> isDemo = GeneratedColumn<bool>(
    'is_demo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_demo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageId,
    grade,
    title,
    version,
    province,
    isDemo,
    sizeBytes,
    installedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installed_packages';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstalledPackage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packageIdMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('province')) {
      context.handle(
        _provinceMeta,
        province.isAcceptableOrUnknown(data['province']!, _provinceMeta),
      );
    }
    if (data.containsKey('is_demo')) {
      context.handle(
        _isDemoMeta,
        isDemo.isAcceptableOrUnknown(data['is_demo']!, _isDemoMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {packageId},
  ];
  @override
  InstalledPackage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstalledPackage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      province: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}province'],
      )!,
      isDemo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_demo'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
    );
  }

  @override
  $InstalledPackagesTable createAlias(String alias) {
    return $InstalledPackagesTable(attachedDatabase, alias);
  }
}

class InstalledPackage extends DataClass
    implements Insertable<InstalledPackage> {
  final int id;

  /// Stable identifier for the package, e.g. "kp-grade-5".
  final String packageId;
  final int grade;
  final String title;

  /// Semantic version string, e.g. "1.2.0". Compared to decide updates.
  final String version;
  final String province;
  final bool isDemo;
  final int sizeBytes;
  final DateTime installedAt;
  const InstalledPackage({
    required this.id,
    required this.packageId,
    required this.grade,
    required this.title,
    required this.version,
    required this.province,
    required this.isDemo,
    required this.sizeBytes,
    required this.installedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_id'] = Variable<String>(packageId);
    map['grade'] = Variable<int>(grade);
    map['title'] = Variable<String>(title);
    map['version'] = Variable<String>(version);
    map['province'] = Variable<String>(province);
    map['is_demo'] = Variable<bool>(isDemo);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['installed_at'] = Variable<DateTime>(installedAt);
    return map;
  }

  InstalledPackagesCompanion toCompanion(bool nullToAbsent) {
    return InstalledPackagesCompanion(
      id: Value(id),
      packageId: Value(packageId),
      grade: Value(grade),
      title: Value(title),
      version: Value(version),
      province: Value(province),
      isDemo: Value(isDemo),
      sizeBytes: Value(sizeBytes),
      installedAt: Value(installedAt),
    );
  }

  factory InstalledPackage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstalledPackage(
      id: serializer.fromJson<int>(json['id']),
      packageId: serializer.fromJson<String>(json['packageId']),
      grade: serializer.fromJson<int>(json['grade']),
      title: serializer.fromJson<String>(json['title']),
      version: serializer.fromJson<String>(json['version']),
      province: serializer.fromJson<String>(json['province']),
      isDemo: serializer.fromJson<bool>(json['isDemo']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageId': serializer.toJson<String>(packageId),
      'grade': serializer.toJson<int>(grade),
      'title': serializer.toJson<String>(title),
      'version': serializer.toJson<String>(version),
      'province': serializer.toJson<String>(province),
      'isDemo': serializer.toJson<bool>(isDemo),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'installedAt': serializer.toJson<DateTime>(installedAt),
    };
  }

  InstalledPackage copyWith({
    int? id,
    String? packageId,
    int? grade,
    String? title,
    String? version,
    String? province,
    bool? isDemo,
    int? sizeBytes,
    DateTime? installedAt,
  }) => InstalledPackage(
    id: id ?? this.id,
    packageId: packageId ?? this.packageId,
    grade: grade ?? this.grade,
    title: title ?? this.title,
    version: version ?? this.version,
    province: province ?? this.province,
    isDemo: isDemo ?? this.isDemo,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    installedAt: installedAt ?? this.installedAt,
  );
  InstalledPackage copyWithCompanion(InstalledPackagesCompanion data) {
    return InstalledPackage(
      id: data.id.present ? data.id.value : this.id,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      grade: data.grade.present ? data.grade.value : this.grade,
      title: data.title.present ? data.title.value : this.title,
      version: data.version.present ? data.version.value : this.version,
      province: data.province.present ? data.province.value : this.province,
      isDemo: data.isDemo.present ? data.isDemo.value : this.isDemo,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstalledPackage(')
          ..write('id: $id, ')
          ..write('packageId: $packageId, ')
          ..write('grade: $grade, ')
          ..write('title: $title, ')
          ..write('version: $version, ')
          ..write('province: $province, ')
          ..write('isDemo: $isDemo, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packageId,
    grade,
    title,
    version,
    province,
    isDemo,
    sizeBytes,
    installedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstalledPackage &&
          other.id == this.id &&
          other.packageId == this.packageId &&
          other.grade == this.grade &&
          other.title == this.title &&
          other.version == this.version &&
          other.province == this.province &&
          other.isDemo == this.isDemo &&
          other.sizeBytes == this.sizeBytes &&
          other.installedAt == this.installedAt);
}

class InstalledPackagesCompanion extends UpdateCompanion<InstalledPackage> {
  final Value<int> id;
  final Value<String> packageId;
  final Value<int> grade;
  final Value<String> title;
  final Value<String> version;
  final Value<String> province;
  final Value<bool> isDemo;
  final Value<int> sizeBytes;
  final Value<DateTime> installedAt;
  const InstalledPackagesCompanion({
    this.id = const Value.absent(),
    this.packageId = const Value.absent(),
    this.grade = const Value.absent(),
    this.title = const Value.absent(),
    this.version = const Value.absent(),
    this.province = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.installedAt = const Value.absent(),
  });
  InstalledPackagesCompanion.insert({
    this.id = const Value.absent(),
    required String packageId,
    required int grade,
    required String title,
    required String version,
    this.province = const Value.absent(),
    this.isDemo = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.installedAt = const Value.absent(),
  }) : packageId = Value(packageId),
       grade = Value(grade),
       title = Value(title),
       version = Value(version);
  static Insertable<InstalledPackage> custom({
    Expression<int>? id,
    Expression<String>? packageId,
    Expression<int>? grade,
    Expression<String>? title,
    Expression<String>? version,
    Expression<String>? province,
    Expression<bool>? isDemo,
    Expression<int>? sizeBytes,
    Expression<DateTime>? installedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageId != null) 'package_id': packageId,
      if (grade != null) 'grade': grade,
      if (title != null) 'title': title,
      if (version != null) 'version': version,
      if (province != null) 'province': province,
      if (isDemo != null) 'is_demo': isDemo,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (installedAt != null) 'installed_at': installedAt,
    });
  }

  InstalledPackagesCompanion copyWith({
    Value<int>? id,
    Value<String>? packageId,
    Value<int>? grade,
    Value<String>? title,
    Value<String>? version,
    Value<String>? province,
    Value<bool>? isDemo,
    Value<int>? sizeBytes,
    Value<DateTime>? installedAt,
  }) {
    return InstalledPackagesCompanion(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      grade: grade ?? this.grade,
      title: title ?? this.title,
      version: version ?? this.version,
      province: province ?? this.province,
      isDemo: isDemo ?? this.isDemo,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      installedAt: installedAt ?? this.installedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (province.present) {
      map['province'] = Variable<String>(province.value);
    }
    if (isDemo.present) {
      map['is_demo'] = Variable<bool>(isDemo.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstalledPackagesCompanion(')
          ..write('id: $id, ')
          ..write('packageId: $packageId, ')
          ..write('grade: $grade, ')
          ..write('title: $title, ')
          ..write('version: $version, ')
          ..write('province: $province, ')
          ..write('isDemo: $isDemo, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueRowsTable extends SyncQueueRows
    with TableInfo<$SyncQueueRowsTable, SyncQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    payload,
    syncStatus,
    attempts,
    createdAt,
    updatedAt,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $SyncQueueRowsTable createAlias(String alias) {
    return $SyncQueueRowsTable(attachedDatabase, alias);
  }
}

class SyncQueueRow extends DataClass implements Insertable<SyncQueueRow> {
  final int id;

  /// 'progress' | 'quiz' | 'achievement'.
  final String kind;

  /// Compact JSON payload (small, anonymous — no name/school/personal fields).
  final String payload;

  /// 'pending' | 'synced' | 'failed'.
  final String syncStatus;
  final int attempts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  const SyncQueueRow({
    required this.id,
    required this.kind,
    required this.payload,
    required this.syncStatus,
    required this.attempts,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['payload'] = Variable<String>(payload);
    map['sync_status'] = Variable<String>(syncStatus);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  SyncQueueRowsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueRowsCompanion(
      id: Value(id),
      kind: Value(kind),
      payload: Value(payload),
      syncStatus: Value(syncStatus),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory SyncQueueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueRow(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      payload: serializer.fromJson<String>(json['payload']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'payload': serializer.toJson<String>(payload),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  SyncQueueRow copyWith({
    int? id,
    String? kind,
    String? payload,
    String? syncStatus,
    int? attempts,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => SyncQueueRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    payload: payload ?? this.payload,
    syncStatus: syncStatus ?? this.syncStatus,
    attempts: attempts ?? this.attempts,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  SyncQueueRow copyWithCompanion(SyncQueueRowsCompanion data) {
    return SyncQueueRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    payload,
    syncStatus,
    attempts,
    createdAt,
    updatedAt,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.payload == this.payload &&
          other.syncStatus == this.syncStatus &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SyncQueueRowsCompanion extends UpdateCompanion<SyncQueueRow> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String> payload;
  final Value<String> syncStatus;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncedAt;
  const SyncQueueRowsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  SyncQueueRowsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String payload,
    this.syncStatus = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : kind = Value(kind),
       payload = Value(payload);
  static Insertable<SyncQueueRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? payload,
    Expression<String>? syncStatus,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  SyncQueueRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String>? payload,
    Value<String>? syncStatus,
    Value<int>? attempts,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return SyncQueueRowsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
      syncStatus: syncStatus ?? this.syncStatus,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueRowsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    code,
    points,
    unlockedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {studentId, code},
  ];
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final int id;
  final int studentId;

  /// Stable achievement code, e.g. 'first_lesson'.
  final String code;
  final int points;
  final DateTime unlockedAt;
  const Achievement({
    required this.id,
    required this.studentId,
    required this.code,
    required this.points,
    required this.unlockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['code'] = Variable<String>(code);
    map['points'] = Variable<int>(points);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      code: Value(code),
      points: Value(points),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      code: serializer.fromJson<String>(json['code']),
      points: serializer.fromJson<int>(json['points']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'code': serializer.toJson<String>(code),
      'points': serializer.toJson<int>(points),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  Achievement copyWith({
    int? id,
    int? studentId,
    String? code,
    int? points,
    DateTime? unlockedAt,
  }) => Achievement(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    code: code ?? this.code,
    points: points ?? this.points,
    unlockedAt: unlockedAt ?? this.unlockedAt,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      code: data.code.present ? data.code.value : this.code,
      points: data.points.present ? data.points.value : this.points,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('code: $code, ')
          ..write('points: $points, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, code, points, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.code == this.code &&
          other.points == this.points &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<String> code;
  final Value<int> points;
  final Value<DateTime> unlockedAt;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.code = const Value.absent(),
    this.points = const Value.absent(),
    this.unlockedAt = const Value.absent(),
  });
  AchievementsCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required String code,
    this.points = const Value.absent(),
    this.unlockedAt = const Value.absent(),
  }) : studentId = Value(studentId),
       code = Value(code);
  static Insertable<Achievement> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<String>? code,
    Expression<int>? points,
    Expression<DateTime>? unlockedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (code != null) 'code': code,
      if (points != null) 'points': points,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
    });
  }

  AchievementsCompanion copyWith({
    Value<int>? id,
    Value<int>? studentId,
    Value<String>? code,
    Value<int>? points,
    Value<DateTime>? unlockedAt,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      code: code ?? this.code,
      points: points ?? this.points,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('code: $code, ')
          ..write('points: $points, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $QuizAttemptsTable quizAttempts = $QuizAttemptsTable(this);
  late final $QuizAnswersTable quizAnswers = $QuizAnswersTable(this);
  late final $LessonProgressTable lessonProgress = $LessonProgressTable(this);
  late final $DownloadsTable downloads = $DownloadsTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $AppSettingsRowsTable appSettingsRows = $AppSettingsRowsTable(
    this,
  );
  late final $TutorMessagesTable tutorMessages = $TutorMessagesTable(this);
  late final $UnderstandingChecksTable understandingChecks =
      $UnderstandingChecksTable(this);
  late final $InstalledPackagesTable installedPackages =
      $InstalledPackagesTable(this);
  late final $SyncQueueRowsTable syncQueueRows = $SyncQueueRowsTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    students,
    subjects,
    units,
    lessons,
    questions,
    quizAttempts,
    quizAnswers,
    lessonProgress,
    downloads,
    favorites,
    appSettingsRows,
    tutorMessages,
    understandingChecks,
    installedPackages,
    syncQueueRows,
    achievements,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subjects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('units', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'units',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lessons', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lessons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('questions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_attempts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lessons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_attempts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quiz_attempts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_answers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'questions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_answers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lesson_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lessons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lesson_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subjects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('downloads', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('favorites', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lessons',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('favorites', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$StudentsTableCreateCompanionBuilder =
    StudentsCompanion Function({
      Value<int> id,
      required String name,
      required int grade,
      required String languageCode,
      Value<int> avatarSeed,
      Value<String?> school,
      Value<String?> className,
      Value<DateTime> createdAt,
    });
typedef $$StudentsTableUpdateCompanionBuilder =
    StudentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> grade,
      Value<String> languageCode,
      Value<int> avatarSeed,
      Value<String?> school,
      Value<String?> className,
      Value<DateTime> createdAt,
    });

final class $$StudentsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentsTable, Student> {
  $$StudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuizAttemptsTable, List<QuizAttempt>>
  _quizAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAttempts,
    aliasName: 'students__id__quiz_attempts__student_id',
  );

  $$QuizAttemptsTableProcessedTableManager get quizAttemptsRefs {
    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LessonProgressTable, List<LessonProgressData>>
  _lessonProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lessonProgress,
    aliasName: 'students__id__lesson_progress__student_id',
  );

  $$LessonProgressTableProcessedTableManager get lessonProgressRefs {
    final manager = $$LessonProgressTableTableManager(
      $_db,
      $_db.lessonProgress,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FavoritesTable, List<Favorite>>
  _favoritesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.favorites,
    aliasName: 'students__id__favorites__student_id',
  );

  $$FavoritesTableProcessedTableManager get favoritesRefs {
    final manager = $$FavoritesTableTableManager(
      $_db,
      $_db.favorites,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoritesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avatarSeed => $composableBuilder(
    column: $table.avatarSeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get className => $composableBuilder(
    column: $table.className,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> quizAttemptsRefs(
    Expression<bool> Function($$QuizAttemptsTableFilterComposer f) f,
  ) {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lessonProgressRefs(
    Expression<bool> Function($$LessonProgressTableFilterComposer f) f,
  ) {
    final $$LessonProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonProgress,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonProgressTableFilterComposer(
            $db: $db,
            $table: $db.lessonProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoritesRefs(
    Expression<bool> Function($$FavoritesTableFilterComposer f) f,
  ) {
    final $$FavoritesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableFilterComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avatarSeed => $composableBuilder(
    column: $table.avatarSeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get className => $composableBuilder(
    column: $table.className,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avatarSeed => $composableBuilder(
    column: $table.avatarSeed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<String> get className =>
      $composableBuilder(column: $table.className, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> quizAttemptsRefs<T extends Object>(
    Expression<T> Function($$QuizAttemptsTableAnnotationComposer a) f,
  ) {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lessonProgressRefs<T extends Object>(
    Expression<T> Function($$LessonProgressTableAnnotationComposer a) f,
  ) {
    final $$LessonProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonProgress,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> favoritesRefs<T extends Object>(
    Expression<T> Function($$FavoritesTableAnnotationComposer a) f,
  ) {
    final $$FavoritesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableAnnotationComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          Student,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (Student, $$StudentsTableReferences),
          Student,
          PrefetchHooks Function({
            bool quizAttemptsRefs,
            bool lessonProgressRefs,
            bool favoritesRefs,
          })
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<int> avatarSeed = const Value.absent(),
                Value<String?> school = const Value.absent(),
                Value<String?> className = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                name: name,
                grade: grade,
                languageCode: languageCode,
                avatarSeed: avatarSeed,
                school: school,
                className: className,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int grade,
                required String languageCode,
                Value<int> avatarSeed = const Value.absent(),
                Value<String?> school = const Value.absent(),
                Value<String?> className = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StudentsCompanion.insert(
                id: id,
                name: name,
                grade: grade,
                languageCode: languageCode,
                avatarSeed: avatarSeed,
                school: school,
                className: className,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                quizAttemptsRefs = false,
                lessonProgressRefs = false,
                favoritesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quizAttemptsRefs) db.quizAttempts,
                    if (lessonProgressRefs) db.lessonProgress,
                    if (favoritesRefs) db.favorites,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quizAttemptsRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          QuizAttempt
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._quizAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lessonProgressRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          LessonProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._lessonProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).lessonProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoritesRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          Favorite
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._favoritesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).favoritesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      Student,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (Student, $$StudentsTableReferences),
      Student,
      PrefetchHooks Function({
        bool quizAttemptsRefs,
        bool lessonProgressRefs,
        bool favoritesRefs,
      })
    >;
typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({
      Value<int> id,
      required String code,
      required int grade,
      required String nameEn,
      required String nameUr,
      required String namePs,
      required String emoji,
      Value<int> sortOrder,
    });
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<int> grade,
      Value<String> nameEn,
      Value<String> nameUr,
      Value<String> namePs,
      Value<String> emoji,
      Value<int> sortOrder,
    });

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, Subject> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UnitsTable, List<Unit>> _unitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.units,
    aliasName: 'subjects__id__units__subject_id',
  );

  $$UnitsTableProcessedTableManager get unitsRefs {
    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_unitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DownloadsTable, List<Download>>
  _downloadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.downloads,
    aliasName: 'subjects__id__downloads__subject_id',
  );

  $$DownloadsTableProcessedTableManager get downloadsRefs {
    final manager = $$DownloadsTableTableManager(
      $_db,
      $_db.downloads,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_downloadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameUr => $composableBuilder(
    column: $table.nameUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namePs => $composableBuilder(
    column: $table.namePs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> unitsRefs(
    Expression<bool> Function($$UnitsTableFilterComposer f) f,
  ) {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> downloadsRefs(
    Expression<bool> Function($$DownloadsTableFilterComposer f) f,
  ) {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableFilterComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameUr => $composableBuilder(
    column: $table.nameUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namePs => $composableBuilder(
    column: $table.namePs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameUr =>
      $composableBuilder(column: $table.nameUr, builder: (column) => column);

  GeneratedColumn<String> get namePs =>
      $composableBuilder(column: $table.namePs, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> unitsRefs<T extends Object>(
    Expression<T> Function($$UnitsTableAnnotationComposer a) f,
  ) {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> downloadsRefs<T extends Object>(
    Expression<T> Function($$DownloadsTableAnnotationComposer a) f,
  ) {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableAnnotationComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, $$SubjectsTableReferences),
          Subject,
          PrefetchHooks Function({bool unitsRefs, bool downloadsRefs})
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameUr = const Value.absent(),
                Value<String> namePs = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                code: code,
                grade: grade,
                nameEn: nameEn,
                nameUr: nameUr,
                namePs: namePs,
                emoji: emoji,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required int grade,
                required String nameEn,
                required String nameUr,
                required String namePs,
                required String emoji,
                Value<int> sortOrder = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                code: code,
                grade: grade,
                nameEn: nameEn,
                nameUr: nameUr,
                namePs: namePs,
                emoji: emoji,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitsRefs = false, downloadsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (unitsRefs) db.units,
                if (downloadsRefs) db.downloads,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (unitsRefs)
                    await $_getPrefetchedData<Subject, $SubjectsTable, Unit>(
                      currentTable: table,
                      referencedTable: $$SubjectsTableReferences
                          ._unitsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SubjectsTableReferences(db, table, p0).unitsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.subjectId == item.id),
                      typedResults: items,
                    ),
                  if (downloadsRefs)
                    await $_getPrefetchedData<
                      Subject,
                      $SubjectsTable,
                      Download
                    >(
                      currentTable: table,
                      referencedTable: $$SubjectsTableReferences
                          ._downloadsRefsTable(db),
                      managerFromTypedResult: (p0) => $$SubjectsTableReferences(
                        db,
                        table,
                        p0,
                      ).downloadsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.subjectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, $$SubjectsTableReferences),
      Subject,
      PrefetchHooks Function({bool unitsRefs, bool downloadsRefs})
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      required int subjectId,
      required String titleEn,
      required String titleUr,
      required String titlePs,
      Value<int> sortOrder,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      Value<int> subjectId,
      Value<String> titleEn,
      Value<String> titleUr,
      Value<String> titlePs,
      Value<int> sortOrder,
    });

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias('units__subject_id__subjects__id');

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<int>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LessonsTable, List<Lesson>> _lessonsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lessons,
    aliasName: 'units__id__lessons__unit_id',
  );

  $$LessonsTableProcessedTableManager get lessonsRefs {
    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleUr => $composableBuilder(
    column: $table.titleUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titlePs => $composableBuilder(
    column: $table.titlePs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> lessonsRefs(
    Expression<bool> Function($$LessonsTableFilterComposer f) f,
  ) {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleUr => $composableBuilder(
    column: $table.titleUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titlePs => $composableBuilder(
    column: $table.titlePs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleUr =>
      $composableBuilder(column: $table.titleUr, builder: (column) => column);

  GeneratedColumn<String> get titlePs =>
      $composableBuilder(column: $table.titlePs, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> lessonsRefs<T extends Object>(
    Expression<T> Function($$LessonsTableAnnotationComposer a) f,
  ) {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, $$UnitsTableReferences),
          Unit,
          PrefetchHooks Function({bool subjectId, bool lessonsRefs})
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<String> titleEn = const Value.absent(),
                Value<String> titleUr = const Value.absent(),
                Value<String> titlePs = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                subjectId: subjectId,
                titleEn: titleEn,
                titleUr: titleUr,
                titlePs: titlePs,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int subjectId,
                required String titleEn,
                required String titleUr,
                required String titlePs,
                Value<int> sortOrder = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                subjectId: subjectId,
                titleEn: titleEn,
                titleUr: titleUr,
                titlePs: titlePs,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UnitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({subjectId = false, lessonsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lessonsRefs) db.lessons],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subjectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectId,
                                referencedTable: $$UnitsTableReferences
                                    ._subjectIdTable(db),
                                referencedColumn: $$UnitsTableReferences
                                    ._subjectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonsRefs)
                    await $_getPrefetchedData<Unit, $UnitsTable, Lesson>(
                      currentTable: table,
                      referencedTable: $$UnitsTableReferences._lessonsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UnitsTableReferences(db, table, p0).lessonsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.unitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, $$UnitsTableReferences),
      Unit,
      PrefetchHooks Function({bool subjectId, bool lessonsRefs})
    >;
typedef $$LessonsTableCreateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      required int unitId,
      required String titleEn,
      required String titleUr,
      required String titlePs,
      required String objectiveEn,
      required String objectiveUr,
      required String objectivePs,
      required String explanationEn,
      required String explanationUr,
      required String explanationPs,
      required String exampleEn,
      required String exampleUr,
      required String examplePs,
      required String illustration,
      Value<String?> audioAsset,
      Value<int> sortOrder,
      Value<bool> isDemo,
    });
typedef $$LessonsTableUpdateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      Value<int> unitId,
      Value<String> titleEn,
      Value<String> titleUr,
      Value<String> titlePs,
      Value<String> objectiveEn,
      Value<String> objectiveUr,
      Value<String> objectivePs,
      Value<String> explanationEn,
      Value<String> explanationUr,
      Value<String> explanationPs,
      Value<String> exampleEn,
      Value<String> exampleUr,
      Value<String> examplePs,
      Value<String> illustration,
      Value<String?> audioAsset,
      Value<int> sortOrder,
      Value<bool> isDemo,
    });

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, Lesson> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('lessons__unit_id__units__id');

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuestionsTable, List<Question>>
  _questionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.questions,
    aliasName: 'lessons__id__questions__lesson_id',
  );

  $$QuestionsTableProcessedTableManager get questionsRefs {
    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_questionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizAttemptsTable, List<QuizAttempt>>
  _quizAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAttempts,
    aliasName: 'lessons__id__quiz_attempts__lesson_id',
  );

  $$QuizAttemptsTableProcessedTableManager get quizAttemptsRefs {
    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LessonProgressTable, List<LessonProgressData>>
  _lessonProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lessonProgress,
    aliasName: 'lessons__id__lesson_progress__lesson_id',
  );

  $$LessonProgressTableProcessedTableManager get lessonProgressRefs {
    final manager = $$LessonProgressTableTableManager(
      $_db,
      $_db.lessonProgress,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FavoritesTable, List<Favorite>>
  _favoritesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.favorites,
    aliasName: 'lessons__id__favorites__lesson_id',
  );

  $$FavoritesTableProcessedTableManager get favoritesRefs {
    final manager = $$FavoritesTableTableManager(
      $_db,
      $_db.favorites,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoritesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleUr => $composableBuilder(
    column: $table.titleUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titlePs => $composableBuilder(
    column: $table.titlePs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objectiveEn => $composableBuilder(
    column: $table.objectiveEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objectiveUr => $composableBuilder(
    column: $table.objectiveUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objectivePs => $composableBuilder(
    column: $table.objectivePs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationEn => $composableBuilder(
    column: $table.explanationEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationUr => $composableBuilder(
    column: $table.explanationUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationPs => $composableBuilder(
    column: $table.explanationPs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleEn => $composableBuilder(
    column: $table.exampleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleUr => $composableBuilder(
    column: $table.exampleUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examplePs => $composableBuilder(
    column: $table.examplePs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get illustration => $composableBuilder(
    column: $table.illustration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioAsset => $composableBuilder(
    column: $table.audioAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> questionsRefs(
    Expression<bool> Function($$QuestionsTableFilterComposer f) f,
  ) {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizAttemptsRefs(
    Expression<bool> Function($$QuizAttemptsTableFilterComposer f) f,
  ) {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lessonProgressRefs(
    Expression<bool> Function($$LessonProgressTableFilterComposer f) f,
  ) {
    final $$LessonProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonProgress,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonProgressTableFilterComposer(
            $db: $db,
            $table: $db.lessonProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoritesRefs(
    Expression<bool> Function($$FavoritesTableFilterComposer f) f,
  ) {
    final $$FavoritesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableFilterComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleUr => $composableBuilder(
    column: $table.titleUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titlePs => $composableBuilder(
    column: $table.titlePs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectiveEn => $composableBuilder(
    column: $table.objectiveEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectiveUr => $composableBuilder(
    column: $table.objectiveUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectivePs => $composableBuilder(
    column: $table.objectivePs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationEn => $composableBuilder(
    column: $table.explanationEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationUr => $composableBuilder(
    column: $table.explanationUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationPs => $composableBuilder(
    column: $table.explanationPs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleEn => $composableBuilder(
    column: $table.exampleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleUr => $composableBuilder(
    column: $table.exampleUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examplePs => $composableBuilder(
    column: $table.examplePs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get illustration => $composableBuilder(
    column: $table.illustration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioAsset => $composableBuilder(
    column: $table.audioAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleUr =>
      $composableBuilder(column: $table.titleUr, builder: (column) => column);

  GeneratedColumn<String> get titlePs =>
      $composableBuilder(column: $table.titlePs, builder: (column) => column);

  GeneratedColumn<String> get objectiveEn => $composableBuilder(
    column: $table.objectiveEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get objectiveUr => $composableBuilder(
    column: $table.objectiveUr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get objectivePs => $composableBuilder(
    column: $table.objectivePs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationEn => $composableBuilder(
    column: $table.explanationEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationUr => $composableBuilder(
    column: $table.explanationUr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationPs => $composableBuilder(
    column: $table.explanationPs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleEn =>
      $composableBuilder(column: $table.exampleEn, builder: (column) => column);

  GeneratedColumn<String> get exampleUr =>
      $composableBuilder(column: $table.exampleUr, builder: (column) => column);

  GeneratedColumn<String> get examplePs =>
      $composableBuilder(column: $table.examplePs, builder: (column) => column);

  GeneratedColumn<String> get illustration => $composableBuilder(
    column: $table.illustration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioAsset => $composableBuilder(
    column: $table.audioAsset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> questionsRefs<T extends Object>(
    Expression<T> Function($$QuestionsTableAnnotationComposer a) f,
  ) {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizAttemptsRefs<T extends Object>(
    Expression<T> Function($$QuizAttemptsTableAnnotationComposer a) f,
  ) {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lessonProgressRefs<T extends Object>(
    Expression<T> Function($$LessonProgressTableAnnotationComposer a) f,
  ) {
    final $$LessonProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonProgress,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> favoritesRefs<T extends Object>(
    Expression<T> Function($$FavoritesTableAnnotationComposer a) f,
  ) {
    final $$FavoritesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableAnnotationComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTable,
          Lesson,
          $$LessonsTableFilterComposer,
          $$LessonsTableOrderingComposer,
          $$LessonsTableAnnotationComposer,
          $$LessonsTableCreateCompanionBuilder,
          $$LessonsTableUpdateCompanionBuilder,
          (Lesson, $$LessonsTableReferences),
          Lesson,
          PrefetchHooks Function({
            bool unitId,
            bool questionsRefs,
            bool quizAttemptsRefs,
            bool lessonProgressRefs,
            bool favoritesRefs,
          })
        > {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<String> titleEn = const Value.absent(),
                Value<String> titleUr = const Value.absent(),
                Value<String> titlePs = const Value.absent(),
                Value<String> objectiveEn = const Value.absent(),
                Value<String> objectiveUr = const Value.absent(),
                Value<String> objectivePs = const Value.absent(),
                Value<String> explanationEn = const Value.absent(),
                Value<String> explanationUr = const Value.absent(),
                Value<String> explanationPs = const Value.absent(),
                Value<String> exampleEn = const Value.absent(),
                Value<String> exampleUr = const Value.absent(),
                Value<String> examplePs = const Value.absent(),
                Value<String> illustration = const Value.absent(),
                Value<String?> audioAsset = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
              }) => LessonsCompanion(
                id: id,
                unitId: unitId,
                titleEn: titleEn,
                titleUr: titleUr,
                titlePs: titlePs,
                objectiveEn: objectiveEn,
                objectiveUr: objectiveUr,
                objectivePs: objectivePs,
                explanationEn: explanationEn,
                explanationUr: explanationUr,
                explanationPs: explanationPs,
                exampleEn: exampleEn,
                exampleUr: exampleUr,
                examplePs: examplePs,
                illustration: illustration,
                audioAsset: audioAsset,
                sortOrder: sortOrder,
                isDemo: isDemo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int unitId,
                required String titleEn,
                required String titleUr,
                required String titlePs,
                required String objectiveEn,
                required String objectiveUr,
                required String objectivePs,
                required String explanationEn,
                required String explanationUr,
                required String explanationPs,
                required String exampleEn,
                required String exampleUr,
                required String examplePs,
                required String illustration,
                Value<String?> audioAsset = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
              }) => LessonsCompanion.insert(
                id: id,
                unitId: unitId,
                titleEn: titleEn,
                titleUr: titleUr,
                titlePs: titlePs,
                objectiveEn: objectiveEn,
                objectiveUr: objectiveUr,
                objectivePs: objectivePs,
                explanationEn: explanationEn,
                explanationUr: explanationUr,
                explanationPs: explanationPs,
                exampleEn: exampleEn,
                exampleUr: exampleUr,
                examplePs: examplePs,
                illustration: illustration,
                audioAsset: audioAsset,
                sortOrder: sortOrder,
                isDemo: isDemo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                unitId = false,
                questionsRefs = false,
                quizAttemptsRefs = false,
                lessonProgressRefs = false,
                favoritesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (questionsRefs) db.questions,
                    if (quizAttemptsRefs) db.quizAttempts,
                    if (lessonProgressRefs) db.lessonProgress,
                    if (favoritesRefs) db.favorites,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (unitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unitId,
                                    referencedTable: $$LessonsTableReferences
                                        ._unitIdTable(db),
                                    referencedColumn: $$LessonsTableReferences
                                        ._unitIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (questionsRefs)
                        await $_getPrefetchedData<
                          Lesson,
                          $LessonsTable,
                          Question
                        >(
                          currentTable: table,
                          referencedTable: $$LessonsTableReferences
                              ._questionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).questionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizAttemptsRefs)
                        await $_getPrefetchedData<
                          Lesson,
                          $LessonsTable,
                          QuizAttempt
                        >(
                          currentTable: table,
                          referencedTable: $$LessonsTableReferences
                              ._quizAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lessonProgressRefs)
                        await $_getPrefetchedData<
                          Lesson,
                          $LessonsTable,
                          LessonProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$LessonsTableReferences
                              ._lessonProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).lessonProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoritesRefs)
                        await $_getPrefetchedData<
                          Lesson,
                          $LessonsTable,
                          Favorite
                        >(
                          currentTable: table,
                          referencedTable: $$LessonsTableReferences
                              ._favoritesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).favoritesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lessonId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTable,
      Lesson,
      $$LessonsTableFilterComposer,
      $$LessonsTableOrderingComposer,
      $$LessonsTableAnnotationComposer,
      $$LessonsTableCreateCompanionBuilder,
      $$LessonsTableUpdateCompanionBuilder,
      (Lesson, $$LessonsTableReferences),
      Lesson,
      PrefetchHooks Function({
        bool unitId,
        bool questionsRefs,
        bool quizAttemptsRefs,
        bool lessonProgressRefs,
        bool favoritesRefs,
      })
    >;
typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      required int lessonId,
      required String promptEn,
      required String promptUr,
      required String promptPs,
      required String optionsEn,
      required String optionsUr,
      required String optionsPs,
      required int correctIndex,
      Value<int> sortOrder,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      Value<int> lessonId,
      Value<String> promptEn,
      Value<String> promptUr,
      Value<String> promptPs,
      Value<String> optionsEn,
      Value<String> optionsUr,
      Value<String> optionsPs,
      Value<int> correctIndex,
      Value<int> sortOrder,
    });

final class $$QuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestionsTable, Question> {
  $$QuestionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias('questions__lesson_id__lessons__id');

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuizAnswersTable, List<QuizAnswer>>
  _quizAnswersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAnswers,
    aliasName: 'questions__id__quiz_answers__question_id',
  );

  $$QuizAnswersTableProcessedTableManager get quizAnswersRefs {
    final manager = $$QuizAnswersTableTableManager(
      $_db,
      $_db.quizAnswers,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizAnswersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promptEn => $composableBuilder(
    column: $table.promptEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promptUr => $composableBuilder(
    column: $table.promptUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promptPs => $composableBuilder(
    column: $table.promptPs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsEn => $composableBuilder(
    column: $table.optionsEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsUr => $composableBuilder(
    column: $table.optionsUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsPs => $composableBuilder(
    column: $table.optionsPs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quizAnswersRefs(
    Expression<bool> Function($$QuizAnswersTableFilterComposer f) f,
  ) {
    final $$QuizAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAnswers,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAnswersTableFilterComposer(
            $db: $db,
            $table: $db.quizAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promptEn => $composableBuilder(
    column: $table.promptEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promptUr => $composableBuilder(
    column: $table.promptUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promptPs => $composableBuilder(
    column: $table.promptPs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsEn => $composableBuilder(
    column: $table.optionsEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsUr => $composableBuilder(
    column: $table.optionsUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsPs => $composableBuilder(
    column: $table.optionsPs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get promptEn =>
      $composableBuilder(column: $table.promptEn, builder: (column) => column);

  GeneratedColumn<String> get promptUr =>
      $composableBuilder(column: $table.promptUr, builder: (column) => column);

  GeneratedColumn<String> get promptPs =>
      $composableBuilder(column: $table.promptPs, builder: (column) => column);

  GeneratedColumn<String> get optionsEn =>
      $composableBuilder(column: $table.optionsEn, builder: (column) => column);

  GeneratedColumn<String> get optionsUr =>
      $composableBuilder(column: $table.optionsUr, builder: (column) => column);

  GeneratedColumn<String> get optionsPs =>
      $composableBuilder(column: $table.optionsPs, builder: (column) => column);

  GeneratedColumn<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quizAnswersRefs<T extends Object>(
    Expression<T> Function($$QuizAnswersTableAnnotationComposer a) f,
  ) {
    final $$QuizAnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAnswers,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, $$QuestionsTableReferences),
          Question,
          PrefetchHooks Function({bool lessonId, bool quizAnswersRefs})
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<String> promptEn = const Value.absent(),
                Value<String> promptUr = const Value.absent(),
                Value<String> promptPs = const Value.absent(),
                Value<String> optionsEn = const Value.absent(),
                Value<String> optionsUr = const Value.absent(),
                Value<String> optionsPs = const Value.absent(),
                Value<int> correctIndex = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                lessonId: lessonId,
                promptEn: promptEn,
                promptUr: promptUr,
                promptPs: promptPs,
                optionsEn: optionsEn,
                optionsUr: optionsUr,
                optionsPs: optionsPs,
                correctIndex: correctIndex,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lessonId,
                required String promptEn,
                required String promptUr,
                required String promptPs,
                required String optionsEn,
                required String optionsUr,
                required String optionsPs,
                required int correctIndex,
                Value<int> sortOrder = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                lessonId: lessonId,
                promptEn: promptEn,
                promptUr: promptUr,
                promptPs: promptPs,
                optionsEn: optionsEn,
                optionsUr: optionsUr,
                optionsPs: optionsPs,
                correctIndex: correctIndex,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonId = false, quizAnswersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (quizAnswersRefs) db.quizAnswers],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable: $$QuestionsTableReferences
                                    ._lessonIdTable(db),
                                referencedColumn: $$QuestionsTableReferences
                                    ._lessonIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (quizAnswersRefs)
                    await $_getPrefetchedData<
                      Question,
                      $QuestionsTable,
                      QuizAnswer
                    >(
                      currentTable: table,
                      referencedTable: $$QuestionsTableReferences
                          ._quizAnswersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$QuestionsTableReferences(
                            db,
                            table,
                            p0,
                          ).quizAnswersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.questionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, $$QuestionsTableReferences),
      Question,
      PrefetchHooks Function({bool lessonId, bool quizAnswersRefs})
    >;
typedef $$QuizAttemptsTableCreateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<int> id,
      required int studentId,
      required int lessonId,
      required int score,
      required int total,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
    });
typedef $$QuizAttemptsTableUpdateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<int> id,
      Value<int> studentId,
      Value<int> lessonId,
      Value<int> score,
      Value<int> total,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
    });

final class $$QuizAttemptsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttempt> {
  $$QuizAttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('quiz_attempts__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias('quiz_attempts__lesson_id__lessons__id');

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuizAnswersTable, List<QuizAnswer>>
  _quizAnswersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAnswers,
    aliasName: 'quiz_attempts__id__quiz_answers__attempt_id',
  );

  $$QuizAnswersTableProcessedTableManager get quizAnswersRefs {
    final manager = $$QuizAnswersTableTableManager(
      $_db,
      $_db.quizAnswers,
    ).filter((f) => f.attemptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizAnswersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quizAnswersRefs(
    Expression<bool> Function($$QuizAnswersTableFilterComposer f) f,
  ) {
    final $$QuizAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAnswers,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAnswersTableFilterComposer(
            $db: $db,
            $table: $db.quizAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quizAnswersRefs<T extends Object>(
    Expression<T> Function($$QuizAnswersTableAnnotationComposer a) f,
  ) {
    final $$QuizAnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAnswers,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptsTable,
          QuizAttempt,
          $$QuizAttemptsTableFilterComposer,
          $$QuizAttemptsTableOrderingComposer,
          $$QuizAttemptsTableAnnotationComposer,
          $$QuizAttemptsTableCreateCompanionBuilder,
          $$QuizAttemptsTableUpdateCompanionBuilder,
          (QuizAttempt, $$QuizAttemptsTableReferences),
          QuizAttempt,
          PrefetchHooks Function({
            bool studentId,
            bool lessonId,
            bool quizAnswersRefs,
          })
        > {
  $$QuizAttemptsTableTableManager(_$AppDatabase db, $QuizAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> studentId = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
              }) => QuizAttemptsCompanion(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                score: score,
                total: total,
                startedAt: startedAt,
                finishedAt: finishedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int studentId,
                required int lessonId,
                required int score,
                required int total,
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
              }) => QuizAttemptsCompanion.insert(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                score: score,
                total: total,
                startedAt: startedAt,
                finishedAt: finishedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({studentId = false, lessonId = false, quizAnswersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quizAnswersRefs) db.quizAnswers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (studentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.studentId,
                                    referencedTable:
                                        $$QuizAttemptsTableReferences
                                            ._studentIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptsTableReferences
                                            ._studentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (lessonId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.lessonId,
                                    referencedTable:
                                        $$QuizAttemptsTableReferences
                                            ._lessonIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptsTableReferences
                                            ._lessonIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quizAnswersRefs)
                        await $_getPrefetchedData<
                          QuizAttempt,
                          $QuizAttemptsTable,
                          QuizAnswer
                        >(
                          currentTable: table,
                          referencedTable: $$QuizAttemptsTableReferences
                              ._quizAnswersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizAttemptsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizAnswersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.attemptId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuizAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptsTable,
      QuizAttempt,
      $$QuizAttemptsTableFilterComposer,
      $$QuizAttemptsTableOrderingComposer,
      $$QuizAttemptsTableAnnotationComposer,
      $$QuizAttemptsTableCreateCompanionBuilder,
      $$QuizAttemptsTableUpdateCompanionBuilder,
      (QuizAttempt, $$QuizAttemptsTableReferences),
      QuizAttempt,
      PrefetchHooks Function({
        bool studentId,
        bool lessonId,
        bool quizAnswersRefs,
      })
    >;
typedef $$QuizAnswersTableCreateCompanionBuilder =
    QuizAnswersCompanion Function({
      Value<int> id,
      required int attemptId,
      required int questionId,
      required int selectedIndex,
      required bool isCorrect,
    });
typedef $$QuizAnswersTableUpdateCompanionBuilder =
    QuizAnswersCompanion Function({
      Value<int> id,
      Value<int> attemptId,
      Value<int> questionId,
      Value<int> selectedIndex,
      Value<bool> isCorrect,
    });

final class $$QuizAnswersTableReferences
    extends BaseReferences<_$AppDatabase, $QuizAnswersTable, QuizAnswer> {
  $$QuizAnswersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QuizAttemptsTable _attemptIdTable(_$AppDatabase db) => db.quizAttempts
      .createAlias('quiz_answers__attempt_id__quiz_attempts__id');

  $$QuizAttemptsTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<int>('attempt_id')!;

    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias('quiz_answers__question_id__questions__id');

  $$QuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<int>('question_id')!;

    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAnswersTable> {
  $$QuizAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizAttemptsTableFilterComposer get attemptId {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAnswersTable> {
  $$QuizAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizAttemptsTableOrderingComposer get attemptId {
    final $$QuizAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAnswersTable> {
  $$QuizAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  $$QuizAttemptsTableAnnotationComposer get attemptId {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAnswersTable,
          QuizAnswer,
          $$QuizAnswersTableFilterComposer,
          $$QuizAnswersTableOrderingComposer,
          $$QuizAnswersTableAnnotationComposer,
          $$QuizAnswersTableCreateCompanionBuilder,
          $$QuizAnswersTableUpdateCompanionBuilder,
          (QuizAnswer, $$QuizAnswersTableReferences),
          QuizAnswer,
          PrefetchHooks Function({bool attemptId, bool questionId})
        > {
  $$QuizAnswersTableTableManager(_$AppDatabase db, $QuizAnswersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> attemptId = const Value.absent(),
                Value<int> questionId = const Value.absent(),
                Value<int> selectedIndex = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
              }) => QuizAnswersCompanion(
                id: id,
                attemptId: attemptId,
                questionId: questionId,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int attemptId,
                required int questionId,
                required int selectedIndex,
                required bool isCorrect,
              }) => QuizAnswersCompanion.insert(
                id: id,
                attemptId: attemptId,
                questionId: questionId,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizAnswersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attemptId = false, questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (attemptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.attemptId,
                                referencedTable: $$QuizAnswersTableReferences
                                    ._attemptIdTable(db),
                                referencedColumn: $$QuizAnswersTableReferences
                                    ._attemptIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable: $$QuizAnswersTableReferences
                                    ._questionIdTable(db),
                                referencedColumn: $$QuizAnswersTableReferences
                                    ._questionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAnswersTable,
      QuizAnswer,
      $$QuizAnswersTableFilterComposer,
      $$QuizAnswersTableOrderingComposer,
      $$QuizAnswersTableAnnotationComposer,
      $$QuizAnswersTableCreateCompanionBuilder,
      $$QuizAnswersTableUpdateCompanionBuilder,
      (QuizAnswer, $$QuizAnswersTableReferences),
      QuizAnswer,
      PrefetchHooks Function({bool attemptId, bool questionId})
    >;
typedef $$LessonProgressTableCreateCompanionBuilder =
    LessonProgressCompanion Function({
      Value<int> id,
      required int studentId,
      required int lessonId,
      Value<int> percent,
      Value<bool> completed,
      Value<DateTime> updatedAt,
    });
typedef $$LessonProgressTableUpdateCompanionBuilder =
    LessonProgressCompanion Function({
      Value<int> id,
      Value<int> studentId,
      Value<int> lessonId,
      Value<int> percent,
      Value<bool> completed,
      Value<DateTime> updatedAt,
    });

final class $$LessonProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LessonProgressTable,
          LessonProgressData
        > {
  $$LessonProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('lesson_progress__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias('lesson_progress__lesson_id__lessons__id');

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LessonProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get percent => $composableBuilder(
    column: $table.percent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get percent => $composableBuilder(
    column: $table.percent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressTable> {
  $$LessonProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get percent =>
      $composableBuilder(column: $table.percent, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonProgressTable,
          LessonProgressData,
          $$LessonProgressTableFilterComposer,
          $$LessonProgressTableOrderingComposer,
          $$LessonProgressTableAnnotationComposer,
          $$LessonProgressTableCreateCompanionBuilder,
          $$LessonProgressTableUpdateCompanionBuilder,
          (LessonProgressData, $$LessonProgressTableReferences),
          LessonProgressData,
          PrefetchHooks Function({bool studentId, bool lessonId})
        > {
  $$LessonProgressTableTableManager(
    _$AppDatabase db,
    $LessonProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> studentId = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<int> percent = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LessonProgressCompanion(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                percent: percent,
                completed: completed,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int studentId,
                required int lessonId,
                Value<int> percent = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LessonProgressCompanion.insert(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                percent: percent,
                completed: completed,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false, lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable: $$LessonProgressTableReferences
                                    ._studentIdTable(db),
                                referencedColumn:
                                    $$LessonProgressTableReferences
                                        ._studentIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable: $$LessonProgressTableReferences
                                    ._lessonIdTable(db),
                                referencedColumn:
                                    $$LessonProgressTableReferences
                                        ._lessonIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LessonProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonProgressTable,
      LessonProgressData,
      $$LessonProgressTableFilterComposer,
      $$LessonProgressTableOrderingComposer,
      $$LessonProgressTableAnnotationComposer,
      $$LessonProgressTableCreateCompanionBuilder,
      $$LessonProgressTableUpdateCompanionBuilder,
      (LessonProgressData, $$LessonProgressTableReferences),
      LessonProgressData,
      PrefetchHooks Function({bool studentId, bool lessonId})
    >;
typedef $$DownloadsTableCreateCompanionBuilder =
    DownloadsCompanion Function({
      Value<int> id,
      required int grade,
      required int subjectId,
      Value<bool> isDownloaded,
      Value<int> sizeBytes,
      Value<DateTime> updatedAt,
    });
typedef $$DownloadsTableUpdateCompanionBuilder =
    DownloadsCompanion Function({
      Value<int> id,
      Value<int> grade,
      Value<int> subjectId,
      Value<bool> isDownloaded,
      Value<int> sizeBytes,
      Value<DateTime> updatedAt,
    });

final class $$DownloadsTableReferences
    extends BaseReferences<_$AppDatabase, $DownloadsTable, Download> {
  $$DownloadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias('downloads__subject_id__subjects__id');

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<int>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DownloadsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadsTable,
          Download,
          $$DownloadsTableFilterComposer,
          $$DownloadsTableOrderingComposer,
          $$DownloadsTableAnnotationComposer,
          $$DownloadsTableCreateCompanionBuilder,
          $$DownloadsTableUpdateCompanionBuilder,
          (Download, $$DownloadsTableReferences),
          Download,
          PrefetchHooks Function({bool subjectId})
        > {
  $$DownloadsTableTableManager(_$AppDatabase db, $DownloadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<bool> isDownloaded = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DownloadsCompanion(
                id: id,
                grade: grade,
                subjectId: subjectId,
                isDownloaded: isDownloaded,
                sizeBytes: sizeBytes,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int grade,
                required int subjectId,
                Value<bool> isDownloaded = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DownloadsCompanion.insert(
                id: id,
                grade: grade,
                subjectId: subjectId,
                isDownloaded: isDownloaded,
                sizeBytes: sizeBytes,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DownloadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subjectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subjectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectId,
                                referencedTable: $$DownloadsTableReferences
                                    ._subjectIdTable(db),
                                referencedColumn: $$DownloadsTableReferences
                                    ._subjectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DownloadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadsTable,
      Download,
      $$DownloadsTableFilterComposer,
      $$DownloadsTableOrderingComposer,
      $$DownloadsTableAnnotationComposer,
      $$DownloadsTableCreateCompanionBuilder,
      $$DownloadsTableUpdateCompanionBuilder,
      (Download, $$DownloadsTableReferences),
      Download,
      PrefetchHooks Function({bool subjectId})
    >;
typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({
      Value<int> id,
      required int studentId,
      required int lessonId,
    });
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({
      Value<int> id,
      Value<int> studentId,
      Value<int> lessonId,
    });

final class $$FavoritesTableReferences
    extends BaseReferences<_$AppDatabase, $FavoritesTable, Favorite> {
  $$FavoritesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('favorites__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias('favorites__lesson_id__lessons__id');

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, $$FavoritesTableReferences),
          Favorite,
          PrefetchHooks Function({bool studentId, bool lessonId})
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> studentId = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
              }) => FavoritesCompanion(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int studentId,
                required int lessonId,
              }) => FavoritesCompanion.insert(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FavoritesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false, lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable: $$FavoritesTableReferences
                                    ._studentIdTable(db),
                                referencedColumn: $$FavoritesTableReferences
                                    ._studentIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable: $$FavoritesTableReferences
                                    ._lessonIdTable(db),
                                referencedColumn: $$FavoritesTableReferences
                                    ._lessonIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, $$FavoritesTableReferences),
      Favorite,
      PrefetchHooks Function({bool studentId, bool lessonId})
    >;
typedef $$AppSettingsRowsTableCreateCompanionBuilder =
    AppSettingsRowsCompanion Function({
      required String settingKey,
      required String settingValue,
      Value<int> rowid,
    });
typedef $$AppSettingsRowsTableUpdateCompanionBuilder =
    AppSettingsRowsCompanion Function({
      Value<String> settingKey,
      Value<String> settingValue,
      Value<int> rowid,
    });

class $$AppSettingsRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );
}

class $$AppSettingsRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsRowsTable,
          AppSettingsRow,
          $$AppSettingsRowsTableFilterComposer,
          $$AppSettingsRowsTableOrderingComposer,
          $$AppSettingsRowsTableAnnotationComposer,
          $$AppSettingsRowsTableCreateCompanionBuilder,
          $$AppSettingsRowsTableUpdateCompanionBuilder,
          (
            AppSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsRowsTable,
              AppSettingsRow
            >,
          ),
          AppSettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsRowsTableTableManager(
    _$AppDatabase db,
    $AppSettingsRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsRowsCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                required String settingValue,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsRowsCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsRowsTable,
      AppSettingsRow,
      $$AppSettingsRowsTableFilterComposer,
      $$AppSettingsRowsTableOrderingComposer,
      $$AppSettingsRowsTableAnnotationComposer,
      $$AppSettingsRowsTableCreateCompanionBuilder,
      $$AppSettingsRowsTableUpdateCompanionBuilder,
      (
        AppSettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsRowsTable, AppSettingsRow>,
      ),
      AppSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$TutorMessagesTableCreateCompanionBuilder =
    TutorMessagesCompanion Function({
      Value<int> id,
      required int studentId,
      required bool fromAi,
      required String content,
      Value<DateTime> createdAt,
    });
typedef $$TutorMessagesTableUpdateCompanionBuilder =
    TutorMessagesCompanion Function({
      Value<int> id,
      Value<int> studentId,
      Value<bool> fromAi,
      Value<String> content,
      Value<DateTime> createdAt,
    });

class $$TutorMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $TutorMessagesTable> {
  $$TutorMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fromAi => $composableBuilder(
    column: $table.fromAi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TutorMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $TutorMessagesTable> {
  $$TutorMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fromAi => $composableBuilder(
    column: $table.fromAi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TutorMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TutorMessagesTable> {
  $$TutorMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<bool> get fromAi =>
      $composableBuilder(column: $table.fromAi, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TutorMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TutorMessagesTable,
          TutorMessage,
          $$TutorMessagesTableFilterComposer,
          $$TutorMessagesTableOrderingComposer,
          $$TutorMessagesTableAnnotationComposer,
          $$TutorMessagesTableCreateCompanionBuilder,
          $$TutorMessagesTableUpdateCompanionBuilder,
          (
            TutorMessage,
            BaseReferences<_$AppDatabase, $TutorMessagesTable, TutorMessage>,
          ),
          TutorMessage,
          PrefetchHooks Function()
        > {
  $$TutorMessagesTableTableManager(_$AppDatabase db, $TutorMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TutorMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TutorMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TutorMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> studentId = const Value.absent(),
                Value<bool> fromAi = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TutorMessagesCompanion(
                id: id,
                studentId: studentId,
                fromAi: fromAi,
                content: content,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int studentId,
                required bool fromAi,
                required String content,
                Value<DateTime> createdAt = const Value.absent(),
              }) => TutorMessagesCompanion.insert(
                id: id,
                studentId: studentId,
                fromAi: fromAi,
                content: content,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TutorMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TutorMessagesTable,
      TutorMessage,
      $$TutorMessagesTableFilterComposer,
      $$TutorMessagesTableOrderingComposer,
      $$TutorMessagesTableAnnotationComposer,
      $$TutorMessagesTableCreateCompanionBuilder,
      $$TutorMessagesTableUpdateCompanionBuilder,
      (
        TutorMessage,
        BaseReferences<_$AppDatabase, $TutorMessagesTable, TutorMessage>,
      ),
      TutorMessage,
      PrefetchHooks Function()
    >;
typedef $$UnderstandingChecksTableCreateCompanionBuilder =
    UnderstandingChecksCompanion Function({
      Value<int> id,
      required int studentId,
      Value<int?> lessonId,
      required bool isCorrect,
      Value<DateTime> createdAt,
    });
typedef $$UnderstandingChecksTableUpdateCompanionBuilder =
    UnderstandingChecksCompanion Function({
      Value<int> id,
      Value<int> studentId,
      Value<int?> lessonId,
      Value<bool> isCorrect,
      Value<DateTime> createdAt,
    });

class $$UnderstandingChecksTableFilterComposer
    extends Composer<_$AppDatabase, $UnderstandingChecksTable> {
  $$UnderstandingChecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnderstandingChecksTableOrderingComposer
    extends Composer<_$AppDatabase, $UnderstandingChecksTable> {
  $$UnderstandingChecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnderstandingChecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnderstandingChecksTable> {
  $$UnderstandingChecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<int> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UnderstandingChecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnderstandingChecksTable,
          UnderstandingCheck,
          $$UnderstandingChecksTableFilterComposer,
          $$UnderstandingChecksTableOrderingComposer,
          $$UnderstandingChecksTableAnnotationComposer,
          $$UnderstandingChecksTableCreateCompanionBuilder,
          $$UnderstandingChecksTableUpdateCompanionBuilder,
          (
            UnderstandingCheck,
            BaseReferences<
              _$AppDatabase,
              $UnderstandingChecksTable,
              UnderstandingCheck
            >,
          ),
          UnderstandingCheck,
          PrefetchHooks Function()
        > {
  $$UnderstandingChecksTableTableManager(
    _$AppDatabase db,
    $UnderstandingChecksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnderstandingChecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnderstandingChecksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UnderstandingChecksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> studentId = const Value.absent(),
                Value<int?> lessonId = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UnderstandingChecksCompanion(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                isCorrect: isCorrect,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int studentId,
                Value<int?> lessonId = const Value.absent(),
                required bool isCorrect,
                Value<DateTime> createdAt = const Value.absent(),
              }) => UnderstandingChecksCompanion.insert(
                id: id,
                studentId: studentId,
                lessonId: lessonId,
                isCorrect: isCorrect,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnderstandingChecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnderstandingChecksTable,
      UnderstandingCheck,
      $$UnderstandingChecksTableFilterComposer,
      $$UnderstandingChecksTableOrderingComposer,
      $$UnderstandingChecksTableAnnotationComposer,
      $$UnderstandingChecksTableCreateCompanionBuilder,
      $$UnderstandingChecksTableUpdateCompanionBuilder,
      (
        UnderstandingCheck,
        BaseReferences<
          _$AppDatabase,
          $UnderstandingChecksTable,
          UnderstandingCheck
        >,
      ),
      UnderstandingCheck,
      PrefetchHooks Function()
    >;
typedef $$InstalledPackagesTableCreateCompanionBuilder =
    InstalledPackagesCompanion Function({
      Value<int> id,
      required String packageId,
      required int grade,
      required String title,
      required String version,
      Value<String> province,
      Value<bool> isDemo,
      Value<int> sizeBytes,
      Value<DateTime> installedAt,
    });
typedef $$InstalledPackagesTableUpdateCompanionBuilder =
    InstalledPackagesCompanion Function({
      Value<int> id,
      Value<String> packageId,
      Value<int> grade,
      Value<String> title,
      Value<String> version,
      Value<String> province,
      Value<bool> isDemo,
      Value<int> sizeBytes,
      Value<DateTime> installedAt,
    });

class $$InstalledPackagesTableFilterComposer
    extends Composer<_$AppDatabase, $InstalledPackagesTable> {
  $$InstalledPackagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get province => $composableBuilder(
    column: $table.province,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstalledPackagesTableOrderingComposer
    extends Composer<_$AppDatabase, $InstalledPackagesTable> {
  $$InstalledPackagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageId => $composableBuilder(
    column: $table.packageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get province => $composableBuilder(
    column: $table.province,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDemo => $composableBuilder(
    column: $table.isDemo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstalledPackagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstalledPackagesTable> {
  $$InstalledPackagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get province =>
      $composableBuilder(column: $table.province, builder: (column) => column);

  GeneratedColumn<bool> get isDemo =>
      $composableBuilder(column: $table.isDemo, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );
}

class $$InstalledPackagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstalledPackagesTable,
          InstalledPackage,
          $$InstalledPackagesTableFilterComposer,
          $$InstalledPackagesTableOrderingComposer,
          $$InstalledPackagesTableAnnotationComposer,
          $$InstalledPackagesTableCreateCompanionBuilder,
          $$InstalledPackagesTableUpdateCompanionBuilder,
          (
            InstalledPackage,
            BaseReferences<
              _$AppDatabase,
              $InstalledPackagesTable,
              InstalledPackage
            >,
          ),
          InstalledPackage,
          PrefetchHooks Function()
        > {
  $$InstalledPackagesTableTableManager(
    _$AppDatabase db,
    $InstalledPackagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstalledPackagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstalledPackagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstalledPackagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packageId = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> province = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
              }) => InstalledPackagesCompanion(
                id: id,
                packageId: packageId,
                grade: grade,
                title: title,
                version: version,
                province: province,
                isDemo: isDemo,
                sizeBytes: sizeBytes,
                installedAt: installedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageId,
                required int grade,
                required String title,
                required String version,
                Value<String> province = const Value.absent(),
                Value<bool> isDemo = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
              }) => InstalledPackagesCompanion.insert(
                id: id,
                packageId: packageId,
                grade: grade,
                title: title,
                version: version,
                province: province,
                isDemo: isDemo,
                sizeBytes: sizeBytes,
                installedAt: installedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstalledPackagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstalledPackagesTable,
      InstalledPackage,
      $$InstalledPackagesTableFilterComposer,
      $$InstalledPackagesTableOrderingComposer,
      $$InstalledPackagesTableAnnotationComposer,
      $$InstalledPackagesTableCreateCompanionBuilder,
      $$InstalledPackagesTableUpdateCompanionBuilder,
      (
        InstalledPackage,
        BaseReferences<
          _$AppDatabase,
          $InstalledPackagesTable,
          InstalledPackage
        >,
      ),
      InstalledPackage,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueRowsTableCreateCompanionBuilder =
    SyncQueueRowsCompanion Function({
      Value<int> id,
      required String kind,
      required String payload,
      Value<String> syncStatus,
      Value<int> attempts,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$SyncQueueRowsTableUpdateCompanionBuilder =
    SyncQueueRowsCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<String> payload,
      Value<String> syncStatus,
      Value<int> attempts,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncedAt,
    });

class $$SyncQueueRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueRowsTable> {
  $$SyncQueueRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueRowsTable> {
  $$SyncQueueRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueRowsTable> {
  $$SyncQueueRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$SyncQueueRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueRowsTable,
          SyncQueueRow,
          $$SyncQueueRowsTableFilterComposer,
          $$SyncQueueRowsTableOrderingComposer,
          $$SyncQueueRowsTableAnnotationComposer,
          $$SyncQueueRowsTableCreateCompanionBuilder,
          $$SyncQueueRowsTableUpdateCompanionBuilder,
          (
            SyncQueueRow,
            BaseReferences<_$AppDatabase, $SyncQueueRowsTable, SyncQueueRow>,
          ),
          SyncQueueRow,
          PrefetchHooks Function()
        > {
  $$SyncQueueRowsTableTableManager(_$AppDatabase db, $SyncQueueRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => SyncQueueRowsCompanion(
                id: id,
                kind: kind,
                payload: payload,
                syncStatus: syncStatus,
                attempts: attempts,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required String payload,
                Value<String> syncStatus = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => SyncQueueRowsCompanion.insert(
                id: id,
                kind: kind,
                payload: payload,
                syncStatus: syncStatus,
                attempts: attempts,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueRowsTable,
      SyncQueueRow,
      $$SyncQueueRowsTableFilterComposer,
      $$SyncQueueRowsTableOrderingComposer,
      $$SyncQueueRowsTableAnnotationComposer,
      $$SyncQueueRowsTableCreateCompanionBuilder,
      $$SyncQueueRowsTableUpdateCompanionBuilder,
      (
        SyncQueueRow,
        BaseReferences<_$AppDatabase, $SyncQueueRowsTable, SyncQueueRow>,
      ),
      SyncQueueRow,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      required int studentId,
      required String code,
      Value<int> points,
      Value<DateTime> unlockedAt,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      Value<int> studentId,
      Value<String> code,
      Value<int> points,
      Value<DateTime> unlockedAt,
    });

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (
            Achievement,
            BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
          ),
          Achievement,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> studentId = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<DateTime> unlockedAt = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                studentId: studentId,
                code: code,
                points: points,
                unlockedAt: unlockedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int studentId,
                required String code,
                Value<int> points = const Value.absent(),
                Value<DateTime> unlockedAt = const Value.absent(),
              }) => AchievementsCompanion.insert(
                id: id,
                studentId: studentId,
                code: code,
                points: points,
                unlockedAt: unlockedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (
        Achievement,
        BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
      ),
      Achievement,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db, _db.quizAttempts);
  $$QuizAnswersTableTableManager get quizAnswers =>
      $$QuizAnswersTableTableManager(_db, _db.quizAnswers);
  $$LessonProgressTableTableManager get lessonProgress =>
      $$LessonProgressTableTableManager(_db, _db.lessonProgress);
  $$DownloadsTableTableManager get downloads =>
      $$DownloadsTableTableManager(_db, _db.downloads);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$AppSettingsRowsTableTableManager get appSettingsRows =>
      $$AppSettingsRowsTableTableManager(_db, _db.appSettingsRows);
  $$TutorMessagesTableTableManager get tutorMessages =>
      $$TutorMessagesTableTableManager(_db, _db.tutorMessages);
  $$UnderstandingChecksTableTableManager get understandingChecks =>
      $$UnderstandingChecksTableTableManager(_db, _db.understandingChecks);
  $$InstalledPackagesTableTableManager get installedPackages =>
      $$InstalledPackagesTableTableManager(_db, _db.installedPackages);
  $$SyncQueueRowsTableTableManager get syncQueueRows =>
      $$SyncQueueRowsTableTableManager(_db, _db.syncQueueRows);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
}
