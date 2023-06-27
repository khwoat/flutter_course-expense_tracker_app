import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseAdding extends StatefulWidget {
  const ExpenseAdding({super.key, required this.onSave});

  final void Function(Expense) onSave;

  @override
  State<ExpenseAdding> createState() => _ExpenseAddingState();
}

class _ExpenseAddingState extends State<ExpenseAdding> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;
  Category? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }

  void _validateAndSave() {
    final amountDouble = double.tryParse(_amountController.text);
    final isAmountInvalid = amountDouble == null || amountDouble < 0;

    if (_titleController.text.trim().isEmpty ||
        isAmountInvalid ||
        _selectedDate == null ||
        _selectedCategory == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
              'Please, check Title, Amount, Date, and Category is valid.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    } else {
      widget.onSave(
        Expense(
          title: _titleController.text,
          amount: amountDouble,
          date: _selectedDate!,
          category: _selectedCategory!,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      child: Column(
        children: [
          // Title textfield
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(label: Text('Title')),
          ),
          Row(
            children: [
              // Amount textfield
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Amount'),
                    prefix: Text('\$ '),
                  ),
                ),
              ),

              // Date picker
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No select date'
                        : formatter.format(_selectedDate!),
                  ),
                  IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.date_range),
                  ),
                ],
              )
            ],
          ),

          Row(
            children: [
              // Category Dropdown
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),

              const Spacer(),

              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              // Save button
              ElevatedButton(
                onPressed: _validateAndSave,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
