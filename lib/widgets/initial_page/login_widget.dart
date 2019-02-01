import 'dart:io';

import 'package:bungie_api/helpers/oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_light/services/auth/auth.service.dart';
import 'package:little_light/services/bungie_api/bungie_api.service.dart';
import 'package:little_light/widgets/common/translated_text.widget.dart';

typedef void LoginCallback(String code);
typedef void SkipCallback();

class LoginWidget extends StatefulWidget {
  final String title = "Login";
  final BungieApiService api = new BungieApiService();
  final AuthService auth = new AuthService();
  final LoginCallback onLogin;
  final SkipCallback onSkip;
  final bool forceReauth;

  LoginWidget({this.onLogin, this.onSkip, this.forceReauth = false});

  @override
  LoginWidgetState createState() => new LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  @override
  void initState() {
    super.initState();
  }

  void authorizeClick(BuildContext context) async {
    try {
      String code = await widget.auth.authorize(widget.forceReauth);
      widget.onLogin(code);
    } on OAuthException catch (e) {
      bool isIOS =  Platform.isIOS;
      String platformMessage =
          "If this keeps happening, please try to login with a mainstream browser (preferably Google Chrome).";
      if (isIOS) {
        platformMessage =
            "Please don't open the auth process in another safari window, this could prevent you from getting logged in.";
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    textColor: Colors.blueGrey.shade300,
                    child: TranslatedTextWidget("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
                title: TranslatedTextWidget(e.error),
                content: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      TranslatedTextWidget(
                        e.errorDescription,
                        textAlign: TextAlign.center,
                      ),
                      TranslatedTextWidget(
                        platformMessage,
                        textAlign: TextAlign.center,
                      )
                    ])),
              ));
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));
  }

  void laterClick() {
    widget.onSkip();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: EdgeInsets.all(8),
        child: TranslatedTextWidget("Authorize Description"),
      ),
      RaisedButton(
        onPressed: () {
          this.authorizeClick(context);
        },
        child: TranslatedTextWidget("Authorize with Bungie.net"),
      ),
      RaisedButton(
        onPressed: () {
          this.laterClick();
        },
        color: Theme.of(context).colorScheme.error,
        child: TranslatedTextWidget("Later"),
      )
    ]);
  }
}
