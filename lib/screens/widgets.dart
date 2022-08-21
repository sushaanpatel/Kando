import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kando/models/db.dart';
import 'package:kando/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kando/screens/home.dart';
import 'package:skeleton_text/skeleton_text.dart';

var chosenValue;

class TaskWidget extends StatefulWidget {
  Task task;
  IconData? icon;
  TextStyle? textStyle;
  String username;
  TaskWidget(
      {required this.task, this.icon, this.textStyle, required this.username});
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    var icon = widget.task.status == 2
        ? Icons.check_circle
        : Icons.radio_button_unchecked;
    var style = widget.task.status == 2
        ? Theme.of(context).textTheme.bodyText2
        : Theme.of(context).textTheme.bodyText1;
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => {
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
                      update: true,
                      task: widget.task,
                      username: widget.username,
                    );
                  })
            },
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) async => {
              await Mongo.delete(widget.task.id),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 1500),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  content: Text(
                    'Task deleted',
                    style: GoogleFonts.poppins(
                      color: const Color(0xff95B2B8),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
              pageKey.currentState!.setState(() {})
            },
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
              splashRadius: 20,
              splashColor: Colors.red,
              onPressed: () => {
                    if (widget.task.status != 2)
                      {
                        widget.icon = Icons.check_circle,
                        widget.textStyle =
                            Theme.of(context).textTheme.bodyText2,
                        setState(() {}),
                        Future.delayed(const Duration(seconds: 2), () async {
                          await Mongo.statusUpdate(widget.task.id);
                          pageKey.currentState!.setState(() {});
                          setState(() {});
                        }),
                      }, // wids.removeLast(),
                  },
              icon: Icon(
                widget.task.status == 2
                    ? Icons.check_circle
                    : widget.task.status == 0
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_double_arrow_down_rounded,
                size: 25,
                color: Theme.of(context).textTheme.bodyText1!.color,
              )),
          Text(
            widget.task.title,
            style: style,
          )
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  String username;
  final String title;
  List children;
  // String username;
  TaskList(
      {required this.title, required this.children, required this.username});
  @override
  Widget build(BuildContext context) {
    var tasks = children.map((task) => Task.fromJson(task)).toList();
    return Expanded(
      child: Column(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.063,
                decoration: BoxDecoration(
                    color: const Color(0xff13213E),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(title,
                          style: Theme.of(context).textTheme.headline2)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...tasks.map((task) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TaskWidget(
                        task: task,
                        username: username,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class ModalSheet extends StatefulWidget {
  bool update;
  Task? task;
  String username;
  ModalSheet(
      {Key? key, required this.update, required this.username, this.task})
      : super(key: key);
  @override
  State<ModalSheet> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    if (widget.update) {
      chosenValue = widget.task!.status;
    }
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () => {
                        setState(() {
                          chosenValue = 0;
                        })
                      },
                  child: const Text('To do'),
                  style: TextButton.styleFrom(
                      backgroundColor: chosenValue == 0
                          ? Theme.of(context).textTheme.bodyText1!.color
                          : const Color(0xffb9e483),
                      primary: Colors.white,
                      shadowColor: Colors.transparent,
                      textStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.31, 50))),
              TextButton(
                  onPressed: () => {
                        setState(() {
                          chosenValue = 1;
                        })
                      },
                  child: const Text('In Progress'),
                  style: TextButton.styleFrom(
                      backgroundColor: chosenValue == 1
                          ? Theme.of(context).textTheme.bodyText1!.color
                          : const Color(0xff9ab4f3),
                      primary: Colors.white,
                      shadowColor: Colors.transparent,
                      textStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.31, 50))),
              TextButton(
                  onPressed: () => {
                        setState(() {
                          chosenValue = 2;
                        }),
                      },
                  child: const Text('Done'),
                  style: TextButton.styleFrom(
                      backgroundColor: chosenValue == 2
                          ? Theme.of(context).textTheme.bodyText1!.color
                          : const Color(0xff9fe3bd),
                      primary: Colors.white,
                      shadowColor: Colors.transparent,
                      textStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.31, 50))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextFormField(
              controller: controller,
              // initialValue: widget.update ? widget.task!.title : '',
              cursorColor: Theme.of(context).textTheme.headline1!.color,
              autofocus: true,
              showCursor: true,
              style: GoogleFonts.poppins(
                color: const Color(0xff95B2B8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                  hintText: "New Task",
                  hintStyle: GoogleFonts.poppins(
                    color: const Color(0xff95B2B8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: () => {
                        if (widget.update)
                          {
                            Mongo.update(
                                id: widget.task!.id,
                                task: controller.text,
                                status: chosenValue),
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 1500),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                content: Text(
                                  'Task Updated',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff95B2B8),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                          }
                        else
                          {
                            Mongo.insert(
                                controller.text, chosenValue, widget.username),
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 1500),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                content: Text(
                                  'Task Added',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff95B2B8),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                          },
                        Navigator.pop(context),
                        controller.clear(),
                        pageKey.currentState!.setState(() {})
                      },
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      color: const Color(0xffFEB95F),
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SkeletonAnimation(
                  shimmerDuration: 500,
                  shimmerColor: const Color(0xff192b52),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.063,
                    decoration: BoxDecoration(
                        color: const Color(0xff13213E),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10)),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SkeletonAnimation(
              shimmerDuration: 500,
              shimmerColor: const Color(0xffF6938E),
              borderRadius: BorderRadius.circular(10),
              child: Opacity(
                opacity: 0.2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                      color: const Color(0xfff1554e),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                ),
              )),
        ),
      ]),
    );
  }
}
