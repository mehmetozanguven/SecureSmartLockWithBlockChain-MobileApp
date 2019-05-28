import 'package:flutter/material.dart';
import 'package:smart_lock/src/common/common_property_holder.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:smart_lock/src/model/user_info.dart';


class ProfileWidget extends StatelessWidget {
  final String _log = "ProfileWidget";

  UserInfo _userInfo;
  CommonPropertySingleton _commonPropertySingleton;

  ProfileWidget(){

    _commonPropertySingleton = CommonPropertySingleton();
    _userInfo = _commonPropertySingleton.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          child: Container(
            color: Theme.of(context).primaryColorDark.withOpacity(0.8),
          ),
          clipper: GetClipper(),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width * 0.793651,
          left: MediaQuery.of(context).size.width * 0.1,
          top: MediaQuery.of(context).size.height / 5,
          child: Column(
            children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width * 0.793651) * 0.4285714,
                height: 143.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(image: AssetImage("images/generic_profile.png")
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(75.0)
                  ),
                  boxShadow: [
                    BoxShadow(blurRadius: 7.0, color: Colors.black)
                  ]
                ),
              ),
              SizedBox(height: 50.0,),
              Text("${_userInfo.getUserFirstName()} ${_userInfo.getUserLastName()}",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark
                ),
              ),
              SizedBox(height: 13.0,),
              Text("${_userInfo.getUserEmail()}",
                style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).primaryColor
                ),
              ),
              SizedBox(height: 13.0,),
              Text("${_userInfo.getUserPhoneNumber()}",
                style: TextStyle(
                    fontSize: 20.0,
                    fontStyle: FontStyle.normal,
                    color: Theme.of(context).primaryColor
                ),
              ),
              SizedBox(height: 13.0,),
              Text(getTextForEmailActivation(context),
                style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.normal,
                    color: Theme.of(context).primaryColor
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  String getTextForEmailActivation(BuildContext context){
    if (_userInfo.isEmailConfirm())
      return Localization.of(context).getText(text: "active_mail");
    else
      return Localization.of(context).getText(text: "please_active_mail");
  }

}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
