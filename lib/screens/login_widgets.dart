import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kando/main.dart';
import 'package:kando/models/db.dart';
import 'package:kando/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

var err = '';

class LoginPage extends StatefulWidget {
  bool login;
  LoginPage({required this.login});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nUser = TextEditingController();
    TextEditingController nPass = TextEditingController();
    TextEditingController nEmail = TextEditingController();
    if (widget.login) {
      return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.headline1!.color, size: 30),
            title: Text('KanDo', style: Theme.of(context).textTheme.headline1),
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        body: Column(
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height * 0.18),
            Align(
              alignment: Alignment.center,
              child: Column(children: [
                Center(
                    child: Text(err,
                        style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 20,
                            decoration: TextDecoration.none))),
                const SizedBox(height: 10),
                Input(controller: nUser, hint: 'Username'),
                const SizedBox(height: 10),
                Input(controller: nPass, hint: 'Password'),
                const SizedBox(height: 15),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xfff1554e),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      Mongo.checkpass(nUser.text, nPass.text)
                          .then((value) async {
                        if (value == 'true') {
                          await SP.pref.setString('username', nUser.text);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage(
                                      // username: nUser.text,
                                      )));
                        } else {
                          err = 'Password Incorrect';
                          setState(() {});
                        }
                      });
                    },
                    child: Text('Login',
                        style: GoogleFonts.poppins(
                          color: const Color(0xff13213E),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ))),
                const SizedBox(height: 10),
                TextButton(
                  child: Text('Dont have an account?'),
                  onPressed: () => {widget.login = false, setState(() {})},
                )
              ]),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.headline1!.color, size: 30),
            title: Text('KanDo', style: Theme.of(context).textTheme.headline1),
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        body: Column(
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height * 0.18),
            Align(
              alignment: Alignment.center,
              child: Column(children: [
                Center(
                    child: Text(err,
                        style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 20,
                            decoration: TextDecoration.none))),
                const SizedBox(height: 10),
                Input(controller: nEmail, hint: 'Email'),
                const SizedBox(height: 10),
                Input(controller: nUser, hint: 'Username'),
                const SizedBox(height: 10),
                Input(controller: nPass, hint: 'Password'),
                const SizedBox(height: 15),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xfff1554e),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      print(nUser.text);
                      Mongo.original(nUser.text).then((String val) async {
                        if (val == 'true') {
                          await Mongo.adduser(
                              nUser.text, nPass.text, nEmail.text);
                          nUser.clear();
                          nPass.clear();
                          nEmail.clear();
                          await SP.pref.setString('username', nUser.text);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage(
                                      // username: nUser.text,
                                      )));
                        } else {
                          err = 'Username already exists';
                          print('err');
                          setState(() {});
                        }
                      });
                    },
                    child: Text('Register',
                        style: GoogleFonts.poppins(
                          color: const Color(0xff13213E),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ))),
                const SizedBox(height: 10),
                TextButton(
                  child: Text('Have an account?'),
                  onPressed: () => {widget.login = true, setState(() {})},
                )
              ]),
            ),
          ],
        ),
      );
    }
  }
}

class Input extends StatelessWidget {
  TextEditingController controller;
  String hint;
  Input({required this.controller, required this.hint});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: TextFormField(
          controller: controller,
          cursorColor: Theme.of(context).textTheme.bodyText1!.color,
          autofocus: true,
          showCursor: true,
          style: GoogleFonts.poppins(
            color: const Color(0xfff1554e),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xff13213E),
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xfff1554e),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        ),
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  String username;
  MenuDrawer({required this.username});
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SafeArea(
          child: Column(
            children: [
              Text(
                'Menu',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Center(
                  child: Column(
                      children: username == ''
                          ? [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage(login: false)));
                                },
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.how_to_reg,
                                    color: Color(0xffFEB95F),
                                    size: 28,
                                  ),
                                  title: Text(
                                    'Register',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xfff1554e),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ]
                          : [
                              ListTile(
                                leading: const Icon(
                                  Icons.account_circle,
                                  color: Color(0xffFEB95F),
                                  size: 28,
                                ),
                                title: Text(
                                  username,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xfff1554e),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  SP.pref.setString('username', '');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.logout_rounded,
                                    color: Color(0xffFEB95F),
                                    size: 28,
                                  ),
                                  title: Text(
                                    'Logout',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xfff1554e),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]))
            ],
          ),
        ));
  }
}
