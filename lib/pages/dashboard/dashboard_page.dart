import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/pages/dashboard/expense_adding.dart';
import 'package:expense_tracker_app/pages/dashboard/expense_list.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _recordedExpense = [
    Expense(
      title: 'Lunch',
      amount: 12.50,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Vacation',
      amount: 100,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  void _openAddExpenseModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => ExpenseAdding(
        onSave: _saveExpense,
      ),
    );
  }

  void _saveExpense(Expense expense) {
    setState(() {
      _recordedExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _recordedExpense.indexOf(expense);
    setState(() {
      _recordedExpense.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense removed'),
        action: SnackBarAction(
          onPressed: () {
            setState(() {
              _recordedExpense.insert(expenseIndex, expense);
            });
          },
          label: 'Undo',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker App'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseModal,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const Text('Chart'),
          Expanded(
            child: ExpenseList(
              expenses: _recordedExpense,
              onRemove: _removeExpense,
            ),
          ),
        ],
      ),
    );
  }
}
