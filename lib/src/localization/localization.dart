import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

/// This class is used to convert between English words and Turkish words
/// If user's phone location is in Turkish => Turkish words
/// otherwise => English words
class Localization{

  Localization(this.locale);

  final Locale locale;

  static Localization of(BuildContext context){
    return Localizations.of<Localization>(context, Localization);
  }

  /// Common words and translation of each them:
  static Map<String, Map<String, String>> _localizedValues ={
    'en':{
      'No_internet': "Check internet connection",
      'logIn': 'Login',
      'email': 'Email',
      'title': 'Smart Lock',
      'enterMail': 'Enter your email',
      'password':'Write your password',
      'passwordHint':"Password",
      'createAccount':"Create new account",
      'forgetPassword':"Forget Password",
      'validateEmail':"Email is not valid",
      'validatePassword':"Password must have at least 6 chars and 1 number",
      'logInError' : 'Email or password incorrect',
      'registerPage':'Registration Form',
      'name':'Name',
      'surname':'Surname',
      'phone':'Numara',
      'confirmPassword':'Confirm password',
      'register':'Register',
      'fillArea':'Fill area',
      'confirmPasswordError': 'Confirmation Password is wrong',
      'phoneError' : 'Only use digits',
      'longString' : "Not longer than 50 chars",
      'generalError': 'Something went wrong, try again',
      'successRegisterMessage': 'Successfully register, navigating to Login page',
      'emailAlreadyTaken' : 'This email is already taken',
      'emailConfirmCode' : 'Email confirm code',
      'enterEmailConfirmCode': 'Enter email confirm code',
      'changePasswordButton' : 'Change Password',
      'confirmationToken' : 'Invalid email confirm code or code has expired',
      'successChangePassword' : 'Successfully change your password, navigating to Login page',
      'generalError_navigateLogin' : 'Something went wrong, navigating to Login page',
      'userPage' : 'User Page',
      'exitUserPage': 'Are you sure?',
      'yes' : 'Yes',
      'no' : 'No',
      'home': 'Home',
      'profile' : 'Profile',
      'devices_menu' : 'Registered Devices',
      'new_person' : 'Add/Update Person',
      'authorized_people': 'Delete Person',
      'email_activation' : 'Email activation',
      'change_password': 'Change password',
      'setting' : 'Settings',
      'logout' : 'Logout',
      'resetQrCode':'Reset Qr code after seconds: ',
      'successChangePasswordWithLogin': 'Successfully change your password',
      'newDeviceName': 'Enter new device name',
      'newDeviceCode': 'DeviceCode',
      'addDevice' : 'Add Device',
      'deviceText' : 'Here is the list of your devices:',
      'addDeviceSuccessMessage': "New device added",
      'invalidDeviceCode':'Invalid device code',
      'activeEmail': 'Activate your email',
      'resendEmailCode': 'Re-send code',
      'emailCodeSent' : 'Code is sent',
      'successEmailActivation' : 'Successfully activated email, login again',
      'noDevice' : 'You have no authenticated device',
      'loading' : 'Loading',
      'deviceName' : 'Device name: ',
      'deviceCode': 'Device code: ',
      'deviceRegistration': 'Device registration: ',
      'saveLogin' : 'Save my login information',
      'add_new_person_email': 'Write the associated person\'s email',
      'description' : 'Please add some description',
      'description_short':'Description',
      'infinite_access':'Give an infinite access',
      'select_date':'Select date',
      'select_time': 'Select time',
      'give_access': 'Give an access',
      'access_granted': 'You have given an permission to user!',
      'invalid_permitted_user':'Invalid email / make sure it is an active mail',
      'invalid_expiresDate' : 'Choose date and time',
      'user_first_name' : 'First Name',
      'user_last_name': 'Last Name',
      'user_mail' : 'Mail',
      'user_phone': 'Phone',
      'user_is_email_confirm': 'Email activation',
      'please_active_mail': 'Please activate your mail',
      'active_mail': 'Email activated',
      'choose_device':'Choose device',
      'authenticated_users': 'Click the user that you want to delete',
      'empty_authenticated_user': 'There is no authenticated person for that device',
      'authenticed_user_timeleft' : 'Time',
      'delete_user_alert_diaglog': 'Are you sure?'

    },
    'tr':{
      'No_internet': "Internet bağlantınızı kontrol edin",
      'logIn': 'Giriş Yap',
      'title': 'Akıllı Kapı Kilidi',
      'email': 'Email',
      'enterMail': 'Email adresinizi yazın',
      'password':'Şifrenizi yazın',
      'passwordHint':"Şifre",
      'createAccount':"Yeni hesap oluştur",
      'forgetPassword':"Şifremi Unuttum",
      'validateEmail':"Geçerli bir email yazın",
      'validatePassword':"Şifre en az 6 karater ve bir tane rakam içermeli",
      'logInError' : 'Email or password incorrect',
      'registerPage':'Kayıt formu',
      'name':'İsim',
      'surname':'Soyisim',
      'phone':'Numara',
      'confirmPassword':'Şifrenizi doğrulayın',
      'register':'Kayıt ol',
      'fillArea':'Alanı doldurun',
      'confirmPasswordError': 'Doğrulama şifresi yanlış',
      'phoneError' : 'Sadece rakam kullanın',
      'longString' : "50 karakterden uzun olmaz",
      'generalError': 'Bir şeyler ters gitti, yeniden deneyin',
      'successRegisterMessage': 'Kayıt başarılı, giriş ekranına yönlendiriliyorsunuz',
      'emailAlreadyTaken' : 'Böyle bir email zaten var',
      'emailConfirmCode' : 'Email aktivasyon kodu',
      'enterEmailConfirmCode': 'Email aktivasyon kodunu yazın',
      'changePasswordButton' : 'Parola değiştir',
      'confirmationToken' : 'Email onaylama kodu yanlış veya süresi dolmuş',
      'successChangePassword' : 'Şifre başarılı bir şekilde değiştirildi, giriş ekranına yönlendiriliyorsunuz',
      'generalError_navigateLogin' : 'Bir şeyler ters gitti, giriş ekranına yönlendiriliyorsunuz',
      'userPage' : 'Kullanıcı sayfası',
      'exitUserPage': 'Çıkış yapmak istiyor musunuz?',
      'yes' : 'Evet',
      'no' : 'Hayır',
      'home': 'Ana sayfa',
      'profile' : 'Profil',
      'devices_menu' : 'Kayıtlı cihazlar',
      'new_person' : 'Kişi ekle/güncelle',
      'authorized_people': 'Kişi sil',
      'email_activation' : 'Email aktivasyonu',
      'change_password': 'Şifre değiştir',
      'setting' : 'Ayarlar',
      'logout' : 'Çıkış yap',
      'resetQrCode':'Qr kodunuzu yenileyin: ',
      'successChangePasswordWithLogin': 'Şifreniz başarılı bir şekilde değiştirildi',
      'newDeviceName': 'Cihaz ismi',
      'newDeviceCode': 'Cihaz kodu',
      'addDevice' : 'Cihaz ekle',
      'deviceText' : 'Size tanımlı cihazlar:',
      'addDeviceSuccessMessage': "Yeni cihaz eklendi",
      'invalidDeviceCode':'Cihaz kodu hatalı',
      'activeEmail': 'Emailinizi aktif edin',
      'resendEmailCode': 'Kodu yeniden gönder',
      'emailCodeSent' : 'Kod gönderildi',
      'successEmailActivation' : 'Email başarıyla aktifleştirildi, yeniden giriş yapın',
      'noDevice' : 'Size tanımlı olan bir cihaz yok',
      'loading' : 'Yükleniyor',
      'deviceName' : 'Cihaz ismi: ',
      'deviceCode': 'Cihaz kodu: ',
      'deviceRegistration': 'Cihazın Kayıt tarihi: ',
      'saveLogin' : 'Giriş bilgilerimi kaydet',
      'add_new_person_email': 'İlgili kişinin email adresini yazın',
      'description' : 'Tanımlayıcı bir kaç sözcük yazın',
      'description_short':'Açıklama',
      'infinite_access':'Süresiz izin ver',
      'select_date':'Günü seçin',
      'select_time': 'Saati Seçin',
      'give_access': 'İzin tanımla',
      'access_granted': 'Kullanıcıya izin verildi!',
      'invalid_permitted_user': 'Geçersiz email / aktif edildiğinden emin olun',
      'invalid_expiresDate' : 'Tarih ve zamanı seçin',
      'user_first_name' : 'İsim',
      'user_last_name': 'Soyisim',
      'user_mail' : 'Mail',
      'user_phone': 'Numara',
      'user_is_email_confirm': 'Email aktivasyon durumu',
      'please_active_mail': 'Lütfen emailinizi aktif edin',
      'active_mail': 'Email aktif edildi',
      'choose_device':'Cihaz seçin',
      'authenticated_users': 'Silmek istediğiniz kullanıcıya tıklayın',
      'empty_authenticated_user': 'Bu kapıya yetkili kimse yok',
      'authenticed_user_timeleft' : 'Zaman',
      'delete_user_alert_diaglog': 'Silmek istediğinizde emin misiniz?'

    }
  };

  String getText({String text}){
    return _localizedValues[locale.languageCode][text];
  }
}

class LocalizationDelegate extends LocalizationsDelegate<Localization>{
  const LocalizationDelegate();


  @override
  bool isSupported(Locale locale) {
    return ['en', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) {
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(LocalizationDelegate old) {
    return false;
  }

}