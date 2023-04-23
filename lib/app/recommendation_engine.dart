import 'dart:math';

class Service {
  String name;
  String category;
  int hour;
  int price;

  Service(this.name, this.category, this.hour, this.price);
}

List<Service> generateRandomServices() {
  List<String> categories = [
    'animals',
    'deliveries',
    'medical',
    'studies',
    'general',
    'babysitting',
    'cooking',
    'cleaning'
  ];

  List<Service> services = [];

  Random random = Random();

  for (int i = 0; i < 20; i++) {
    String category = categories[random.nextInt(categories.length)];
    String name = 'service${i + 1}';
    int startHour = random.nextInt(21); // start hour can be between 0-20
    int price = random.nextInt(500) + 1;
    Service service = Service(name, category, startHour, price);
    services.add(service);
  }

  return services;
}

List<MapEntry<String, double>> sortMapByValue(Map<String, double> map, int n) {
  // convert the map to a list of entries, sort in descending order based on the value
  List<MapEntry<String, double>> sortedEntries = map.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  // return the first n entries
  return sortedEntries.take(n).toList();
}

double calculateCosineSimilarity(Map<String, int> vector1,
    Map<String, int> vector2, double categoryWeight, double hourWeight) {
  // calculate the dot product of the two vectors
  double dotProduct = 0.0;
  for (String key in vector1.keys) {
    if (vector2.containsKey(key)) {
      dotProduct += vector1[key]! * vector2[key]!;
    }
  }

  // calculate the magnitude of the two vectors
  double magnitude1 =
      sqrt(vector1.values.map((x) => x * x).reduce((a, b) => a + b));
  double magnitude2 =
      sqrt(vector2.values.map((x) => x * x).reduce((a, b) => a + b));

  // calculate the cosine similarity
  if (magnitude1 == 0 || magnitude2 == 0) {
    return 0.0;
  } else {
    double categorySimilarity = dotProduct / (magnitude1 * magnitude2);
    double hourSimilarity = 0.0;
    if (vector1.containsKey('hour') && vector2.containsKey('hour')) {
      print("@@@@@@@");
      double hourDiff =
          (vector1['hour']! - vector2['hour']!).abs() / Duration.hoursPerDay;
      hourSimilarity = 1 - hourDiff;
    }
    return categoryWeight * categorySimilarity + hourWeight * hourSimilarity;
  }
}

List<Service> recommend(
    Map<String, int> preferences,
    List<Service> services,
    int n,
    int preferredStartHour,
    int preferredEndHour,
    int lowBoundPrice,
    int highBoundPrice) {
  // calculate the similarity between user preferences and each service's categories
  double categoryWeight = 0.75;
  double hourWeight = 0.15;
  double priceWeight = 0.10;
  Map<String, double> serviceScores = {};
  for (Service service in services) {
    Map<String, int> categoryVector = {service.category: 2};
    double categorySimilarity = calculateCosineSimilarity(
        preferences, categoryVector, categoryWeight, hourWeight);

    // calculate hour similarity based on whether the service's hour range overlaps with the preferred hour range
    double hourSimilarity = 0.0;
    if (service.hour <= preferredEndHour &&
        service.hour >= preferredStartHour) {
      hourSimilarity = 1.0;
    }

    double priceSimilarity =
        service.price >= lowBoundPrice && service.price <= highBoundPrice
            ? 1.0
            : 0.0;

    // calculate the total similarity as a weighted sum of the category similarity and the hour similarity
    double totalSimilarity = categorySimilarity * categoryWeight +
        hourSimilarity * hourWeight +
        priceSimilarity * priceWeight;
    serviceScores[service.name] = totalSimilarity;
  }

  // sort the services by their scores and return the top n recommendations
  List<MapEntry<String, double>> sortedEntries =
      sortMapByValue(serviceScores, n);
  return sortedEntries
      .map((entry) =>
          services.firstWhere((service) => service.name == entry.key))
      .toList();
}

void main() {
  Map<String, int> preferences = {
    'animals': 6,
    'deliveries': 4,
    'medical': 2,
    'studies': 8,
    'general': 5,
    'babysitting': 8,
    'cooking': 7,
    'cleaning': 1
  };
  int preferredStartHour = 16;
  int preferredEndHour = 19;
  int preferredLowPrice = 15;
  int preferredHighPrice = 100;

  List<Service> services = generateRandomServices();

  Map<String, int> categoryCounts = {};
  for (Service service in services) {
    if (!categoryCounts.containsKey(service.category)) {
      categoryCounts[service.category] = 0;
    }
    categoryCounts[service.category] = categoryCounts[service.category]! + 1;
  }

  for (String category in categoryCounts.keys) {
    print('$category: ${categoryCounts[category]}');
  }

  List<Service> recommendedServices = recommend(
      preferences,
      services,
      10,
      preferredStartHour,
      preferredEndHour,
      preferredLowPrice,
      preferredHighPrice);
  print('Results\n');
  for (Service service in recommendedServices) {
    print(
        'Service: ${service.name}, Category: ${service.category}, Hours: ${service.hour}, Price: ${service.price}');
  }
}
