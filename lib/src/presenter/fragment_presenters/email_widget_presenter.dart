import 'dart:convert';

import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';


class EmailPresenterImpl extends BasePresenter implements EmailPresenter{


  final String _log = "EmailPresenterImpl";
  final EmailWidgetView responsibleView;

  Repository _repository;
  CommonPropertySingleton _commonPropertySingleton;

  EmailPresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();
  }

  @override
  emailActivateButtonListener() {
    final form = responsibleView.getFormKey().currentState;
    if (form.validate()){
      form.save();
      checkInternetConnection();
    }
  }

  void checkInternetConnection({bool isEmailActiveButtonClicked = true}) async{
    responsibleView.setVisibilityOfCircularProgressIndicator(true);
    bool isInternet = await isInternetConnection();
    if (isInternet){
      if (isEmailActiveButtonClicked)
        activateEmail();
      else
        resendEmailActivateCode();
    }else{
      responsibleView.loadErrorMessage("No_internet");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }
  }

  void activateEmail () async{
    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    String activatedCode = responsibleView.getUserInputs()[0];
    responsibleView.getUserInputs().clear();

    String emailValidationResponse = await _repository.activateEmail(userToken: userToken, validationCode: activatedCode);

    if (emailValidationResponse.isEmpty){
      responsibleView.loadSuccessMessage("successEmailActivation");
      _commonPropertySingleton.getUserDrawerMenu().exitAppWithSpecificDelay();
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }else{
      getErrorAndShow(emailValidationResponse);
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }
  }

  void getErrorAndShow(String changePasswordResponse) {
    Map<String,dynamic> resultMap = jsonDecode(changePasswordResponse);
    if (resultMap.containsKey("ModelState")){
      Map<String, dynamic> errorMap = resultMap["ModelState"];
      getErrorFromModelState(errorMap);
    }
  }

  void getErrorFromModelState(Map<String, dynamic> errorMap) {
    if (errorMap.containsKey("ConfirmaEmailToken"))
      responsibleView.loadErrorMessage("confirmationToken");
    else
      responsibleView.loadErrorMessage("generalError");
  }

  @override
  resendActivationCodeButtonListener() {
    checkInternetConnection(isEmailActiveButtonClicked: false);
  }

  void resendEmailActivateCode() async{
    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    String resendEmailCodeResponse = await _repository.resendEmailActivationCode(userToken: userToken);

    if (resendEmailCodeResponse.isEmpty){
      responsibleView.loadSuccessMessage("emailCodeSent");
    }else{
      responsibleView.loadErrorMessage("generalError");
    }
    responsibleView.setVisibilityOfCircularProgressIndicator(false);

  }

}