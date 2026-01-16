import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:join_em/service/database_service.dart';

class EventInfo extends StatefulWidget {
  final int id;
  const EventInfo({super.key, required this.id});

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {

  // 🔹 Fetch event from DB
  Future<List<Map<String, Object?>>?> fetchEvent() async {
    return await DatabaseService.instance.FetchEventInfo(widget.id);
  }

  // 🔹 Centralised date formatter (USED EVERYWHERE)
  String formatDate(dynamic date) {
    if (date == null) return "";
    try {
      final DateTime parsed =
      date is DateTime ? date : DateTime.parse(date.toString());
      return DateFormat("dd MMM yyyy").format(parsed); // 05 Jan 2026
    } catch (_) {
      return date.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Event Details"),
        backgroundColor: const Color(0xFFe4544d),
      ),
      body: FutureBuilder<List<Map<String, Object?>>?>(
        future: fetchEvent(),
        builder: (context, snapshot) {

          // ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ No data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Event not found"));
          }

          final event = snapshot.data!.first;

          // 🔐 Safe JSON decoding
          final List prizes = event["prizes"] is String
              ? jsonDecode(event["prizes"].toString())
              : event["prizes"] as List;

          final List schedule = event["schedule"] is String
              ? jsonDecode(event["schedule"].toString())
              : event["schedule"] as List;

          final List faqs = event["faqs"] is String
              ? jsonDecode(event["faqs"].toString())
              : event["faqs"] as List;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🖼 EVENT BANNER
                if (event["image_path"] != null &&
                    File(event["image_path"].toString()).existsSync())
                  Image.file(
                    File(event["image_path"].toString()),
                    width: w,
                    height: h * 0.3,
                    fit: BoxFit.cover,
                  ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 20),

                      // 🔷 EVENT NAME
                      Text(
                        event["name"].toString(),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // 📅 EVENT DATE
                      Text(
                        "📅 ${formatDate(event["date_of_event"])}",
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 16),

                      // 📝 DESCRIPTION
                      Text(
                        event["description"].toString(),
                        style: const TextStyle(fontSize: 15),
                      ),

                      const SizedBox(height: 30),

                      // 🏆 PRIZES
                      _sectionTitle("🏆 Prizes"),
                      ...prizes.map((p) => _infoCard(
                        title: "₹ ${p["amount"]}",
                        subtitle: p["giver"],
                      )),

                      const SizedBox(height: 24),

                      // 🗓 SCHEDULE
                      _sectionTitle("🗓 Schedule"),
                      ...schedule.map((s) => _infoCard(
                        title: formatDate(s["date"]),
                        subtitle: s["description"],
                      )),

                      const SizedBox(height: 24),

                      // ❓ FAQs
                      _sectionTitle("❓ FAQs"),
                      ...faqs.map((f) => _infoCard(
                        title: f["q"],
                        subtitle: f["a"],
                      )),

                      const SizedBox(height: 40),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Join logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFe4544d),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Join",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: Sponsor logic
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFe4544d),
                                  width: 1.5,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Sponsor",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFe4544d),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),

                ),

              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 Section title widget
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // 🧱 Card widget (matches your Login UI style)
  Widget _infoCard({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
