class Endpoints{
  static String _website = "https://securesmartlock.com";
  static Map<String, String> endpointMapValue;

  static createMap(){
    endpointMapValue ={
      "user_token": _website + "/token",
      "new_user_register":_website + "/api/Account/Register",
      "forget_password_w_login_email_verify" : _website + "/api/Account/PasswordReset",
      "forget_password_w_login_email_validate_code" :_website + "/api/Account/VerifyPasswordResetToken",
      "forget_password_w_login_confirm_new_password" : _website + "/api/Account/ConfirmPasswordReset",
      "get_user_info" : _website + "/api/Account/UserInfo",
      "qr_code_content" : _website + "/api/Device/QRCode",
      "user_change_password":_website + "/api/Account/ChangePassword",
      "add_new_device" : _website +  "/api/Device/RegisterDevice",
      "get_devices_list": _website + "/api/Device/RegisteredDevices",
      "resend_activation_code" : _website + "/api/Account/ResendEmailConfirmationToken",
      "activate_email" : _website + "/api/Account/ConfirmEmail",
      "getDevicePermissionUserList": _website + "/api/Device/PermissionList",
      "requestUserPermissionForDevice" : _website + "/api/Device/AddOrUpdatePermission",
      "delete_permission": _website + "/api/Device/DeletePermission"
    };
  }


  static String getEndpoint({String endpoint}){
    createMap();
    return endpointMapValue[endpoint];
  }

}