import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/add_new_device_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class DevicesWidget extends StatefulWidget {
  @override
  _DevicesWidgetImpl createState() => _DevicesWidgetImpl();
}

class _DevicesWidgetImpl extends State<DevicesWidget> implements DeviceWidgetView{
  String _log = "_DevicesWidgetImpl";

  CommonPropertySingleton _commonPropertySingleton;
  bool _visibleCircularProgressIndicator;

  GlobalKey<FormState> _formKey;
  List<String> _userInputs;
  Future<String> _devicesListFuture;

  AddNewDevicePresenter _addNewDevicePresenter;

  _DevicesWidgetImpl(){
    _visibleCircularProgressIndicator = false;
    _formKey = new GlobalKey<FormState>();
    _userInputs = List();
    _commonPropertySingleton = CommonPropertySingleton();
    _addNewDevicePresenter = AddNewDevicePresenterImpl(this);
  }

  @override
  GlobalKey<FormState> getFormKey() => _formKey;

  @override
  List<String> getUserInputs() => _userInputs;

  @override
  setVisibilityOfCircularProgressIndicator(bool visibility) {
    _visibleCircularProgressIndicator = visibility;
    setState(() {});
  }

  @override
  loadErrorMessage(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(Localization.of(context).getText(text: errorMessage)),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  loadSuccessMessage(String successMessage) {
    final snackBar = SnackBar(
      content: Text(Localization.of(context).getText(text: successMessage)),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void setDevicesListFuture(Future<String> newDevicesListFuture){
    _devicesListFuture = newDevicesListFuture;
  }

  @override
  void initState() {
    super.initState();
    _devicesListFuture = _addNewDevicePresenter.getDevicesList();
  }

  @override
  void dispose() {
    super.dispose();
    _addNewDevicePresenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("\n$_log 1) build method");
    print("");
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          buildDeviceNameField(context),
          buildDeviceCodeField(context),
          SizedBox(height: 2.0,),
          _commonPropertySingleton.showCircularProgressIndicator(show: _visibleCircularProgressIndicator),
          SizedBox(height: 3.0,),
          buildAddDeviceButton(context),
          SizedBox(height: 20.0,),
          buildListDevicesTextView(context),
          SizedBox(height: 10.0,),
          FutureBuilder<String>(
            future: _devicesListFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.hasData){
                bool isUserHasDevice = _addNewDevicePresenter.isUserHasDevicesList(snapshot.data);
                return isUserHasDevice ? buildUserCard() : buildListDeviceErrorText(context, "noDevice");
              }else{
                return buildListDeviceErrorText(context, "loading");
              }
            }
          )
        ],
      ),
    );
  }

  Padding buildDeviceCodeField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: buildUserInputTextField(
          Localization.of(context).getText(text: "newDeviceCode"),
          Localization.of(context).getText(text: 'newDeviceCode')),
    );
  }

  Padding buildDeviceNameField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: buildUserInputTextField(
          Localization.of(context).getText(text: "newDeviceName"),
          Localization.of(context).getText(text: 'newDeviceName')),
    );
  }

  Column buildUserCard() {
    List<Widget> devicesListWidget = List();
    _commonPropertySingleton.getDevicesList().forEach((elem) => devicesListWidget.add(deviceListItem(elem)));
    return Column(
      children: devicesListWidget,
    );
  }


  Card deviceListItem(Device deviceItem) {
    return
      Card(
        child: InkWell(
          child: ListTile(
            title: Text(
              Localization.of(context).getText(text: "deviceName"),
              style: TextStyle(color: Theme.of(context).primaryColorDark),
            ),
            subtitle: Text(
              deviceItem.getDeviceName(),
            ),
            trailing: Icon(Icons.subdirectory_arrow_right),
          ),
          onTap: () => showBottomModalSheetToUser(deviceItem),
        ),
      );
  }

  void showBottomModalSheetToUser(Device deviceItem){
    print("\n$_log showBottomModalSheet runs");
    print("");
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return ListView(
            children: <Widget>[
              SizedBox(height: 20.0,),
              _commonPropertySingleton.buildTwoRowTextWidgets(context: context, propertyName: Localization.of(context).getText(text: "deviceName"), propertyValue: deviceItem.getDeviceName()),
              SizedBox(height: 20.0,),
              _commonPropertySingleton.buildTwoRowTextWidgets(context: context, propertyName: Localization.of(context).getText(text: "deviceCode"), propertyValue: deviceItem.getDeviceCode()),
              SizedBox(height: 20.0,),
              _commonPropertySingleton.buildTwoRowTextWidgets(context: context, propertyName: Localization.of(context).getText(text: "deviceRegistration"), propertyValue: deviceItem.getRegisteredTime()),
              SizedBox(height: 20.0,),
            ],
          );
        });
  }



  buildListDeviceErrorText(BuildContext context, String data) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: Text(
            Localization.of(context).getText(text: data),
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: Theme.of(context).textTheme.title.fontSize
          ),
        ),
      ),
    );
  }

  Center buildListDevicesTextView(BuildContext context) {
    return Center(
      child: Text(
            Localization.of(context).getText(text: "deviceText"),
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: Theme.of(context).textTheme.title.fontSize
            ),
          ),
    );
  }


  TextFormField buildUserInputTextField(String inputType, String hintText) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty)
          return Localization.of(context).getText(text: "fillArea");
      },
      enabled: !_visibleCircularProgressIndicator,
      onSaved: (value) =>_userInputs.add(value),
      decoration: _commonPropertySingleton.getInputDecoration(inputType: inputType, hintText: hintText),
    );
  }

  Center buildAddDeviceButton(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: !_visibleCircularProgressIndicator?_addNewDevicePresenter.addNewDeviceButtonListener:null,
          child: Text(
            Localization.of(context).getText(text: "addDevice"),
            style: Theme.of(context).textTheme.button,
          ),
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0))
      ),
    );
  }







}
