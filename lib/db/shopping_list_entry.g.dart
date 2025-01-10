// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetShoppingListEntryCollection on Isar {
  IsarCollection<ShoppingListEntry> get shoppingListEntrys => this.collection();
}

const ShoppingListEntrySchema = CollectionSchema(
  name: r'ShoppingListEntry',
  id: -4102456327754990243,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.double,
    )
  },
  estimateSize: _shoppingListEntryEstimateSize,
  serialize: _shoppingListEntrySerialize,
  deserialize: _shoppingListEntryDeserialize,
  deserializeProp: _shoppingListEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'ingredient': LinkSchema(
      id: -6571234344709621817,
      name: r'ingredient',
      target: r'Ingredient',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _shoppingListEntryGetId,
  getLinks: _shoppingListEntryGetLinks,
  attach: _shoppingListEntryAttach,
  version: '3.1.8',
);

int _shoppingListEntryEstimateSize(
  ShoppingListEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _shoppingListEntrySerialize(
  ShoppingListEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.count);
}

ShoppingListEntry _shoppingListEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ShoppingListEntry();
  object.count = reader.readDoubleOrNull(offsets[0]);
  object.id = id;
  return object;
}

P _shoppingListEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _shoppingListEntryGetId(ShoppingListEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _shoppingListEntryGetLinks(
    ShoppingListEntry object) {
  return [object.ingredient];
}

void _shoppingListEntryAttach(
    IsarCollection<dynamic> col, Id id, ShoppingListEntry object) {
  object.id = id;
  object.ingredient
      .attach(col, col.isar.collection<Ingredient>(), r'ingredient', id);
}

extension ShoppingListEntryQueryWhereSort
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QWhere> {
  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ShoppingListEntryQueryWhere
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QWhereClause> {
  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ShoppingListEntryQueryFilter
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QFilterCondition> {
  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      countIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'count',
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      countIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'count',
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      countEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      countGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      countLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      countBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ShoppingListEntryQueryObject
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QFilterCondition> {}

extension ShoppingListEntryQueryLinks
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QFilterCondition> {
  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      ingredient(FilterQuery<Ingredient> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'ingredient');
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterFilterCondition>
      ingredientIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'ingredient', 0, true, 0, true);
    });
  }
}

extension ShoppingListEntryQuerySortBy
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QSortBy> {
  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterSortBy>
      sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterSortBy>
      sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }
}

extension ShoppingListEntryQuerySortThenBy
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QSortThenBy> {
  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterSortBy>
      thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterSortBy>
      thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ShoppingListEntryQueryWhereDistinct
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QDistinct> {
  QueryBuilder<ShoppingListEntry, ShoppingListEntry, QDistinct>
      distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }
}

extension ShoppingListEntryQueryProperty
    on QueryBuilder<ShoppingListEntry, ShoppingListEntry, QQueryProperty> {
  QueryBuilder<ShoppingListEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ShoppingListEntry, double?, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }
}
