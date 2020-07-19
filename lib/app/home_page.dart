import 'package:canli_konusma_app/app/konusmalarim_page.dart';
import 'package:canli_konusma_app/app/kullanicilar.dart';
import 'package:canli_konusma_app/app/my_custom_bottom_navi.dart';
import 'package:canli_konusma_app/app/profil.dart';
import 'package:canli_konusma_app/app/tab_items.dart';
import 'package:canli_konusma_app/model/user.dart';
import 'package:canli_konusma_app/notification_handler.dart';
import 'package:canli_konusma_app/viewmodel/all_user_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  TabItem _currentTab = TabItem.Kullanicilar;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  void initState() {
    super.initState();
    NotificationHandler().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        navigatorKeys: navigatorKeys,
        sayfaOlusturucu: tumSayfalar(),
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}

/*

 */
