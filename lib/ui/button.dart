import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({ Key? key, required this.label, required this.onTap }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 60,
        padding: EdgeInsets.only(top: 20,left: 25, bottom: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}