import 'package:flutter/material.dart';
import 'package:kando/main.dart';
import 'package:kando/screens/login_widgets.dart';
import 'package:kando/screens/widgets.dart';
import 'package:kando/models/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? uname = '';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final pref = SP.pref;
    if (pref.containsKey('username')) {
      uname = pref.getString('username');
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return LoginPage(
      //     login: true,
      //   );
      // }));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(uname);
    return Scaffold(
        drawer: MenuDrawer(username: uname.toString()),
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Theme.of(context).textTheme.headline1!.color, size: 35),
          title: Text('KanDo', style: Theme.of(context).textTheme.headline1),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                isScrollControlled: true,
                builder: (context) {
                  return ModalSheet(
                    username: uname.toString(),
                    update: false,
                  );
                })
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).textTheme.headline2!.color,
            size: 40,
          ),
          elevation: 0,
          backgroundColor: const Color(0xff95B2B8),
        ),
        body: FutureBuilder(
            future: Mongo.getall(uname.toString()),
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Skeleton(),
                    const SizedBox(height: 10),
                    Skeleton(),
                    const SizedBox(height: 10),
                    Skeleton(),
                    const SizedBox(height: 10),
                  ],
                );
              } else {
                List<Map<String, dynamic>> tasks = snapshot.data ?? [];
                List<Map<String, dynamic>> todo = [];
                List<Map<String, dynamic>> inprogress = [];
                List<Map<String, dynamic>> done = [];
                if (tasks != []) {
                  for (var i in tasks) {
                    switch (i['status']) {
                      case 0:
                        todo.add(i);
                        break;
                      case 1:
                        inprogress.add(i);
                        break;
                      case 2:
                        done.add(i);
                        break;
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskList(
                          title: 'To Do',
                          children: todo,
                          username: uname.toString()),
                      // username: widget.username),
                      TaskList(
                          title: 'In Progress',
                          children: inprogress,
                          username: uname.toString()),
                      // username: widget.username),
                      TaskList(
                          title: 'Done',
                          children: done,
                          username: uname.toString()),
                      // username: widget.username),
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Text('No Tasks found, Add some!',
                            style: Theme.of(context).textTheme.headline1),
                        IconButton(
                            onPressed: () => {
                                  showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return ModalSheet(
                                          update: false,
                                          username: uname.toString(),
                                        );
                                      })
                                },
                            icon: const Icon(Icons.add))
                      ],
                    ),
                  );
                }
              }
            }));
  }

  void setst() {
    setState(() {});
  }
}
