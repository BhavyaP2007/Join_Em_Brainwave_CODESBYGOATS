import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Event{
  late String event_type;
  Event({required this.event_type});
}
class Competition{
  late final Event event;
  late String name,image_path,description,prizes,schedule,date_of_event,online_offline,venue,faqs,text_file,reviews,n_participants,total_participants,team_data;
  Competition({required this.name,required this.image_path,required this.event});
}
class EventCard extends StatelessWidget{
  late final Competition competition;
  EventCard({super.key,required this.competition});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          height: 140,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: NetworkImage(competition.image_path),fit: BoxFit.cover)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Row(
            children: [
              Text(competition.name),
              Spacer(),
              Text(competition.event.event_type),
            ],
          ),
        )
      ],
    );
  }

}