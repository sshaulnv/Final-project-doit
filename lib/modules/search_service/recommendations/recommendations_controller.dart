import 'package:get/get.dart';

import '../../../shared/models/service_model.dart';

class RecommendationsController extends GetxController {
  static RecommendationsController get instance => Get.find();

  late List<ServiceModel> serviceList;
  late RxList filteredList;
}
