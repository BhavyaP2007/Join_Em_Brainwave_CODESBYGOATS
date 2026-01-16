import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:join_em/event_classes.dart';

class WelcomePage extends StatefulWidget{
  WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>{

  @override

  Widget build(BuildContext context) {
    List<List> carousel_cards = [
      ["Bhavya's Concert","https://images.pexels.com/photos/2747449/pexels-photo-2747449.jpeg?cs=srgb&dl=pexels-wolfgang-1002140-2747449.jpg&fm=jpg","Social"],
      ["Brainwave","https://images.pexels.com/photos/2747449/pexels-photo-2747449.jpeg?cs=srgb&dl=pexels-wolfgang-1002140-2747449.jpg&fm=jpg","Competition"]
    ];
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.grey.withOpacity(0.5),
        height: MediaQuery.of(context).size.height * 0.07,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.emoji_events), iconSize: 30),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.event_note),iconSize: 30,),

                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.account_circle_sharp), iconSize: 30),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.add), iconSize: 30),

              ],
            ),)),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.93,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06,right: MediaQuery.of(context).size.width * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text("Join'Em",textAlign: TextAlign.center,style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1,
                              ),),
                              Spacer(),
                              IconButton(onPressed: (){}, icon: Icon(Icons.search),alignment: Alignment.topRight,iconSize: 30,)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text("Featured",style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1,
                        ),),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Container(
                          child: CarouselSlider(items:
                            carousel_cards.map((card)=>EventCard(competition: Competition(name: card[0], image_path: card[1], event: Event(event_type: card[2]))),
                            ).toList(),
                            options: CarouselOptions(
                              aspectRatio: 16/9,
                              height: 200,
                              autoPlay: true,
                              autoPlayAnimationDuration: Duration(milliseconds: 800),
                              autoPlayInterval: Duration(seconds: 3),
                              viewportFraction: 0.8,
                              enlargeCenterPage: true
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text("Recommended",style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1,
                        ),),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Container(
                          child: CarouselSlider(items:
                          carousel_cards.map((card)=>EventCard(competition: Competition(name: card[0], image_path: card[1], event: Event(event_type: card[2]))),
                          ).toList(),
                            options: CarouselOptions(
                                aspectRatio: 16/9,
                                height: 200,
                                autoPlay: true,
                                autoPlayAnimationDuration: Duration(milliseconds: 800),
                                autoPlayInterval: Duration(seconds: 3),
                                viewportFraction: 0.8,
                                enlargeCenterPage: true
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      )
    );
  }
}