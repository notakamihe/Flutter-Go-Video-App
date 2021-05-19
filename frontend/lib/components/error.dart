import "package:flutter/material.dart";

class Error extends StatefulWidget {
  final String message;

  const Error ({Key key, this.message}): super(key: key);

  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.message != null ?
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          child: Text(
            widget.message.toUpperCase(), 
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ) :
        null
    );
  }
}