import 'package:expense_tracker_app/pages/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DashboardPage(),
      theme: ThemeData().copyWith(useMaterial3: true),
    );
  }
}
