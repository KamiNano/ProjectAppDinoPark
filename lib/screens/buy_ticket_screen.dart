import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/ticket_provider.dart';
import '../database/ticket_model.dart';

class BuyTicketScreen extends StatefulWidget {
  @override
  _BuyTicketScreenState createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  Map<String, int> ticketCounts = {
    "ธรรมดา": 0,
    "VIP": 0
  };

  final Map<String, int> ticketPrices = {
    "ธรรมดา": 100,
    "VIP": 200
  };

  void confirmPurchase() {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    setState(() {
      ticketCounts.forEach((type, count) {
        if (count > 0) {
          Ticket newTicket = Ticket(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: type,
            quantity: count,
            purchaseTime: DateTime.now(),
          );
          ticketProvider.addTicket(newTicket);
        }
      });
      ticketCounts.updateAll((key, value) => 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ซื้อตั๋วเข้าสวนสนุก")),
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
            children: [
              ...ticketCounts.keys.map((type) => buildTicketOption(type)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmPurchase,
                child: Text("ยืนยันการซื้อ"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTicketOption(String type) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text("ตั๋ว$type", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text("ราคา ${ticketPrices[type] ?? 0} บาท", style: TextStyle(fontSize: 16, color: Colors.green)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (ticketCounts[type]! > 0) {
                    ticketCounts[type] = ticketCounts[type]! - 1;
                  }
                });
              },
            ),
            Text(ticketCounts[type].toString(), style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  ticketCounts[type] = ticketCounts[type]! + 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}