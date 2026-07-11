// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StocksTable extends Stocks with TableInfo<$StocksTable, Stock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StocksTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _capitalPriceMeta = const VerificationMeta(
    'capitalPrice',
  );
  @override
  late final GeneratedColumn<double> capitalPrice = GeneratedColumn<double>(
    'capital_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellPriceMeta = const VerificationMeta(
    'sellPrice',
  );
  @override
  late final GeneratedColumn<double> sellPrice = GeneratedColumn<double>(
    'sell_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
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
    name,
    category,
    quantity,
    capitalPrice,
    sellPrice,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Stock> instance, {
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('capital_price')) {
      context.handle(
        _capitalPriceMeta,
        capitalPrice.isAcceptableOrUnknown(
          data['capital_price']!,
          _capitalPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_capitalPriceMeta);
    }
    if (data.containsKey('sell_price')) {
      context.handle(
        _sellPriceMeta,
        sellPrice.isAcceptableOrUnknown(data['sell_price']!, _sellPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_sellPriceMeta);
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
  Stock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      capitalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capital_price'],
      )!,
      sellPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sell_price'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StocksTable createAlias(String alias) {
    return $StocksTable(attachedDatabase, alias);
  }
}

class Stock extends DataClass implements Insertable<Stock> {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final double capitalPrice;
  final double sellPrice;
  final DateTime updatedAt;
  const Stock({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.capitalPrice,
    required this.sellPrice,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['quantity'] = Variable<int>(quantity);
    map['capital_price'] = Variable<double>(capitalPrice);
    map['sell_price'] = Variable<double>(sellPrice);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StocksCompanion toCompanion(bool nullToAbsent) {
    return StocksCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      quantity: Value(quantity),
      capitalPrice: Value(capitalPrice),
      sellPrice: Value(sellPrice),
      updatedAt: Value(updatedAt),
    );
  }

  factory Stock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stock(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      quantity: serializer.fromJson<int>(json['quantity']),
      capitalPrice: serializer.fromJson<double>(json['capitalPrice']),
      sellPrice: serializer.fromJson<double>(json['sellPrice']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'quantity': serializer.toJson<int>(quantity),
      'capitalPrice': serializer.toJson<double>(capitalPrice),
      'sellPrice': serializer.toJson<double>(sellPrice),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Stock copyWith({
    int? id,
    String? name,
    String? category,
    int? quantity,
    double? capitalPrice,
    double? sellPrice,
    DateTime? updatedAt,
  }) => Stock(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    quantity: quantity ?? this.quantity,
    capitalPrice: capitalPrice ?? this.capitalPrice,
    sellPrice: sellPrice ?? this.sellPrice,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Stock copyWithCompanion(StocksCompanion data) {
    return Stock(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      capitalPrice: data.capitalPrice.present
          ? data.capitalPrice.value
          : this.capitalPrice,
      sellPrice: data.sellPrice.present ? data.sellPrice.value : this.sellPrice,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Stock(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('capitalPrice: $capitalPrice, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    quantity,
    capitalPrice,
    sellPrice,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stock &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.capitalPrice == this.capitalPrice &&
          other.sellPrice == this.sellPrice &&
          other.updatedAt == this.updatedAt);
}

class StocksCompanion extends UpdateCompanion<Stock> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> quantity;
  final Value<double> capitalPrice;
  final Value<double> sellPrice;
  final Value<DateTime> updatedAt;
  const StocksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.capitalPrice = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StocksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    this.quantity = const Value.absent(),
    required double capitalPrice,
    required double sellPrice,
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       capitalPrice = Value(capitalPrice),
       sellPrice = Value(sellPrice);
  static Insertable<Stock> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? quantity,
    Expression<double>? capitalPrice,
    Expression<double>? sellPrice,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (capitalPrice != null) 'capital_price': capitalPrice,
      if (sellPrice != null) 'sell_price': sellPrice,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StocksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? quantity,
    Value<double>? capitalPrice,
    Value<double>? sellPrice,
    Value<DateTime>? updatedAt,
  }) {
    return StocksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      capitalPrice: capitalPrice ?? this.capitalPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (capitalPrice.present) {
      map['capital_price'] = Variable<double>(capitalPrice.value);
    }
    if (sellPrice.present) {
      map['sell_price'] = Variable<double>(sellPrice.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StocksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('capitalPrice: $capitalPrice, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _villageMeta = const VerificationMeta(
    'village',
  );
  @override
  late final GeneratedColumn<String> village = GeneratedColumn<String>(
    'village',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressDetailMeta = const VerificationMeta(
    'addressDetail',
  );
  @override
  late final GeneratedColumn<String> addressDetail = GeneratedColumn<String>(
    'address_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneBrandMeta = const VerificationMeta(
    'phoneBrand',
  );
  @override
  late final GeneratedColumn<String> phoneBrand = GeneratedColumn<String>(
    'phone_brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneTypeMeta = const VerificationMeta(
    'phoneType',
  );
  @override
  late final GeneratedColumn<String> phoneType = GeneratedColumn<String>(
    'phone_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issueMeta = const VerificationMeta('issue');
  @override
  late final GeneratedColumn<String> issue = GeneratedColumn<String>(
    'issue',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceFeeMeta = const VerificationMeta(
    'serviceFee',
  );
  @override
  late final GeneratedColumn<double> serviceFee = GeneratedColumn<double>(
    'service_fee',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Menunggu Sparepart'),
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
    customerName,
    village,
    addressDetail,
    phone,
    phoneBrand,
    phoneType,
    issue,
    serviceFee,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<Service> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('village')) {
      context.handle(
        _villageMeta,
        village.isAcceptableOrUnknown(data['village']!, _villageMeta),
      );
    } else if (isInserting) {
      context.missing(_villageMeta);
    }
    if (data.containsKey('address_detail')) {
      context.handle(
        _addressDetailMeta,
        addressDetail.isAcceptableOrUnknown(
          data['address_detail']!,
          _addressDetailMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('phone_brand')) {
      context.handle(
        _phoneBrandMeta,
        phoneBrand.isAcceptableOrUnknown(data['phone_brand']!, _phoneBrandMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneBrandMeta);
    }
    if (data.containsKey('phone_type')) {
      context.handle(
        _phoneTypeMeta,
        phoneType.isAcceptableOrUnknown(data['phone_type']!, _phoneTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneTypeMeta);
    }
    if (data.containsKey('issue')) {
      context.handle(
        _issueMeta,
        issue.isAcceptableOrUnknown(data['issue']!, _issueMeta),
      );
    } else if (isInserting) {
      context.missing(_issueMeta);
    }
    if (data.containsKey('service_fee')) {
      context.handle(
        _serviceFeeMeta,
        serviceFee.isAcceptableOrUnknown(data['service_fee']!, _serviceFeeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      village: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}village'],
      )!,
      addressDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_detail'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      phoneBrand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_brand'],
      )!,
      phoneType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_type'],
      )!,
      issue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}issue'],
      )!,
      serviceFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}service_fee'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class Service extends DataClass implements Insertable<Service> {
  final int id;
  final String customerName;
  final String village;
  final String? addressDetail;
  final String phone;
  final String phoneBrand;
  final String phoneType;
  final String issue;
  final double serviceFee;
  final String status;
  final DateTime createdAt;
  const Service({
    required this.id,
    required this.customerName,
    required this.village,
    this.addressDetail,
    required this.phone,
    required this.phoneBrand,
    required this.phoneType,
    required this.issue,
    required this.serviceFee,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_name'] = Variable<String>(customerName);
    map['village'] = Variable<String>(village);
    if (!nullToAbsent || addressDetail != null) {
      map['address_detail'] = Variable<String>(addressDetail);
    }
    map['phone'] = Variable<String>(phone);
    map['phone_brand'] = Variable<String>(phoneBrand);
    map['phone_type'] = Variable<String>(phoneType);
    map['issue'] = Variable<String>(issue);
    map['service_fee'] = Variable<double>(serviceFee);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      customerName: Value(customerName),
      village: Value(village),
      addressDetail: addressDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(addressDetail),
      phone: Value(phone),
      phoneBrand: Value(phoneBrand),
      phoneType: Value(phoneType),
      issue: Value(issue),
      serviceFee: Value(serviceFee),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Service.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<int>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      village: serializer.fromJson<String>(json['village']),
      addressDetail: serializer.fromJson<String?>(json['addressDetail']),
      phone: serializer.fromJson<String>(json['phone']),
      phoneBrand: serializer.fromJson<String>(json['phoneBrand']),
      phoneType: serializer.fromJson<String>(json['phoneType']),
      issue: serializer.fromJson<String>(json['issue']),
      serviceFee: serializer.fromJson<double>(json['serviceFee']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerName': serializer.toJson<String>(customerName),
      'village': serializer.toJson<String>(village),
      'addressDetail': serializer.toJson<String?>(addressDetail),
      'phone': serializer.toJson<String>(phone),
      'phoneBrand': serializer.toJson<String>(phoneBrand),
      'phoneType': serializer.toJson<String>(phoneType),
      'issue': serializer.toJson<String>(issue),
      'serviceFee': serializer.toJson<double>(serviceFee),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Service copyWith({
    int? id,
    String? customerName,
    String? village,
    Value<String?> addressDetail = const Value.absent(),
    String? phone,
    String? phoneBrand,
    String? phoneType,
    String? issue,
    double? serviceFee,
    String? status,
    DateTime? createdAt,
  }) => Service(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    village: village ?? this.village,
    addressDetail: addressDetail.present
        ? addressDetail.value
        : this.addressDetail,
    phone: phone ?? this.phone,
    phoneBrand: phoneBrand ?? this.phoneBrand,
    phoneType: phoneType ?? this.phoneType,
    issue: issue ?? this.issue,
    serviceFee: serviceFee ?? this.serviceFee,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  Service copyWithCompanion(ServicesCompanion data) {
    return Service(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      village: data.village.present ? data.village.value : this.village,
      addressDetail: data.addressDetail.present
          ? data.addressDetail.value
          : this.addressDetail,
      phone: data.phone.present ? data.phone.value : this.phone,
      phoneBrand: data.phoneBrand.present
          ? data.phoneBrand.value
          : this.phoneBrand,
      phoneType: data.phoneType.present ? data.phoneType.value : this.phoneType,
      issue: data.issue.present ? data.issue.value : this.issue,
      serviceFee: data.serviceFee.present
          ? data.serviceFee.value
          : this.serviceFee,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('village: $village, ')
          ..write('addressDetail: $addressDetail, ')
          ..write('phone: $phone, ')
          ..write('phoneBrand: $phoneBrand, ')
          ..write('phoneType: $phoneType, ')
          ..write('issue: $issue, ')
          ..write('serviceFee: $serviceFee, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerName,
    village,
    addressDetail,
    phone,
    phoneBrand,
    phoneType,
    issue,
    serviceFee,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.village == this.village &&
          other.addressDetail == this.addressDetail &&
          other.phone == this.phone &&
          other.phoneBrand == this.phoneBrand &&
          other.phoneType == this.phoneType &&
          other.issue == this.issue &&
          other.serviceFee == this.serviceFee &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<int> id;
  final Value<String> customerName;
  final Value<String> village;
  final Value<String?> addressDetail;
  final Value<String> phone;
  final Value<String> phoneBrand;
  final Value<String> phoneType;
  final Value<String> issue;
  final Value<double> serviceFee;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.village = const Value.absent(),
    this.addressDetail = const Value.absent(),
    this.phone = const Value.absent(),
    this.phoneBrand = const Value.absent(),
    this.phoneType = const Value.absent(),
    this.issue = const Value.absent(),
    this.serviceFee = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required String customerName,
    required String village,
    this.addressDetail = const Value.absent(),
    required String phone,
    required String phoneBrand,
    required String phoneType,
    required String issue,
    this.serviceFee = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : customerName = Value(customerName),
       village = Value(village),
       phone = Value(phone),
       phoneBrand = Value(phoneBrand),
       phoneType = Value(phoneType),
       issue = Value(issue);
  static Insertable<Service> custom({
    Expression<int>? id,
    Expression<String>? customerName,
    Expression<String>? village,
    Expression<String>? addressDetail,
    Expression<String>? phone,
    Expression<String>? phoneBrand,
    Expression<String>? phoneType,
    Expression<String>? issue,
    Expression<double>? serviceFee,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (village != null) 'village': village,
      if (addressDetail != null) 'address_detail': addressDetail,
      if (phone != null) 'phone': phone,
      if (phoneBrand != null) 'phone_brand': phoneBrand,
      if (phoneType != null) 'phone_type': phoneType,
      if (issue != null) 'issue': issue,
      if (serviceFee != null) 'service_fee': serviceFee,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ServicesCompanion copyWith({
    Value<int>? id,
    Value<String>? customerName,
    Value<String>? village,
    Value<String?>? addressDetail,
    Value<String>? phone,
    Value<String>? phoneBrand,
    Value<String>? phoneType,
    Value<String>? issue,
    Value<double>? serviceFee,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      village: village ?? this.village,
      addressDetail: addressDetail ?? this.addressDetail,
      phone: phone ?? this.phone,
      phoneBrand: phoneBrand ?? this.phoneBrand,
      phoneType: phoneType ?? this.phoneType,
      issue: issue ?? this.issue,
      serviceFee: serviceFee ?? this.serviceFee,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (village.present) {
      map['village'] = Variable<String>(village.value);
    }
    if (addressDetail.present) {
      map['address_detail'] = Variable<String>(addressDetail.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (phoneBrand.present) {
      map['phone_brand'] = Variable<String>(phoneBrand.value);
    }
    if (phoneType.present) {
      map['phone_type'] = Variable<String>(phoneType.value);
    }
    if (issue.present) {
      map['issue'] = Variable<String>(issue.value);
    }
    if (serviceFee.present) {
      map['service_fee'] = Variable<double>(serviceFee.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('village: $village, ')
          ..write('addressDetail: $addressDetail, ')
          ..write('phone: $phone, ')
          ..write('phoneBrand: $phoneBrand, ')
          ..write('phoneType: $phoneType, ')
          ..write('issue: $issue, ')
          ..write('serviceFee: $serviceFee, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ServiceSparepartsTable extends ServiceSpareparts
    with TableInfo<$ServiceSparepartsTable, ServiceSparepart> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceSparepartsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES services (id)',
    ),
  );
  static const VerificationMeta _stockIdMeta = const VerificationMeta(
    'stockId',
  );
  @override
  late final GeneratedColumn<int> stockId = GeneratedColumn<int>(
    'stock_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stocks (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serviceId,
    stockId,
    quantity,
    price,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_spareparts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceSparepart> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('stock_id')) {
      context.handle(
        _stockIdMeta,
        stockId.isAcceptableOrUnknown(data['stock_id']!, _stockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceSparepart map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceSparepart(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_id'],
      )!,
      stockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
    );
  }

  @override
  $ServiceSparepartsTable createAlias(String alias) {
    return $ServiceSparepartsTable(attachedDatabase, alias);
  }
}

class ServiceSparepart extends DataClass
    implements Insertable<ServiceSparepart> {
  final int id;
  final int serviceId;
  final int stockId;
  final int quantity;
  final double price;
  const ServiceSparepart({
    required this.id,
    required this.serviceId,
    required this.stockId,
    required this.quantity,
    required this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['service_id'] = Variable<int>(serviceId);
    map['stock_id'] = Variable<int>(stockId);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    return map;
  }

  ServiceSparepartsCompanion toCompanion(bool nullToAbsent) {
    return ServiceSparepartsCompanion(
      id: Value(id),
      serviceId: Value(serviceId),
      stockId: Value(stockId),
      quantity: Value(quantity),
      price: Value(price),
    );
  }

  factory ServiceSparepart.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceSparepart(
      id: serializer.fromJson<int>(json['id']),
      serviceId: serializer.fromJson<int>(json['serviceId']),
      stockId: serializer.fromJson<int>(json['stockId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serviceId': serializer.toJson<int>(serviceId),
      'stockId': serializer.toJson<int>(stockId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
    };
  }

  ServiceSparepart copyWith({
    int? id,
    int? serviceId,
    int? stockId,
    int? quantity,
    double? price,
  }) => ServiceSparepart(
    id: id ?? this.id,
    serviceId: serviceId ?? this.serviceId,
    stockId: stockId ?? this.stockId,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
  );
  ServiceSparepart copyWithCompanion(ServiceSparepartsCompanion data) {
    return ServiceSparepart(
      id: data.id.present ? data.id.value : this.id,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      stockId: data.stockId.present ? data.stockId.value : this.stockId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceSparepart(')
          ..write('id: $id, ')
          ..write('serviceId: $serviceId, ')
          ..write('stockId: $stockId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serviceId, stockId, quantity, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceSparepart &&
          other.id == this.id &&
          other.serviceId == this.serviceId &&
          other.stockId == this.stockId &&
          other.quantity == this.quantity &&
          other.price == this.price);
}

class ServiceSparepartsCompanion extends UpdateCompanion<ServiceSparepart> {
  final Value<int> id;
  final Value<int> serviceId;
  final Value<int> stockId;
  final Value<int> quantity;
  final Value<double> price;
  const ServiceSparepartsCompanion({
    this.id = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.stockId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
  });
  ServiceSparepartsCompanion.insert({
    this.id = const Value.absent(),
    required int serviceId,
    required int stockId,
    required int quantity,
    required double price,
  }) : serviceId = Value(serviceId),
       stockId = Value(stockId),
       quantity = Value(quantity),
       price = Value(price);
  static Insertable<ServiceSparepart> custom({
    Expression<int>? id,
    Expression<int>? serviceId,
    Expression<int>? stockId,
    Expression<int>? quantity,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceId != null) 'service_id': serviceId,
      if (stockId != null) 'stock_id': stockId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
    });
  }

  ServiceSparepartsCompanion copyWith({
    Value<int>? id,
    Value<int>? serviceId,
    Value<int>? stockId,
    Value<int>? quantity,
    Value<double>? price,
  }) {
    return ServiceSparepartsCompanion(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      stockId: stockId ?? this.stockId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (stockId.present) {
      map['stock_id'] = Variable<int>(stockId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceSparepartsCompanion(')
          ..write('id: $id, ')
          ..write('serviceId: $serviceId, ')
          ..write('stockId: $stockId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentAmountMeta = const VerificationMeta(
    'paymentAmount',
  );
  @override
  late final GeneratedColumn<double> paymentAmount = GeneratedColumn<double>(
    'payment_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeAmountMeta = const VerificationMeta(
    'changeAmount',
  );
  @override
  late final GeneratedColumn<double> changeAmount = GeneratedColumn<double>(
    'change_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleDateMeta = const VerificationMeta(
    'saleDate',
  );
  @override
  late final GeneratedColumn<DateTime> saleDate = GeneratedColumn<DateTime>(
    'sale_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalAmount,
    paymentAmount,
    changeAmount,
    saleDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('payment_amount')) {
      context.handle(
        _paymentAmountMeta,
        paymentAmount.isAcceptableOrUnknown(
          data['payment_amount']!,
          _paymentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentAmountMeta);
    }
    if (data.containsKey('change_amount')) {
      context.handle(
        _changeAmountMeta,
        changeAmount.isAcceptableOrUnknown(
          data['change_amount']!,
          _changeAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_changeAmountMeta);
    }
    if (data.containsKey('sale_date')) {
      context.handle(
        _saleDateMeta,
        saleDate.isAcceptableOrUnknown(data['sale_date']!, _saleDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      paymentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payment_amount'],
      )!,
      changeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}change_amount'],
      )!,
      saleDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sale_date'],
      )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final double totalAmount;
  final double paymentAmount;
  final double changeAmount;
  final DateTime saleDate;
  const Sale({
    required this.id,
    required this.totalAmount,
    required this.paymentAmount,
    required this.changeAmount,
    required this.saleDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_amount'] = Variable<double>(totalAmount);
    map['payment_amount'] = Variable<double>(paymentAmount);
    map['change_amount'] = Variable<double>(changeAmount);
    map['sale_date'] = Variable<DateTime>(saleDate);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      totalAmount: Value(totalAmount),
      paymentAmount: Value(paymentAmount),
      changeAmount: Value(changeAmount),
      saleDate: Value(saleDate),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      paymentAmount: serializer.fromJson<double>(json['paymentAmount']),
      changeAmount: serializer.fromJson<double>(json['changeAmount']),
      saleDate: serializer.fromJson<DateTime>(json['saleDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'paymentAmount': serializer.toJson<double>(paymentAmount),
      'changeAmount': serializer.toJson<double>(changeAmount),
      'saleDate': serializer.toJson<DateTime>(saleDate),
    };
  }

  Sale copyWith({
    int? id,
    double? totalAmount,
    double? paymentAmount,
    double? changeAmount,
    DateTime? saleDate,
  }) => Sale(
    id: id ?? this.id,
    totalAmount: totalAmount ?? this.totalAmount,
    paymentAmount: paymentAmount ?? this.paymentAmount,
    changeAmount: changeAmount ?? this.changeAmount,
    saleDate: saleDate ?? this.saleDate,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      paymentAmount: data.paymentAmount.present
          ? data.paymentAmount.value
          : this.paymentAmount,
      changeAmount: data.changeAmount.present
          ? data.changeAmount.value
          : this.changeAmount,
      saleDate: data.saleDate.present ? data.saleDate.value : this.saleDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('saleDate: $saleDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, totalAmount, paymentAmount, changeAmount, saleDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.totalAmount == this.totalAmount &&
          other.paymentAmount == this.paymentAmount &&
          other.changeAmount == this.changeAmount &&
          other.saleDate == this.saleDate);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<double> totalAmount;
  final Value<double> paymentAmount;
  final Value<double> changeAmount;
  final Value<DateTime> saleDate;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paymentAmount = const Value.absent(),
    this.changeAmount = const Value.absent(),
    this.saleDate = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required double totalAmount,
    required double paymentAmount,
    required double changeAmount,
    this.saleDate = const Value.absent(),
  }) : totalAmount = Value(totalAmount),
       paymentAmount = Value(paymentAmount),
       changeAmount = Value(changeAmount);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<double>? totalAmount,
    Expression<double>? paymentAmount,
    Expression<double>? changeAmount,
    Expression<DateTime>? saleDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paymentAmount != null) 'payment_amount': paymentAmount,
      if (changeAmount != null) 'change_amount': changeAmount,
      if (saleDate != null) 'sale_date': saleDate,
    });
  }

  SalesCompanion copyWith({
    Value<int>? id,
    Value<double>? totalAmount,
    Value<double>? paymentAmount,
    Value<double>? changeAmount,
    Value<DateTime>? saleDate,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      saleDate: saleDate ?? this.saleDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paymentAmount.present) {
      map['payment_amount'] = Variable<double>(paymentAmount.value);
    }
    if (changeAmount.present) {
      map['change_amount'] = Variable<double>(changeAmount.value);
    }
    if (saleDate.present) {
      map['sale_date'] = Variable<DateTime>(saleDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('saleDate: $saleDate')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales (id)',
    ),
  );
  static const VerificationMeta _stockIdMeta = const VerificationMeta(
    'stockId',
  );
  @override
  late final GeneratedColumn<int> stockId = GeneratedColumn<int>(
    'stock_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stocks (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, saleId, stockId, quantity, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('stock_id')) {
      context.handle(
        _stockIdMeta,
        stockId.isAcceptableOrUnknown(data['stock_id']!, _stockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_id'],
      )!,
      stockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final int id;
  final int saleId;
  final int stockId;
  final int quantity;
  final double price;
  const SaleItem({
    required this.id,
    required this.saleId,
    required this.stockId,
    required this.quantity,
    required this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['stock_id'] = Variable<int>(stockId);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      stockId: Value(stockId),
      quantity: Value(quantity),
      price: Value(price),
    );
  }

  factory SaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      stockId: serializer.fromJson<int>(json['stockId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'stockId': serializer.toJson<int>(stockId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
    };
  }

  SaleItem copyWith({
    int? id,
    int? saleId,
    int? stockId,
    int? quantity,
    double? price,
  }) => SaleItem(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    stockId: stockId ?? this.stockId,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
  );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      stockId: data.stockId.present ? data.stockId.value : this.stockId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('stockId: $stockId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, saleId, stockId, quantity, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.stockId == this.stockId &&
          other.quantity == this.quantity &&
          other.price == this.price);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> stockId;
  final Value<int> quantity;
  final Value<double> price;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.stockId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int stockId,
    required int quantity,
    required double price,
  }) : saleId = Value(saleId),
       stockId = Value(stockId),
       quantity = Value(quantity),
       price = Value(price);
  static Insertable<SaleItem> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? stockId,
    Expression<int>? quantity,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (stockId != null) 'stock_id': stockId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
    });
  }

  SaleItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? saleId,
    Value<int>? stockId,
    Value<int>? quantity,
    Value<double>? price,
  }) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      stockId: stockId ?? this.stockId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (stockId.present) {
      map['stock_id'] = Variable<int>(stockId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('stockId: $stockId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Konter Fedora'),
  );
  static const VerificationMeta _storeAddressMeta = const VerificationMeta(
    'storeAddress',
  );
  @override
  late final GeneratedColumn<String> storeAddress = GeneratedColumn<String>(
    'store_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storePhoneMeta = const VerificationMeta(
    'storePhone',
  );
  @override
  late final GeneratedColumn<String> storePhone = GeneratedColumn<String>(
    'store_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeName,
    storeAddress,
    storePhone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    }
    if (data.containsKey('store_address')) {
      context.handle(
        _storeAddressMeta,
        storeAddress.isAcceptableOrUnknown(
          data['store_address']!,
          _storeAddressMeta,
        ),
      );
    }
    if (data.containsKey('store_phone')) {
      context.handle(
        _storePhoneMeta,
        storePhone.isAcceptableOrUnknown(data['store_phone']!, _storePhoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      )!,
      storeAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_address'],
      ),
      storePhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_phone'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String storeName;
  final String? storeAddress;
  final String? storePhone;
  const Setting({
    required this.id,
    required this.storeName,
    this.storeAddress,
    this.storePhone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['store_name'] = Variable<String>(storeName);
    if (!nullToAbsent || storeAddress != null) {
      map['store_address'] = Variable<String>(storeAddress);
    }
    if (!nullToAbsent || storePhone != null) {
      map['store_phone'] = Variable<String>(storePhone);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      storeName: Value(storeName),
      storeAddress: storeAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(storeAddress),
      storePhone: storePhone == null && nullToAbsent
          ? const Value.absent()
          : Value(storePhone),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      storeName: serializer.fromJson<String>(json['storeName']),
      storeAddress: serializer.fromJson<String?>(json['storeAddress']),
      storePhone: serializer.fromJson<String?>(json['storePhone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'storeName': serializer.toJson<String>(storeName),
      'storeAddress': serializer.toJson<String?>(storeAddress),
      'storePhone': serializer.toJson<String?>(storePhone),
    };
  }

  Setting copyWith({
    int? id,
    String? storeName,
    Value<String?> storeAddress = const Value.absent(),
    Value<String?> storePhone = const Value.absent(),
  }) => Setting(
    id: id ?? this.id,
    storeName: storeName ?? this.storeName,
    storeAddress: storeAddress.present ? storeAddress.value : this.storeAddress,
    storePhone: storePhone.present ? storePhone.value : this.storePhone,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      storeAddress: data.storeAddress.present
          ? data.storeAddress.value
          : this.storeAddress,
      storePhone: data.storePhone.present
          ? data.storePhone.value
          : this.storePhone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('storeName: $storeName, ')
          ..write('storeAddress: $storeAddress, ')
          ..write('storePhone: $storePhone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storeName, storeAddress, storePhone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.storeName == this.storeName &&
          other.storeAddress == this.storeAddress &&
          other.storePhone == this.storePhone);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> storeName;
  final Value<String?> storeAddress;
  final Value<String?> storePhone;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.storeName = const Value.absent(),
    this.storeAddress = const Value.absent(),
    this.storePhone = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.storeName = const Value.absent(),
    this.storeAddress = const Value.absent(),
    this.storePhone = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? storeName,
    Expression<String>? storeAddress,
    Expression<String>? storePhone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeName != null) 'store_name': storeName,
      if (storeAddress != null) 'store_address': storeAddress,
      if (storePhone != null) 'store_phone': storePhone,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? storeName,
    Value<String?>? storeAddress,
    Value<String?>? storePhone,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      storePhone: storePhone ?? this.storePhone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (storeAddress.present) {
      map['store_address'] = Variable<String>(storeAddress.value);
    }
    if (storePhone.present) {
      map['store_phone'] = Variable<String>(storePhone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('storeName: $storeName, ')
          ..write('storeAddress: $storeAddress, ')
          ..write('storePhone: $storePhone')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StocksTable stocks = $StocksTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $ServiceSparepartsTable serviceSpareparts =
      $ServiceSparepartsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    stocks,
    services,
    serviceSpareparts,
    sales,
    saleItems,
    settings,
  ];
}

typedef $$StocksTableCreateCompanionBuilder =
    StocksCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      Value<int> quantity,
      required double capitalPrice,
      required double sellPrice,
      Value<DateTime> updatedAt,
    });
typedef $$StocksTableUpdateCompanionBuilder =
    StocksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<int> quantity,
      Value<double> capitalPrice,
      Value<double> sellPrice,
      Value<DateTime> updatedAt,
    });

final class $$StocksTableReferences
    extends BaseReferences<_$AppDatabase, $StocksTable, Stock> {
  $$StocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ServiceSparepartsTable, List<ServiceSparepart>>
  _serviceSparepartsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.serviceSpareparts,
        aliasName: 'stocks__id__service_spareparts__stock_id',
      );

  $$ServiceSparepartsTableProcessedTableManager get serviceSparepartsRefs {
    final manager = $$ServiceSparepartsTableTableManager(
      $_db,
      $_db.serviceSpareparts,
    ).filter((f) => f.stockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _serviceSparepartsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
  _saleItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleItems,
    aliasName: 'stocks__id__sale_items__stock_id',
  );

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager(
      $_db,
      $_db.saleItems,
    ).filter((f) => f.stockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StocksTableFilterComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get capitalPrice => $composableBuilder(
    column: $table.capitalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sellPrice => $composableBuilder(
    column: $table.sellPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> serviceSparepartsRefs(
    Expression<bool> Function($$ServiceSparepartsTableFilterComposer f) f,
  ) {
    final $$ServiceSparepartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceSpareparts,
      getReferencedColumn: (t) => t.stockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceSparepartsTableFilterComposer(
            $db: $db,
            $table: $db.serviceSpareparts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> saleItemsRefs(
    Expression<bool> Function($$SaleItemsTableFilterComposer f) f,
  ) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleItems,
      getReferencedColumn: (t) => t.stockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleItemsTableFilterComposer(
            $db: $db,
            $table: $db.saleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StocksTableOrderingComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get capitalPrice => $composableBuilder(
    column: $table.capitalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sellPrice => $composableBuilder(
    column: $table.sellPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get capitalPrice => $composableBuilder(
    column: $table.capitalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sellPrice =>
      $composableBuilder(column: $table.sellPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> serviceSparepartsRefs<T extends Object>(
    Expression<T> Function($$ServiceSparepartsTableAnnotationComposer a) f,
  ) {
    final $$ServiceSparepartsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.serviceSpareparts,
          getReferencedColumn: (t) => t.stockId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ServiceSparepartsTableAnnotationComposer(
                $db: $db,
                $table: $db.serviceSpareparts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> saleItemsRefs<T extends Object>(
    Expression<T> Function($$SaleItemsTableAnnotationComposer a) f,
  ) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleItems,
      getReferencedColumn: (t) => t.stockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.saleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StocksTable,
          Stock,
          $$StocksTableFilterComposer,
          $$StocksTableOrderingComposer,
          $$StocksTableAnnotationComposer,
          $$StocksTableCreateCompanionBuilder,
          $$StocksTableUpdateCompanionBuilder,
          (Stock, $$StocksTableReferences),
          Stock,
          PrefetchHooks Function({
            bool serviceSparepartsRefs,
            bool saleItemsRefs,
          })
        > {
  $$StocksTableTableManager(_$AppDatabase db, $StocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> capitalPrice = const Value.absent(),
                Value<double> sellPrice = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => StocksCompanion(
                id: id,
                name: name,
                category: category,
                quantity: quantity,
                capitalPrice: capitalPrice,
                sellPrice: sellPrice,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                Value<int> quantity = const Value.absent(),
                required double capitalPrice,
                required double sellPrice,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => StocksCompanion.insert(
                id: id,
                name: name,
                category: category,
                quantity: quantity,
                capitalPrice: capitalPrice,
                sellPrice: sellPrice,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StocksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({serviceSparepartsRefs = false, saleItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serviceSparepartsRefs) db.serviceSpareparts,
                    if (saleItemsRefs) db.saleItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serviceSparepartsRefs)
                        await $_getPrefetchedData<
                          Stock,
                          $StocksTable,
                          ServiceSparepart
                        >(
                          currentTable: table,
                          referencedTable: $$StocksTableReferences
                              ._serviceSparepartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StocksTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceSparepartsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stockId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (saleItemsRefs)
                        await $_getPrefetchedData<
                          Stock,
                          $StocksTable,
                          SaleItem
                        >(
                          currentTable: table,
                          referencedTable: $$StocksTableReferences
                              ._saleItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StocksTableReferences(
                                db,
                                table,
                                p0,
                              ).saleItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stockId == item.id,
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

typedef $$StocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StocksTable,
      Stock,
      $$StocksTableFilterComposer,
      $$StocksTableOrderingComposer,
      $$StocksTableAnnotationComposer,
      $$StocksTableCreateCompanionBuilder,
      $$StocksTableUpdateCompanionBuilder,
      (Stock, $$StocksTableReferences),
      Stock,
      PrefetchHooks Function({bool serviceSparepartsRefs, bool saleItemsRefs})
    >;
typedef $$ServicesTableCreateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      required String customerName,
      required String village,
      Value<String?> addressDetail,
      required String phone,
      required String phoneBrand,
      required String phoneType,
      required String issue,
      Value<double> serviceFee,
      Value<String> status,
      Value<DateTime> createdAt,
    });
typedef $$ServicesTableUpdateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      Value<String> customerName,
      Value<String> village,
      Value<String?> addressDetail,
      Value<String> phone,
      Value<String> phoneBrand,
      Value<String> phoneType,
      Value<String> issue,
      Value<double> serviceFee,
      Value<String> status,
      Value<DateTime> createdAt,
    });

final class $$ServicesTableReferences
    extends BaseReferences<_$AppDatabase, $ServicesTable, Service> {
  $$ServicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ServiceSparepartsTable, List<ServiceSparepart>>
  _serviceSparepartsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.serviceSpareparts,
        aliasName: 'services__id__service_spareparts__service_id',
      );

  $$ServiceSparepartsTableProcessedTableManager get serviceSparepartsRefs {
    final manager = $$ServiceSparepartsTableTableManager(
      $_db,
      $_db.serviceSpareparts,
    ).filter((f) => f.serviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _serviceSparepartsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
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

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressDetail => $composableBuilder(
    column: $table.addressDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneBrand => $composableBuilder(
    column: $table.phoneBrand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneType => $composableBuilder(
    column: $table.phoneType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get issue => $composableBuilder(
    column: $table.issue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get serviceFee => $composableBuilder(
    column: $table.serviceFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> serviceSparepartsRefs(
    Expression<bool> Function($$ServiceSparepartsTableFilterComposer f) f,
  ) {
    final $$ServiceSparepartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceSpareparts,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceSparepartsTableFilterComposer(
            $db: $db,
            $table: $db.serviceSpareparts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
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

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get village => $composableBuilder(
    column: $table.village,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressDetail => $composableBuilder(
    column: $table.addressDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneBrand => $composableBuilder(
    column: $table.phoneBrand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneType => $composableBuilder(
    column: $table.phoneType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get issue => $composableBuilder(
    column: $table.issue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get serviceFee => $composableBuilder(
    column: $table.serviceFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get village =>
      $composableBuilder(column: $table.village, builder: (column) => column);

  GeneratedColumn<String> get addressDetail => $composableBuilder(
    column: $table.addressDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get phoneBrand => $composableBuilder(
    column: $table.phoneBrand,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneType =>
      $composableBuilder(column: $table.phoneType, builder: (column) => column);

  GeneratedColumn<String> get issue =>
      $composableBuilder(column: $table.issue, builder: (column) => column);

  GeneratedColumn<double> get serviceFee => $composableBuilder(
    column: $table.serviceFee,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> serviceSparepartsRefs<T extends Object>(
    Expression<T> Function($$ServiceSparepartsTableAnnotationComposer a) f,
  ) {
    final $$ServiceSparepartsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.serviceSpareparts,
          getReferencedColumn: (t) => t.serviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ServiceSparepartsTableAnnotationComposer(
                $db: $db,
                $table: $db.serviceSpareparts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicesTable,
          Service,
          $$ServicesTableFilterComposer,
          $$ServicesTableOrderingComposer,
          $$ServicesTableAnnotationComposer,
          $$ServicesTableCreateCompanionBuilder,
          $$ServicesTableUpdateCompanionBuilder,
          (Service, $$ServicesTableReferences),
          Service,
          PrefetchHooks Function({bool serviceSparepartsRefs})
        > {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String> village = const Value.absent(),
                Value<String?> addressDetail = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> phoneBrand = const Value.absent(),
                Value<String> phoneType = const Value.absent(),
                Value<String> issue = const Value.absent(),
                Value<double> serviceFee = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                customerName: customerName,
                village: village,
                addressDetail: addressDetail,
                phone: phone,
                phoneBrand: phoneBrand,
                phoneType: phoneType,
                issue: issue,
                serviceFee: serviceFee,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String customerName,
                required String village,
                Value<String?> addressDetail = const Value.absent(),
                required String phone,
                required String phoneBrand,
                required String phoneType,
                required String issue,
                Value<double> serviceFee = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServicesCompanion.insert(
                id: id,
                customerName: customerName,
                village: village,
                addressDetail: addressDetail,
                phone: phone,
                phoneBrand: phoneBrand,
                phoneType: phoneType,
                issue: issue,
                serviceFee: serviceFee,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({serviceSparepartsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (serviceSparepartsRefs) db.serviceSpareparts,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serviceSparepartsRefs)
                    await $_getPrefetchedData<
                      Service,
                      $ServicesTable,
                      ServiceSparepart
                    >(
                      currentTable: table,
                      referencedTable: $$ServicesTableReferences
                          ._serviceSparepartsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ServicesTableReferences(
                        db,
                        table,
                        p0,
                      ).serviceSparepartsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.serviceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicesTable,
      Service,
      $$ServicesTableFilterComposer,
      $$ServicesTableOrderingComposer,
      $$ServicesTableAnnotationComposer,
      $$ServicesTableCreateCompanionBuilder,
      $$ServicesTableUpdateCompanionBuilder,
      (Service, $$ServicesTableReferences),
      Service,
      PrefetchHooks Function({bool serviceSparepartsRefs})
    >;
typedef $$ServiceSparepartsTableCreateCompanionBuilder =
    ServiceSparepartsCompanion Function({
      Value<int> id,
      required int serviceId,
      required int stockId,
      required int quantity,
      required double price,
    });
typedef $$ServiceSparepartsTableUpdateCompanionBuilder =
    ServiceSparepartsCompanion Function({
      Value<int> id,
      Value<int> serviceId,
      Value<int> stockId,
      Value<int> quantity,
      Value<double> price,
    });

final class $$ServiceSparepartsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ServiceSparepartsTable,
          ServiceSparepart
        > {
  $$ServiceSparepartsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ServicesTable _serviceIdTable(_$AppDatabase db) =>
      db.services.createAlias('service_spareparts__service_id__services__id');

  $$ServicesTableProcessedTableManager get serviceId {
    final $_column = $_itemColumn<int>('service_id')!;

    final manager = $$ServicesTableTableManager(
      $_db,
      $_db.services,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StocksTable _stockIdTable(_$AppDatabase db) =>
      db.stocks.createAlias('service_spareparts__stock_id__stocks__id');

  $$StocksTableProcessedTableManager get stockId {
    final $_column = $_itemColumn<int>('stock_id')!;

    final manager = $$StocksTableTableManager(
      $_db,
      $_db.stocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ServiceSparepartsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceSparepartsTable> {
  $$ServiceSparepartsTableFilterComposer({
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

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  $$ServicesTableFilterComposer get serviceId {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableFilterComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StocksTableFilterComposer get stockId {
    final $$StocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableFilterComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServiceSparepartsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceSparepartsTable> {
  $$ServiceSparepartsTableOrderingComposer({
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

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServicesTableOrderingComposer get serviceId {
    final $$ServicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableOrderingComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StocksTableOrderingComposer get stockId {
    final $$StocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableOrderingComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServiceSparepartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceSparepartsTable> {
  $$ServiceSparepartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  $$ServicesTableAnnotationComposer get serviceId {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StocksTableAnnotationComposer get stockId {
    final $$StocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableAnnotationComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServiceSparepartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceSparepartsTable,
          ServiceSparepart,
          $$ServiceSparepartsTableFilterComposer,
          $$ServiceSparepartsTableOrderingComposer,
          $$ServiceSparepartsTableAnnotationComposer,
          $$ServiceSparepartsTableCreateCompanionBuilder,
          $$ServiceSparepartsTableUpdateCompanionBuilder,
          (ServiceSparepart, $$ServiceSparepartsTableReferences),
          ServiceSparepart,
          PrefetchHooks Function({bool serviceId, bool stockId})
        > {
  $$ServiceSparepartsTableTableManager(
    _$AppDatabase db,
    $ServiceSparepartsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceSparepartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceSparepartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceSparepartsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> serviceId = const Value.absent(),
                Value<int> stockId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
              }) => ServiceSparepartsCompanion(
                id: id,
                serviceId: serviceId,
                stockId: stockId,
                quantity: quantity,
                price: price,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int serviceId,
                required int stockId,
                required int quantity,
                required double price,
              }) => ServiceSparepartsCompanion.insert(
                id: id,
                serviceId: serviceId,
                stockId: stockId,
                quantity: quantity,
                price: price,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceSparepartsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({serviceId = false, stockId = false}) {
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
                    if (serviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.serviceId,
                                referencedTable:
                                    $$ServiceSparepartsTableReferences
                                        ._serviceIdTable(db),
                                referencedColumn:
                                    $$ServiceSparepartsTableReferences
                                        ._serviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (stockId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.stockId,
                                referencedTable:
                                    $$ServiceSparepartsTableReferences
                                        ._stockIdTable(db),
                                referencedColumn:
                                    $$ServiceSparepartsTableReferences
                                        ._stockIdTable(db)
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

typedef $$ServiceSparepartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceSparepartsTable,
      ServiceSparepart,
      $$ServiceSparepartsTableFilterComposer,
      $$ServiceSparepartsTableOrderingComposer,
      $$ServiceSparepartsTableAnnotationComposer,
      $$ServiceSparepartsTableCreateCompanionBuilder,
      $$ServiceSparepartsTableUpdateCompanionBuilder,
      (ServiceSparepart, $$ServiceSparepartsTableReferences),
      ServiceSparepart,
      PrefetchHooks Function({bool serviceId, bool stockId})
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      required double totalAmount,
      required double paymentAmount,
      required double changeAmount,
      Value<DateTime> saleDate,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      Value<double> totalAmount,
      Value<double> paymentAmount,
      Value<double> changeAmount,
      Value<DateTime> saleDate,
    });

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
  _saleItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleItems,
    aliasName: 'sales__id__sale_items__sale_id',
  );

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager(
      $_db,
      $_db.saleItems,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
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

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> saleItemsRefs(
    Expression<bool> Function($$SaleItemsTableFilterComposer f) f,
  ) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleItems,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleItemsTableFilterComposer(
            $db: $db,
            $table: $db.saleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
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

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get changeAmount => $composableBuilder(
    column: $table.changeAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get saleDate =>
      $composableBuilder(column: $table.saleDate, builder: (column) => column);

  Expression<T> saleItemsRefs<T extends Object>(
    Expression<T> Function($$SaleItemsTableAnnotationComposer a) f,
  ) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleItems,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.saleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, $$SalesTableReferences),
          Sale,
          PrefetchHooks Function({bool saleItemsRefs})
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> paymentAmount = const Value.absent(),
                Value<double> changeAmount = const Value.absent(),
                Value<DateTime> saleDate = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                totalAmount: totalAmount,
                paymentAmount: paymentAmount,
                changeAmount: changeAmount,
                saleDate: saleDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double totalAmount,
                required double paymentAmount,
                required double changeAmount,
                Value<DateTime> saleDate = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                totalAmount: totalAmount,
                paymentAmount: paymentAmount,
                changeAmount: changeAmount,
                saleDate: saleDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SalesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({saleItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (saleItemsRefs) db.saleItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleItemsRefs)
                    await $_getPrefetchedData<Sale, $SalesTable, SaleItem>(
                      currentTable: table,
                      referencedTable: $$SalesTableReferences
                          ._saleItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SalesTableReferences(db, table, p0).saleItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.saleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, $$SalesTableReferences),
      Sale,
      PrefetchHooks Function({bool saleItemsRefs})
    >;
typedef $$SaleItemsTableCreateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<int> id,
      required int saleId,
      required int stockId,
      required int quantity,
      required double price,
    });
typedef $$SaleItemsTableUpdateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<int> id,
      Value<int> saleId,
      Value<int> stockId,
      Value<int> quantity,
      Value<double> price,
    });

final class $$SaleItemsTableReferences
    extends BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem> {
  $$SaleItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) =>
      db.sales.createAlias('sale_items__sale_id__sales__id');

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<int>('sale_id')!;

    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StocksTable _stockIdTable(_$AppDatabase db) =>
      db.stocks.createAlias('sale_items__stock_id__stocks__id');

  $$StocksTableProcessedTableManager get stockId {
    final $_column = $_itemColumn<int>('stock_id')!;

    final manager = $$StocksTableTableManager(
      $_db,
      $_db.stocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
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

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StocksTableFilterComposer get stockId {
    final $$StocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableFilterComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
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

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableOrderingComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StocksTableOrderingComposer get stockId {
    final $$StocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableOrderingComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StocksTableAnnotationComposer get stockId {
    final $$StocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableAnnotationComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleItemsTable,
          SaleItem,
          $$SaleItemsTableFilterComposer,
          $$SaleItemsTableOrderingComposer,
          $$SaleItemsTableAnnotationComposer,
          $$SaleItemsTableCreateCompanionBuilder,
          $$SaleItemsTableUpdateCompanionBuilder,
          (SaleItem, $$SaleItemsTableReferences),
          SaleItem,
          PrefetchHooks Function({bool saleId, bool stockId})
        > {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> saleId = const Value.absent(),
                Value<int> stockId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
              }) => SaleItemsCompanion(
                id: id,
                saleId: saleId,
                stockId: stockId,
                quantity: quantity,
                price: price,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int saleId,
                required int stockId,
                required int quantity,
                required double price,
              }) => SaleItemsCompanion.insert(
                id: id,
                saleId: saleId,
                stockId: stockId,
                quantity: quantity,
                price: price,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SaleItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleId = false, stockId = false}) {
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
                    if (saleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.saleId,
                                referencedTable: $$SaleItemsTableReferences
                                    ._saleIdTable(db),
                                referencedColumn: $$SaleItemsTableReferences
                                    ._saleIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (stockId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.stockId,
                                referencedTable: $$SaleItemsTableReferences
                                    ._stockIdTable(db),
                                referencedColumn: $$SaleItemsTableReferences
                                    ._stockIdTable(db)
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

typedef $$SaleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleItemsTable,
      SaleItem,
      $$SaleItemsTableFilterComposer,
      $$SaleItemsTableOrderingComposer,
      $$SaleItemsTableAnnotationComposer,
      $$SaleItemsTableCreateCompanionBuilder,
      $$SaleItemsTableUpdateCompanionBuilder,
      (SaleItem, $$SaleItemsTableReferences),
      SaleItem,
      PrefetchHooks Function({bool saleId, bool stockId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String> storeName,
      Value<String?> storeAddress,
      Value<String?> storePhone,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String> storeName,
      Value<String?> storeAddress,
      Value<String?> storePhone,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
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

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeAddress => $composableBuilder(
    column: $table.storeAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storePhone => $composableBuilder(
    column: $table.storePhone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
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

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeAddress => $composableBuilder(
    column: $table.storeAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storePhone => $composableBuilder(
    column: $table.storePhone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get storeAddress => $composableBuilder(
    column: $table.storeAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storePhone => $composableBuilder(
    column: $table.storePhone,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> storeName = const Value.absent(),
                Value<String?> storeAddress = const Value.absent(),
                Value<String?> storePhone = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                storeName: storeName,
                storeAddress: storeAddress,
                storePhone: storePhone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> storeName = const Value.absent(),
                Value<String?> storeAddress = const Value.absent(),
                Value<String?> storePhone = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                storeName: storeName,
                storeAddress: storeAddress,
                storePhone: storePhone,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StocksTableTableManager get stocks =>
      $$StocksTableTableManager(_db, _db.stocks);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$ServiceSparepartsTableTableManager get serviceSpareparts =>
      $$ServiceSparepartsTableTableManager(_db, _db.serviceSpareparts);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
