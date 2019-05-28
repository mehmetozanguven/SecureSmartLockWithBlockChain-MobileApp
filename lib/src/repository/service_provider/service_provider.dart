import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:smart_lock/src/repository/endpoints.dart';


abstract class ServiceProvider{
  Future<String> logIn(String useremail, userpassword);
  Future<String> registerNewUser({String firstName,
    String lastName,
    String email,
    String phoneNum,
    String password,
    String confirmPassword});

  Future<String> emailVerificationForForgetPasswordWithoutLogin({String usermail});

  Future<String> emailConfirmCodeForForgetPasswordWithoutLogin({String usermail, String confirmCode});

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

/// This class is used to connect with backend service
class ServiceProviderImpl implements ServiceProvider{
  Client client = Client();
  String _log = "ServiceProvider";

  Map<String, String> _headerParameters;

  /// Most operation will be used user token and API key as a header parameters
  /// If isUserTokenNeed is overwrite with true => that's means user token
  ///       is needed for this operation
  /// otherwise just api key will be added in the header parameters
  void setPreHeaderParameters({bool isUserTokenNeed = false, String userToken = ""}) {
    _headerParameters = new Map();
    _headerParameters.putIfAbsent("APIKey", () => "SmartLockOzanSafaBuket");
    if (isUserTokenNeed){
      _headerParameters.putIfAbsent("Authorization",() => "Bearer $userToken");
    }
  }

  ///
  Future<String> logIn(String useremail, userpassword) async {
    String url = Endpoints.getEndpoint(endpoint:"user_token");
    print("$_log logIn: post to this url " + url);
    try {
      final postParameters = {
        "grant_type" : "password",
        "username" : useremail,
        "password" : userpassword
      };
      setPreHeaderParameters();
      final response = await client.post(url, headers: _headerParameters, body: postParameters);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "Fail";
      }
    } catch (e) {
      return "No_internet";
    }
  }

