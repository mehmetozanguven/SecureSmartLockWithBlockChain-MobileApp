import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/change_password_widget_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
class ChangePasswordWidget extends StatefulWidget {
  @override
  _ChangePasswordWidgetImpl createState() => _ChangePasswordWidgetImpl();
}

class _ChangePasswordWidgetImpl extends State<ChangePasswordWidget> implements ChangePasswordWidgetView {
  bool _obscureText;
  bool _visibleCircularProgressIndicator;
  CommonPropertySingleton _commonPropertySingleton;
  GlobalKey<FormState> _formKey;

  ChangePasswordPresenter _changePasswordPresenter;

  List<String> _userInputs;

  _ChangePasswordWidgetImpl(){
    _visibleCircularProgressIndicator = false;
    _obscureText = true;
    _commonPropertySingleton = CommonPropertySingleton();
    _formKey = new GlobalKey<FormState>();
    _changePasswordPresenter = ChangePasswordPresenterImpl(this);
    _userInputs = new List();
  }

  @override
  List<String> getUserInputs() => _userInputs;

  @override
  GlobalKey<FormState> getFormKey() => _formKey;


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



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: buildUserPasswordTextField(Localization.of(context).getText(text: "password"),
                Localization.of(context).getText(text: 'passwordHint')),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: buildUserPasswordTextField(Localization.of(context).getText(text: "confirmPassword"),
                Localization.of(context).getText(text: "confirmPassword")),
          ),
          SizedBox(height: 10.0,),
          _commonPropertySingleton.showCircularProgressIndicator(show: _visibleCircularProgressIndicator),
          SizedBox(height: 10.0,),
          buildChangePasswordButton(context)
        ],
      ),
    );
  }

  Center buildChangePasswordButton(BuildContext context) {
    return Center(
        child: RaisedButton(
            onPressed: !_visibleCircularProgressIndicator?_changePasswordPresenter.changePasswordButtonListener:null,
            child: Text(
              Localization.of(context).getText(text: "change_password"),
              style: Theme.of(context).textTheme.button,
            ),
            color: Theme.of(context).primaryColor,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(12.0))
        ),
      );
  }


  TextFormField buildUserPasswordTextField(String inputType, String hintText) {
    return TextFormField(
      validator: (value) {
        if (value.length < 6) return Localization.of(context).getText(text: "validatePassword");
      },
      enabled: !_visibleCircularProgressIndicator,
      onSaved: (value){_userInputs.add(value);},
      obscureText: this._obscureText,
      decoration: InputDecoration(
          labelText: inputType,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: hintText,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              semanticLabel: _obscureText ? 'show password' : 'hide password',
            ),
          )
      ),
    );
  }



}
