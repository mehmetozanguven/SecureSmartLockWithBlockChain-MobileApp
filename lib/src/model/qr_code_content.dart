abstract class QrCodeContent{
  int getDurationInSecond();

  String getQrCodeContent();
}

/// This class is used to get user's qr code content
class QrCodeContentImpl implements QrCodeContent{
  String _qrCodeContent, _expirationDateTime, _creationDateTime;
  int _durationInSecond;

  /// Constructor: It is used to convert json response from the backend to
  /// proper object's attributes
  QrCodeContentImpl.fromJsonResponse(Map<String, dynamic> jsonResponse){
    _qrCodeContent = jsonResponse["QRCode"];
    _durationInSecond = jsonResponse["DurationInSeconds"];
    _expirationDateTime = jsonResponse["ExpiresOnUTC"];
    _creationDateTime = (jsonResponse["CreatedOnUTC"]);
  }

  @override
  String toString() {
    return 'QrCodeImpl{_qrCodeContent: $_qrCodeContent, _durationInSecond: $_durationInSecond, _expirationDateTime: $_expirationDateTime, _creationDateTime: $_creationDateTime}';
  }

  int getDurationInSecond() => _durationInSecond;

  String getQrCodeContent() => _qrCodeContent;

}