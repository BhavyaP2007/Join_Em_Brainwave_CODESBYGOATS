import 'dart:io';
import 'package:flutter/material.dart';
import 'package:join_em/main.dart';
import 'package:join_em/service/database_service.dart';
import 'package:quickalert/quickalert.dart';

class CreateAccountPage extends StatefulWidget{
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage>{
  final GlobalKey<FormState> _createAccountKey = GlobalKey<FormState>();

  List employment_types = [
    "Student","Employed","Self-Employed","Unemployed","Freelancer"
  ];
  String? selected_Employment_type;
  List account_types = ["Individual","Company"];
  String? selected_account_type;
  String? name;
  String? email;
  String? password;
  final DatabaseService _databaseService = DatabaseService.instance;


  void submitCreateAccountForm() async{
    if(_createAccountKey.currentState!.validate()){
      _createAccountKey.currentState!.save();
      print(name);
      print(selected_account_type);
      print(selected_Employment_type);
      print(email);
      print(password);
      if(email=="cleardb@bhavya.com"){
        _databaseService.ClearUsers();
        print("users cleared");
        return;
      }
      final user_exists = await _databaseService.userExists(email);
      if(user_exists == true){
        print("user exists");
        QuickAlert.show(context: context, type: QuickAlertType.error,text: "User already exists",confirmBtnText: "Retry",confirmBtnColor: Color(0xFFe4544d)
        );
      }
      else{
        print("user doesn\'t exits");
        _databaseService.addUser(name, email, password, selected_Employment_type, selected_account_type);
        QuickAlert.show(context: context, type: QuickAlertType.success,text: "Account created successfully",confirmBtnColor: Colors.green,onConfirmBtnTap: () => Navigator.of(context)..pop()..pop());
      }

    }
  }
  String? _SubmitName(String? nameOfPerson){
    if(nameOfPerson!.isEmpty){
      return "Name cannot be empty";
    }
    if(!RegExp(r"[a-zA-Z]+$").hasMatch(nameOfPerson.toString())){
      return "Name can only contain alphabets";
    }
    return null;
  }
  String? _SubmitEmail(String? mail){
    if(mail!.isEmpty){
      return "Mail cannot be empty";
    }
    if(!mail.contains("@")){
      return "Mail should contain @";
    }
    String mail_host = mail.split("@")[1];
    if(!mail_host.contains(".")){
      return "Invalid or Incomplete E-mail address";
    }
    return null;
  }
  String? _SubmitPassword(String? password){
    if(password!.length < 8){
      return "Password should have atleast 8 characters";
    }
    if(password.contains(" ")){
      return "Password should not contain blank spaces";
    }
    return null;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          // alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Join'Em",textAlign: TextAlign.center,style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                  ),),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Padding(
                padding:EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Create Account",textAlign: TextAlign.center,style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06,right: MediaQuery.of(context).size.width * 0.06),
                child: Form(
                  key: _createAccountKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (value) => name = value,
                        keyboardType: TextInputType.name,
                        validator: _SubmitName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFe4544d),
                            )
                          ),
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Color(0xFFe4544d),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        onSaved: (value) => email = value,
                        keyboardType: TextInputType.emailAddress,
                        validator: _SubmitEmail,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFe4544d),
                                )
                            ),
                            labelText: "E-mail",
                            labelStyle: TextStyle(
                              color: Color(0xFFe4544d),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        onSaved: (value) => password = value,
                        keyboardType: TextInputType.visiblePassword,
                        validator: _SubmitPassword,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        obscureText: true,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFe4544d),
                                )
                            ),
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Color(0xFFe4544d),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      DropdownButtonFormField(
                        validator: (value){
                          if(value==null){
                            return "No value selected";
                          }
                          return null;
                        },
                          decoration: InputDecoration(
                            hintText: "Employment Type",
                            hintStyle: TextStyle(
                                color: Color(0xFFe4544d)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFe4544d),
                                )
                            ),
                          ),
                          items: employment_types.map(
                                  (ep_type){
                            return DropdownMenuItem(child: Text(ep_type),value: ep_type);
                          }).toList(),
                          onChanged: (ep_type){
                            setState(() {
                              selected_Employment_type = ep_type.toString();
                            });
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      DropdownButtonFormField(
                          validator: (value){
                            if(value==null){
                              return "No value selected";
                            }
                            return null;
                          },
                        decoration: InputDecoration(
                          hintText: "Account Type",
                          hintStyle: TextStyle(
                            color: Color(0xFFe4544d)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFFe4544d),
                            )

                          )

                        ),
                        items: account_types.map(
                        (acc_type){
                          return DropdownMenuItem(child: Text(acc_type),value: acc_type,);
                        }).toList(),
                        onChanged: (acc_type){
                          setState(() {
                            selected_account_type = acc_type.toString();
                          });
                        }
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                            onPressed: submitCreateAccountForm,
                            child: Text("Submit",style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFe4544d),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}