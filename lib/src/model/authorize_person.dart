abstract class AuthorizePerson{
  String getEmail();

  String getDescription();

  String getCreatedOnUTC();

  String getExpiresOnUTC();

  String getExpiresOnLocal();
}

class AuthorizePersonImpl implements AuthorizePerson{
  String _email, _description, _createdOnUTC, _expiresOnUTC, _expiresOnLocal;


  /// Constructor: It is used to convert json response from the backend to
  /// proper object's attributes
  AuthorizePersonImpl.fromJsonResponse(Map<String, dynamic> jsonResponse){
    _email = jsonResponse["Email"];
    _description = jsonResponse["Description"];
    _createdOnUTC = jsonResponse["CreatedOnUTC"];
    _expiresOnUTC = jsonResponse["ExpiresOnUTC"];
    if (_expiresOnUTC != null){
      DateTime dateTime = DateTime.parse(_expiresOnUTC);
      dateTime.toLocal();
      _expiresOnLocal = dateTime.toString();
    }else{
      _expiresOnLocal = "---";
    }

  }

  String getEmail() => _email;

  String getDescription() => _description;

  String getCreatedOnUTC() => _createdOnUTC;

  String getExpiresOnUTC() => _expiresOnUTC;

  String getExpiresOnLocal() => _expiresOnLocal;

  @override
  String toString() {
    return 'AuthorizePersonImpl{_email: $_email, _description: $_description, _createdOnUTC: $_createdOnUTC, _expiresOnUTC: $_expiresOnUTC, _expiresOnLocal: $_expiresOnLocal}';
  }


}