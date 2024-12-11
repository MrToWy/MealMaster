// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_ingredient.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStorageIngredientCollection on Isar {
  IsarCollection<StorageIngredient> get storageIngredients => this.collection();
}

const StorageIngredientSchema = CollectionSchema(
  name: r'StorageIngredient',
  id: 1733125210204349503,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.double,
    )
  },
  estimateSize: _storageIngredientEstimateSize,
  serialize: _storageIngredientSerialize,
  deserialize: _storageIngredientDeserialize,
  deserializeProp: _storageIngredientDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'ingredient': LinkSchema(
      id: -7804568162400088457,
      name: r'ingredient',
      target: r'Ingredient',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _storageIngredientGetId,
  getLinks: _storageIngredientGetLinks,
  attach: _storageIngredientAttach,
  version: '3.1.8',
);

int _storageIngredientEstimateSize(
  StorageIngredient object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _storageIngredientSerialize(
  StorageIngredient object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.count);
}

StorageIngredient _storageIngredientDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StorageIngredient();
  object.count = reader.readDoubleOrNull(offsets[0]);
  object.id = id;
  return object;
}

P _storageIngredientDeserializeProp<P>(
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

Id _storageIngredientGetId(StorageIngredient object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _storageIngredientGetLinks(
    StorageIngredient object) {
  return [object.ingredient];
}

void _storageIngredientAttach(
    IsarCollection<dynamic> col, Id id, StorageIngredient object) {
  object.id = id;
  object.ingredient
      .attach(col, col.isar.collection<Ingredient>(), r'ingredient', id);
}

extension StorageIngredientQueryWhereSort
    on QueryBuilder<StorageIngredient, StorageIngredient, QWhere> {
  QueryBuilder<StorageIngredient, StorageIngredient, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StorageIngredientQueryWhere
    on QueryBuilder<StorageIngredient, StorageIngredient, QWhereClause> {
  QueryBuilder<StorageIngredient, StorageIngredient, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterWhereClause>
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

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterWhereClause>
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

extension StorageIngredientQueryFilter
    on QueryBuilder<StorageIngredient, StorageIngredient, QFilterCondition> {
  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
      countIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'count',
      ));
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
      countIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'count',
      ));
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
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

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
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

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
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

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
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

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
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

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
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

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
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

extension StorageIngredientQueryObject
    on QueryBuilder<StorageIngredient, StorageIngredient, QFilterCondition> {}

extension StorageIngredientQueryLinks
    on QueryBuilder<StorageIngredient, StorageIngredient, QFilterCondition> {
  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
      ingredient(FilterQuery<Ingredient> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'ingredient');
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterFilterCondition>
      ingredientIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'ingredient', 0, true, 0, true);
    });
  }
}

extension StorageIngredientQuerySortBy
    on QueryBuilder<StorageIngredient, StorageIngredient, QSortBy> {
  QueryBuilder<StorageIngredient, StorageIngredient, QAfterSortBy>
      sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterSortBy>
      sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }
}

extension StorageIngredientQuerySortThenBy
    on QueryBuilder<StorageIngredient, StorageIngredient, QSortThenBy> {
  QueryBuilder<StorageIngredient, StorageIngredient, QAfterSortBy>
      thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterSortBy>
      thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StorageIngredient, StorageIngredient, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension StorageIngredientQueryWhereDistinct
    on QueryBuilder<StorageIngredient, StorageIngredient, QDistinct> {
  QueryBuilder<StorageIngredient, StorageIngredient, QDistinct>
      distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }
}

extension StorageIngredientQueryProperty
    on QueryBuilder<StorageIngredient, StorageIngredient, QQueryProperty> {
  QueryBuilder<StorageIngredient, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StorageIngredient, double?, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }
}
