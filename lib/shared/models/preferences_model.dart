import '../constants/categories.dart';

class PreferencesModel {
  Map<Categories, double> categories;
  int lowerBoundPrice;
  int higherBoundPrice;
  int lowerBoundHour;
  int higherBoundHour;

  PreferencesModel(
      {required this.categories,
      required this.lowerBoundPrice,
      required this.higherBoundPrice,
      required this.lowerBoundHour,
      required this.higherBoundHour});

  Map<String, dynamic> toMap() {
    return {
      "categories": categories,
      "lowerBoundPrice": lowerBoundPrice,
      "higherBoundPrice": higherBoundPrice,
      "lowerBoundHour": lowerBoundHour,
      "higherBoundHour": higherBoundHour,
    };
  }

  factory PreferencesModel.fromMap(Map<String, dynamic> preferencesMap) {
    return PreferencesModel(
      categories: preferencesMap["categories"],
      lowerBoundPrice: preferencesMap["lowerBoundPrice"],
      higherBoundPrice: preferencesMap["higherBoundPrice"],
      lowerBoundHour: preferencesMap["lowerBoundHour"],
      higherBoundHour: preferencesMap["higherBoundHour"],
    );
  }
}
