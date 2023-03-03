import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:group_button/group_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whimsical App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0B0707),
      ),
      home: const MyHomePage(title: 'WHIMSICAL APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TcpSocketConnection socketConnection =
      TcpSocketConnection("192.168.4.1", 80);

  String message = "";
  String yellowStatus = "yc",
      blueStatus = "bc",
      greenStatus = "gc",
      purpleStatus = "pc",
      redStatus = "rc";
  String transmitMessage = "";

  bool isConnected = false;

  final controller = GroupButtonController();

  @override
  void initState() {
    super.initState();
    stopConnection();
  }

  //receiving and sending back a custom message
  void messageReceived(String msg) {
    setState(() {
      message = msg;
    });
    socketConnection.sendMessage("MessageIsReceived");
  }

  //starting the connection and listening to the socket asynchronously
  void startConnection() async {
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 3);
      if (socketConnection.isConnected()) {
        showInSnackBar("Connected!");
        setState(() {
          isConnected = true;
        });
      }
    } else {
      showInSnackBar("Connection Problem! Check 192.168.4.1");
    }
  }

  void stopConnection() async {
    socketConnection.disconnect();
    showInSnackBar("Disconnected!");
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void onSelectedMethod() async {}

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: Colors.green, textStyle: const TextStyle(fontSize: 80));
    ButtonStyle style2 = ElevatedButton.styleFrom(
        primary: Colors.green, textStyle: const TextStyle(fontSize: 80));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xc80a6000),
        title: Text(
          widget.title,
          textScaleFactor: 2,
        ),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (!socketConnection.isConnected()) {
                  startConnection();
                } else {
                  stopConnection();
                  if (!socketConnection.isConnected()) {
                    setState(() {
                      isConnected = false;
                    });
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    //if (states.contains(MaterialState.pressed)) {
                    if (isConnected) {
                      return Colors.greenAccent;
                    } else {
                      return Colors.redAccent;
                    } // Defer to the widget's default.
                  },
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text((isConnected) ? ('CONNECTED') : ('DISCONNECTED'),
                    textScaleFactor: 3),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (socketConnection.isConnected()) {
                        socketConnection.sendMessage(transmitMessage);
                        //showInSnackBar("$transmitMessage sended!");
                      } else {
                        showInSnackBar("No Connection!");
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        //if (states.contains(MaterialState.pressed)) {
                        if (isConnected) {
                          return Colors.greenAccent;
                        } else {
                          return Colors.redAccent;
                        } // Defer to the widget's default.
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text((isConnected) ? ('SEND') : ('DISABLED'),
                        textScaleFactor: 5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            GroupButton(
                controller: controller,
                isRadio: false,
                onSelected: (value, index, isSelected) {
                  switch (index) {
                    case 0:
                      if (isSelected) {
                        print("case $index is selected");
                        yellowStatus = "yo";
                      } else {
                        print("case $index is unselected");
                        yellowStatus = "yc";
                      }
                      break;
                    case 1:
                      if (isSelected) {
                        print("case $index is selected");
                        blueStatus = "bo";
                      } else {
                        print("case $index is unselected");
                        blueStatus = "bc";
                      }
                      break;
                    case 2:
                      if (isSelected) {
                        print("case $index is selected");
                        greenStatus = "go";
                      } else {
                        print("case $index is unselected");
                        greenStatus = "gc";
                      }
                      break;
                    case 3:
                      if (isSelected) {
                        print("case $index is selected");
                        purpleStatus = "po";
                      } else {
                        print("case $index is unselected");
                        purpleStatus = "pc";
                      }
                      break;
                    case 4:
                      if (isSelected) {
                        print("case $index is selected");
                        redStatus = "ro";
                      } else {
                        print("case $index is unselected");
                        redStatus = "rc";
                      }
                      break;
                    default:
                  }
                  transmitMessage = yellowStatus +
                      blueStatus +
                      greenStatus +
                      purpleStatus +
                      redStatus;
                  //socketConnection.sendMessage(transmitMessage);
                  //print("Transmit Message: $transmitMessage");
                },
                buttons: [
                  "Yellow",
                  "Blue",
                  "Green",
                  "Purple",
                  "Red",
                ])
          ],
        ),
      ),
    );
  }
}
