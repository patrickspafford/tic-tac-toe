import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  Cell(
      {required this.row,
      required this.column,
      required this.value,
      required this.onPressed});
  final int row;
  final int column;
  final Function onPressed;
  final String value;

  void _handlePress() {
    this.onPressed(column, row);
  }

  @override
  Widget build(BuildContext build) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.all(4),
            child: ElevatedButton(
              onPressed: _handlePress,
              style: new ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      value == 'X' ? Colors.red : Colors.blue)),
              child: Text(this.value,
                  style: new TextStyle(fontSize: 40, color: Colors.white)),
            )));
  }
}
