import 'dart:math';

import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/constants/constants.dart';

import '../models/service_model.dart';
import '../models/user_model.dart';

class EmbeddedVector {
  List<double> generalVector;

  EmbeddedVector({required this.generalVector});

  factory EmbeddedVector.fromService(ServiceModel service) {
    List<double> categoryVector = List.filled(Categories.values.length, 0.0);
    List<double> hoursVector = List.filled(24, 0.0);
    List<double> priceVector = List.filled(30, 0.0);
    int categoryIndex = service.category.index;
    categoryVector[categoryIndex] = 1.0;
    int hourIndex = service.hour.hour;
    hoursVector[hourIndex] = 1.0;
    int priceIndex = service.price / (kMaximumPrice / 10) < 30
        ? (service.price / (kMaximumPrice / 10)).floor()
        : 29;
    priceVector[priceIndex] = 1.0;

    List<double> generalVector = categoryVector + hoursVector + priceVector;
    return EmbeddedVector(generalVector: generalVector);
  }

  factory EmbeddedVector.fromUserPreferences(UserModel user) {
    List<double> categoryVector = List.filled(Categories.values.length, 0.0);
    List<double> hoursVector = List.filled(24, 0.0);
    List<double> priceVector = List.filled(30, 0.0);
    for (MapEntry<String, dynamic> categoryPreferences
        in user.categoriesPreferences.entries) {
      int categoryIndex =
          convertStringToCategory(categoryPreferences.key).index;
      double categoryValue = categoryPreferences.value / 100;
      categoryVector[categoryIndex] = categoryValue;
    }
    for (int i = user.preferredHours['start'];
        i <= user.preferredHours['end'];
        i++) {
      hoursVector[i] = 1.0;
    }
    int preferredPriceStartIndex =
        user.preferredPrice['start'] / (kMaximumPrice / 10) < 30
            ? (user.preferredPrice['start'] / (kMaximumPrice / 10)).floor()
            : 29;
    int preferredPriceEndIndex =
        user.preferredPrice['end'] / (kMaximumPrice / 10) < 30
            ? (user.preferredPrice['end'] / (kMaximumPrice / 10)).floor()
            : 29;
    for (int i = preferredPriceStartIndex; i <= preferredPriceEndIndex; i++) {
      priceVector[i] = 1.0;
    }

    List<double> generalVector = categoryVector + hoursVector + priceVector;
    return EmbeddedVector(generalVector: generalVector);
  }

  static List<int> findMostSimilarVectors(EmbeddedVector vector_a,
      List<EmbeddedVector> vectors, int numberOfSimilar) {
    // Calculate the cosine similarity between vector_a and each vector in vectors
    final similarities = <double>[];
    for (final vector in vectors) {
      double dotProduct = 0;
      double normA = 0;
      double normB = 0;
      for (int i = 0; i < vector.generalVector.length; i++) {
        dotProduct += vector.generalVector[i] * vector_a.generalVector[i];
        normA += vector_a.generalVector[i] * vector_a.generalVector[i];
        normB += vector.generalVector[i] * vector.generalVector[i];
      }

      final similarity = dotProduct / (sqrt(normA) * sqrt(normB));

      similarities.add(similarity);
    }

    // Find the indexes of the 'numberOfSimilar' most similar vectors to vector_a
    final sortedIndexes = List<int>.generate(vectors.length, (i) => i)
      ..sort((a, b) => similarities[b].compareTo(similarities[a]));
    numberOfSimilar =
        numberOfSimilar < vectors.length ? numberOfSimilar : vectors.length;
    return sortedIndexes.sublist(0, numberOfSimilar);
  }
}
