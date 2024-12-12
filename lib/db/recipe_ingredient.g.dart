// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_ingredient.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecipeIngredientCollection on Isar {
  IsarCollection<RecipeIngredient> get recipeIngredients => this.collection();
}

const RecipeIngredientSchema = CollectionSchema(
  name: r'RecipeIngredient',
  id: -7135109042295776315,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.double,
    )
  },
  estimateSize: _recipeIngredientEstimateSize,
  serialize: _recipeIngredientSerialize,
  deserialize: _recipeIngredientDeserialize,
  deserializeProp: _recipeIngredientDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'recipe': LinkSchema(
      id: -4990576110225770811,
      name: r'recipe',
      target: r'Recipe',
      single: true,
    ),
    r'ingredient': LinkSchema(
      id: 3116977082130816210,
      name: r'ingredient',
      target: r'Ingredient',
      single: true,
      linkName: r'recipeIngredients',
    )
  },
  embeddedSchemas: {},
  getId: _recipeIngredientGetId,
  getLinks: _recipeIngredientGetLinks,
  attach: _recipeIngredientAttach,
  version: '3.1.8',
);

int _recipeIngredientEstimateSize(
  RecipeIngredient object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _recipeIngredientSerialize(
  RecipeIngredient object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.count);
}

RecipeIngredient _recipeIngredientDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecipeIngredient();
  object.count = reader.readDoubleOrNull(offsets[0]);
  object.id = id;
  return object;
}

P _recipeIngredientDeserializeProp<P>(
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

Id _recipeIngredientGetId(RecipeIngredient object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recipeIngredientGetLinks(RecipeIngredient object) {
  return [object.recipe, object.ingredient];
}

void _recipeIngredientAttach(
    IsarCollection<dynamic> col, Id id, RecipeIngredient object) {
  object.id = id;
  object.recipe.attach(col, col.isar.collection<Recipe>(), r'recipe', id);
  object.ingredient
      .attach(col, col.isar.collection<Ingredient>(), r'ingredient', id);
}

extension RecipeIngredientQueryWhereSort
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QWhere> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecipeIngredientQueryWhere
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QWhereClause> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause>
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause> idBetween(
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

extension RecipeIngredientQueryFilter
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QFilterCondition> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      countIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'count',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      countIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'count',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
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

extension RecipeIngredientQueryObject
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QFilterCondition> {}

extension RecipeIngredientQueryLinks
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QFilterCondition> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      recipe(FilterQuery<Recipe> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'recipe');
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      recipeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'recipe', 0, true, 0, true);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      ingredient(FilterQuery<Ingredient> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'ingredient');
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      ingredientIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'ingredient', 0, true, 0, true);
    });
  }
}

extension RecipeIngredientQuerySortBy
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QSortBy> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy> sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }
}

extension RecipeIngredientQuerySortThenBy
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QSortThenBy> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy> thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension RecipeIngredientQueryWhereDistinct
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QDistinct> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QDistinct>
      distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }
}

extension RecipeIngredientQueryProperty
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QQueryProperty> {
  QueryBuilder<RecipeIngredient, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecipeIngredient, double?, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }
}
