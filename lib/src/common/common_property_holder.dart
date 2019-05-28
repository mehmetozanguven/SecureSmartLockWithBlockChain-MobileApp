import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/model/qr_code_content.dart';
import 'package:smart_lock/src/model/token.dart';
import 'package:smart_lock/src/model/user_info.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// This is singleton class which holds common objects that will be used for presenters,
/// user interface classes etc..
class CommonPropertySingleton{
  static final CommonPropertySingleton _singleton = new CommonPropertySingleton._internal();
  Token _userToken;
  UserInfo _userInfo;
  QrCodeContent _qrCodeContent;
  CountdownTimer _countdownTimer;
  UserDrawerMenuView _userDrawerMenuView;
  String _userPassword;
  List<Device> _devicesList;
  SharedPreferences _sharedPreferences;

  factory CommonPropertySingleton() {
    return _singleton;
  }

  CommonPropertySingleton._internal() {
     // initialization logic here
  }

  /// assign (hold) user token
  assignUserToken(Token currentUserToken){
    _userToken = currentUserToken;
  }

  /// assign(hold) user information
  assignUserInfo(UserInfo currentUserInfo){
    _userInfo = currentUserInfo;
  }

  /// assign(hold) QrCodeContent
  assignQrCodeContent(QrCodeContent currentQrCodeContent){
    _qrCodeContent = currentQrCodeContent;
  }

  /// assign(hold) CountdownTimer
  assignCountdownTimerForQrCode(CountdownTimer currentTimer){
    _countdownTimer = currentTimer;
  }

  /// assign(hold) UserDrawerMenuView (ui)
  assignUserDrawerMenu(UserDrawerMenuView currentUserDrawerMenu){
    _userDrawerMenuView = currentUserDrawerMenu;
  }

  /// assign(hold) user currentUserPassword (It will be used when user wants to
  /// change his/her password after login)
  assignUserPassword(String currentUserPassword){
    _userPassword = currentUserPassword;
  }

  /// assign(hold) devicesList
  assignDevicesList(List<Device> devicesList){
    _devicesList = devicesList;
  }

  assignSharedPreferences(SharedPreferences sharedPreferences){
    _sharedPreferences = sharedPreferences;
  }

  /// Because circular progress indicator is used many classes
  /// It is a better to define in here
  /// This methods return CircularProgressIndicator widget
  Container showCircularProgressIndicator({bool show = false}){
    return Container(
      child: Center(
        child: Opacity(
          opacity: show ? 1.0 : 0.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Because input decoration for text input form is used many classes
  /// It is defined here.
  /// If gesture detector is not null, that's means obscure text is needed
  InputDecoration getInputDecoration({String inputType, String hintText, GestureDetector gestureDetector = null}){
    return InputDecoration(
        labelText: inputType,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: hintText,
        errorStyle: TextStyle(color: Colors.red),
        suffixIcon: gestureDetector
    );
  }

  /// This row widget is used by devices_widget and add_people_widget
  Row buildTwoRowTextWidgets({BuildContext context,
      String propertyName, String propertyValue, isTitleFontSize = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            propertyName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontSize: isTitleFontSize ? Theme.of(context).textTheme.title.fontSize :
                                              Theme.of(context).textTheme.subtitle.fontSize
              )
          ),
        ),
        Flexible(
          child: Text(propertyValue,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: isTitleFontSize ? Theme.of(context).textTheme.title.fontSize :
                                              Theme.of(context).textTheme.subtitle.fontSize
              )
          ),
        )
      ],
    );
  }

  TextStyle buildTextStyle({BuildContext context, isTitleFontSize = true}){
    return TextStyle(color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: isTitleFontSize ? Theme.of(context).textTheme.title.fontSize
    :Theme.of(context).textTheme.subtitle.fontSize);
  }
  
  Text buildRaisedButtonTextChild({BuildContext context, String text}){
    return Text(
      text,
      style: Theme.of(context).textTheme.button,
    );
  }
  
  RoundedRectangleBorder buildBorderForRaisedButton(){
    new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(12.0));
  }

  /// Correspond get methods for holding objects

  Token getUserToken() => _userToken;

  UserInfo getUserInfo() => _userInfo;

  QrCodeContent getQrCodeContent() => _qrCodeContent;

  CountdownTimer getCountDownTimer() => _countdownTimer;

  UserDrawerMenuView getUserDrawerMenu() => _userDrawerMenuView;

  String getUserPassword() => _userPassword;

  List<Device> getDevicesList() => _devicesList;

  int getSizeOfDevicesList() => _devicesList.length;

  SharedPreferences getSharedPreferences() => _sharedPreferences;

}