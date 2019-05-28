
import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper{
  final String _log = "SharedPrefsHelper";
  String _usermail, _userpassword;
  
  StreamController<String> _userMailSharedCont;
  Stream<String> getUserMailSharedStream() => _userMailSharedCont.stream;


  StreamController<String> _userPasswordSharedCont;
  Stream<String> getUserPasswordSharedStream() => _userPasswordSharedCont.stream;

  SharedPrefsHelper(){
    createControllers();
    _loadSharedPrefs();
  }

  String getUsermail() => _usermail;

  String getUserPassword() => _userpassword;

  void _loadSharedPrefs() async{
    SharedPreferences sharedPrefs = await getSharedPreferences();
    _usermail = sharedPrefs.getString("usermail")??"";
    _userpassword = sharedPrefs.getString("userpassword")??"";
    _userMailSharedCont.sink.add(sharedPrefs.getString("usermail")??"");
    _userPasswordSharedCont.sink.add(_userpassword);
  }

  Future<SharedPreferences> getSharedPreferences() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  void createControllers() {
    _userMailSharedCont = BehaviorSubject<String>();
    _userPasswordSharedCont = StreamController<String>.broadcast();
  }
}