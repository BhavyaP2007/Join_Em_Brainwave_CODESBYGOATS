import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:join_em/create_account.dart';
import 'package:join_em/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState(){
    super.initState();
    Timer(
      const Duration(seconds: 2),
        () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: Text("Join'Em",style: TextStyle(
          color: Colors.black,
          fontSize: 50,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w700,
          letterSpacing: -1
        ),),
      )
    );
  }
}
class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Welcome to Join\'Em",textAlign: TextAlign.center,style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 30,
                  fontWeight: FontWeight.w900
                ),),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Text("Create an account with us and experience serious event planning.",textAlign: TextAlign.center,style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                ),)
              ]
            ),
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(buttontext: "Create Account", textcolor: Colors.white, buttoncolor: Color(0xFFe4544d),widthfactor: 0.7,bordercolor: Color(0xFFe4544d),class_path: CreateAccountPage(),),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                CustomButton(buttontext: "Login", textcolor: Color(0xFFe4544d), buttoncolor: Colors.white,widthfactor: 0.7,bordercolor: Color(0xFFe4544d),class_path: LoginPage(),),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget{
  final Color textcolor;
  final Color buttoncolor;
  final String buttontext;
  final double widthfactor;
  final Color bordercolor;
  final Widget class_path;
  const CustomButton({super.key,required this.buttontext,required this.textcolor,required this.buttoncolor,required this.widthfactor,required this.bordercolor,required this.class_path});
  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * widthfactor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttoncolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          side: BorderSide(
            color: bordercolor,
            width: 0.8
          )

        ),
          onPressed: (){
            Navigator.push(
              context,
            MaterialPageRoute(builder: (context) => class_path)
            );
          },
          child: Text(buttontext,style: TextStyle(
            color: textcolor,
          ),)
      ),
    );
}
}