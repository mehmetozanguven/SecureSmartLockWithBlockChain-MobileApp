import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:smart_lock/src/model/devices_list.dart';
import 'package:smart_lock/src/presenter/fragment_presenters/update_people_extend_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

/// Stateful widget responsible for update/add authenticated person to specific
/// device.
/// Device is determined by the constructor
class UpdatePeopleExtendWidget extends StatefulWidget {

  final Device deviceItem;

  UpdatePeopleExtendWidget({@required this.deviceItem});

  @override
  _UpdatePeopleExtendWidgetState createState() => _UpdatePeopleExtendWidgetState(deviceItem);
}

class _UpdatePeopleExtendWidgetState extends State<UpdatePeopleExtendWidget> implements UpdatePeopleExtendWidgetView {
  final String _log = "_UpdatePeopleExtendWidgetState";

  final Device deviceItem;

  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  CommonPropertySingleton _commonPropertySingleton;
  UpdatePeopleExtendPresenter _updatePeoplePresenterImpl;
  DateTime _currentDate;
  TimeOfDay _currentTime;

  /// _formKey for save the user input and validate
  /// _scaffoldKey to show snackbar
  /// _commonPropertySingleton to access common widgets, user token etc..
  /// _updatePeoplePresenterImpl to create this widget's presenter
  /// _currentDate and _currentTime to show the user current time and date.
  _UpdatePeopleExtendWidgetState(this.deviceItem){
    _formKey = GlobalKey<FormState>();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _commonPropertySingleton = CommonPropertySingleton();
    _updatePeoplePresenterImpl = UpdatePeopleExtendPresenterImpl(this);
    _currentDate = DateTime.now();
    _currentTime = TimeOfDay.now();
  }

  /// getter method of _formKey
  /// This widget's presenter will need this. To validate user input
  GlobalKey<FormState> getFormKey() => _formKey;

  /// Specific device item getter,
  /// This widget's presenter will need this. To send update/add request
  /// to correct device.
  Device getDeviceItem() => deviceItem;

