import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../screens/LoginScreen.dart';
import 'calendar.dart';
import '../model/list_item.dart';
import 'dodadi_element.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotificationService service;

  @override
  void initState() {
    service = NotificationService();
    service.initialize();
    super.initState();
  }

  final List<ListItem> _userItems = [
    ListItem(
      id: "T1",
      predmet: "Bazi Na Podatoci",
      datum: "19.11.2022",
      vreme: "10:00",
    ),
    ListItem(
      id: "T2",
      predmet: "Veb Programiranje",
      datum: "19.11.2022",
      vreme: "15:00",
    ),
    ListItem(
      id: "T3",
      predmet: "Agoritmi i Podatocni Strukturi",
      datum: "21.11.2022",
      vreme: "08:00",
    ),
    ListItem(
      id: "T4",
      predmet: "Strukturno Programiranje",
      datum: "22.11.2022",
      vreme: "14:30",
    ),
    ListItem(
      id: "T5",
      predmet: "Kalkulus",
      datum: "22.11.2022",
      vreme: "16:00",
    ),
    ListItem(
      id: "T6",
      predmet: "Diskretna matematika",
      datum: "23.11.2022",
      vreme: "10:00",
    ),
  ];

  void _openCalendarFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: CalendarApp(),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: DodadiElement(_addNewItemToList),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addNewItemToList(ListItem item) {
    setState(() {
      _userItems.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _userItems.removeWhere((elem) => elem.id == id);
    });
  }

  Widget _createAppBar() {
    return AppBar(title: Text("Lab4-186041"), actions: <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () => _addItemFunction(context),
      ),
      IconButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        icon: Icon(Icons.logout),
      ),
    ]);
  }

  Widget _createBody() {
    return Container(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      Center(
        child: _userItems.isEmpty
            ? Text("Nema termini")
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _userItems.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: ListTile(
                      title: Text(_userItems[index].predmet),
                      subtitle: Text(_userItems[index].datum +
                          " " +
                          _userItems[index].vreme),
                      trailing: IconButton(
                        onPressed: () => _deleteItem(_userItems[index].id),
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
                //itemCount: _userItems.length,
              ),
      ),
      ElevatedButton.icon(
        icon: Icon(
          Icons.notifications,
          size: 30,
        ),
        label: Text(
          "Нотификации",
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          await service.showNotification(
              id: 0,
              title: 'Наскоро имате испити',
              body: 'Проверете во календарот');
        },
      ),
    ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _createAppBar(),
      ),
      body: _createBody(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        onPressed: () {
          _openCalendarFunction(context);
        },
        icon: Icon(Icons.calendar_month),
        label: Text(''),
      ),
    );
  }
}
