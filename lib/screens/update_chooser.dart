
import 'package:flutter/material.dart';


class UpdatePicker extends StatelessWidget {

  final Function button1Function;
  final Function button2Function;
  final Function button3Function;

  const UpdatePicker({
    this.button1Function,
    this.button2Function,
    this.button3Function,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Stack(
        children: <Widget>[GestureDetector(
          onTap: button3Function,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(0, 0, 0, 0.7),
          ),
        ),
          Positioned(
            left:MediaQuery.of(context).size.width * 0.3,
            bottom: 140,
            child: Column(
              children: <Widget>[
                GestureDetector(

                    onTap: button2Function,
                    child: Container(
                      key: Key('2'),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.hourglass_empty,
                        color: Colors.black,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Session',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                )
              ],
            ),),
          Positioned(
            right:MediaQuery.of(context).size.width * 0.3-10,
            bottom: 140,
            child: Column(
              children: <Widget>[
                GestureDetector(

                    onTap: button1Function,
                    child: Container(
                      key: Key('2'),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'General Day',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                )
              ],
            ),),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5-22,
            bottom: 30,
            child: GestureDetector(
                onTap: button3Function,
                child: Container(
                  key: Key('2'),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xff0088ff),
                      borderRadius: BorderRadius.circular(50)),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                )),)]
    );
  }
}