import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  const NewTransaction({required this.addNewTransaction, Key? key})
      : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  DateTime? selectedDate;

  void submitData() {
    final entredTitle = titleController.text;
    final entredAmount1 = amountController.text;

    if (entredTitle.isEmpty || entredAmount1.isEmpty || selectedDate == null) {
      return;
    }

    final entredAmount = double.parse(entredAmount1);

    if (entredAmount <= 0) {
      return;
    }

    widget.addNewTransaction(entredTitle, entredAmount, selectedDate);
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: titleController,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) => titleInput = val,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: amountController,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) {
                //   amountInput = val;
                // },
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Text(selectedDate == null
                        ? "No Date Choosen!"
                        : DateFormat.yMd().format(selectedDate as DateTime)),
                    TextButton(
                        onPressed: presentDatePicker,
                        child: const Text(
                          'Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: submitData,
                child: const Text("Add Transaction"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
