// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMealPlanEntryCollection on Isar {
  IsarCollection<MealPlanEntry> get mealPlanEntrys => this.collection();
}

const MealPlanEntrySchema = CollectionSchema(
  name: r'MealPlanEntry',
  id: 8909763871689159472,
  properties: {
    r'day': PropertySchema(
      id: 0,
      name: r'day',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _mealPlanEntryEstimateSize,
  serialize: _mealPlanEntrySerialize,
  deserialize: _mealPlanEntryDeserialize,
  deserializeProp: _mealPlanEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'mealPlan': LinkSchema(
      id: -8444097583561803931,
      name: r'mealPlan',
      target: r'MealPlan',
      single: true,
    ),
    r'recipe': LinkSchema(
      id: 6926882901754934193,
      name: r'recipe',
      target: r'Recipe',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _mealPlanEntryGetId,
  getLinks: _mealPlanEntryGetLinks,
  attach: _mealPlanEntryAttach,
  version: '3.1.8',
);

int _mealPlanEntryEstimateSize(
  MealPlanEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _mealPlanEntrySerialize(
  MealPlanEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.day);
}

MealPlanEntry _mealPlanEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealPlanEntry();
  object.day = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  return object;
}

P _mealPlanEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mealPlanEntryGetId(MealPlanEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mealPlanEntryGetLinks(MealPlanEntry object) {
  return [object.mealPlan, object.recipe];
}

void _mealPlanEntryAttach(
    IsarCollection<dynamic> col, Id id, MealPlanEntry object) {
  object.id = id;
  object.mealPlan.attach(col, col.isar.collection<MealPlan>(), r'mealPlan', id);
  object.recipe.attach(col, col.isar.collection<Recipe>(), r'recipe', id);
}

extension MealPlanEntryQueryWhereSort
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QWhere> {
  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MealPlanEntryQueryWhere
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QWhereClause> {
  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterWhereClause> idBetween(
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

extension MealPlanEntryQueryFilter
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QFilterCondition> {
  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition>
      dayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'day',
      ));
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition>
      dayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'day',
      ));
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition> dayEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'day',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition>
      dayGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'day',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition> dayLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'day',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition> dayBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'day',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition>
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

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition> idBetween(
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

extension MealPlanEntryQueryObject
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QFilterCondition> {}

extension MealPlanEntryQueryLinks
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QFilterCondition> {
  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition> mealPlan(
      FilterQuery<MealPlan> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'mealPlan');
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition>
      mealPlanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'mealPlan', 0, true, 0, true);
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition> recipe(
      FilterQuery<Recipe> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'recipe');
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterFilterCondition>
      recipeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'recipe', 0, true, 0, true);
    });
  }
}

extension MealPlanEntryQuerySortBy
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QSortBy> {
  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterSortBy> sortByDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'day', Sort.asc);
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterSortBy> sortByDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'day', Sort.desc);
    });
  }
}

extension MealPlanEntryQuerySortThenBy
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QSortThenBy> {
  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterSortBy> thenByDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'day', Sort.asc);
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterSortBy> thenByDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'day', Sort.desc);
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MealPlanEntry, MealPlanEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension MealPlanEntryQueryWhereDistinct
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QDistinct> {
  QueryBuilder<MealPlanEntry, MealPlanEntry, QDistinct> distinctByDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'day');
    });
  }
}

extension MealPlanEntryQueryProperty
    on QueryBuilder<MealPlanEntry, MealPlanEntry, QQueryProperty> {
  QueryBuilder<MealPlanEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MealPlanEntry, DateTime?, QQueryOperations> dayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'day');
    });
  }
}
