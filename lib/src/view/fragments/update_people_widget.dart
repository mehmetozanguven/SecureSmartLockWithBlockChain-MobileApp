import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/update_people_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/fragments/update_people_extend_widget.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class UpdatePeopleWidget extends StatefulWidget{
  @override
  _UpdatePeopleWidgetState createState() => _UpdatePeopleWidgetState();
}

class _UpdatePeopleWidgetState extends State<UpdatePeopleWidget> implements UpdatePeopleWidgetView {

  String _log = "_UpdatePeopleWidgetState";

  CommonPropertySingleton _commonPropertySingleton;



  UpdatePeoplePresenter _updatePeoplePresenter;
  Future<String> _allDevicesList;

  _UpdatePeopleWidgetState(){
    _commonPropertySingleton = CommonPropertySingleton();
    _updatePeoplePresenter = UpdatePeopleImpl(this);

  }

  @override
  void initState() {
    super.initState();
    _allDevicesList = _updatePeoplePresenter.getDevicesList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(8.0),
      children: <Widget>[
        FutureBuilder<String>(
            future: _allDevicesList,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.hasData){
                return buildFutureHasDataWidget(snapshot.data);
              }else{
                return Center(
                  child: Text(
                    Localization.of(context).getText(text: "loading"),
                    style: TextStyle(color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context).textTheme.subtitle.fontSize),
                  ),
                );
              }
            }
        )
      ],
    );
  }

  Widget buildFutureHasDataWidget(String data) {
    if (data == "[]") {
      return Container(
        child: Text(
          Localization.of(context).getText(text: "noDevice"),
          style: TextStyle(color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.subtitle.fontSize),
        ),
      );
    }else if (data == "NoInternet"){
      return Center(
        child: Text(
          Localization.of(context).getText(text: "No_internet"),
          style: TextStyle(color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: Theme.of(context).textTheme.subtitle.fontSize),
        ),
      );
    }else {
      bool responseIsDecoded = _updatePeoplePresenter.decodeResponse(data);
      return !responseIsDecoded ? Container() :  buildCardListFromResponse();
    }
  }

  Widget buildCardListFromResponse() {
    List<Widget> devicesListWidget = List();
    _updatePeoplePresenter.getAllDevicesAsList().forEach((elem) => devicesListWidget.add(deviceListItem(elem)));

    return Column(
      children: devicesListWidget,
    );
  }

  Widget deviceListItem(Device deviceItem) {
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
          onTap: () => routeToUpdatePeopleExtendWidget(context, deviceItem),
        ),
      );
  }

  void routeToUpdatePeopleExtendWidget(BuildContext context, Device deviceItem){
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => UpdatePeopleExtendWidget(deviceItem: deviceItem),
      ),
    );
  }

  Center buildNewUserButton() {
    return Center(
      child: RaisedButton(
          onPressed: () => print("$_log presssed"),
          child: Text(
            Localization.of(context).getText(text: "new_person"),
            style: Theme.of(context).textTheme.button,
          ),
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0))),
    );
  }

  TextFormField buildNewUserInputArea({Device deviceItem, String inputType, String hintText}) {
    InputDecoration inputDecoration = _commonPropertySingleton.getInputDecoration(inputType: inputType, hintText: hintText);
    return TextFormField(
      validator: (value) {
        if (value.isEmpty)
          return Localization.of(context).getText(text: "fillArea");
      },
        decoration: inputDecoration,
    );
  }


}
