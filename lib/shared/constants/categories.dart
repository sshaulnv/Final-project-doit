import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Categories { ANIMALS, SHOPPING, CLEANING, MEDICAL, DELIVERIES }

Categories convertStringToCategory(String categoryString) {
  return Categories.values
      .firstWhere((e) => e.toString().split('.')[1] == categoryString);
}

String convertCategoryToString(Categories category) {
  return category.toString().split('.')[1];
}

Map<Categories, IconData> categoriesIcon = {
  Categories.ANIMALS: Icons.pets,
  Categories.SHOPPING: Icons.shopping_cart,
  Categories.CLEANING: Icons.cleaning_services,
  Categories.MEDICAL: Icons.healing,
  Categories.DELIVERIES: Icons.delivery_dining,
};
