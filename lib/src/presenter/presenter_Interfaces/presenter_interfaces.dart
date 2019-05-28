
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_lock/src/model/authorize_person.dart';
import 'package:smart_lock/src/model/devices_list.dart';

abstract class LoginPagePresenter {
  getUserEmail(String usermail);

  getUserPassword(String userpassword);

  loginButtonListener();
}

abstract class NewRegisterPagePresenter {
  newRegisterButtonListener();
}

abstract class ForgetPasswordWithoutRegisterPresenter {
  changePasswordListener();
}

abstract class QrCodeWidgetPresenter {
  resetQrCodeButtonListener();
}

abstract class ChangePasswordPresenter {
  changePasswordButtonListener();
}

abstract class AddNewDevicePresenter {
  addNewDeviceButtonListener();

  Future<String> getDevicesList();

  bool isUserHasDevicesList(data);

  getDevicePermissionUserList({String deviceCode});

  Stream<String> getAddNewDeviceStream();

  void dispose();
}

abstract class EmailPresenter {
  emailActivateButtonListener();

  resendActivationCodeButtonListener();
}

abstract class UpdatePeoplePresenter{

  Future<String> getDevicesList();

  List<Device> getAllDevicesAsList();

  bool decodeResponse(String responseData);

}

abstract class UpdatePeopleExtendPresenter{
  void createStreams();

  StreamSink<bool> getSwitchStreamInput();

  Stream<bool> getSwitchStream();

  StreamSink<DateTime> getDateStreamInput();

  Stream<DateTime> getDateStream();

  StreamSink<TimeOfDay> getTimeOfDayStreamInput();

  Stream<TimeOfDay> getTimeOfDayStream();

  StreamSink<Device> getSendPermissionToRepoStreamInput();

  Stream<Device> getSendPermissionToRepoStream();

  StreamSink<bool> getIsSpecificPermissionStreamInput();

  Stream<bool> getIsSpecificPermissionStream();

  Stream<String> getPermissionResponseStream();

  StreamSink<String> getPermissionResponseStreamInput();

  Stream<String> getSpecificPermissionStream();

  Stream<bool> getProgressIndicatorStream();

  void setPermittedMail(String permittedMail);

  void setDescription(String description);

  void dispose();

}

abstract class AuthorizedPeoplePresenter{
  Future<String> getListOfDevicesFromRepository();

  StreamSink<String> getParseResponseStreamInput();

  StreamSink<String> getListTileStreamInput();

  Stream<String> getListTileStream();

  Stream<List<Device>> getDoorDevicesListStream();

  void dispose();

}

abstract class AuthorizedPeopleExtendPresenter{

  Stream<String> getAuthenticatedUserListSteam();

  Stream<List<AuthorizePerson>> getAuthorizePersonStream();

  StreamSink<String> getDeviceCodeListenerStreamInput();

  StreamSink<String> getMailListenerStreamInput();

  StreamSink<bool> getDeleteUserListenerStreamInput();

  void dispose();

}
