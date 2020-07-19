import 'package:canli_konusma_app/app/hata_exception.dart';
import 'package:canli_konusma_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:canli_konusma_app/common_widget/social_login_button.dart';
import 'package:canli_konusma_app/model/user.dart';
import 'package:canli_konusma_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  String _butonText, _linkText;
  var _formType = FormType.LogIn;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState.save();
    final _userModel = Provider.of<UserModel>(context);

    if (_formType == FormType.LogIn) {
      try {
        User _girisYapanUser =
            await _userModel.signInWithEmailandPassword(_email, _sifre);
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
                baslik: "Oturum Açma Hata",
                icerik: Hatalar.goster(e.code),
                anaButonYazisi: "Tamam")
            .goster(context);
      }
    } else {
      try {
        User _olusturulanUser =
            await _userModel.createUserWithEmailandPassword(_email, _sifre);
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
                baslik: "Kullanıcı Oluşturma Hata",
                icerik: Hatalar.goster(e.code),
                anaButonYazisi: "Tamam")
            .goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    _butonText = _formType == FormType.LogIn ? "Giriş Yap " : "Kayıt Ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabınız yok mu? Kayıt Olun"
        : "Hesabınız Var mı? Giriş Yap";

    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Giriş ve Kayıt Sayfası"),
        ),
        body: _userModel.state == ViewState.Idle
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: _userModel.emailHataMesaji != null
                                ? _userModel.emailHataMesaji
                                : null,
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'Email',
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String girilenEmail) {
                            _email = girilenEmail;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            errorText: _userModel.sifreHataMesaji != null
                                ? _userModel.sifreHataMesaji
                                : null,
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Password',
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String girilenSifre) {
                            _sifre = girilenSifre;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SocialLoginButton(
                            butonText: _butonText,
                            butonColor: Theme.of(context).primaryColor,
                            radius: 10,
                            onPressed: () => _formSubmit()),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                            onPressed: () => _degistir(),
                            child: Text(_linkText))
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
