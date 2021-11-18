import 'package:expensive_app/widgets/function.dart';

import './widgets/chart.dart';

import './widgets/transaction_list.dart';

import './widgets/new_transaction.dart';

import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter",
      theme: ThemeData(
        primaryColor: Colors.pink[300],
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.green[300]),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
              ),
        ),
      ),
      home: PaginaP(),
    );
  }
}

class PaginaP extends StatefulWidget {
  @override
  _PaginaPState createState() => _PaginaPState();
}

class _PaginaPState extends State<PaginaP> {
  final List<Transaction> _userTransactions = [
    Transaction(id: '1', titulo: 'juegos', monto: 10.00, fecha: DateTime.now()),
    //Transaction(id: '2', titulo: 'comida', monto: 90.00, fecha: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.fecha.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txtitle, double txamount, DateTime chosenData) {
    final newTrans = Transaction(
      id: DateTime.now().toString(),
      titulo: txtitle,
      monto: txamount,
      fecha: chosenData,
    );
    setState(() {
      _userTransactions.add(newTrans);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text("Personal Expensives"),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    FunctionDart statusBar = FunctionDart();
    statusBar.portraitModeOnly();
    statusBar.transparentStatusBar();
    final appBar = _buildAppBar();
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        (mediaQuery.padding.top)) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        (mediaQuery.padding.top)) *
                    0.7,
                child: TransactionList(_userTransactions, _deleteTransaction),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
        //backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
