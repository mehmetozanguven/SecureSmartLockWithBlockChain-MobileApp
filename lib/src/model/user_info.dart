abstract class UserInfo{
  bool isEmailConfirm();
  void setEmailConfirm(bool isConfirm);
  String getUserEmail();
  String getUserFirstName();
  String getUserLastName();
  String getUserPhoneNumber();
}

/// This class is used to get user's information
class UserInfoImpl implements UserInfo{
  String _email, _firstName, _lastName;
  bool _isEmailConfirm, _isPhoneConfirmed;
  double _phoneNum;

  /// Constructor: It is used to convert json response from the backend to
  /// proper object's attributes
  UserInfoImpl.fromJsonResponse(Map<String, dynamic> jsonResponse){
    _email = jsonResponse["Email"];
    _firstName = jsonResponse["FirstName"];
    _lastName = jsonResponse["LastName"];
    _isEmailConfirm = (jsonResponse["EmailConfirmed"]);
    _isPhoneConfirmed = (jsonResponse["PhoneNumberConfirmed"]);
    _phoneNum = double.parse(jsonResponse["PhoneNumber"]);
  }

  bool isEmailConfirm() => _isEmailConfirm;

  void setEmailConfirm(bool isConfirm){
    _isEmailConfirm = isConfirm;
  }

  @override
  String toString() {
    return 'PersonImpl{_email: $_email, _firstName: $_firstName, _lastName: $_lastName, _isEmailConfirm: $_isEmailConfirm, _isPhoneConfirmed: $_isPhoneConfirmed, _phoneNum: $_phoneNum}';
  }

  @override
  String getUserEmail() => _email;

  @override
  String getUserFirstName() => _firstName;

  @override
  String getUserLastName() => _lastName;

  @override
  String getUserPhoneNumber() => _phoneNum.toString();


}