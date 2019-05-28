import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:rxdart/rxdart.dart';

class UpdatePeopleExtendPresenterImpl extends BasePresenter implements UpdatePeopleExtendPresenter{

  final String _log = "UpdatePeopleExtendPresenterImpl";
  final UpdatePeopleExtendWidgetView responsibleView;

  String _permittedMail, _description;
  bool _isSpecificTimePermission = false;
  DateTime _userPickedDate;
  TimeOfDay _userPickedDay;

  Repository _repository;
  CommonPropertySingleton _commonPropertySingleton;

  StreamController<bool> _switchStreamController;
  StreamSink<bool> getSwitchStreamInput() => _switchStreamController.sink;
  Stream<bool> getSwitchStream() => _switchStreamController.stream;

  StreamController<DateTime> _dateStreamController;
  StreamSink<DateTime> getDateStreamInput() => _dateStreamController.sink;
  Stream<DateTime> getDateStream() =>_dateStreamController.stream;

  StreamController<TimeOfDay> _timeOfDayStreamController;
  StreamSink<TimeOfDay> getTimeOfDayStreamInput() => _timeOfDayStreamController.sink;
  Stream<TimeOfDay> getTimeOfDayStream() => _timeOfDayStreamController.stream;

  StreamController<Device> _sendPermissionToRepoStreamController;
  StreamSink<Device> getSendPermissionToRepoStreamInput() => _sendPermissionToRepoStreamController.sink;
  Stream<Device> getSendPermissionToRepoStream() => _sendPermissionToRepoStreamController.stream;

  StreamController<bool> _isSpecificPermissionStreamController;
  StreamSink<bool> getIsSpecificPermissionStreamInput() => _isSpecificPermissionStreamController.sink;
  Stream<bool> getIsSpecificPermissionStream() => _isSpecificPermissionStreamController.stream;

  StreamController<String> _getPermissionResponseStreamController;
  Stream<String> getPermissionResponseStream() => _getPermissionResponseStreamController.stream;
  StreamSink<String> getPermissionResponseStreamInput() => _getPermissionResponseStreamController.sink;

  StreamController<String> _specificTimePermissionUserStreamController;
  Stream<String> getSpecificPermissionStream() => _specificTimePermissionUserStreamController.stream;
  StreamSink<String> getSpecificPermissionStreamInput() => _specificTimePermissionUserStreamController.sink;

  StreamController<bool> _progressIndicatorStreamController;
  Stream<bool> getProgressIndicatorStream() => _progressIndicatorStreamController.stream;

  UpdatePeopleExtendPresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();
    createStreams();
  }

  void createStreams(){
    _switchStreamController = StreamController<bool>.broadcast();

    _dateStreamController = BehaviorSubject<DateTime>();
    _dateStreamController.stream.listen((event) => _userPickedDate = event);

    _timeOfDayStreamController = BehaviorSubject<TimeOfDay>();
    _timeOfDayStreamController.stream.listen((event) => _userPickedDay = event);

    _sendPermissionToRepoStreamController = StreamController<Device>.broadcast();
    _sendPermissionToRepoStreamController.stream.listen(permissionListener);

    _getPermissionResponseStreamController = StreamController<String>.broadcast();

    _progressIndicatorStreamController = StreamController<bool>.broadcast();

    _isSpecificPermissionStreamController = StreamController<bool>.broadcast();
    _isSpecificPermissionStreamController.stream.listen((event) => _isSpecificTimePermission = event);

    _specificTimePermissionUserStreamController = StreamController<String>.broadcast();

  }

  void setPermittedMail(String permittedMail) => _permittedMail = permittedMail;

  void setDescription(String description) => _description = description;

  void dispose(){
    _switchStreamController.close();
    _dateStreamController.close();
    _timeOfDayStreamController.close();
    _sendPermissionToRepoStreamController.close();
    _getPermissionResponseStreamController.close();
    _progressIndicatorStreamController.close();
    _isSpecificPermissionStreamController.close();
    _specificTimePermissionUserStreamController.close();
  }

  void permissionListener(Device event) async{
    print("$_log 1) infinitePermissionButton");
    bool isInternet = await isInternetConnection();
    if (isInternet){
      validateInputForm();
    }else {
      _getPermissionResponseStreamController.sink.addError("No_internet");
    }
  }

  void validateInputForm() {
    print("$_log 2) validateInputForm");
    final form = responsibleView.getFormKey().currentState;
    if (form.validate()){
      form.save();
      requestInfiniteUserPermissionForDevice();
    }
  }


  void requestInfiniteUserPermissionForDevice() async{
    _progressIndicatorStreamController.sink.add(true);

    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    String deviceCode = responsibleView.getDeviceItem().getDeviceCode();
    String response = await _repository.requestUserPermissionForDevice(
        userToken: userToken,
        permittedMail: _permittedMail,
        expiresOnUTC: _isSpecificTimePermission ? getTimeOnUTC():"",
        description: _description,
        deviceCode: deviceCode);
    print("$_log requestUser response: $response");

    if (response.isEmpty){
      _getPermissionResponseStreamController.sink.add("access_granted");
    }else{
      decodeResponse(response);
    }
    _progressIndicatorStreamController.sink.add(false);

  }

  decodeResponse(String response) {
    print("$_log response : $response");
    Map<String,dynamic> resultMap = jsonDecode(response);
    if (resultMap.containsKey("ModelState")){
      Map<String, dynamic> errorMap = resultMap["ModelState"];
      getErrorFromModelState(errorMap);
    }else
      _getPermissionResponseStreamController.sink.addError("generalError");
  }

  void getErrorFromModelState(Map<String, dynamic> errorMap) {
    if (errorMap.containsKey("model.ExpiresOnUTC"))
      _getPermissionResponseStreamController.sink.addError("invalid_expiresDate");
    else if (errorMap.containsKey("model.Email"))
      _getPermissionResponseStreamController.sink.addError("validateEmail");
    else if (errorMap.containsKey("Email"))
      _getPermissionResponseStreamController.sink.addError("invalid_permitted_user");
    else
      _getPermissionResponseStreamController.sink.addError("generalError");

  }

  String getTimeOnUTC() {
    if (_userPickedDay == null || _userPickedDate == null){
      return "error";
    }else{
      Duration duration = Duration(hours: _userPickedDay.hour, minutes: _userPickedDay.minute);
      DateTime userPickedUTC = _userPickedDate.add(duration).toUtc();

      return userPickedUTC.toString();
    }

  }


}
