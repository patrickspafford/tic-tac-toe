import 'package:flutter/material.dart';
import 'components/cell.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Tic-Tac-Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  // Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> _columns = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];
  bool isPlayerOne = true;

  bool checkMoveWinsGame(int updatedCol, int updatedRow, String value) {
    // A little "baby programmer", but simple
    int colSum = 0, rowSum = 0, diagSum = 0, rDiagSum = 0;
    int gridDimension = _columns.length;
    for (int i = 0; i < gridDimension; i++) {
      if (_columns[updatedCol][i] == value) colSum++;
      if (_columns[i][updatedRow] == value) rowSum++;
      if (_columns[i][i] == value) diagSum++;
      if (_columns[i][gridDimension - (i + 1)] == value) rDiagSum++;
    }
    return [colSum, rowSum, diagSum, rDiagSum]
        .any((element) => element == gridDimension);
  }

  bool checkIsDraw() {
    for (int i = 0; i < _columns.length; i++) {
      for (int j = 0; j < _columns[i].length; j++) {
        if (_columns[i][j] == '') return false;
      }
    }
    return true;
  }

  void clearBoard() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        _columns[i][j] = '';
      }
    }
  }

  Future<void> _showMyDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateCell(int column, int row) {
    setState(() {
      String valueToInsert = isPlayerOne ? 'X' : 'O';
      _columns[column][row] = valueToInsert;
      if (checkMoveWinsGame(column, row, valueToInsert)) {
        _showMyDialog('Game Over', isPlayerOne ? 'X wins!' : 'O wins!');
        clearBoard();
      } else if (checkIsDraw()) {
        _showMyDialog('Game Over', 'Draw');
        clearBoard();
      }
      isPlayerOne = !isPlayerOne;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Row(
              children: _columns.asMap().entries.map((entry) {
        int columnIdx = entry.key;
        List<String> column = entry.value;
        return Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: column.asMap().entries.map((cellEntry) {
                  int cellIdx = cellEntry.key;
                  String cell = cellEntry.value;
                  return Cell(
                    column: columnIdx,
                    row: cellIdx,
                    onPressed: _updateCell,
                    value: cell,
                  );
                }).toList()));
      }).toList())), //
    );
  }
}
