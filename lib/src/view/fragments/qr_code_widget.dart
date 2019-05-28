import 'dart:async';

import 'package:quiver/async.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/qr_code_widget_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatefulWidget {

  @override
  _QrCodeWidgetState createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> implements QrCodeWidgetView{
  String _log = "_QrCodeWidgetState";

  CommonPropertySingleton _commonPropertySingleton;
  bool _visibleCircularProgressIndicator;


  QrCodeWidgetPresenter _qrCodeWidgetPresenter;

  _QrCodeWidgetState(){
    print("$_log Constructor ");
    _visibleCircularProgressIndicator = false;
    _qrCodeWidgetPresenter = QrCodeWidgetPresenterImpl(this);
    _commonPropertySingleton = CommonPropertySingleton();
  }


  @override
  setVisibilityOfCircularProgressIndicator(bool visibility) {
    _visibleCircularProgressIndicator = visibility;
    setState(() {});
  }

  resetQrCodeContent(){
    _commonPropertySingleton.getUserDrawerMenu().resetQrCodeContent();
  }

  @override
  loadErrorMessage(String errorMessage){
    final snackBar = SnackBar(
      content: Text(Localization.of(context).getText(text: errorMessage)),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    print("$_log initState");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    print("$_log build");
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        buildQrCodeInfoWidget(context),
        _commonPropertySingleton.showCircularProgressIndicator(show: _visibleCircularProgressIndicator),
        SizedBox(height: 60.0,),
        buildQrCode(data: _commonPropertySingleton.getQrCodeContent().getQrCodeContent()),
      ],
    );
  }

  Center buildQrCode({String data = "null"}) {
    return Center(
        child: new QrImage(
          data: data,
          size: 300.0,
        ),
      );
  }

  Padding buildQrCodeInfoWidget(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildTextViewInfo(context),
              buildTimerStreamBuilderInfo(),
              SizedBox(width: 13.0,),
              buildResetQrCode(context),
            ],
          ),
        ),
      );
  }

  RaisedButton buildResetQrCode(BuildContext context) {
    return RaisedButton(
        onPressed: _qrCodeWidgetPresenter.resetQrCodeButtonListener,
        child: Text(
          "Yenile",
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(12.0))
    );
  }

  StreamBuilder<Object> buildTimerStreamBuilderInfo() {
    return StreamBuilder<CountdownTimer>(
      stream: _commonPropertySingleton.getCountDownTimer(),
      builder: (context, snapshot) {
        return builderMethodOfStreamBuilder(snapshot);
      },
    );
  }

  Expanded buildTextViewInfo(BuildContext context) {
    return Expanded(
      child: Text(
        Localization.of(context).getText(text: "resetQrCode"),
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: Theme.of(context).textTheme.subtitle.fontSize
        ),
      ),
    );
  }

  Text builderMethodOfStreamBuilder(AsyncSnapshot snapshot) {
    String b = "0";
    if (snapshot.hasData){
      try {
        CountdownTimer a = snapshot.data;
        b = a.remaining.inSeconds.toString();
      }catch(e) {
        print("$_log stream error: $e");
      }
      return Text(b);
    }else{
      return Text("");
    }
  }



}
