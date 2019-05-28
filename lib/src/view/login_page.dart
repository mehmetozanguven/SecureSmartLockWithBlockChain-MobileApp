

import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/common/shared_prefs_helper.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:smart_lock/src/presenter/login_page_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginView {
  String _log = "LoginPage";

  bool _obscureText;
  bool _visibleCircularProgressIndicator = false;

  CommonPropertySingleton _commonPropertySingleton;

  Future<SharedPreferences> _sharedPreferences;

  LoginPagePresenter _loginPagePresenter;

  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;

  SharedPrefsHelper _preferencesHelper;
  TextEditingController _userMailController, _userPasswordController;

  _LoginPageState() {
    _commonPropertySingleton = CommonPropertySingleton();
    this._obscureText = true;
    _formKey = new GlobalKey<FormState>();
    this._loginPagePresenter = LoginPagePresenterImpl(this);
    this._scaffoldKey = GlobalKey<ScaffoldState>();

    _preferencesHelper = SharedPrefsHelper();
    _preferencesHelper.getUserMailSharedStream().listen((val) => _userMailController = TextEditingController(text: val));
    _preferencesHelper.getUserPasswordSharedStream().listen((val) => _userPasswordController = TextEditingController(text: val));

    print("$_log 1) constructors");
    print("");
  }

  @override
  GlobalKey<FormState> getFormKey() => _formKey;

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
  loadNewRegisterPage() {
    return Navigator.pushNamed(context, '/new_register');
  }

  loadForgetPasswordWithoutLoginPage(){
    return Navigator.pushNamed(context, '/forget_password_without_login');
  }

  loadUserQrCodePage(){
    return Navigator.pushNamed(context, "/user_qr_code_page");
  }

  Future<SharedPreferences> getSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _commonPropertySingleton.assignSharedPreferences(prefs);
    return prefs;
  }

  @override
  void initState() {
    _sharedPreferences = getSharedPreferences();
    super.initState();
    print("");
    print("$_log 3) initState");
    print("");
  }

  @override
  void didUpdateWidget(LoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("");
    print("$_log 2) didUpdateWidget");
    print("");
  }


  @override
  Widget build(BuildContext context) {
    print("");
    print("$_log 4) build method");
    print("");
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Localization.of(context).getText(text: "title")),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: buildContainerChild(context),
          ),
        )
    );
  }

  ListView buildContainerChild(BuildContext context) {
    return ListView(
      children: <Widget>[
        buildLoginTextView(context),
        SizedBox(height: 60.0,),
        buildUserEmailInputForm(Localization.of(context).getText(text: "enterMail"),
            Localization.of(context).getText(text: "email")),
        buildUserPasswordInputForm(Localization.of(context).getText(text: "password"),
            Localization.of(context).getText(text: "passwordHint")),
        SizedBox(height: 5.0,),
        _commonPropertySingleton.showCircularProgressIndicator(show: _visibleCircularProgressIndicator),
        SizedBox(height: 5.0,),
        buildLogInButton(context),
        SizedBox(height: 20.0,),
        buildClickableTextView(context, text: Localization.of(context).getText(text: "createAccount")),
        SizedBox(height: 20.0,),
        buildClickableTextView(context, text: Localization.of(context).getText(text: "forgetPassword"), newRegister: false),
        SizedBox(height: 20.0,),
      ],
    );
  }

  Container buildLoginTextView(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(32.0),
      child: Text(
        Localization.of(context).getText(text: "logIn"),
        style: TextStyle(
            fontSize: 40.0, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Padding buildUserEmailInputForm(String inputType, String hintText){
    InputDecoration inputDecoration = _commonPropertySingleton.getInputDecoration(inputType: inputType, hintText: hintText);

    TextFormField userMailField = TextFormField(
      controller: _userMailController,
        validator: (value) {
          if (!value.contains("@"))
            return Localization.of(context).getText(text: "validateEmail");
        },
        onSaved: _loginPagePresenter.getUserEmail,
        decoration: inputDecoration
    );

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: userMailField,
    );

  }

  Padding buildUserPasswordInputForm(String inputType, String hintText){
    GestureDetector gestureDetector = GestureDetector(
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      child: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off,
        semanticLabel: _obscureText ? 'show password' : 'hide password',
      ),
    );

    InputDecoration inputDecoration = _commonPropertySingleton.getInputDecoration(inputType: inputType, hintText: hintText, gestureDetector: gestureDetector);

    TextFormField passwordField = TextFormField(
        controller: _userPasswordController,
        validator: (value) {
          if (value.length < 6)
            return Localization.of(context).getText(text: "validatePassword");
        },
        onSaved: _loginPagePresenter.getUserPassword,
        obscureText: this._obscureText,
        decoration: inputDecoration
    );

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: passwordField,
    );

  }

  Center buildLogInButton(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: !_visibleCircularProgressIndicator?_loginPagePresenter.loginButtonListener:null,
          child: Text(
            Localization.of(context).getText(text: "logIn"),
            style: Theme.of(context).textTheme.button,
          ),
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0))),
    );
  }

  Center buildClickableTextView(BuildContext context, {String text, bool newRegister = true}) {
    return Center(
      child: InkWell(
        child: Text(
          text,
          style: TextStyle(color: Colors.grey, fontSize: 19.0),
        ),
        onTap: !_visibleCircularProgressIndicator? (){
          if (newRegister) loadNewRegisterPage();
          else loadForgetPasswordWithoutLoginPage();
        } :null,
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Theme.of(context).primaryColorDark,
      ),
    );
  }


}
