import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_em/service/database_service.dart';
import 'package:join_em/service/welcome_page.dart';
import 'package:join_em/user_profile.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class HostEventPage extends StatefulWidget {
  final List userdetails;
  HostEventPage({super.key,required this.userdetails});


  @override
  State<HostEventPage> createState() => _HostEventPageState(userdetails: userdetails);
}

class _HostEventPageState extends State<HostEventPage> {
  // ---------------- CONTROLLERS ----------------
  final TextEditingController eventNameCtrl = TextEditingController();
  final TextEditingController eventDescCtrl = TextEditingController();
  String eventType = "Competition";
  String eventMode = "Online";
  DateTime? eventDate;

  List<Map<String, TextEditingController>> prizes = [];
  List<Map<String, TextEditingController>> faqs = [];
  List<Map<String, dynamic>> schedules = [];

  // ---------------- IMAGE ----------------
  final ImagePicker _picker = ImagePicker();
  File? bannerImage;
  String? bannerImagePath;

  // ---------------- TEXT FILE ----------------
  File? textFile;
  String textFileContent = "NA";

  // ---------------- IMAGE PICKER ----------------
  Future<void> pickAndSaveImage() async {
    final XFile? picked =
    await _picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(picked.path);
    final savedPath = p.join(dir.path, fileName);

    final savedImage = await File(picked.path).copy(savedPath);

    setState(() {
      bannerImage = savedImage;
      bannerImagePath = savedImage.path;
    });
  }

