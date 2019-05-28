
abstract class Token{
  String getUserTokenData();
}

/// This class is used to get user's token code
class TokenImpl implements Token{
  String _userToken;

  /// Constructor: It is used to convert json response from the backend to
  /// proper object's attributes
  TokenImpl.fromResponse(Map<String, dynamic> parsedResponse){
    this._userToken = parsedResponse["access_token"];
  }

  String getUserTokenData() => _userToken;

  @override
  String toString() {
    return "User token is $_userToken";
  }
}