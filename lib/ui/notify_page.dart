import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifyPage extends StatelessWidget {
  final String? label;
  const NotifyPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios),
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            'Your Task',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
            child: Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        Get.isDarkMode ? Colors.green[700] : Colors.green[400]),
                child: Center(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(this.label.toString().split("|")[0],
                            style: TextStyle(
                                color:
                                    Get.isDarkMode ? Colors.black : Colors.black,
                                fontSize: 30)),
                        Divider(),
                        Text(
                          this.label.toString().split("|")[1],
                          style: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.grey : Colors.black45,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )))));
  }
}
