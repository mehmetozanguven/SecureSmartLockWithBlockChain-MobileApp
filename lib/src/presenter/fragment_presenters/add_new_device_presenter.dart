import 'dart:async';
import 'dart:convert';

import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class AddNewDevicePresenterImpl extends BasePresenter implements AddNewDevicePresenter{

  final String _log = "AddNewDevicePresenterImpl";
  final DeviceWidgetView responsibleView;

  Repository _repository;
  CommonPropertySingleton _commonPropertySingleton;

  StreamController<String> _addNewDeviceStreamController = StreamController<String>.broadcast();
  StreamSink<String> getAddDeviceStreamSink() => _addNewDeviceStreamController.sink;
  Stream<String> getAddNewDeviceStream() => _addNewDeviceStreamController.stream;

  AddNewDevicePresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();
  }

  void dispose(){
    _addNewDeviceStreamController.close();
  }

  @override
  addNewDeviceButtonListener() {
    final form = responsibleView.getFormKey().currentState;
    if (form.validate()){
      form.save();
      checkInternetConnection();
    }
  }

  void checkInternetConnection({bool forAddNewDevice = true}) async{
    responsibleView.setVisibilityOfCircularProgressIndicator(true);
    bool isInternet = await isInternetConnection();
    if (isInternet && forAddNewDevice){
      addNewDevice();
    }else{
      responsibleView.loadErrorMessage("No_internet");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }
  }

  void addNewDevice () async{
    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    String deviceName = responsibleView.getUserInputs()[0];
    String deviceCode = responsibleView.getUserInputs()[1];
    responsibleView.getUserInputs().clear();

    String addNewDeviceResponse = await _repository.addNewDevice(userToken: userToken, deviceName: deviceName, deviceCode: deviceCode);

    print("$_log response: $addNewDeviceResponse");
    if (addNewDeviceResponse.isEmpty){
      responsibleView.loadSuccessMessage("addDeviceSuccessMessage");
      responsibleView.setDevicesListFuture(getDevicesList());
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }else{
      getErrorAndShow(addNewDeviceResponse);
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }

  }

  void getErrorAndShow(String changePasswordResponse) {
    Map<String,dynamic> resultMap = jsonDecode(changePasswordResponse);
    if (resultMap.containsKey("ModelState")){
      Map<String, dynamic> errorMap = resultMap["ModelState"];
      getErrorFromModelState(errorMap);
    }
  }
  
  void getErrorFromModelState(Map<String, dynamic> errorMap) {
    if (errorMap.containsKey("DeviceCode"))
      responsibleView.loadErrorMessage("invalidDeviceCode");
    else if (errorMap.containsKey("Email"))
      responsibleView.loadErrorMessage("activeEmail");
    else
      responsibleView.loadErrorMessage("generalError");

  }

  @override
  Future<String> getDevicesList() {
    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    return  _repository.getDevicesList(userToken: userToken);
  }

  @override
  bool isUserHasDevicesList(data) {
    String responseData = data.toString();
    if (responseData.isEmpty){
      return false;
    }
    else{
      return decodeResponse(responseData);
    }
  }

  bool decodeResponse(String responseData) {
    print("$_log :- decodeResponse() method - deviceList: $responseData");
    bool isDecode = true;
    JsonCodec jsonCodec = JsonCodec();
    try{
      List<dynamic> dynamicList = jsonCodec.decode(responseData);
      List<Device> devicesList = List();
      dynamicList.forEach((d) {
        devicesList.add(DoorDevice.fromJsonResponse(d));
      });
      _commonPropertySingleton.assignDevicesList(devicesList);
    }catch (e){
      print("$_log, error occured when decoded response : $e");
      isDecode = false;
    }
    return isDecode;
  }

  void getDevicePermissionUserList({String deviceCode}) async{
    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    bool isInternet = await isInternetConnection();

    if (isInternet){
      String result = await _repository.getDevicePermissionUserList(userToken: userToken, deviceCode: deviceCode);
      _addNewDeviceStreamController.sink.add(result);
    }
  }



}