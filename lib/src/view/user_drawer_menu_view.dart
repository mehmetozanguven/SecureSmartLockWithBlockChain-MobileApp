import 'dart:async';

import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/view/fragments/authorized_people_widget.dart';
import 'package:smart_lock/src/view/fragments/profile_widget.dart';
import 'package:smart_lock/src/view/fragments/update_people_widget.dart';
import 'package:smart_lock/src/view/fragments/change_password.dart';
import 'package:smart_lock/src/view/fragments/devices_widget.dart';
import 'package:smart_lock/src/view/fragments/email_widget.dart';
import 'package:smart_lock/src/view/fragments/qr_code_widget.dart';
import 'package:smart_lock/src/view/fragments/settings_widget.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:quiver/async.dart';

class UserDrawerMenuPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _UserDrawerMenuViewImpl();
  }
}

class _UserDrawerMenuViewImpl extends State<UserDrawerMenuPage> implements UserDrawerMenuView {
  String _log = "_UserDrawerMenuViewImpl";

  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  int _selectedDrawerItem;
  bool _isEmailActived;
  CommonPropertySingleton _commonPropertySingleton;

  CountdownTimer _countdownTimer;


  _UserDrawerMenuViewImpl(){
    _commonPropertySingleton = CommonPropertySingleton();
    _isEmailActived = _commonPropertySingleton.getUserInfo().isEmailConfirm();
    _commonPropertySingleton.assignUserDrawerMenu(this);
    _selectedDrawerItem = 0;
    _formKey = new GlobalKey<FormState>();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  setCountDownTimer(){
    int second = _commonPropertySingleton.getQrCodeContent().getDurationInSecond();
    print("$_log second : $second");
    _countdownTimer = CountdownTimer(Duration(seconds: second),Duration(seconds: 1));
    _commonPropertySingleton.assignCountdownTimerForQrCode(_countdownTimer);
  }

  void resetQrCodeContent(){
    print("$_log : resetQrCodeContent()");
    setCountDownTimer();
  }

  void simplySetStateToUseInDifferentWidget(){
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _countdownTimer.cancel();
  }

  @override
  void initState() {
    super.initState();
    setCountDownTimer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text(Localization.of(context).getText(text: "userPage"))
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              buildUserAccountsDrawerHeader(context),
              buildListTile(context, 0, "home", Icons.home),
              buildListTile(context, 1, "profile", Icons.person),
              buildListTile(context, 2, "devices_menu", Icons.devices),
              buildListTile(context, 3, "new_person", Icons.person_add),
              buildListTile(context, 4, "authorized_people", Icons.person_pin),
              buildListTile(context, 5, "change_password", Icons.stay_current_portrait),
              Opacity(
                opacity: _isEmailActived ? 0.0:1.0,
                child: buildListTile(context, 6, "email_activation", Icons.email, isEnabled: !_isEmailActived)
              ),
              buildListTile(context, 7, "setting", Icons.settings),
              ListTile(
                title: Text(Localization.of(context).getText(text: 'logout')),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  setState(() {
                    _selectedDrawerItem = 0;
                    Navigator.of(context).pop();
                    exitAppFromDrawerMenu();
                  });
                },
              ),
            ],
          ),
        ),
        body: _getDrawerContent(),
      ),
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text(
          _commonPropertySingleton.getUserInfo().getUserFirstName() + " " +
              _commonPropertySingleton.getUserInfo().getUserLastName()),
      accountEmail: Text(_commonPropertySingleton.getUserInfo().getUserEmail()),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        child: Text(
            _commonPropertySingleton.getUserInfo().getUserFirstName()[0].toUpperCase() + _commonPropertySingleton.getUserInfo().getUserLastName()[0].toUpperCase()),
      ),
    );
  }


  ListTile buildListTile(BuildContext context, int itemNum, String listTitle,
      IconData listTileIcon, {bool isEnabled=true}) {
    return ListTile(
      enabled: isEnabled,
      title: Text(Localization.of(context).getText(text: listTitle)),
      leading: Icon(listTileIcon),
      onTap: () {
        setState(() {
          _selectedDrawerItem = itemNum;
          Navigator.of(context).pop();
          _getDrawerContent();
        });
      },
    );
  }

  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
      new AlertDialog(
        title: new Text(Localization.of(context).getText(text: "exitUserPage")),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(Localization.of(context).getText(text: "no")),
          ),
          new FlatButton(
            onPressed: () {
              _countdownTimer.cancel();
              Navigator.of(context).pop(true);
              },
            child: new Text(Localization.of(context).getText(text: "yes")),
          ),
        ],
      ),
    ) ?? false;
  }


  _getDrawerContent() {
    switch (_selectedDrawerItem){
      case 0:
        return new QrCodeWidget();
      case 1:
        return new ProfileWidget();
      case 2:
        return new DevicesWidget();
      case 3:
        return new UpdatePeopleWidget();
      case 4:
        return new AuthorizedPeopleWidget();
      case 5:
        return new ChangePasswordWidget();
      case 6:
        return new EmailWidget();
      case 7:
        return new SettingsWidget();
    }
  }

  void exitAppFromDrawerMenu(){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(Localization.of(context).getText(text: "exitUserPage")),
      action: SnackBarAction(
          label: Localization.of(context).getText(text: "yes"),
          onPressed: () {
            _countdownTimer.cancel();
            Navigator.pop(context);
          }
      ),
    )
    );
  }

  void exitApp(){
    Navigator.pop(context);
  }

  void exitAppWithSpecificDelay(){
    Future.delayed(Duration(milliseconds: 2500),()=>Navigator.pop(context));
  }

  void loadErrorMessage_forDrawerMenu() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(Localization.of(context).getText(text: "generalError")),
    ));
  }



}