  Future<String> registerNewUser({String firstName,
                                  String lastName,
                                  String email,
                                  String phoneNum,
                                  String password,
                                  String confirmPassword}) async
{
  String url = Endpoints.getEndpoint(endpoint: "new_user_register");
  print("$_log logIn: post to this url " + url);

  final postParameters = {
    'FirstName' : firstName,
    'LastName' : lastName,
    'Email' : email,
    'PhoneNumber' : phoneNum,
    'Password' : password,
    'ConfirmPassword' : confirmPassword
  };
  setPreHeaderParameters();
  final response = await client.post(url, headers: _headerParameters, body: postParameters);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return response.body;
  }
}

  @override
  Future<String> emailVerificationForForgetPasswordWithoutLogin({String usermail}) async {
    String url = Endpoints.getEndpoint(endpoint: "forget_password_w_login_email_verify");
    print("$_log : post to this url " + url);
    setPreHeaderParameters();
    final postParameters = {
      "Email" : usermail
    };
    final response = await client.post(url, headers: _headerParameters, body: postParameters);

    return response.body;
  }


  @override
  Future<String> emailConfirmCodeForForgetPasswordWithoutLogin({String usermail, String confirmCode}) async{
    String url = Endpoints.getEndpoint(endpoint: "forget_password_w_login_email_validate_code");
    print("$_log : post to this url " + url);
    setPreHeaderParameters();
    final postParameters = {
      "Email" : usermail,
      "ConfirmationToken" : confirmCode
    };
    final response = await client.post(url, headers: _headerParameters, body: postParameters);

    return response.body;
  }

  @override
  Future<String> confirmNewPasswordForForgetPasswordWithoutLogin(
      {String usermail, String confirmCode, String newPassword, String confirmNewPassword}) async {

    String url = Endpoints.getEndpoint(endpoint: "forget_password_w_login_confirm_new_password");
    print("$_log : post to this url " + url);
    setPreHeaderParameters();

    final postParameters = {
      "Email" : usermail,
      "ConfirmationToken" : confirmCode,
      "NewPassword" : newPassword,
      "ConfirmPassword" : confirmNewPassword
    };

    final response = await client.post(url, headers: _headerParameters, body: postParameters);

    return response.body;
  }

  Future<String> getUserInfo({String userToken})async{
    String url = Endpoints.getEndpoint(endpoint: "get_user_info");
    print("$_log : get to this url " + url);
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final response = await client.get(url, headers: _headerParameters);
    return response.body;
  }

  Future<String> getQrCodeContent({String userToken}) async{
    String url = Endpoints.getEndpoint(endpoint: "qr_code_content");
    print("$_log : get to this url " + url);
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final response = await client.get(url, headers: _headerParameters);
    return response.body;
  }

  Future<String> resetQrCodeContent({String userToken}) async{
    return getQrCodeContent(userToken: userToken);
  }

  @override
  Future<String> changeUserPassword(
      {String userToken, String oldPassword, String newPassword, String confirmNewPassword}) async{
    String url = Endpoints.getEndpoint(endpoint: "user_change_password");
    print("$_log : post to this url " + url);
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final postParameters = {
      "OldPassword": oldPassword,
      "NewPassword": newPassword,
      "ConfirmPassword": confirmNewPassword
    };
    final response = await client.post(
        url, headers: _headerParameters, body: postParameters);

    return response.body;
  }

  @override
  Future<String> addNewDevice({String userToken, String deviceName, String deviceCode}) async{
    String url = Endpoints.getEndpoint(endpoint: "add_new_device");
    print("$_log : post to this url " + url);
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final postParameters = {
      "Name": deviceName,
      "DeviceCode": deviceCode,
    };

    final response = await client.post(
        url, headers: _headerParameters, body: postParameters);

    return response.body;
  }

  @override
  Future<String> getDevicesList({String userToken}) async{
    String url = Endpoints.getEndpoint(endpoint: "get_devices_list");
    print("$_log : get to this url " + url);
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final response = await client.get(url, headers: _headerParameters);

    return response.body;
  }

  @override
  Future<String> activateEmail({String userToken, String validationCode}) async{
    String url = Endpoints.getEndpoint(endpoint: "activate_email");
    print("$_log : post to this url " + url);
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final postParameters = {
      "ConfirmEmailToken": validationCode,
    };

    final response = await client.post(
        url, headers: _headerParameters, body: postParameters);

    return response.body;
  }

  @override
  Future<String> resendEmailActivationCode({String userToken}) async{
    String url = Endpoints.getEndpoint(endpoint: "resend_activation_code");
    print("$_log : get to this url " + url);
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final response = await client.get(url, headers: _headerParameters);

    return response.body;
  }

  @override
  Future<String> getDevicePermissionUserList({String userToken, String deviceCode}) async {
    String url = Endpoints.getEndpoint(endpoint: "getDevicePermissionUserList");
    print("$_log : post to this url " + url);
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final postParameters = {
      "DeviceCode": deviceCode
    };

    final response = await client.post(url, headers: _headerParameters, body: postParameters);

    return response.body;

  }

  @override
  Future<String> requestUserPermissionForDevice({String userToken, String permittedMail, String deviceCode, String expiresOnUTC, String description}) async{
    String url = Endpoints.getEndpoint(endpoint: "requestUserPermissionForDevice");
    print("$_log : post to this url $url");
    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final postParameters = {
      "Email" : permittedMail,
      "DeviceCode" : deviceCode,
      "ExpiresOnUTC" :expiresOnUTC,
      "Description":description
    };

    final response = await client.post(url, headers: _headerParameters, body: postParameters);

    return response.body;
  }

  @override
  Future<String> deletePermission({String userToken, String deviceCode, String userMail}) async{
    String url = Endpoints.getEndpoint(endpoint: "delete_permission");
    print("$_log : delete to this url $url");

    setPreHeaderParameters(isUserTokenNeed: true, userToken: userToken);

    final postParamaters = {
      "Email": userMail,
      "DeviceCode": deviceCode
    };

    final response = await client.post(url, headers: _headerParameters, body: postParamaters);

    return response.body;
  }



}