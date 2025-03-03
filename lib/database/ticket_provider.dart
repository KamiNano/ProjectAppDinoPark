import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'database_helper.dart';
import 'ticket_model.dart';

class TicketProvider with ChangeNotifier {
  static const String ticketStoreName = 'tickets';
  final _ticketStore = intMapStoreFactory.store(ticketStoreName);
  late Database _db;

  Future<void> init() async {
    _db = await DatabaseHelper().database;
    notifyListeners();
  }

  // เพิ่มตั๋วใหม่
  Future<void> addTicket(Ticket ticket) async {
    await _ticketStore.add(_db, ticket.toMap());
    notifyListeners();
  }

  // ดึงตั๋วทั้งหมด
  Future<List<Ticket>> getTickets() async {
    final snapshot = await _ticketStore.find(_db);
    return snapshot.map((record) {
      return Ticket.fromMap({...record.value, 'id': record.key.toString()});
    }).toList();
  }

  // ลบตั๋ว
  Future<void> deleteTicket(String id) async {
    final finder = Finder(filter: Filter.byKey(int.parse(id)));
    await _ticketStore.delete(_db, finder: finder);
    notifyListeners();
  }
}
