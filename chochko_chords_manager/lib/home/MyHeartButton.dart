import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHeartButton extends StatefulWidget{
  final StreamController<bool> controller;

  MyHeartButton(this.controller);

  @override
  _MyHeartButtonState createState() => _MyHeartButtonState();
}

class _MyHeartButtonState extends State<MyHeartButton>{
  bool filled = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon((filled) ? Icons.favorite : Icons.favorite_border),
      color: Colors.red,
      onPressed: () {
        setState((){
          filled = false;
        });
        print("deleting");
        showDialog(
            context: context,
            builder:(BuildContext context){
              return AlertDialog(
                title: Text("Delete"),
                content: Text("Are you sure you want to unlike this page?"),
                actions: <Widget>[
                  FlatButton(
                      child: Text("Yes",style: TextStyle(color:Colors.purple,)),
                      onPressed:(){
                        widget.controller.add(true);
                        Navigator.of(context).pop();
                      }
                  ),
                  FlatButton(
                    child: Text("No",style: TextStyle(color:Colors.purple,)),
                    onPressed: (){
                      setState((){
                        filled = true;
                      });
                      widget.controller.add(false);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        // showDialog(context: context);
      },
    );
  }

}