
import 'dart:convert';

import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/qr_code_content.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class ChangePasswordPresenterImpl extends BasePresenter implements ChangePasswordPresenter{
  final String _log = "ChangePasswordPresenterImpl";
  final ChangePasswordWidgetView responsibleView;

  Repository _repository;
  CommonPropertySingleton _commonPropertySingleton;

  ChangePasswordPresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();
  }

  @override
  changePasswordButtonListener() async{
    final form = responsibleView.getFormKey().currentState;
    if (form.validate()){
      form.save();
      checkInternetConnection();
    }
  }

  void checkInternetConnection() async{
    responsibleView.setVisibilityOfCircularProgressIndicator(true);
    bool isInternet = await isInternetConnection();
    if (isInternet){
      changeUserPassword();
    }else{
      responsibleView.loadErrorMessage("No_internet");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }
  }

  void changeUserPassword () async{
    String oldPassword = _commonPropertySingleton.getUserPassword();
    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    String newPassword = responsibleView.getUserInputs()[0];
    String confirmNewPassword = responsibleView.getUserInputs()[1];
    responsibleView.getUserInputs().clear();

    String changePasswordResponse = await _repository.changeUserPassword(userToken: userToken, oldPassword: oldPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword);

    print("$_log response: $changePasswordResponse");
    if (changePasswordResponse.isEmpty){
      responsibleView.loadSuccessMessage("successChangePasswordWithLogin");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }else{
      getErrorAndShow(changePasswordResponse);
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
    if (errorMap.containsKey("Error0"))
      responsibleView.loadErrorMessage("validatePassword");
    else if (errorMap.containsKey("model.ConfirmPassword"))
      responsibleView.loadErrorMessage("confirmPasswordError");
    else
      responsibleView.loadErrorMessage("generalError");

  }

}