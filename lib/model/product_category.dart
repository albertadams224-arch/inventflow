enum ProductCategory {
  fruitsAndVegetables,
  meatAndSeafood,
  dairyAndEggs,
  bakeryAndBread,
  beverages,
  snacksAndConfectionery,
  cannedAndPackagedGoods,
  frozenFoods,
  condimentsAndSauces,
  grainsRiceAndPasta,
  cookingOilsAndFats,
  spicesAndSeasonings,
  personalCare,
  householdAndCleaning,
  babyProducts,
}

extension ProductCategoryLabel on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.fruitsAndVegetables:
        return 'Fruits & Vegetables';
      case ProductCategory.meatAndSeafood:
        return 'Meat & Seafood';
      case ProductCategory.dairyAndEggs:
        return 'Dairy & Eggs';
      case ProductCategory.bakeryAndBread:
        return 'Bakery & Bread';
      case ProductCategory.beverages:
        return 'Beverages';
      case ProductCategory.snacksAndConfectionery:
        return 'Snacks & Confectionery';
      case ProductCategory.cannedAndPackagedGoods:
        return 'Canned & Packaged Goods';
      case ProductCategory.frozenFoods:
        return 'Frozen Foods';
      case ProductCategory.condimentsAndSauces:
        return 'Condiments & Sauces';
      case ProductCategory.grainsRiceAndPasta:
        return 'Grains, Rice & Pasta';
      case ProductCategory.cookingOilsAndFats:
        return 'Cooking Oils & Fats';
      case ProductCategory.spicesAndSeasonings:
        return 'Spices & Seasonings';
      case ProductCategory.personalCare:
        return 'Personal Care';
      case ProductCategory.householdAndCleaning:
        return 'Household & Cleaning';
      case ProductCategory.babyProducts:
        return 'Baby Products';
    }
  }
}
