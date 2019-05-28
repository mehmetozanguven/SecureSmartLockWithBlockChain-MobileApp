import 'package:flutter/material.dart';
import 'package:smart_lock/src/model/devices_list.dart';

abstract class LoginView {
  GlobalKey<FormState> getFormKey();

  setVisibilityOfCircularProgressIndicator(bool visibility);

  loadErrorMessage(String errorMessage);

  loadNewRegisterPage();

  loadUserQrCodePage();
}

abstract class RegisterView {
  List getUserInputResult();

  GlobalKey<FormState> getFormKey();

  setVisibilityOfCircularProgressIndicator(bool visibility);

  loadErrorMessage(String errorMessage);

  void loadSuccessNewRegisterMessage_navigateLoginPage();
}

abstract class ForgetPasswordWithoutLoginView {
  GlobalKey<FormState> getFormKey();

  List getUserInputResult();

  setVisibilityOfCircularProgressIndicator(bool visibility);

  setVisibilityOfUserTextInputs(
      {bool emailTextVisibility,
      bool emailConfirmCodeVisibility,
      bool newPasswordVisiblity});

  loadErrorMessage(String errorMessage);

  loadSuccessMessage_navigateLoginPage();

  loadGeneralError_navigateLoginPage();
}

abstract class UserDrawerMenuView {
  void resetQrCodeContent();

  void simplySetStateToUseInDifferentWidget();

  void exitApp();

  void exitAppWithSpecificDelay();
}

abstract class QrCodeWidgetView {
  setVisibilityOfCircularProgressIndicator(bool visibility);

  resetQrCodeContent();

  loadErrorMessage(String errorMessage);
}

abstract class ChangePasswordWidgetView {
  GlobalKey<FormState> getFormKey();

  setVisibilityOfCircularProgressIndicator(bool visibility);

  loadErrorMessage(String errorMessage);

  loadSuccessMessage(String successMessage);

  List<String> getUserInputs();
}

abstract class DeviceWidgetView {
  GlobalKey<FormState> getFormKey();

  setVisibilityOfCircularProgressIndicator(bool visibility);

  loadErrorMessage(String errorMessage);

  loadSuccessMessage(String successMessage);

  void setDevicesListFuture(Future<String> newDevicesListFuture);

  List<String> getUserInputs();
}

abstract class EmailWidgetView {
  GlobalKey<FormState> getFormKey();

  setVisibilityOfCircularProgressIndicator(bool visibility);

  loadErrorMessage(String errorMessage);

  loadSuccessMessage(String successMessage);

  List<String> getUserInputs();
}

abstract class SettingsWidgetView{

}

abstract class UpdatePeopleWidgetView{

}

abstract class UpdatePeopleExtendWidgetView{
  GlobalKey<FormState> getFormKey();

  Device getDeviceItem();

}

abstract class AuthorizedPeopleView{

}



abstract class AuthorizedPeopleExtendView{
  Device getDeviceItem();

  void navigateToPreviousPage();
}
