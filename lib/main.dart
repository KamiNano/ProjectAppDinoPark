import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/ticket_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ticketProvider = TicketProvider();
  await ticketProvider.init();

  runApp(MyApp(ticketProvider: ticketProvider));
}

class MyApp extends StatelessWidget {
  final TicketProvider ticketProvider;
  MyApp({required this.ticketProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ticketProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'สวนสนุก',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
