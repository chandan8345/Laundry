import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(FontAwesomeIcons.chevronLeft, color: Colors.black),
        ),
        actions: [
          //IconButton(icon: Icon(FontAwesomeIcons.dropbox), onPressed: null)
        ],
        title: Text(
          'Account',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 5),
                CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.transparent,
                    child: Image.network(
                      "https://i.pinimg.com/originals/17/56/8f/17568fcd478e0699067ca7b9a34c702f.png",
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )),
                Text(
                  "Chandan Biswas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text("01762981976"),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonAccount("Orders", Colors.orange,
                          FontAwesomeIcons.file),
                      buttonAccount("Profile", Colors.green,
                          FontAwesomeIcons.userAlt),
                      buttonAccount("Address", Colors.cyan,
                          FontAwesomeIcons.mapMarker),
                      buttonAccount("Messages", Colors.blue,  
                          FontAwesomeIcons.mailBulk),
                    ],
                  ),
                ),
                SizedBox(height: 5)
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
              height: MediaQuery.of(context).size.height / 1.9,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FontAwesomeIcons.bell,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        "Notifications",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FontAwesomeIcons.calendarAlt,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        "Appoinments",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      onTap: () {},
                      leading: Icon(FontAwesomeIcons.creditCard,
                          color: Colors.blueGrey),
                      title: Text(
                        "Payment History",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FontAwesomeIcons.keycdn,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        "Change Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FontAwesomeIcons.language,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        "Language",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        //     Navigator.push(context,
                        // MaterialPageRoute(builder: (context) => Login()));
                      },
                      leading: Icon(
                        FontAwesomeIcons.signOutAlt,
                        color: Colors.blueGrey,
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
  
  buttonAccount(title,color,icon){
    return Column(
      children: [
        SizedBox.fromSize(
          size: Size(60, 60), // button width and height
          child: ClipOval(
            child: Material(
              color: color, // button color
              child: InkWell(
                splashColor: Colors.white, // splash color
                onTap: () {}, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.white,
                    ), // icon
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text("$title"),
      ]);
}
}
