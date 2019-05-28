import 'dart:io';

/// This class defines common action for all presenters
abstract class BasePresenter{

  /// All presenters are responsible for checking whether there is a
  /// internet connection or not.
  /// If phone can look up google.com => then, there is a internet connection,
  ///                                   therefore return true,
  /// Otherwise return false
  Future<bool> isInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      return false;
    }
  }

}