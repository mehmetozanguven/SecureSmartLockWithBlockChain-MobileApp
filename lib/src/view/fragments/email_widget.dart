import 'dart:async';

import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/email_widget_presenter.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/qr_code_widget_presenter.dart';
import 'package:smart_lock/src/presenter/new_register_page_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/fragments/update_people_widget.dart';
import 'package:smart_lock/src/view/fragments/qr_code_widget.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:quiver/async.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EmailWidget extends StatefulWidget{
  @override
  _EmailWidgetState createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> implements EmailWidgetView{
  String _log = "_EmailWidgetState";

  CommonPropertySingleton _commonPropertySingleton;
  bool _visibleCircularProgressIndicator;

  GlobalKey<FormState> _formKey;
  List<String> _userInputs;

  EmailPresenter _emailPresenter;

  _EmailWidgetState(){
    print("$_log Constructor ");
    _visibleCircularProgressIndicator = false;
    _formKey = new GlobalKey<FormState>();
    _userInputs = List();
    _emailPresenter = EmailPresenterImpl(this);
    _commonPropertySingleton = CommonPropertySingleton();
  }

  @override
  List<String> getUserInputs() => _userInputs;

  @override
  setVisibilityOfCircularProgressIndicator(bool visibility) {
    _visibleCircularProgressIndicator = visibility;
    setState(() {});
  }

  @override
  GlobalKey<FormState> getFormKey() => _formKey;

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
    return Center(
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12.0),
              child: buildUserInputTextField(Localization.of(context).getText(text: "emailConfirmCode"),
                  Localization.of(context).getText(text: 'enterEmailConfirmCode')),
            ),
            SizedBox(height: 2.0,),
            _commonPropertySingleton.showCircularProgressIndicator(show: _visibleCircularProgressIndicator),
            SizedBox(height: 3.0,),
            buildEmailActivateButton(context),
            SizedBox(height: 10.0,),
            buildResendEmailButton(context)
          ],
        ),
      ),
    );
  }

  Center buildResendEmailButton(BuildContext context) {
    return Center(
            child: RaisedButton(
                onPressed: !_visibleCircularProgressIndicator?_emailPresenter.resendActivationCodeButtonListener:null,
                child: Text(
                  Localization.of(context).getText(text: "resendEmailCode"),
                  style: Theme.of(context).textTheme.button,
                ),
                color: Theme.of(context).primaryColor,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0))
            ),
          );
  }

  TextFormField buildUserInputTextField(String inputType, String hintText) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty)
          return Localization.of(context).getText(text: "fillArea");
      },
      enabled: !_visibleCircularProgressIndicator,
      onSaved: (value) =>_userInputs.add(value),
      decoration: InputDecoration(
          labelText: inputType,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: hintText,
          errorStyle: TextStyle(color: Colors.red)),
    );
  }

  Center buildEmailActivateButton(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: !_visibleCircularProgressIndicator?_emailPresenter.emailActivateButtonListener:null,
          child: Text(
            Localization.of(context).getText(text: "activeEmail"),
            style: Theme.of(context).textTheme.button,
          ),
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(12.0))
      ),
    );
  }
}
