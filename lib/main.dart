import 'package:flutter/services.dart';

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
        primaryColor: Colors.pink[400],
        accentColor: Colors.green[200],
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
                headline6: TextStyle(fontFamily: 'OpenSans', fontSize: 20))),
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
    Transaction(id: '2', titulo: 'comida', monto: 90.00, fecha: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.fecha.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _transparentStatusBar() {
    SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    _transparentStatusBar();
    final appBar = AppBar(
      title: Text("Flutter"),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add))
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      (MediaQuery.of(context).padding.top)) *
                  0.3,
              child: Chart(_recentTransactions),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      (MediaQuery.of(context).padding.top)) *
                  0.7,
              child: TransactionList(_userTransactions, _deleteTransaction),
            )
          ],
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