  // ---------------- TEXT FILE PICKER ----------------
  Future<void> pickTextFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result == null) return;

    File file = File(result.files.single.path!);
    String content = await file.readAsString();

    setState(() {
      textFile = file;
      textFileContent = content;
    });
  }

  // ---------------- BUILD ----------------
  final List userdetails;
  _HostEventPageState({required this.userdetails});
  @override
  Widget build(BuildContext context) {
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _sectionTitle("Host an Event"),

              // ---------------- BANNER ----------------
              _sectionTitle("Event Banner"),
              GestureDetector(
                onTap: pickAndSaveImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFe4544d)),
                    image: bannerImage != null
                        ? DecorationImage(
                      image: FileImage(bannerImage!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: bannerImage == null
                      ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_photo_alternate,
                            size: 40, color: Color(0xFFe4544d)),
                        SizedBox(height: 8),
                        Text("Add Banner Image"),
                      ],
                    ),
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- TEXT FILE ----------------
              _sectionTitle("Event Text File"),
              GestureDetector(
                onTap: pickTextFile,
                child: Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFe4544d)),
                  ),
                  child: Center(
                    child: Text(
                      textFile != null
                          ? "Uploaded: ${p.basename(textFile!.path)}"
                          : "Upload Event Details (.txt)",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- EVENT DETAILS ----------------
              _sectionTitle("Event Details"),
              _inputField("Event Name", eventNameCtrl),
              _inputField("Event Description", eventDescCtrl, maxLines: 3),

              const SizedBox(height: 20),

              // ---------------- EVENT TYPE ----------------
              _sectionTitle("Event Type"),
              ...["Competition", "Social"].map(
                    (type) => RadioListTile(
                  value: type,
                  groupValue: eventType,
                  title: Text(type),
                  activeColor: const Color(0xFFe4544d),
                  onChanged: (val) {
                    setState(() {
                      eventType = val!;
                      if (eventType == "Social") prizes.clear();
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- EVENT MODE ----------------
              _sectionTitle("Event Mode"),
              ...["Online", "Offline", "Hybrid"].map(
                    (mode) => RadioListTile(
                  value: mode,
                  groupValue: eventMode,
                  title: Text(mode),
                  activeColor: const Color(0xFFe4544d),
                  onChanged: (val) => setState(() => eventMode = val!),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- MAIN DATE ----------------
              _sectionTitle("Main Event Date"),
              _datePickerTile(
                label: eventDate == null
                    ? "Select Date"
                    : eventDate!.toLocal().toString().split(" ")[0],
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => eventDate = picked);
                },
              ),

              const SizedBox(height: 30),

              // ---------------- PRIZES ----------------
              if (eventType == "Competition") ...[
                _sectionTitle("Prizes"),
                ...prizes.asMap().entries.map(
                      (e) => _cardContainer(
                    Column(
                      children: [
                        _inputField("Prize Amount",
                            e.value["amount"]!,
                            keyboardType: TextInputType.number),
                        _inputField("Given By", e.value["giver"]!),
                      ],
                    ),
                  ),
                ),
                _addButton("Add Prize", () {
                  setState(() {
                    prizes.add({
                      "amount": TextEditingController(),
                      "giver": TextEditingController(),
                    });
                  });
                }),
              ],

              const SizedBox(height: 30),

              // ---------------- FAQS ----------------
              _sectionTitle("FAQs"),
              ...faqs.asMap().entries.map(
                    (e) => _cardContainer(
                  Column(
                    children: [
                      _inputField("Question", e.value["q"]!,
                          textInputAction: TextInputAction.next),
                      _inputField("Answer", e.value["a"]!,
                          maxLines: 2,
                          textInputAction: TextInputAction.done),
                    ],
                  ),
                ),
              ),
              _addButton("Add FAQ", () {
                setState(() {
                  faqs.add({
                    "q": TextEditingController(),
                    "a": TextEditingController(),
                  });
                });
              }),

              const SizedBox(height: 30),

              // ---------------- SCHEDULE ----------------
              _sectionTitle("Event Schedule"),
              ...schedules.asMap().entries.map(
                    (e) => _cardContainer(
                  Column(
                    children: [
                      _datePickerTile(
                        label: e.value["date"] == null
                            ? "Select Date"
                            : e.value["date"]
                            .toLocal()
                            .toString()
                            .split(" ")[0],
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                            initialDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => e.value["date"] = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      _inputField(
                        "What will happen on this day?",
                        e.value["description"],
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              _addButton("Add Schedule Day", () {
                setState(() {
                  schedules.add({
                    "date": null,
                    "description": TextEditingController(),
                  });
                });
              }),

              const SizedBox(height: 40),

              // ---------------- SUBMIT ----------------
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFe4544d),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: submitEvent,
                  child: const Text("Create Event",
                      style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SUBMIT ----------------
  void submitEvent() async{
    final eventData = {
      "name": eventNameCtrl.text,
      "description": eventDescCtrl.text,
      "type": eventType,
      "mode": eventMode,
      "eventDate": eventDate?.toString() ?? "NA",
      "bannerPath": bannerImagePath ?? "NA",
      "textFileContent": textFileContent,
      "prizes": prizes
          .map((p) => {"amount": p["amount"]!.text, "giver": p["giver"]!.text})
          .toList(),
      "faqs": faqs.map((f) => {"q": f["q"]!.text, "a": f["a"]!.text}).toList(),
      "schedule": schedules
          .map((s) => {"date": s["date"]?.toString() ?? "NA", "description": s["description"]!.text})
          .toList(),
    };
    final DatabaseService _databaseService = await DatabaseService.instance;
    if(eventData["name"].toString() == "cleardb"){
      _databaseService.CLearEvents();
      return;
    }
    _databaseService.addEvent(imagePath: eventData["bannerPath"].toString(), description: eventData["description"].toString(), prizes: jsonEncode(eventData["prizes"]).toString(), schedule: jsonEncode(eventData["schedule"]).toString(), dateOfEvent: eventData["eventDate"].toString(), offlineOnline: eventData["mode"].toString(),  faqs: jsonEncode(eventData["faqs"]).toString(), textFile: eventData["textFileContent"].toString(), name: eventData["name"].toString());

    final info = await _databaseService.database;
    final result = await info!.rawQuery("SELECT COUNT(*) FROM competition");
    debugPrint(result.toString());
  }

  // ---------------- UI HELPERS ----------------
  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(t,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
  );

  Widget _inputField(
      String hint,
      TextEditingController ctrl, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        TextInputAction textInputAction = TextInputAction.next,
      }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            hintText: hint,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFe4544d)),
            ),
          ),
        ),
      );

  Widget _cardContainer(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );

  Widget _addButton(String label, VoidCallback onTap) => TextButton.icon(
    onPressed: onTap,
    icon: const Icon(Icons.add, color: Color(0xFFe4544d)),
    label: Text(label, style: const TextStyle(color: Color(0xFFe4544d))),
  );

  Widget _datePickerTile({required String label, required VoidCallback onTap}) =>
      ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFe4544d)),
        ),
        title: Text(label),
        trailing: const Icon(Icons.calendar_month),
        onTap: onTap,
      );
}
