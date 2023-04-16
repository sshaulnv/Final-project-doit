enum ServiceStatus { PENDING, INPROCESS, COMPLETED }

ServiceStatus convertStringToServiceStatus(String statusString) {
  return ServiceStatus.values
      .firstWhere((e) => e.toString().split('.')[1] == statusString);
}

String convertStatusToString(ServiceStatus status) {
  return status.toString().split('.')[1];
}
