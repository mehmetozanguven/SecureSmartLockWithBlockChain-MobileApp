
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/presenter/new_register_page_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/src/localization/localization.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return  _RegisterViewImpl();
  }

}

class _RegisterViewImpl extends State<RegisterPage> implements RegisterView{
  bool _obscureText;
  bool _visibleCircularProgressIndicator;

  CommonPropertySingleton _commonPropertySingleton;

  List<String> _userInputResults;

  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;

  NewRegisterPagePresenter _newRegisterPagePresenter;

  _RegisterViewImpl(){
    this._newRegisterPagePresenter = NewRegisterPagePresenterImpl(this);
    this._userInputResults = List();
    this._obscureText = true;
    _commonPropertySingleton = CommonPropertySingleton();
    _formKey = GlobalKey<FormState>();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _visibleCircularProgressIndicator = false;
  }

  @override
  GlobalKey<FormState> getFormKey() => _formKey;

  List<String> getUserInputResult() => _userInputResults;

  @override
  setVisibilityOfCircularProgressIndicator(bool visibility) {
    _visibleCircularProgressIndicator = visibility;
    setState(() {});
  }

  @override
  loadErrorMessage(String errorMessage){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(Localization.of(context).getText(text: errorMessage)),
    ));
  }

  @override
  void loadSuccessNewRegisterMessage_navigateLoginPage() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(Localization.of(context).getText(text: "successRegisterMessage")),
    ));
    Future.delayed(Duration(milliseconds: 2500),()=>Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(Localization.of(context).getText(text: "registerPage"))
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: buildContainerChild(),
        ),
      ),
    );
  }

  ListView buildContainerChild() {
    return ListView(
      children: <Widget>[
        buildUserInputForm(Localization.of(context).getText(text: 'name'), Localization.of(context).getText(text: 'name')),
        buildUserInputForm(Localization.of(context).getText(text: 'surname'), Localization.of(context).getText(text: 'surname')),
        buildUserInputForm(Localization.of(context).getText(text: 'email'), Localization.of(context).getText(text: 'email'),  userEmailArea: true),
        buildUserInputForm(Localization.of(context).getText(text: 'passwordHint'), Localization.of(context).getText(text: 'passwordHint'), showPasswordIcon: true),
        buildUserInputForm(Localization.of(context).getText(text: 'confirmPassword'), Localization.of(context).getText(text: 'confirmPassword'), showPasswordIcon: true),
        buildUserInputForm(Localization.of(context).getText(text: 'phone'), Localization.of(context).getText(text: 'phone'), isNumpadNeed: true),
        SizedBox(height: 10.0,),
        buildRegisterButton(),
        SizedBox(height: 10.0,),
        _commonPropertySingleton.showCircularProgressIndicator(show: _visibleCircularProgressIndicator),
      ],
    );
  }

  Center buildRegisterButton() {
    return Center(
        child: RaisedButton(
          onPressed: !_visibleCircularProgressIndicator ? _newRegisterPagePresenter.newRegisterButtonListener:null,
            child: Text(
              Localization.of(context).getText(text: "register"),
              style: Theme.of(context).textTheme.button,
            ),
            color: Theme.of(context).primaryColor,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(12.0))
        ),
      );
  }

  Padding buildUserInputForm(String inputType, String hintText,
      {showPasswordIcon = false, userEmailArea = false, isNumpadNeed = false}) {
    TextFormField textFormField;
    if (showPasswordIcon) {
      //password field
      textFormField = buildUserPasswordTextField(inputType, hintText);
    } else {
      textFormField = buildUserInputTextField(inputType, hintText, userEmailArea: userEmailArea, isNumpadNeed: isNumpadNeed);
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: textFormField,
    );
  }

  TextFormField buildUserInputTextField(String inputType, String hintText, {userEmailArea = false, isNumpadNeed = false}) {
    return TextFormField(
      validator: (value) {
          if (value.isEmpty)
            return Localization.of(context).getText(text: "fillArea");
          else if (value.length > 50)
            return Localization.of(context).getText(text: "longString");
          else if (userEmailArea && !value.contains(RegExp(r"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*")))
              return Localization.of(context).getText(text: "validateEmail");
          else if (isNumpadNeed && !value.contains(new RegExp(r"^[0-9]{1,10}$")))
              return  Localization.of(context).getText(text: "phoneError");

          },
      onSaved: (value) => _userInputResults.add(value),
      keyboardType: isNumpadNeed ? TextInputType.phone:TextInputType.text,
      decoration: InputDecoration(
          labelText: inputType,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: hintText,
          errorStyle: TextStyle(color: Colors.red)),
    );
  }

  TextFormField buildUserPasswordTextField(String inputType, String hintText) {
    return TextFormField(
      validator: (value) {
        if (value.length < 6)
          return Localization.of(context).getText(text: "validatePassword");
      },
      onSaved: (value) => _userInputResults.add(value),
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
          )),
    );
  }
}