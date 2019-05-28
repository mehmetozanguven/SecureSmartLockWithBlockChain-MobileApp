import 'package:smart_lock/src/repository/service_provider/service_provider.dart';

abstract class Repository{
  Future<String> getUserToken(String username, String userpassword);

  Future<String> registerNewUser({String firstName,
    String lastName,
    String email,
    String phoneNum,
    String password,
    String confirmPassword});

  Future<String> emailVerificationForForgetPasswordWithoutLogin({String usermail});

  Future<String> emailConfirmCodeForForgetPasswordWithoutLogin(
      {String usermail, String confirmCode});

  Future<String> confirmNewPasswordForForgetPasswordWithoutLogin(
      {String usermail, String confirmCode, String newPassword, String confirmNewPassword});

  Future<String> getUserInfo({String userToken});

  Future<String> getQrCodeContent({String userToken});

  Future<String> resetQrCodeContent({String userToken});

  Future<String> changeUserPassword({String userToken, String oldPassword, String newPassword, String confirmNewPassword});

  Future<String> addNewDevice({String userToken, String deviceName, String deviceCode});

  Future<String> getDevicesList({String userToken});

  Future<String> activateEmail({String userToken, String validationCode});

  Future<String> resendEmailActivationCode({String userToken});

  Future<String> getDevicePermissionUserList({String userToken, String deviceCode});

  Future<String> requestUserPermissionForDevice({String userToken, String permittedMail, String deviceCode, String expiresOnUTC, String description});

  Future<String> deletePermission({String userToken, String deviceCode, String userMail});

}

class RepositoryImpl implements Repository{
  final ServiceProvider _serviceProvider = ServiceProviderImpl();

  Future<String> getUserToken(String username, String userpassword) async {
    String result = await _serviceProvider.logIn(username, userpassword);
    return result;
  }

  Future<String> registerNewUser({String firstName,
    String lastName,
    String email,
    String phoneNum,
    String password,
    String confirmPassword}) async
  {
    String result = await _serviceProvider.registerNewUser(firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNum: phoneNum,
        password: password,
        confirmPassword: confirmPassword);
    return result;
  }

  Future<String> emailVerificationForForgetPasswordWithoutLogin(
      {String usermail}) async {
    String result = await _serviceProvider
        .emailVerificationForForgetPasswordWithoutLogin(usermail: usermail);
    return result;
  }

  Future<String> emailConfirmCodeForForgetPasswordWithoutLogin(
      {String usermail, String confirmCode}) async {
    String result = await _serviceProvider
        .emailConfirmCodeForForgetPasswordWithoutLogin(
        usermail: usermail, confirmCode: confirmCode);
    return result;
  }

  Future<String> confirmNewPasswordForForgetPasswordWithoutLogin(
      {String usermail, String confirmCode, String newPassword, String confirmNewPassword}) async {
    String result = await _serviceProvider
        .confirmNewPasswordForForgetPasswordWithoutLogin(usermail: usermail,
        confirmCode: confirmCode,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword);
    return result;
  }

  Future<String> getUserInfo({String userToken}) async{
    String result = await _serviceProvider.getUserInfo(userToken: userToken);
    return result;
  }

  Future<String> getQrCodeContent({String userToken})async{
    String result = await _serviceProvider.getQrCodeContent(userToken: userToken);
    return result;
  }

  @override
  Future<String> resetQrCodeContent({String userToken}) async{
    String result = await _serviceProvider.resetQrCodeContent(userToken: userToken);
    return result;
  }

  @override
  Future<String> changeUserPassword(
      {String userToken, String oldPassword, String newPassword, String confirmNewPassword}) async{
    String result = await _serviceProvider.changeUserPassword(userToken: userToken, oldPassword: oldPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword);
    return result;
  }

  @override
  Future<String> addNewDevice({String userToken, String deviceName, String deviceCode}) async{
    String result = await _serviceProvider.addNewDevice(userToken: userToken,  deviceName: deviceName, deviceCode: deviceCode);
    return result;
  }

  @override
  Future<String> getDevicesList({String userToken}) async{
    String result = await _serviceProvider.getDevicesList(userToken: userToken);
    return result;
  }

  @override
  Future<String> activateEmail({String userToken, String validationCode}) async {
    String result = await _serviceProvider.activateEmail(userToken: userToken, validationCode: validationCode);
    return result;
  }

  @override
  Future<String> resendEmailActivationCode({String userToken}) async {
    String result = await _serviceProvider.resendEmailActivationCode(userToken: userToken);
    return result;
  }

  @override
  Future<String> getDevicePermissionUserList({String userToken, String deviceCode}) async{
    String result = await _serviceProvider.getDevicePermissionUserList(userToken: userToken, deviceCode: deviceCode);
    return result;
  }

  @override
  Future<String> requestUserPermissionForDevice({String userToken, String permittedMail, String deviceCode, String expiresOnUTC, String description}) async{
    String result = await _serviceProvider.requestUserPermissionForDevice(userToken: userToken, permittedMail: permittedMail, deviceCode: deviceCode, expiresOnUTC: expiresOnUTC, description: description);
    return result;
  }

  @override
  Future<String> deletePermission({String userToken, String deviceCode, String userMail}) async{
    String result = await _serviceProvider.deletePermission(userToken: userToken, deviceCode: deviceCode, userMail: userMail);
    return result;
  }
}
