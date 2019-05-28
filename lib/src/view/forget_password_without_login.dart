
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:smart_lock/src/presenter/forget_password_without_login_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:flutter/material.dart';

class ForgetPasswordWithoutLoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordWithoutLoginViewImpl();
  }

}

class _ForgetPasswordWithoutLoginViewImpl extends State<ForgetPasswordWithoutLoginPage>
  implements ForgetPasswordWithoutLoginView {
  bool _obscureText, _showEmailText, _showNewPasswordText, _showMailTokenText;
  bool _visibleCircularProgressIndicator;

  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;

  ForgetPasswordWithoutRegisterPresenter _passwordWithoutRegisterPresenter;
  List<String> _userInputResults;

  CommonPropertySingleton _commonPropertySingleton;

  @override
  GlobalKey<FormState> getFormKey() {
    return _formKey;
  }


  _ForgetPasswordWithoutLoginViewImpl(){
    _commonPropertySingleton = CommonPropertySingleton();
    this._obscureText = true;
    _formKey = new GlobalKey<FormState>();
    this._scaffoldKey = GlobalKey<ScaffoldState>();
    _visibleCircularProgressIndicator = false;
    _showEmailText =true;
    _showNewPasswordText = false;
    _showMailTokenText = false;
    _passwordWithoutRegisterPresenter = ForgetPasswordWithoutLoginPresenterImpl(this);
    _userInputResults = new List();
  }

  List getUserInputResult() => _userInputResults;

  @override
  loadErrorMessage(String errorMessage) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(Localization.of(context).getText(text: errorMessage)),
    ));
  }

  @override
  setVisibilityOfCircularProgressIndicator(bool visibility) {
    _visibleCircularProgressIndicator = visibility;
    setState(() {});
  }

  @override
  setVisibilityOfUserTextInputs({bool emailTextVisibility, bool emailConfirmCodeVisibility,
                                bool newPasswordVisiblity}){
    _showEmailText = emailTextVisibility;
    _showMailTokenText = emailConfirmCodeVisibility;
    _showNewPasswordText = newPasswordVisiblity;
    setState(() {});
  }

  @override
  loadGeneralError_navigateLoginPage() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(Localization.of(context).getText(text: "generalError_navigateLogin")),
    ));
    Future.delayed(Duration(milliseconds: 2500),()=>Navigator.pop(context));
  }

  @override
  loadSuccessMessage_navigateLoginPage() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(Localization.of(context).getText(text: "successChangePassword")),
    ));
    Future.delayed(Duration(milliseconds: 2500),()=>Navigator.pop(context));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(Localization.of(context).getText(text: "forgetPassword"))
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              buildUserEmailTextForm(context,Localization.of(context).getText(text: "enterMail"),
                  Localization.of(context).getText(text: "email")),
              buildEmailTokenText(context, Localization.of(context).getText(text: "emailConfirmCode"),
                  Localization.of(context).getText(text: "enterEmailConfirmCode")),
              buildNewPasswordTextField(context, Localization.of(context).getText(text: "password"),
                Localization.of(context).getText(text: "passwordHint")),
              buildNewPasswordTextField(context, Localization.of(context).getText(text: "password"),
                  Localization.of(context).getText(text: "confirmPassword")),
              SizedBox(height: 5.0,),
              _commonPropertySingleton.showCircularProgressIndicator(show: _visibleCircularProgressIndicator),
              SizedBox(height: 5.0,),
              buildPasswordResetButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Center buildPasswordResetButton(BuildContext context) {
    return Center(
      child: RaisedButton(
          child: Text(
            Localization.of(context).getText(text: "changePasswordButton"),
            style: Theme
                .of(context).textTheme.button,
          ),
          onPressed: !_visibleCircularProgressIndicator ? _passwordWithoutRegisterPresenter.changePasswordListener:null,
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0))
      ),
    );
  }

  Padding buildNewPasswordTextField(BuildContext context, String inputType, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Opacity(
          opacity: 1.0,
          child: TextFormField(
            enabled: _showNewPasswordText ? true : false,
            validator: (value){},
            onSaved: (value) => _userInputResults.add(value),
            obscureText: _obscureText,
            decoration: InputDecoration(
                labelText: inputType,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: hintText,
                errorStyle: TextStyle(color: Colors.red),
            suffixIcon: GestureDetector(
                onTap: (){setState(() {_obscureText = !_obscureText;});},
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel: _obscureText ? 'show password' : 'hide password',
                ),
              )
            ),
          ),
        ),
      ),
    );
  }


  Padding buildEmailTokenText(BuildContext context, String inputType, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Opacity(
          opacity:  1.0,
          child: TextFormField(
  enabled: _showMailTokenText ? true : false,
  validator: (value){},
            onSaved: (value) => _userInputResults.add(value),
            decoration: InputDecoration(
                labelText: inputType,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: hintText,
                errorStyle: TextStyle(color: Colors.red)
            ),
          ),
        ),
      ),
    );
  }

  Padding buildUserEmailTextForm(BuildContext context, String inputType, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Opacity(
          opacity: 1.0,
            child: TextFormField(
              enabled: _showEmailText ? true : false,
              onSaved: (value) => _userInputResults.add(value),
              validator: (value){
                if (!value.contains(RegExp(r"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*")))
                  return Localization.of(context).getText(text: "validateEmail");
                  },
            decoration: InputDecoration(
            labelText: inputType,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
             ),
                hintText: hintText,
                errorStyle: TextStyle(color: Colors.red))
            ),
        )
      ),
    );
  }



}


