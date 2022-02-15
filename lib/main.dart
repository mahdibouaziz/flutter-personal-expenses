import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_personal_expenses/models/transaction.dart';
import 'package:flutter_personal_expenses/widgets/chart.dart';
import 'package:flutter_personal_expenses/widgets/new_transaction.dart';
import 'package:flutter_personal_expenses/widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      home: const MyHomePage(),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
            errorColor: Colors.red[700],
          ).copyWith(secondary: Colors.amber),
          fontFamily: 'Quicksand',
          textTheme: const TextTheme(
            titleLarge: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> userTransactions = [
    Transaction(amount: 60, date: DateTime.now(), id: 't0', title: 'New Shoes'),
    Transaction(
        amount: 40, date: DateTime.now(), id: 't1', title: 'Weekly Groceries'),
    Transaction(
        amount: 30,
        date: DateTime.now().subtract(const Duration(days: 1)),
        id: 't2',
        title: 'New Shoes2'),
    Transaction(
        amount: 57,
        date: DateTime.now().subtract(const Duration(days: 2)),
        id: 't3',
        title: 'New Shoes3'),
    Transaction(
        amount: 57,
        date: DateTime.now().subtract(const Duration(days: 2)),
        id: 't3',
        title: 'New Shoes3'),
    Transaction(
        amount: 57,
        date: DateTime.now().subtract(const Duration(days: 2)),
        id: 't3',
        title: 'New Shoes3'),
    Transaction(
        amount: 57,
        date: DateTime.now().subtract(const Duration(days: 2)),
        id: 't3',
        title: 'New Shoes3'),
  ];

  bool showChart = false;

  List<Transaction> get recentTransactions {
    return userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void addNewTransaction(String title, double amount, DateTime selectedDate) {
    final newTx = Transaction(
        amount: amount,
        date: selectedDate,
        id: DateTime.now().toString(),
        title: title);

    setState(() {
      userTransactions.add(newTx);
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void startAddNewTransaction(ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(addNewTransaction: addNewTransaction));
        });
  }

  List<Widget> buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Show Chart"),
          Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: showChart,
            onChanged: (val) {
              setState(() {
                showChart = val;
              });
            },
          )
        ],
      ),
      showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(recentTransactions: recentTransactions))
          : txListWidget,
    ];
  }

  List<Widget> buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(recentTransactions: recentTransactions),
      ),
      txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Personal Expenses"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => startAddNewTransaction(context),
                  child: const Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text("Personal Expenses"),
            actions: [
              IconButton(
                  onPressed: () {
                    startAddNewTransaction(context);
                  },
                  icon: const Icon(Icons.add))
            ],
          );

    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
          userTransactions: userTransactions,
          deleteTransaction: deleteTransaction),
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            ...buildLandscapeContent(mediaQuery, appBar, txListWidget),
          if (!isLandscape)
            ...buildPortraitContent(mediaQuery, appBar, txListWidget),
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as CupertinoNavigationBar, child: pageBody)
        : Scaffold(
            appBar: appBar as AppBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      startAddNewTransaction(context);
                    },
                    child: const Icon(Icons.add)),
          );
  }
}
