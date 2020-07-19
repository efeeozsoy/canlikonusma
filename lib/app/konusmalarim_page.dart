import 'package:canli_konusma_app/app/sohbet_page.dart';
import 'package:canli_konusma_app/model/konusma.dart';
import 'package:canli_konusma_app/model/user.dart';
import 'package:canli_konusma_app/viewmodel/chat_view_model.dart';
import 'package:canli_konusma_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Konuşmalarım"),
      ),
      body: FutureBuilder<List<Konusma>>(
        future: _userModel.getAllConversations(_userModel.user.userID),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = konusmaListesi.data;
            if (tumKonusmalar.length > 0) {
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var oankiKonusma = tumKonusmalar[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ChatViewModel(
                                  currentUser: _userModel.user,
                                  sohbetEdilenUser: User.idveResim(
                                      userID: oankiKonusma.kimle_konusuyor,
                                      profilURL:
                                          oankiKonusma.konusulanUserProfilURL)),
                              child: SohbetPage(),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(oankiKonusma.konusulanUserName),
                        subtitle: Text(oankiKonusma.son_yollanan_mesaj),
                        trailing: Text(oankiKonusma.aradakiFark),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(30),
                          backgroundImage:
                              NetworkImage(oankiKonusma.konusulanUserProfilURL),
                        ),
                      ),
                    );
                  },
                  itemCount: tumKonusmalar.length,
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            "Konuşma bulunamadı",
                            style: TextStyle(fontSize: 36),
                          ),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<Null> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
