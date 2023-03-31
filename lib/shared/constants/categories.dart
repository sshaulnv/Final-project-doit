enum Category { ANIMALS, SHOPPING, CLEANING, MEDICAL, DELIVERIES }

Category convertStringToCategory(String categoryString) {
  return Category.values
      .firstWhere((e) => e.toString().split('.')[1] == categoryString);
}
