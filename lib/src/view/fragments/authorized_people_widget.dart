import 'dart:async';

import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/authorized_people_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/fragments/authorized_people_extend_widget.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/src/localization/localization.dart';


class AuthorizedPeopleWidget extends StatefulWidget {
  @override
  _AuthorizedPeopleWidgetState createState() => _AuthorizedPeopleWidgetState();
}

class _AuthorizedPeopleWidgetState extends State<AuthorizedPeopleWidget> implements AuthorizedPeopleView{

  final String _log = "_AuthorizedPeopleWidgetState";
  AuthorizedPeoplePresenter _authorizedPeoplePresenter;

  Future<String> _devicesList;


  _AuthorizedPeopleWidgetState(){
    _authorizedPeoplePresenter = AuthorizedPeoplePresenterImpl(this);
  }

  @override
  void initState() {
    super.initState();
    _devicesList = _authorizedPeoplePresenter.getListOfDevicesFromRepository();
  }

  @override
  void dispose() {
    super.dispose();
    _authorizedPeoplePresenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
          child: Text(
            Localization.of(context).getText(text: "choose_device"),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.title.fontSize
            ),
          ),
        ),
        SizedBox(height: 20.0,),
        getAuthenticatedDeviceFromRepository(),
        buildAuthenticatedDevicesList()
      ],
    );
  }

  FutureBuilder<String> getAuthenticatedDeviceFromRepository() {
    return FutureBuilder<String>(
          future: _devicesList,
          initialData: "loading",
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.data == "No_internet"){
              return Text(
                Localization.of(context).getText(text: "No_internet"),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.subtitle.fontSize
                  )
              );
            }else if (snapshot.data == "loading"){
              return Text(
                  Localization.of(context).getText(text: "loading"),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.subtitle.fontSize
                  )
              );
            }else{
              _authorizedPeoplePresenter.getParseResponseStreamInput().add(snapshot.data);
              return createUserDevicesList();
            }
          }
      );
  }

  StreamBuilder<List<Device>> buildAuthenticatedDevicesList() {
    return StreamBuilder<List<Device>>(
      stream: _authorizedPeoplePresenter.getDoorDevicesListStream(),
      initialData: null,
      builder: (context, snapshot){
        if (snapshot.hasData){
          List<Widget> devicesListWidget = List();
          snapshot.data.forEach((device) => devicesListWidget.add(deviceListItem(device)));
          return Column(children: devicesListWidget,);
        }else{
          return Container();
        }
      },
    );
  }

  StreamBuilder createUserDevicesList() {
    StreamBuilder<String> devicesList = StreamBuilder<String>(
      stream: _authorizedPeoplePresenter.getListTileStream(),
      initialData: "loading",
      builder: (context, snapshot){
        if (snapshot.data == "loading"){
          return Center(
            child: Text(
                Localization.of(context).getText(text: "loading"),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.subtitle.fontSize
                )
            ),
          );
        }else if(snapshot.data == "empty"){
          return Center(
            child: Text(
                Localization.of(context).getText(text: "noDevice"),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.subtitle.fontSize
                )
            ),
          );
        }else if (snapshot.data == "done"){
          return Container();
        }else if (snapshot.hasError){
          Center(child: Text(Localization.of(context).getText(text: snapshot.error)));
        }else
          return Container();
      },
    );
    return devicesList;
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
          onTap: () => routeToAuthorizePeopleExtendWidget(context, deviceItem),
        ),
      );
  }

  void routeToAuthorizePeopleExtendWidget(BuildContext context, Device deviceItem){
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => AuthorizePeopleExtendWidget(deviceItem: deviceItem),
      ),
    );
  }
}
