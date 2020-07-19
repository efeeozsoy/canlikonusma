import 'package:canli_konusma_app/app/home_page.dart';
import 'package:canli_konusma_app/app/sign_in/sign_in_page.dart';
import 'package:canli_konusma_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,
        listen:
            true); // "listen" default olarak "true " kabul edildigi icin bunu yazmaya da bilisiniz
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(user: _userModel.user);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
