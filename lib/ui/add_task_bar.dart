import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saqr_elfirgany/ui/widgets/button.dart';

import '/ui/theme.dart';
import '/ui/widgets/input_filed.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "09:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Task", style: headingStyle),
                MyInputField(title: "Title", hint: "Enter your title"),
                MyInputField(title: "Note", hint: "Enter your note"),
                MyInputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: "Start Date",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFormUser(isStartTime: true),
                          icon: Icon(
                            Icons.access_alarm_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MyInputField(
                        title: "End Date",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFormUser(isStartTime: false),
                          icon: Icon(
                            Icons.access_alarm_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                MyInputField(
                  title: "Remind",
                  hint: "$_selectedRemind minutes early",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    items: remindList.map<DropdownMenuItem<String>>(
                      (int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                      },
                    ).toList(),
                  ),
                ),
                MyInputField(
                  title: "Repeat",
                  hint: "$_selectedRepeat",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    items: repeatList.map<DropdownMenuItem<String>>(
                      (String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value!,
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorPallete(),
                    MyButton(label: 'Create Task', onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColor == index
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.png"),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2051),
    );
    if (_pickDate != null) {
      setState(() {
        _selectedDate = _pickDate;
      });
    } else {
      print("_pickDate is null or something wrong");
    }
  }

  _getTimeFormUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("pickedTime == null");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