  /// load snack bar message,
  /// because of stream builder must return a widget
  /// I can not return widget and snack bar at the same time
  /// Therefore I add some delay to show widget and snack bar
  @override
  loadMessage(String message) async{
    await Future.delayed(Duration(milliseconds: 400));
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(Localization.of(context).getText(text: message)),
    ));
  }

  /// dispose method to close stream controller
  @override
  void dispose() {
    super.dispose();
    _updatePeoplePresenterImpl.dispose();
  }

  /// build method of this widget
  /// because of user inputs, body Container child is form widget
  @override
  Widget build(BuildContext context) {
    print("$_log build(BuildContext context) runs");
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text(Localization.of(context).getText(text: "new_person")),
        ),
        body: Container(
          padding: EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: buildFormChildWidget(context),
          ),
        )
    );
  }

  /// Form widget children
  /// It builds authenticated email, description text form fields,
  /// and also switch to determine infinite access or not
  /// according to the switch, new widget will be arises
  ListView buildFormChildWidget(BuildContext context) {
    return ListView(
      children: <Widget>[
        _commonPropertySingleton.buildTwoRowTextWidgets(context: context, propertyName: Localization.of(context).getText(text: "deviceName"), propertyValue: deviceItem.getDeviceName() ),
        SizedBox(height: 20.0,),
        _commonPropertySingleton.buildTwoRowTextWidgets(context: context, propertyName: Localization.of(context).getText(text: "deviceCode"), propertyValue: deviceItem.getDeviceCode() ),
        SizedBox(height: 20.0,),
        buildUserInputWidget(context, Localization.of(context).getText(text: "email"),
            Localization.of(context).getText(text: "add_new_person_email")),
        buildUserInputWidget(context, Localization.of(context).getText(text: "description_short"),
            Localization.of(context).getText(text: "description"), isMailInput: false),
        buildSwitchListTileForInfiniteAccess(context),
        SizedBox(height: 20.0,),
        buildWidgetAccordingToSwitchValue()
      ],
    );
  }

  /// Widget that builds user mail and description text form field
  /// if parameter isMailInput = true, then it is a user mail form field
  /// if not, then it is a description form field
  StreamBuilder buildUserInputWidget(BuildContext context, String hintText, String inputType, {bool isMailInput = true}) {
    InputDecoration inputDecoration = _commonPropertySingleton
        .getInputDecoration(hintText: hintText, inputType: inputType);
    return StreamBuilder<bool>(
      stream: _updatePeoplePresenterImpl.getProgressIndicatorStream(),
      initialData: false,
      builder: (context, snapshot){
        return Padding(
          padding: EdgeInsets.all(12.0),
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty)
                return Localization.of(context).getText(text: "fillArea");
            },
            enabled: !snapshot.data,
            decoration: inputDecoration,
            onSaved: (value) => isMailInput ? _updatePeoplePresenterImpl.setPermittedMail(value) : _updatePeoplePresenterImpl.setDescription(value),
          ),
        );
      },
    );

  }

  /// This widget builds switch to determine infinite access or not
  /// If switch is true, that's means infinite access
  /// There is a switch stream to change switch position
  /// Initial data for switch stream is false, that's means for initial building
  /// switch value will be false
  /// When switch value is changed, that value will be added that stream
  /// to determine other widgets for example if switch is false, then I will show
  /// the select date and day widget
  StreamBuilder buildSwitchListTileForInfiniteAccess(BuildContext context) {
    StreamBuilder<bool> switchStreamBuilder = StreamBuilder<bool>(
      stream: _updatePeoplePresenterImpl.getSwitchStream(),
      initialData: false,
      builder: (context, snapshot){
        return SwitchListTile(
            title: Text(
              Localization.of(context).getText(text: "infinite_access"),
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: Theme.of(context).textTheme.subhead.fontSize
              ),
            ),
            value: snapshot.data,
            secondary: Icon(Icons.error),
            onChanged: (bool value){
              print("$_log onchanges switch value : $value");
              _updatePeoplePresenterImpl.getSwitchStreamInput().add(value);
            }
        );
      },
    );

    return switchStreamBuilder;

  }

  /// This stream will build a widget according to the switch stream value
  /// If switch stream value is false, then it will build widget which is about
  /// choosing specific time and also it will add value to another stream which is
  /// "isSpecificPermission" stream. Otherwise build infinite permission widget
  /// I need "isSpecificPermission" stream because I use one stream for both
  /// infinite permission widget and specific time permission widget. Therefore I should separate
  /// inputs to understand it is coming from infinite permission widget or specific time permission widget
  StreamBuilder<bool> buildWidgetAccordingToSwitchValue() {
    return StreamBuilder<bool>(
      stream: _updatePeoplePresenterImpl.getSwitchStream(),
      initialData: false,
      builder: (context, snapshot){
        if  (snapshot.data){
          _updatePeoplePresenterImpl.getIsSpecificPermissionStreamInput().add(false);
          print("$_log buildWidgetAccordingToSwitchValue has data");
          return buildInfinitePermissionWidget();
        }else{
          _updatePeoplePresenterImpl.getIsSpecificPermissionStreamInput().add(true);
          print("$_log buildWidgetAccordingToSwitchValue has no data");
          return buildSpecificTimePermissionWidget();
        }
      },
    );
  }

  /// Builds infinite permission widget
  /// When user press' the button, button will add a value to the stream which is
  /// only device itself. Because of presenter listening that stream already,
  /// (look at the line "_sendPermissionToRepoStreamController.stream.listen(permissionListener);" in the presenter)
  /// it will take the device item object and send to the repository with
  /// correspond value (presenter will also check _isSpecificPermissionStream input,
  /// if it is false, then it will create a expiresOnUTC parameter as empty,
  /// otherwise it will check the whether user choose the date and day not.)
  ///
  /// Repo operation output will be getting via permissionResponse stream(presenter will
  /// add an value to that stream)
  /// If there is an error in that, then show the error, otherwise show the data
  Container buildInfinitePermissionWidget() {
      StreamBuilder<bool> giveAccessButtonStream = StreamBuilder<bool>(
        stream: _updatePeoplePresenterImpl.getProgressIndicatorStream(),
        initialData: false,
        builder: (context, snapshot){
          return RaisedButton(
              child: _commonPropertySingleton.buildRaisedButtonTextChild(
                  context: context,
                  text: Localization.of(context).getText(text: "give_access")),
          color: Theme.of(context).primaryColor,
          shape: _commonPropertySingleton.buildBorderForRaisedButton(),
              onPressed: snapshot.data ? null : () =>
                  _updatePeoplePresenterImpl.getSendPermissionToRepoStreamInput().add(
                      deviceItem)
          );
        },
      );

      StreamBuilder<String> infinitePermissionListener = StreamBuilder<String>(
        stream: _updatePeoplePresenterImpl.getPermissionResponseStream(),
        initialData: null,
        builder: (context, snapshot){
          if (snapshot.hasData){
            loadMessage(snapshot.data);
          }else if (snapshot.hasError){
            loadMessage(snapshot.error);
          }
          _updatePeoplePresenterImpl.getPermissionResponseStreamInput().add(null);
          return Container();
        },
      );

      Column containerChild = Column(
        children: <Widget>[
          giveAccessButtonStream,
          SizedBox(height: 12.0,),
          infinitePermissionListener,
          SizedBox(height: 12.0,),
          buildProgressIndicator()
        ],
      );

      Container infinitePermissionWidget = Container(
        child: containerChild,
      );
      return infinitePermissionWidget;
  }

  Container buildSpecificTimePermissionWidget() {
    StreamBuilder<DateTime> dateTimeTextWidget = StreamBuilder<DateTime>(
      stream: _updatePeoplePresenterImpl.getDateStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
              "${snapshot.data.day}:${snapshot.data.month}:${snapshot.data.year}");
        } else {
          return Container();
        }
      },
    );

    StreamBuilder<bool> selectDateButton = StreamBuilder<bool>(
      stream: _updatePeoplePresenterImpl.getProgressIndicatorStream(),
      initialData: false,
      builder: (context, snapshot){
        return RaisedButton(
            child: _commonPropertySingleton.buildRaisedButtonTextChild(
                context: context,
                text: Localization.of(context).getText(text: "select_date")),
            onPressed: snapshot.data ? null : () => _selectDate(context),
            color: Theme.of(context).primaryColor,
            shape: _commonPropertySingleton.buildBorderForRaisedButton()
        );
      },
    );

    StreamBuilder<TimeOfDay> timeOfDayTextWidget = StreamBuilder<TimeOfDay>(
      stream: _updatePeoplePresenterImpl.getTimeOfDayStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text("${snapshot.data.hour}:${snapshot.data.minute}");
        } else {
          return Container();
        }
      },
    );

    StreamBuilder<bool> selectTimeOfDayButton = StreamBuilder<bool>(
      stream: _updatePeoplePresenterImpl.getProgressIndicatorStream(),
      initialData: false,
      builder: (context, snapshot){
        return RaisedButton(
            child: _commonPropertySingleton.buildRaisedButtonTextChild(
                context: context,
                text: Localization.of(context).getText(text: "select_time")),
            onPressed: snapshot.data ? null : () => _selectTime(context),
            color: Theme.of(context).primaryColor,
            shape: _commonPropertySingleton.buildBorderForRaisedButton()
        );
      },
    );

    StreamBuilder<bool> giveAccessButtonStream = StreamBuilder<bool>(
      stream: _updatePeoplePresenterImpl.getProgressIndicatorStream(),
      initialData: false,
      builder: (context, snapshot){
        return RaisedButton(
            child: _commonPropertySingleton.buildRaisedButtonTextChild(
                context: context,
                text: Localization.of(context).getText(text: "give_access")),
            onPressed: snapshot.data ? null :() {
//              _updatePeoplePresenterImpl.getIsSpecificPermissionStreamInput().add(true);
              _updatePeoplePresenterImpl.getSendPermissionToRepoStreamInput().add(deviceItem);
            },
            color: Theme.of(context).primaryColor,
            shape: _commonPropertySingleton.buildBorderForRaisedButton()
        );
      },
    );

    StreamBuilder<String> specificTimePermissionListener = StreamBuilder<String>(
      stream: _updatePeoplePresenterImpl.getPermissionResponseStream(),
      initialData: null,
      builder: (context, snapshot){
        if (snapshot.hasData){
          loadMessage(snapshot.data);
        }else if (snapshot.hasError){
          loadMessage(snapshot.error);
        }
        _updatePeoplePresenterImpl.getPermissionResponseStreamInput().add(null);
        return Container();
      },
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          dateTimeTextWidget,
          selectDateButton,
          SizedBox(height: 5.0,),
          timeOfDayTextWidget,
          selectTimeOfDayButton,
          SizedBox(height: 12.0,),
          giveAccessButtonStream,
          buildProgressIndicator(),
          specificTimePermissionListener
        ],
      ),
    );
  }

  StreamBuilder buildProgressIndicator(){
    StreamBuilder<bool> progressIndicator = StreamBuilder<bool>(
      stream: _updatePeoplePresenterImpl.getProgressIndicatorStream(),
      initialData: false,
      builder: (context, snapshot){
        return _commonPropertySingleton.showCircularProgressIndicator(show: snapshot.data);
      },
    );
    return progressIndicator;
  }

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _currentDate,
        firstDate: _currentDate,
        lastDate: _currentDate.add(Duration(days: 10)));

    if (picked != null){
      _updatePeoplePresenterImpl.getDateStreamInput().add(picked);
      print("$_log selected date : ${picked.toString()}");
    }
  }

  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _currentTime);
    if (picked != null){
      _updatePeoplePresenterImpl.getTimeOfDayStreamInput().add(picked);
    }
  }


}
