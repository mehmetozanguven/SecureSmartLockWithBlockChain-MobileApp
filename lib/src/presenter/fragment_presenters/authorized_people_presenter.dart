import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class AuthorizedPeoplePresenterImpl extends BasePresenter implements AuthorizedPeoplePresenter{

  final String _log = "AuthorizedPeoplePresenterImpl";
  final AuthorizedPeopleView responsibleView;

  StreamController<String> _parseResponseStreamController;
  StreamSink<String> getParseResponseStreamInput() => _parseResponseStreamController.sink;

  StreamController<String> _buildListTileStreamController;
  StreamSink<String> getListTileStreamInput() => _buildListTileStreamController.sink;
  Stream<String> getListTileStream() => _buildListTileStreamController.stream;

  StreamController<List<Device>> _doorDevicesListStreamController;
  Stream<List<Device>> getDoorDevicesListStream() => _doorDevicesListStreamController.stream;

  Repository _repository;
  CommonPropertySingleton _commonPropertySingleton;

  AuthorizedPeoplePresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();

    _parseResponseStreamController = StreamController<String>.broadcast();
    _parseResponseStreamController.stream.listen(responseListener);

    _buildListTileStreamController = StreamController<String>.broadcast();

    _doorDevicesListStreamController = StreamController<List<Device>>.broadcast();
  }

  void dispose(){
    _parseResponseStreamController.close();
    _buildListTileStreamController.close();
    _doorDevicesListStreamController.close();
  }

  Future<String> getListOfDevicesFromRepository() async{
    bool isInternet = await isInternetConnection();

    if  (isInternet){
      String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
      return  _repository.getDevicesList(userToken: userToken);
    }else
      return "No_internet";
  }

  void responseListener(String event) {
    print("$_log  response listener $event");
    if (event.isEmpty)
      _buildListTileStreamController.sink.add("empty");
    else if (event == "[]")
      _buildListTileStreamController.sink.add("empty");
    else {
      JsonCodec jsonCodec = JsonCodec();
      try{
        List<dynamic> dynamicList = jsonCodec.decode(event);
        List<Device> devicesList = List();
        dynamicList.forEach((d) {
          devicesList.add(DoorDevice.fromJsonResponse(d));
        });
        _buildListTileStreamController.sink.add("done");
        _doorDevicesListStreamController.sink.add(devicesList);
      }catch (e){
        print("$_log, error occured when decoded response : $e");
        _buildListTileStreamController.sink.addError("generalError");
      }
    }
  }
}