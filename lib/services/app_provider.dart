import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_scanner/provider/ticket_provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TicketProvider()),
        ],
        child: child,
      );
}
