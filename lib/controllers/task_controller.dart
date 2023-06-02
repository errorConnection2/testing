import 'package:get/get.dart';
import 'package:reminder/db/db_Helper.dart';
import 'package:reminder/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  //get all the data from table
  void getTask() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTask();
    //print(val); // taro ke samping db helper  var val=
  }

  void markTaskCompleted(Task task, DateTime dateTime) async {
    if (task.repeat == "Daily") {
      //await DBHelper.getById(task.id!);
      dynamic tasks = await DBHelper.getById(task.id!);
     String taskDate = tasks[0]['dateArr'].toString().replaceAll('[', '').replaceAll(']', '') ;
     List <dynamic> updatedTask = [];
      updatedTask.add(taskDate);
     updatedTask.add(dateTime.toString());
      print(updatedTask.toString());
      await DBHelper.updateDaily(task.id!, dateTime);
    } else {
      await DBHelper.update(task.id!);
    }

    getTask();
  }
}
