import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:join_em/login.dart';
import 'package:join_em/service/welcome_page.dart';

import 'create_event.dart';

class UserProfile extends StatefulWidget{
  final List userdetails;
  UserProfile({super.key,required this.userdetails});
  @override
  State<UserProfile> createState() =>
    // TODO: implement createState
    _UserProfileState(userdetails:userdetails);
}

class _UserProfileState extends State<UserProfile>{
  final List userdetails;
  _UserProfileState({required this.userdetails});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: Container(
          color: Colors.grey.withOpacity(0.5),
          height: MediaQuery.of(context).size.height * 0.07,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Row(
              children: [
                IconButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> WelcomePage(userdetails: userdetails))
                  );
                }, icon: Icon(Icons.emoji_events), iconSize: 30),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.event_note),iconSize: 30,),
                Spacer(),

                IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> HostEventPage(userdetails: userdetails,))), icon: Icon(Icons.add), iconSize: 30),
                Spacer(),
                IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfile(userdetails: userdetails))), icon: Icon(Icons.account_circle_sharp), iconSize: 30),
              ],
            ),)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
               color:  Color(0xFFe4544d).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.1,
                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.account_circle_sharp), iconSize: 100),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.05,
                ),
                Text(userdetails[0]["email"],style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"
                ),)
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.05,
          ),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05,right: MediaQuery.of(context).size.width * 0.05),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                border: BoxBorder.all(
                  color: Color(0xFFe4544d).withValues(alpha: 0.7),
                  width: 1,
                  style: BorderStyle.solid
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.create_outlined), iconSize: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text("Edit Profile",style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500
                  ),)
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.02,
          ),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05,right: MediaQuery.of(context).size.width * 0.05),
            child: InkWell(
              onTap: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()),(route)=> false);
              },
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  border: BoxBorder.all(
                      color: Color(0xFFe4544d).withValues(alpha: 0.7),
                      width: 1,
                      style: BorderStyle.solid
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()),(route)=> false);
                    }, icon: Icon(Icons.exit_to_app), iconSize: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text("Logout",style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500
                    ),)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}