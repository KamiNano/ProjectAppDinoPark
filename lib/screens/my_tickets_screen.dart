import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/ticket_provider.dart';
import '../database/ticket_model.dart';

class MyTicketsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ตั๋วของตนเองทั้งหมด")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<TicketProvider>(
          builder: (context, ticketProvider, child) {
            return FutureBuilder<List<Ticket>>(
              future: ticketProvider.getTickets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("ไม่มีตั๋วที่ซื้อ"));
                }

                final tickets = snapshot.data!;
                final parkTickets = tickets.where((t) => t.type == "ธรรมดา" || t.type == "VIP").toList();
                final rideTickets = tickets.where((t) => !(t.type == "ธรรมดา" || t.type == "VIP")).toList();

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    if (parkTickets.isNotEmpty) ...[
                      Text("ตั๋วเข้าสวนสนุก", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ...parkTickets.map((ticket) => buildTicketItem(context, ticketProvider, ticket)),
                    ],
                    if (rideTickets.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text("ตั๋วเครื่องเล่น", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ...rideTickets.map((ticket) => buildTicketItem(context, ticketProvider, ticket)),
                    ],
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildTicketItem(BuildContext context, TicketProvider provider, Ticket ticket) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(ticket.type, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => confirmDelete(context, provider, ticket.id),
        ),
      ),
    );
  }

  void confirmDelete(BuildContext context, TicketProvider provider, String ticketId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ยืนยันการยกเลิกตั๋ว"),
        content: Text("คุณต้องการยกเลิกตั๋วนี้ใช่หรือไม่?(ไม่การคืนเงิน)"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("ยกเลิก")),
          TextButton(
            onPressed: () {
              provider.deleteTicket(ticketId);
              Navigator.pop(context);
            },
            child: Text("ยืนยัน", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
