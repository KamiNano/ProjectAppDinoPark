import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/ticket_provider.dart';
import '../database/database_helper.dart';
import 'buy_ticket_screen.dart';
import 'buy_ride_ticket_screen.dart';
import 'map_screen.dart';
import 'my_tickets_screen.dart';
import 'package:sembast/sembast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = "ผู้ใช้";
  final _store = StoreRef.main();
  late Database _db;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    _db = await DatabaseHelper().database;
    var username = await _store.record("username").get(_db) as String?;
    setState(() {
      _username = username ?? "ผู้ใช้";
    });
  }

  Future<void> _updateUsername(String newUsername) async {
    await _store.record("username").put(_db, newUsername);
    setState(() {
      _username = newUsername;
    });
  }

  void _editUsername() {
    TextEditingController controller = TextEditingController(text: _username);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("แก้ไขชื่อผู้ใช้"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "ป้อนชื่อใหม่"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () {
              _updateUsername(controller.text);
              Navigator.pop(context);
            },
            child: Text("บันทึก"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DinosaurPark"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _editUsername,
              child: Row(
                children: [
                  Text(_username, style: TextStyle(fontSize: 18)),
                  SizedBox(width: 6),
                  Icon(Icons.edit, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/dinosaur_logo.png",
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              MenuButton("🎟️ ซื้อบัตรเข้าสวนสนุก", context, BuyTicketScreen()),
              MenuButton("🎢 ซื้อตั๋วเข้าเล่นเครื่องเล่น", context, BuyRideTicketScreen()),
              MenuButton("🗺️ ดูแผนที่", context, ParkMapScreen()),
              MenuButton("📄 ตั๋วของตนเอง", context, MyTicketsScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget MenuButton(String text, BuildContext context, Widget page) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        child: Text(text),
        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
      ),
    );
  }
}
