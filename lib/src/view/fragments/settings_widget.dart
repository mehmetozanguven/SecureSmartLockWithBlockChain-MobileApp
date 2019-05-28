
import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/add_new_device_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetImpl createState() => _SettingsWidgetImpl();
}

class _SettingsWidgetImpl extends State<SettingsWidget> implements SettingsWidgetView{
  String _log = "_SettingsWidgetImpl";
  bool _value = false;
  CommonPropertySingleton _commonPropertySingleton;

  _SettingsWidgetImpl(){
    _commonPropertySingleton = CommonPropertySingleton();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: SwitchListTile(
                  title: Text(
                    Localization.of(context).getText(text: "saveLogin"),
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: Theme.of(context).textTheme.subhead.fontSize
                    ),
                  ),
                  secondary: Icon(Icons.save),
                  value: getSwitchValueFromShared(),
                  onChanged: (bool value) {
                    changeSwitchFunction(value);
                  }
              ),
            )
          ],
        ),

    );
  }

  void changeSwitchFunction(bool value){

    SharedPreferences prefs = _commonPropertySingleton.getSharedPreferences();
    print("$_log new switch value: $value");
    prefs.setBool("defaultValue", value);
    setState(() {
      if(value){
        print("$_log value: $value and useremail and password will be saved");
        print("$_log useremail: ${_commonPropertySingleton.getUserInfo().getUserEmail()}");
        print("$_log userpassword: ${_commonPropertySingleton.getUserPassword()}");

        prefs.setString("usermail", _commonPropertySingleton.getUserInfo().getUserEmail());
        prefs.setString("userpassword", _commonPropertySingleton.getUserPassword());
      }else{
        prefs.setString("usermail", "");
        prefs.setString("userpassword", "");
      }
    });

  }

  getSwitchValueFromShared(){
    SharedPreferences prefs = _commonPropertySingleton.getSharedPreferences();

    bool defaultValue = prefs.getBool("defaultValue") ?? false;

    return defaultValue;
  }

}
