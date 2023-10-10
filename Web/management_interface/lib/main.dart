import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


/* Original design
void main() {
  runApp(MyApp());
}
*/


void main() async {
  print("Enter the man function");  // Debug print
  // Initialize Firebase
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  print("Firebase initialized");  // Debug print
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Building MyApp widget");  // Debug print
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
      ],
      theme: ThemeData(
        fontFamily: 'NotoSansTC',
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Travel Information")),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  MyFormState createState() {
    print("Creating MyFormState");  // Debug print
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  Future<void> _sendToFirebase() async {
    print("Attempting to send data to Firebase");  // Debug print
    CollectionReference travelData = FirebaseFirestore.instance.collection('travelData');
    return travelData.add({
      'travelDate': formatter.format(selectedDate),
      'travelTime': selectedTime.format(context),
      // Add other fields here
    })
    .then((value) {
      print("Data Added");  // Debug print
    })
    .catchError((error) {
      print("Failed to add data: $error");  // Debug print
    });
  }


  @override
  Widget build(BuildContext context) {
    print("Building MyFormState widget");  // Debug print
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Text("Travel Date:", style: TextStyle(fontFamily: 'NotoSansTC')),
          TextButton(
            onPressed: () => _selectDate(context),
            child: Text(formatter.format(selectedDate)),
          ),
          Text("Travel Time:", style: TextStyle(fontFamily: 'NotoSansTC')),
          TextButton(
            onPressed: () => _selectTime(context),
            child: Text(selectedTime.format(context)),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Flight Number:"),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Passenger Name:"),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Contact Number:"),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Pick-up Location:"),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Drop-off Location:"),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Number of Passengers:"),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Number of Luggage:"),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Remarks:"),
          ),
          SizedBox(height: 30.0),  // Add space here
          Container(
            height: 50.0,  // Customize height here
            width: 200.0,  // Customize width here
            child: ElevatedButton(
              onPressed: _sendToFirebase,
              child: Text("Confirm and Send to System"),
            ),
          ),
        ],
      ),
    );
  }
}
