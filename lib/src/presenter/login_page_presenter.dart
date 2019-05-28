import 'dart:convert';


import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/qr_code_content.dart';
import 'package:smart_lock/src/model/token.dart';
import 'package:smart_lock/src/model/user_info.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class LoginPagePresenterImpl extends BasePresenter implements LoginPagePresenter {
  final String _log = "LoginPagePresenterImpl";

  final LoginView responsibleView;
  Repository _repository;

  String _usermail;
  String _userpassword;
  Token _userToken;
  CommonPropertySingleton _commonPropertySingleton;

  LoginPagePresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();
  }

  /// get user's email inputs when form is saved
  @override
  getUserEmail(String usermail) {
    _usermail = usermail;
  }

  /// get user's password inputs when form is saved
  @override
  getUserPassword(String userpassword) {
    _userpassword = userpassword;
    _commonPropertySingleton.assignUserPassword(userpassword);
  }

  /// Login button listener.
  /// first check form is validate ,
  /// if it is validate, then check internet connection
  @override
  loginButtonListener() async {
    final form = responsibleView.getFormKey().currentState;
    if (form.validate()){
      form.save();
      responsibleView.setVisibilityOfCircularProgressIndicator(true);
      print("$_log user email : $_usermail");
      checkInternetConnection();
    }
  }

  /// If user has internet connection, get necessary user information
  /// otherwise, inform the user "no internet"
  checkInternetConnection() async {
    bool isInternet = await isInternetConnection();
    if (isInternet){
      getUserLogInDataFromRepository();
    }else{
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
      responsibleView.loadErrorMessage("No_internet");
    }
  }

  /// wait for userToken from backend
  /// if userToken is "fail" or "No_internet", inform the user corresponds errors
  /// otherwise create new UserToken object and assign userToken
  ///           add this object to the CommonHolder Singleton object
  ///           now get userInfo from backend
  getUserLogInDataFromRepository() async {
    String userTokenResult = await (_repository.getUserToken(_usermail, _userpassword));
    print("$_log user token : $userTokenResult");
    if (userTokenResult == "Fail"){
      responsibleView.loadErrorMessage("logInError");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }
    else if (userTokenResult == "No_internet"){
      responsibleView.loadErrorMessage("No_internet");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }
    else{
        _userToken = TokenImpl.fromResponse(json.decode(userTokenResult));
        _commonPropertySingleton.assignUserToken(_userToken);
        getUserInfo();
    }
  }

  /// wait for userInfo from backend
  /// decode this response (userInfo)
  /// If there is an error after decoding =>
  ///         inform the user(actually this error causes from developer site,
  ///              therefore inform the user about general Error -something went wrong ... -)
  ///              and close the circular process
  /// otherwise, now get user's qr code content from backend
  void getUserInfo() async{
    String userInfoResult =  await (_repository.getUserInfo(userToken: _commonPropertySingleton.getUserToken().getUserTokenData()));
    print("$_log User info : $userInfoResult");
    bool isErrorDecodedUserInfo = isDecodeUserInfo(userInfoResult);
    if (isErrorDecodedUserInfo){
      responsibleView.loadErrorMessage("generalError");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }else{
      getUserQrCodeContent();
    }
  }

  /// wait for userQrCode content from backend
  /// decode this response (userQrCode)
  /// If there is an error after decoding =>
  ///         inform the user(actually this error causes from developer site,
  ///              therefore inform the user about general Error -something went wrong ... -)
  ///              and close the circular process
  /// otherwise, now get user's qr code content from backend
  void getUserQrCodeContent() async{
    String qrCodeContent = await (_repository.getQrCodeContent(userToken: _commonPropertySingleton.getUserToken().getUserTokenData()));
    print("$_log UserQrCode response : $qrCodeContent");
    bool isErrorDecodedUserQrCodeContent = isDecodeUserQrCodeContent(qrCodeContent);
    if (isErrorDecodedUserQrCodeContent){
      responsibleView.loadErrorMessage("generalError");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }else{
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
      responsibleView.loadUserQrCodePage();
    }
  }
  /// userInfo decoding method
  /// If decoding is succeed, then create new UserInfo object from userInfo
  ///                       , assign to CommonProperty object and return true
  /// Otherwise return false
  bool isDecodeUserInfo(String userInfoResult) {
    JsonCodec jsonCodec = JsonCodec();
    bool isErrorOccured = false;
    try {
      var decodedJson = jsonCodec.decode(userInfoResult);
      UserInfo userInfo = UserInfoImpl.fromJsonResponse(decodedJson);
      _commonPropertySingleton.assignUserInfo(userInfo);
      print("$_log UserInfo object: $userInfo");
    } catch (e) {
      isErrorOccured = true;
      print("$_log, error occured when decoded response : $e");
    }
    return isErrorOccured;
  }

  /// userQrCode decoding method
  /// If decoding is succeed, then create new QrCodeContent object from userQrCode
  ///                       , assign to CommonProperty object and return true
  /// Otherwise return false
  bool isDecodeUserQrCodeContent(String qrCodeContent) {
    JsonCodec jsonCodec = JsonCodec();
    bool isErrorOccurred = false;

    try {
      var decodedJson = jsonCodec.decode(qrCodeContent);
      QrCodeContent userQrCodeContent= QrCodeContentImpl.fromJsonResponse(decodedJson);
      _commonPropertySingleton.assignQrCodeContent(userQrCodeContent);
      print("$_log UserQrCode object: $userQrCodeContent");
    } catch (e) {
      print("$_log, error occured when decoded response : $e");
      isErrorOccurred = true;
    }
    return isErrorOccurred;
  }
}