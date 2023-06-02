import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reminder/controllers/task_controller.dart';
import 'package:reminder/models/task.dart';
import 'package:reminder/services/notification_services.dart';
import 'package:reminder/ui/add_taskBar.dart';
import 'package:reminder/ui/theme.dart';
import 'package:reminder/ui/theme_services.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:reminder/ui/button.dart';
import 'package:reminder/ui/widgets/task_tile.dart';
import 'package:flutter/animation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  var notifyHelper;
  @override
  void initState() {
    notifyHelper = NotifiHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _showTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appbar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              print(_taskController.taskList.length);
              Task task = _taskController.taskList[index];
              print(task.toJson());
              if (task.repeat == 'Daily') {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task);
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                        child: FadeInAnimation(
                            child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task))
                      ],
                    ))));
              }
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                print('Tanggalskrg' + DateTime.now().day.toString());
                print('Bulanskrg' + DateTime.now().month.toString());
                print('Tahunskrg' + DateTime.now().year.toString());
                //=====
                print('TanggalTask' + task.date!.split('/')[1]);
                print('BulanTask' + task.date!.split('/')[0]);
                print('TahunTask' + task.date!.split('/')[2]);

                if (DateTime.now().day.toString() == task.date!.split('/')[1] &&
                    DateTime.now().month.toString() ==
                        task.date!.split('/')[0] &&
                    DateTime.now().year.toString() ==
                        task.date!.split('/')[2]) {
                  notifyHelper.scheduledNotification(
                      int.parse(myTime.toString().split(":")[0]),
                      int.parse(myTime.toString().split(":")[1]),
                      task);
                }
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                        child: FadeInAnimation(
                            child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task))
                      ],
                    ))));
              } else {
                return Container();
              }
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  ontap: () {
                    _taskController.markTaskCompleted(task, _selectedDate);
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context,
                ),
          SizedBox(height: 5),
          _bottomSheetButton(
            label: "Delete Task",
            ontap: () {
              _confirmalert(context, task);
            },
            clr: Colors.red[300]!,
            context: context,
          ),
          SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
            label: "Close",
            ontap: () {
              Get.back();
            },
            clr: Colors.red[300]!,
            isClose: true,
            context: context,
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ));
  }

  _confirmalert(BuildContext context, Task task) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are You sure you want to delete?'),
            content: Text('The data will be delete permanently'),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    _taskController.delete(task);
                    Get.offAll(HomePage());
                  },
                  child: Text('Yes'))
            ],
          );
        });
  }

  _bottomSheetButton(
      {required String label,
      required Function()? ontap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: HeadingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: "+ Add Reminder",
              onTap: () async {
                await Get.to(AddTaskPage());
                _taskController.getTask();
              })
        ],
      ),
    );
  }

  _appbar() {
    return AppBar(
      backgroundColor: Color(0XFFf4f0ec),
      title: Text("Reminder", style: titleStyle),
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
      leading: GestureDetector(
          onTap: () {
            sReminderNotifikasi();
          },
          child: Icon(
            Get.isDarkMode ? Icons.arrow_back_ios : Icons.arrow_back_ios,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          )),
          
    );
  }
}
