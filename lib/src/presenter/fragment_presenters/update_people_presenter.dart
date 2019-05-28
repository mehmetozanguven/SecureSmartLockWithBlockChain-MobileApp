import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class UpdatePeopleImpl extends BasePresenter implements UpdatePeoplePresenter{
  final String _log = "UpdatePeopleImpl";

  final UpdatePeopleWidgetView responsibleView;

  Repository _repository;
  CommonPropertySingleton _commonPropertySingleton;
  List<Device> _devicesList;

  UpdatePeopleImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();
  }

  List<Device> getAllDevicesAsList() => _devicesList;

  Future<String> getDevicesList() async{
    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    bool isInternet = await isInternetConnection();

    if (isInternet)
      return  _repository.getDevicesList(userToken: userToken);
    else
      return "NoInternet";

  }

  bool decodeResponse(String responseData) {
    print("$_log :- decodeResponse() method - deviceList: $responseData");
    bool isDecode = true;
    JsonCodec jsonCodec = JsonCodec();
    try{
      List<dynamic> dynamicList = jsonCodec.decode(responseData);
      _devicesList = List();
      dynamicList.forEach((d) {
        _devicesList.add(DoorDevice.fromJsonResponse(d));
      });
    }catch (e){
      print("$_log, error occured when decoded response : $e");
      isDecode = false;
    }
    return isDecode;
  }



}