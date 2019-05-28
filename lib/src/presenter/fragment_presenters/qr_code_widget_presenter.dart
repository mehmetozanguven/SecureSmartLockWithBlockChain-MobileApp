

import 'dart:convert';

import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/model/qr_code_content.dart';
import 'package:smart_lock/src/presenter/base_presenter/base_presenter.dart';
import 'package:smart_lock/src/presenter/presenter_Interfaces/presenter_interfaces.dart';
import 'package:smart_lock/src/repository/repository.dart';
import 'package:smart_lock/src/view/view_Interfaces/view_interfaces.dart';

class QrCodeWidgetPresenterImpl extends BasePresenter implements QrCodeWidgetPresenter{
  final String _log = "QrCodeWidgetPresenterImpl";

  final QrCodeWidgetView responsibleView;

  Repository _repository;
  CommonPropertySingleton _commonPropertySingleton;

  QrCodeWidgetPresenterImpl(this.responsibleView){
    _repository = RepositoryImpl();
    _commonPropertySingleton = CommonPropertySingleton();
  }

  @override
  resetQrCodeButtonListener() async{
    responsibleView.setVisibilityOfCircularProgressIndicator(true);
    bool isInternet = await isInternetConnection();
    if (isInternet){
      resetQrCode();
    }else{
      responsibleView.loadErrorMessage("No_internet");
      responsibleView.setVisibilityOfCircularProgressIndicator(false);
    }
  }

  resetQrCode() async{
    String userToken = _commonPropertySingleton.getUserToken().getUserTokenData();
    String newQrCodeContent = await _repository.resetQrCodeContent(userToken: userToken);
    if (isErrorDecodeUserQrCodeContent(newQrCodeContent)){
      responsibleView.loadErrorMessage("generalError");
    }else{
      responsibleView.resetQrCodeContent();
    }
    responsibleView.setVisibilityOfCircularProgressIndicator(false);
  }

  bool isErrorDecodeUserQrCodeContent(String qrCodeContent) {
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