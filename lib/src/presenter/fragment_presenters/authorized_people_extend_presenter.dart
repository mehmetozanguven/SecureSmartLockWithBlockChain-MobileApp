import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/authorize_person.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:rxdart/rxdart.dart';

class AuthorizedPeopleExtendPresenterImpl extends BasePresenter implements AuthorizedPeopleExtendPresenter{

  final String _log = "AuthorizedPeopleExtendPresenterImpl";
  final AuthorizedPeopleExtendView responsibleView;

  String _deviceCode, _deletedMail;


  Repository _repository;
  CommonPropertySingleton _commonPropertySingleton;

  StreamController<String> _authenticatedUserListStreamController;
  Stream<String> getAuthenticatedUserListSteam() => _authenticatedUserListStreamController.stream;

  StreamController<List<AuthorizePerson>> _authorizePersonStreamController;
  Stream<List<AuthorizePerson>> getAuthorizePersonStream() => _authorizePersonStreamController.stream;

  StreamController<String> _deviceCodeListenerStream;
  StreamSink<String> getDeviceCodeListenerStreamInput() => _deviceCodeListenerStream.sink;

  StreamController<String> _mailListenerStream;
  StreamSink<String> getMailListenerStreamInput() => _mailListenerStream.sink;

  StreamController<bool> _deleteUserListenerStreamContoller;
  StreamSink<bool> getDeleteUserListenerStreamInput() => _deleteUserListenerStreamContoller.sink;


  AuthorizedPeopleExtendPresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();

    createStreamController();

    getPermissionListFromRepository();
  }


  void getPermissionListFromRepository() async{
    bool isInternet = await isInternetConnection();
    if (isInternet){
      String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
      String deviceCode = responsibleView.getDeviceItem().getDeviceCode();
      String response = await _repository.getDevicePermissionUserList(userToken: userToken, deviceCode: deviceCode);
      parseResponse(response);
    }else
      _authenticatedUserListStreamController.sink.add("No_internet");
  }

  void parseResponse(String response) {
    print("$_log permission list response: $response");
    if (response == "[]" || response.isEmpty)
      _authenticatedUserListStreamController.sink.add("empty");
    else{
      JsonCodec jsonCodec = JsonCodec();
      try{
        List<dynamic> dynamicList = jsonCodec.decode(response);
        List<AuthorizePerson> permissionList = List();
        dynamicList.forEach((d) {
          permissionList.add(AuthorizePersonImpl.fromJsonResponse(d));
        });
        _authenticatedUserListStreamController.sink.add("done");
        _authorizePersonStreamController.sink.add(permissionList);
        print("$_log ${permissionList[0]}");
      }catch (e){
        print("$_log, error occured when decoded response : $e");
        _authenticatedUserListStreamController.sink.addError("generalError");
      }
    }
  }


  void deleteListener(bool event) async{
    if (event){
      String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
      String response = await _repository.deletePermission(userToken: userToken, deviceCode: _deviceCode, userMail: _deletedMail);
      print("$_log delete response $response");
      responsibleView.navigateToPreviousPage();
    }
  }

  void createStreamController(){
    _authenticatedUserListStreamController = StreamController<String>.broadcast();

    _authorizePersonStreamController = StreamController<List<AuthorizePerson>>.broadcast();

    _deviceCodeListenerStream = StreamController<String>.broadcast();
    _deviceCodeListenerStream.stream.listen((deviceCode) => _deviceCode = deviceCode);

    _mailListenerStream = StreamController<String>.broadcast();
    _mailListenerStream.stream.listen((deletedMail) => _deletedMail = deletedMail);

    _deleteUserListenerStreamContoller = StreamController<bool>.broadcast();
    _deleteUserListenerStreamContoller.stream.listen(deleteListener);
  }

  void dispose(){
    _authenticatedUserListStreamController.close();

    _authorizePersonStreamController.close();

    _deviceCodeListenerStream.close();

    _mailListenerStream.close();

    _deleteUserListenerStreamContoller.close();
  }
}