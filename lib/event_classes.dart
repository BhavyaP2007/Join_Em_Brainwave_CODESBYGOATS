import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:join_em/event_info.dart';


class Event{
  late String event_type;
  Event({required this.event_type});
}
class Competition{
  late final Event event;
  late final DateTime date_of_event;
  late String name,image_path,description,prizes,schedule,online_offline,faqs,text_file,reviews;
  Competition({required this.name,required this.image_path,required this.event,required this.date_of_event});
}
class EventCard extends StatelessWidget{
  late final Competition competition;
  late int id;
  EventCard({super.key,required this.competition,required this.id});
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.yMMMd("en-US");
    // TODO: implement build
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EventInfo(id: id)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(image: FileImage(File(competition.image_path)))
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(competition.name),
                    Spacer(),
                    Text(formatter.format(competition.date_of_event.toLocal()))
                  ],
                ),
                Opacity(
                    opacity: 0.5,
                    child: Text(competition.event.event_type)),
              ],
            ),
          )
        ],
      ),
    );
  }

}