
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/authorize_person.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/authorized_people_extend_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/src/localization/localization.dart';

class AuthorizePeopleExtendWidget extends StatefulWidget {
  final Device deviceItem;

  AuthorizePeopleExtendWidget({@required this.deviceItem});

  @override
  _AuthorizePeopleExtendWidgetState createState() => _AuthorizePeopleExtendWidgetState(deviceItem);
}

class _AuthorizePeopleExtendWidgetState extends State<AuthorizePeopleExtendWidget> implements AuthorizedPeopleExtendView{
  final String _log = "_AuthorizePeopleExtendWidgetState";

  final Device _deviceItem;
  AuthorizedPeopleExtendPresenter _authorizedPeopleExtendPresenter;
  CommonPropertySingleton _commonPropertySingleton;

  _AuthorizePeopleExtendWidgetState(this._deviceItem){
    _authorizedPeopleExtendPresenter = AuthorizedPeopleExtendPresenterImpl(this);
    _commonPropertySingleton = CommonPropertySingleton();
  }

  void navigateToPreviousPage(){
    Navigator.of(context).pop(true);
  }

  @override
  Device getDeviceItem() {
    return _deviceItem;
  }

  @override
  void dispose() {
    super.dispose();
    _authorizedPeopleExtendPresenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Localization.of(context).getText(text: "authorized_people")),
        ),
        body: Container(
          padding: EdgeInsets.all(12.0),
          child:buildFormChildWidget(context),
        )
    );
  }

  buildFormChildWidget(BuildContext context) {
     Text infoText = Text(
         Localization.of(context).getText(text: "authenticated_users"),
         style: _commonPropertySingleton.buildTextStyle(context: context)
     );

     Text loadingText = Text(
       Localization.of(context).getText(text: "loading"),
       style: _commonPropertySingleton.buildTextStyle(context: context, isTitleFontSize: false),
     );

     Text emptyListText = Text(
       Localization.of(context).getText(text: "empty_authenticated_user"),
       style: _commonPropertySingleton.buildTextStyle(context: context, isTitleFontSize: false),
     );

     Text generalErrorText = Text(
       Localization.of(context).getText(text: "generalError"),
       style: _commonPropertySingleton.buildTextStyle(context: context, isTitleFontSize: false),
     );

     StreamBuilder<String> userInfoStream = StreamBuilder<String>(
       stream: _authorizedPeopleExtendPresenter.getAuthenticatedUserListSteam(),
       initialData: "loading",
       builder: (context, snapshot){
         if (snapshot.data == "loading")
           return loadingText;
         else if (snapshot.data == "empty")
           return emptyListText;
         else if (snapshot.data == "done")
           return Container();
         else if (snapshot.hasError)
           return generalErrorText;
         else
           return generalErrorText;
       },
     );

     List<Widget> children = [
       Center(child: infoText),
       SizedBox(height: 30.0,),
       Center(child: userInfoStream),
       buildAuthorizePersonList()
     ];
     return ListView(children: children,);
  }

  StreamBuilder buildAuthorizePersonList(){
    StreamBuilder<List<AuthorizePerson>> authorizePersonList = StreamBuilder<List<AuthorizePerson>>(
      stream: _authorizedPeopleExtendPresenter.getAuthorizePersonStream(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          if (snapshot.data.isEmpty){
            return Container();
          }else{
            return buildColumnPersonList(snapshot.data);
          }
        }else
          return Container();
      },
    );
    return authorizePersonList;
  }

  Column buildColumnPersonList(List<AuthorizePerson> authPersonList){
    List<Widget> columnChildren = List();

    authPersonList.forEach((elem) => columnChildren.add(buildClickableColumnElement(elem)));

    return Column(
      children: columnChildren,
    );
  }

  InkWell buildClickableColumnElement(AuthorizePerson authorizePerson){
    InkWell inkwell = InkWell(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0,),
          _commonPropertySingleton.buildTwoRowTextWidgets(context: context,
              propertyName: Localization.of(context).getText(text: "email"),
              propertyValue: authorizePerson.getEmail(),
              isTitleFontSize: false),
          SizedBox(height: 10.0,),
          _commonPropertySingleton.buildTwoRowTextWidgets(context: context,
              propertyName: Localization.of(context).getText(text: "description_short"),
              propertyValue: authorizePerson.getDescription(),
              isTitleFontSize: false),
          SizedBox(height: 10.0,),
          _commonPropertySingleton.buildTwoRowTextWidgets(context: context,
              propertyName: Localization.of(context).getText(text: "authenticed_user_timeleft"),
              propertyValue: authorizePerson.getExpiresOnLocal(),
              isTitleFontSize: false),
          SizedBox(height: 10.0,),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColorDark,
            height: 3.0,
          ),
        ],
      ),
      onTap: () {
        String deletedMail = authorizePerson.getEmail();
        showAlertDialogToDelete(deletedMail);
      },
    );
    return inkwell;
  }


  void showAlertDialogToDelete(String deletedMail){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
      new AlertDialog(
        title: new Text(Localization.of(context).getText(text: "delete_user_alert_diaglog")),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              _authorizedPeopleExtendPresenter.getDeleteUserListenerStreamInput().add(false);
            },
            child: new Text(Localization.of(context).getText(text: "no")),
          ),
          new FlatButton(
            onPressed: () {
              _authorizedPeopleExtendPresenter.getDeviceCodeListenerStreamInput().add(_deviceItem.getDeviceCode());
              _authorizedPeopleExtendPresenter.getMailListenerStreamInput().add(deletedMail);
              _authorizedPeopleExtendPresenter.getDeleteUserListenerStreamInput().add(true);
              Navigator.of(context).pop(true);
            },
            child: new Text(Localization.of(context).getText(text: "yes")),
          ),
        ],
      ),
    ) ?? false;
  }



}
