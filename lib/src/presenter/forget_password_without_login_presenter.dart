
import 'dart:convert';

import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class ForgetPasswordWithoutLoginPresenterImpl extends BasePresenter implements ForgetPasswordWithoutRegisterPresenter{
  final String _log = "ForgetPasswordWithoutLoginPresenterImpl";
  final ForgetPasswordWithoutLoginView responsibleView;
  Repository _repository;

  bool _isEmailState, _isEmailTokenState, _isPasswordState;
  String _userEmail, _userEmailConfirmCode, _userNewPassword, _userNewPasswordConfirm;
  List<String> _userInputResults;

  ForgetPasswordWithoutLoginPresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _isEmailState = true;
    _isEmailTokenState = false;
    _isPasswordState = false;
  }

  @override
  changePasswordListener() async {
    print("$_log changePasswordListener");
    final form = responsibleView.getFormKey().currentState;
    if (form.validate()){
      form.save();
      responsibleView.setVisibilityOfCircularProgressIndicator(true);

      _userInputResults = responsibleView.getUserInputResult();

      bool isInternet = await checkInternetConnection();
      if (isInternet){
        sendDataToBackend();
      }else{
        responsibleView.setVisibilityOfCircularProgressIndicator(false);
        responsibleView.loadErrorMessage("No_internet");
      }
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
      responsibleView.getUserInputResult().clear();
    }

  }

  void sendDataToBackend() async{
    if (_isEmailState){
      _userEmail = _userInputResults[0];
      String emailConfirm = await _repository.emailVerificationForForgetPasswordWithoutLogin(usermail: _userEmail);
      checkErrorForEmailState(emailConfirm);
    }else if (_isEmailTokenState){
      _userEmailConfirmCode = _userInputResults[1];
      String emailConfirmCode = await _repository.emailConfirmCodeForForgetPasswordWithoutLogin(usermail: _userEmail, confirmCode: _userEmailConfirmCode);
      print("emailConfirm : $emailConfirmCode");
      checkErrorForEmailTokenState(emailConfirmCode);
    }else if (_isPasswordState){
      _userNewPassword = _userInputResults[2];
      _userNewPasswordConfirm = _userInputResults[3];
      String newPasswordValidation = await _repository
          .confirmNewPasswordForForgetPasswordWithoutLogin(usermail: _userEmail,
          confirmCode: _userEmailConfirmCode,
          newPassword: _userNewPassword,
          confirmNewPassword: _userNewPasswordConfirm);
      checkErrorForPasswordState(newPasswordValidation);
    }else{
      responsibleView.loadGeneralError_navigateLoginPage();
    }
  }


  Future<bool> checkInternetConnection() async {
    bool isInternet = await isInternetConnection();
    if (isInternet){
      return true;
    }else{
      return false;
    }
  }

  void checkErrorForEmailState(String emailConfirm) {
    responsibleView.setVisibilityOfCircularProgressIndicator(false);

    if (emailConfirm.isNotEmpty){
      Map<String, dynamic> resultMap = jsonDecode(emailConfirm);
      if (resultMap.containsKey("ModelState")){
        Map<String, dynamic> errorMap = resultMap["ModelState"];
        showErrorFromModelState(errorMap);
      }
    }else{
      responsibleView.setVisibilityOfUserTextInputs(emailTextVisibility: false, emailConfirmCodeVisibility: true, newPasswordVisiblity: false);
      _isEmailState = false;
      _isEmailTokenState = true;
    }
  }

  void checkErrorForEmailTokenState(String emailTokenCode){
    responsibleView.setVisibilityOfCircularProgressIndicator(false);

    if (emailTokenCode.isNotEmpty){
      Map<String, dynamic> resultMap = jsonDecode(emailTokenCode);
      if (resultMap.containsKey("ModelState")){
        Map<String, dynamic> errorMap = resultMap["ModelState"];
        showErrorFromModelState(errorMap);
      }
    }else{
      responsibleView.setVisibilityOfUserTextInputs(emailTextVisibility: false, emailConfirmCodeVisibility: false, newPasswordVisiblity: true);
      _isEmailState = false;
      _isEmailTokenState = false;
      _isPasswordState = true;
    }
  }

  void checkErrorForPasswordState(String newPasswordValidation) {
    responsibleView.setVisibilityOfCircularProgressIndicator(false);

    if (newPasswordValidation.isNotEmpty){
      Map<String, dynamic> resultMap = jsonDecode(newPasswordValidation);
      if (resultMap.containsKey("ModelState")){
        Map<String, dynamic> errorMap = resultMap["ModelState"];
        showErrorFromModelState(errorMap);
      }
    }else{
      responsibleView.setVisibilityOfUserTextInputs(emailTextVisibility: false, emailConfirmCodeVisibility: false, newPasswordVisiblity: false);
      _isEmailState = false;
      _isEmailTokenState = false;
      _isPasswordState = false;
      responsibleView.loadSuccessMessage_navigateLoginPage();
    }
  }

  void showErrorFromModelState(Map<String, dynamic> errorMap) {
    if (errorMap.containsKey("Email"))
      responsibleView.loadErrorMessage("validateEmail");
    else if (errorMap.containsKey("ConfirmationToken") || errorMap.containsKey("model.ConfirmationToken"))
      responsibleView.loadErrorMessage("confirmationToken");
    else if (errorMap.containsKey("model.NewPassword") || errorMap.containsKey("Error0"))
      responsibleView.loadErrorMessage("validatePassword");
    else if (errorMap.containsKey("model.ConfirmPassword"))
      responsibleView.loadErrorMessage("confirmPasswordError");
    else
      responsibleView.loadErrorMessage("generalError");
  }





}

