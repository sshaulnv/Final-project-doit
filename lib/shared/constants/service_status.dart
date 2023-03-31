enum ServiceStatus { PENDING, IN_PROCESS, COMPLETED }

ServiceStatus convertStringToServiceStatus(String statusString) {
  return ServiceStatus.values
      .firstWhere((e) => e.toString().split('.')[1] == statusString);
}
