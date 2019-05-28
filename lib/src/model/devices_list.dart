abstract class Device{
  String getDeviceName();
  String getDeviceCode();
  String getRegisteredTime();
}

/// This class is used to get user's devices list
class DoorDevice implements Device{
  String _deviceName, _deviceCode, _registeredOnUTC;

  /// Constructor: It is used to convert json response from the backend to
  /// proper object's attributes
  DoorDevice.fromJsonResponse(Map<String, dynamic> jsonResponse){
    _deviceName = jsonResponse["Name"];
    _deviceCode = jsonResponse["DeviceCode"];
    _registeredOnUTC = jsonResponse["RegisteredOnUTC"];
  }

  @override
  String toString() {
    return "DevicesListImpl: $_deviceName, $_deviceCode, $_registeredOnUTC";
  }

  @override
  String getDeviceCode() => _deviceCode;

  @override
  String getDeviceName() => _deviceName;

  @override
  String getRegisteredTime() {
    return _registeredOnUTC;
  }


}