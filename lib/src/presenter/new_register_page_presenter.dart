import 'dart:convert';

import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';

class NewRegisterPagePresenterImpl extends BasePresenter implements NewRegisterPagePresenter{
  String log = "NewRegisterPagePresenterImpl";

  RegisterView responsibleView;
  Repository _repository;

  NewRegisterPagePresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
  }

  @override
  newRegisterButtonListener() async {
    final form = responsibleView.getFormKey().currentState;
    if (form.validate()){
      form.save();
      bool checkConfirmPassword = checkUserConfirmPassword(
                              password: responsibleView.getUserInputResult()[3],
                              confirmPassword: responsibleView.getUserInputResult()[4]);

      if (checkConfirmPassword){
        responsibleView.setVisibilityOfCircularProgressIndicator(true);
        await checkInternetConnection();
      }else{
        responsibleView.loadErrorMessage("confirmPasswordError");
      }
    }
    responsibleView.getUserInputResult().clear();
  }

  bool checkUserConfirmPassword({String password, String confirmPassword}) {
    return password == confirmPassword ? true:false;
  }


  Future checkInternetConnection() async {
    bool isInternet = await isInternetConnection();
    if (isInternet){
      await registerNewUser();
    }else{
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
      responsibleView.loadErrorMessage("No_internet");
    }
  }

  Future registerNewUser() async {
    List<String> userInputResult = responsibleView.getUserInputResult();
    String userRegisterResult = await _repository.registerNewUser(
        firstName: userInputResult[0],
        lastName: userInputResult[1],
        email: userInputResult[2],
        password: userInputResult[3],
        confirmPassword: userInputResult[4],
        phoneNum: userInputResult[5]);
    responsibleView.setVisibilityOfCircularProgressIndicator(false);
    if (userRegisterResult == "Fail")
      responsibleView.loadErrorMessage("logInError");
    else if (userRegisterResult == "No_internet")
      responsibleView.loadErrorMessage("No_internet");
    else{
      if (userRegisterResult.isEmpty) // success register
        responsibleView.loadSuccessNewRegisterMessage_navigateLoginPage();
      else // unsuccessful register
        getErrorAndShow(userRegisterResult);
    }
  }

  void getErrorAndShow(String userRegisterResult) {
    print("$log response $userRegisterResult");
    Map<String,dynamic> resultMap = jsonDecode(userRegisterResult);
    print(resultMap);
    if (resultMap.containsKey("ModelState")){
      Map<String, dynamic> errorMap = resultMap["ModelState"];
      getErrorFromModelState(errorMap);
    }
  }

  void getErrorFromModelState(Map<String, dynamic> errorMap) {
    if (errorMap.containsKey("Error1"))
      responsibleView.loadErrorMessage("emailAlreadyTaken");
    else if (errorMap.containsKey("Error0"))
      responsibleView.loadErrorMessage("validatePassword");
    else if (errorMap.containsKey("model.Email"))
      responsibleView.loadErrorMessage("validateEmail");
    else
      responsibleView.loadErrorMessage("generalError");

  }







}