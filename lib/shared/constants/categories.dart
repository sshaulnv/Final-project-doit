enum Categories { ANIMALS, SHOPPING, CLEANING, MEDICAL, DELIVERIES }

Categories convertStringToCategory(String categoryString) {
  return Categories.values
      .firstWhere((e) => e.toString().split('.')[1] == categoryString);
}
