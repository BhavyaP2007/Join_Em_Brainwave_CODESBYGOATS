import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:join_em/create_account.dart';
import 'package:join_em/service/database_service.dart';
import 'package:join_em/service/welcome_page.dart';
import 'package:quickalert/quickalert.dart';

class LoginPage extends StatefulWidget{
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
  final DatabaseService _databaseService = DatabaseService.instance;
  final GlobalKey<FormState> _createAccountKey = GlobalKey<FormState>();
  void submitCreateAccountForm() async{
    if(_createAccountKey.currentState!.validate()){
      _createAccountKey.currentState!.save();
      final userexists = await _databaseService.userExists(email);
      if(userexists == true){
        print(email);
        print(password);
        final userdetails = await _databaseService.LoginUser(email, password);
        if(userdetails != null && userdetails.isNotEmpty){
          print(userdetails);

          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> WelcomePage(userdetails: userdetails))
          );
        }
        else{
          QuickAlert.show(context: context, type: QuickAlertType.error,text: "Incorrect Password",confirmBtnText: "Retry",confirmBtnColor: Color(0xFFe4544d),onConfirmBtnTap: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        }

      }
      else{
        QuickAlert.show(context: context, type: QuickAlertType.error,text: "No such user exists",confirmBtnText: "Create Account",confirmBtnColor: Color(0xFFe4544d),onConfirmBtnTap: (){
          Navigator.of(context).pop();
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateAccountPage())
          );
        });
        print("No such user exists");
      }

    }
  }

  String? email;
  String? password;
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
                    Text("Login",textAlign: TextAlign.center,style: TextStyle(
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
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}