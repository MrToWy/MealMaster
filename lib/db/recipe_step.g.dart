// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_step.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecipeStepCollection on Isar {
  IsarCollection<RecipeStep> get recipeSteps => this.collection();
}

const RecipeStepSchema = CollectionSchema(
  name: r'RecipeStep',
  id: 4627384835942223803,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'orderPosition': PropertySchema(
      id: 1,
      name: r'orderPosition',
      type: IsarType.long,
    )
  },
  estimateSize: _recipeStepEstimateSize,
  serialize: _recipeStepSerialize,
  deserialize: _recipeStepDeserialize,
  deserializeProp: _recipeStepDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'recipe': LinkSchema(
      id: 1598309638564857676,
      name: r'recipe',
      target: r'Recipe',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _recipeStepGetId,
  getLinks: _recipeStepGetLinks,
  attach: _recipeStepAttach,
  version: '3.1.8',
);

int _recipeStepEstimateSize(
  RecipeStep object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _recipeStepSerialize(
  RecipeStep object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeLong(offsets[1], object.orderPosition);
}

RecipeStep _recipeStepDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecipeStep();
  object.description = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.orderPosition = reader.readLongOrNull(offsets[1]);
  return object;
}

P _recipeStepDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recipeStepGetId(RecipeStep object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recipeStepGetLinks(RecipeStep object) {
  return [object.recipe];
}

void _recipeStepAttach(IsarCollection<dynamic> col, Id id, RecipeStep object) {
  object.id = id;
  object.recipe.attach(col, col.isar.collection<Recipe>(), r'recipe', id);
}

extension RecipeStepQueryWhereSort
    on QueryBuilder<RecipeStep, RecipeStep, QWhere> {
  QueryBuilder<RecipeStep, RecipeStep, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecipeStepQueryWhere
    on QueryBuilder<RecipeStep, RecipeStep, QWhereClause> {
  QueryBuilder<RecipeStep, RecipeStep, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<RecipeStep, RecipeStep, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterWhereClause> idBetween(
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

extension RecipeStepQueryFilter
    on QueryBuilder<RecipeStep, RecipeStep, QFilterCondition> {
  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      orderPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orderPosition',
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      orderPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orderPosition',
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      orderPositionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      orderPositionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      orderPositionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition>
      orderPositionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderPosition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RecipeStepQueryObject
    on QueryBuilder<RecipeStep, RecipeStep, QFilterCondition> {}

extension RecipeStepQueryLinks
    on QueryBuilder<RecipeStep, RecipeStep, QFilterCondition> {
  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition> recipe(
      FilterQuery<Recipe> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'recipe');
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterFilterCondition> recipeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'recipe', 0, true, 0, true);
    });
  }
}

extension RecipeStepQuerySortBy
    on QueryBuilder<RecipeStep, RecipeStep, QSortBy> {
  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> sortByOrderPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderPosition', Sort.asc);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> sortByOrderPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderPosition', Sort.desc);
    });
  }
}

extension RecipeStepQuerySortThenBy
    on QueryBuilder<RecipeStep, RecipeStep, QSortThenBy> {
  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> thenByOrderPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderPosition', Sort.asc);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QAfterSortBy> thenByOrderPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderPosition', Sort.desc);
    });
  }
}

extension RecipeStepQueryWhereDistinct
    on QueryBuilder<RecipeStep, RecipeStep, QDistinct> {
  QueryBuilder<RecipeStep, RecipeStep, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecipeStep, RecipeStep, QDistinct> distinctByOrderPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderPosition');
    });
  }
}

extension RecipeStepQueryProperty
    on QueryBuilder<RecipeStep, RecipeStep, QQueryProperty> {
  QueryBuilder<RecipeStep, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecipeStep, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<RecipeStep, int?, QQueryOperations> orderPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderPosition');
    });
  }
}
