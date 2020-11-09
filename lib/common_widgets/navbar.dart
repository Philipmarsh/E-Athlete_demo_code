

import 'package:eathlete/misc/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common_widgets.dart';



class EAthleteNavBar extends StatefulWidget {
  final Function button1OnPressed;
  final Function button2OnPressed;
  final Function button3OnPressed;
  final Function button4OnPressed;
  final Function button5OnPressed;
  int pageNumber;

  EAthleteNavBar(
      {this.button1OnPressed,
      this.button2OnPressed,
      this.button3OnPressed,
      this.button4OnPressed,
      this.button5OnPressed,
      this.pageNumber});

  @override
  _EAthleteNavBarState createState() => _EAthleteNavBarState();
}

class _EAthleteNavBarState extends State<EAthleteNavBar> {


  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =Provider.of<UserRepository>(context, listen: false);
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.075,
      bottom: 20,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(blurRadius: 2, spreadRadius: 0.2, color: Colors.grey)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: IconButton(
                key: Key('0'),
                icon: ImageIcon(widget.pageNumber==0?AssetImage('images/homeactive_icon.png'):AssetImage('images/homenonactive_icon.png'),
                    color: widget.pageNumber == 0
                        ? Colors.blue
                        : Color(0xff828289)),
                onPressed: () {
                  setState(() {
                    widget.button1OnPressed();
                    widget.pageNumber = 0;
                  });
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 8.0),
                child: IconButton(
                  key: Key('1'),
                  icon: ImageIcon(widget.pageNumber==1?AssetImage('images/book_icon@3x.png'):AssetImage('images/unbook_icon@3x.png'),
                  color:  widget.pageNumber == 1
                      ? Colors.blue
                      : Color(0xff828289),),
                  onPressed: () {
                    setState(() {
                      widget.button2OnPressed();
                      widget.pageNumber = 1;
                    });
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: GestureDetector(
                  onTap: () {
                    widget.button3OnPressed();
                  },
                  child: Container(
                    key: Key('2'),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xff0088ff),
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  key: Key('3'),
                  icon: ImageIcon(widget.pageNumber==2?AssetImage('images/calendar_icon@3x.png'):AssetImage('images/uncalendar_icon@3x.png'),
                    color:  widget.pageNumber == 2
                        ? Colors.blue
                        : Color(0xff828289),),
                  onPressed: () {
                    setState(() {
                      widget.button4OnPressed();
                      widget.pageNumber = 2;
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfilePhoto(
                photo: userRepository.user.profilePhoto!=null?NetworkImage(userRepository.user.profilePhoto): AssetImage('images/anon-profile-picture.png'),
                onPress: () {
                  setState(() {
                    widget.button5OnPressed();
                    widget.pageNumber = 3;
                  });
                },
                key: Key('4'),
              ),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.85,
        height: 70,
      ),
    );
  }
}

//IconButton(icon: Icon(Icons.book, color: widget.diaryButtonColor,), onPressed: () {
//
//}),
