import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calorie/Widget/AppText.dart';
import 'package:flutter_calorie/Widget/ThemeChanger.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.title})
      : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FocusNode _nodeText1 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[300],
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
              focusNode: _nodeText1,
              toolbarButtons: [
                    (node) {
                  return GestureDetector(
                    onTap: () {
                      node.unfocus();
                    } ,
                    child: platformDoneButton(),
                  );
                }
              ]
          ),

        ]
    );
  }

  double userBaseCalorie;
  double userSportCalorie;
  bool gender = true;
  int userAge = 0;
  double cmSize = 165.0;
  double userWeight = 0.0;
  int userActivity = 1;
  Map userActivityState = {
    'Faible' : 0,
    'Moderé' : 1,
    'Intense' : 2
  };

  @override
  Widget build(BuildContext mainContext) {
    return PlatformCheck.isIOS ?
    CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: AppText(widget.title),
          backgroundColor: genderColor(),
        ),
        child: body()
    )
        :
    Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: body()
    );
  }

  Widget body() {
    return KeyboardActions(
        config: _buildConfig(context),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppText('Remplissez tous les champs pour obtenir votre besoin journalier en calories'),
              spacePadding(),
              Card(
                  elevation: 10.0,
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        spacePadding(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText('Femme', color: Colors.pink),
                            platformSwitch(gender, updateGender),
                            AppText('Homme', color: Colors.blue)
                          ],
                        ),
                        genderDivider(height: 30.0),
                        platformButton(userAge == 0 ? 'Renseigner votre age' : 'Votre age: $userAge ans', () {chooseDateOfBirth();}),
                        genderDivider(height: 30.0),
                        AppText('Votre taille est de: ${cmSize.toInt()} cm', color: genderColor()),
                        platformSlider(cmSize, updateUserSize, min: 100.0, max: 240.0, activeColor: genderColor(), inactiveColor: genderColor(clear: true)),
                        genderDivider(height: 30.0),
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: platformTextField('Entrez votre poids en kilo',updateUserWeight, _nodeText1)
                        ),
                        genderDivider(height: 30.0),
                        AppText('Quelle est votre activité sportive?', color: genderColor()),
                        userActivityRadio(),
                        spacePadding()
                      ]
                  )
              ),
              spacePadding(),
              platformButton('Calculer', () {
                if(allInfoSet()) {
                  showResult();
                } else {
                  showFillInfo();
                }},
                textColor: Colors.white
              )
            ],
          ),
        )
    );
  }

  Padding spacePadding({height: 30.0}) {
    return Padding(padding: EdgeInsets.only(top: height));
  }

  Divider genderDivider({height: 10.0}) {
    return Divider(
      color: genderColor(),
      height: height,
      thickness: 2.0,
      indent: 10.0,
      endIndent: 10.0,
    );
  }

  Widget platformDoneButton() {
    if(PlatformCheck.isIOS) {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Done',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        )
      );
    }
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.all(8.0),
      child: Text(
        "DONE",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget platformSwitch(bool value, void onChangedFunc(bool b),{activeColor: Colors.blue, inactiveColor: Colors.pink}) {
    if(PlatformCheck.isIOS) {
      return CupertinoSwitch(
          value: value,
          activeColor: activeColor,
          trackColor: inactiveColor,
          onChanged: (bool b) {
            onChangedFunc(b);
          });
    } else {
      return Switch(
          value: value,
          activeColor: activeColor,
          inactiveTrackColor: inactiveColor,
          onChanged: (bool b) {
            onChangedFunc(b);
          });
    }
  }

  void updateGender(bool b) {
    setState(() {
      gender = b;
      ThemeChanger.setTheme(context,
          ThemeData(
              primarySwatch: gender ? Colors.blue : Colors.pink
          ));
    });
  }

  Widget platformSlider(double value, void onChangedFunc(double _value),{min: 0.0, max: 1.0, activeColor: Colors.black, inactiveColor: Colors.grey}) {
    if(PlatformCheck.isIOS) {
      return CupertinoSlider(
          min: min,
          max: max,
          activeColor: activeColor,
          thumbColor: inactiveColor,
          value: value,
          onChanged: (double _value) {
            onChangedFunc(_value);
          });
    } else {
      return Slider(
          min: min,
          max: max,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          value: value,
          onChanged: (double _value) {
            onChangedFunc(_value);
          }
      );
    }
  }

  void updateUserSize(double value) {
    setState(() {
      cmSize = value;
    });
  }

  Widget platformTextField(String infoText, void onChangedFunc(String data), FocusNode focus) {
    if(PlatformCheck.isIOS) {
      return CupertinoTextField(
        keyboardType: TextInputType.number,
        focusNode: focus,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(5)
        ),
        onChanged: (String data) {
          onChangedFunc(data);
        },
        placeholder: infoText,
      );
    } else {
      return TextField(
        keyboardType: TextInputType.number,
        focusNode: focus,
        onSubmitted: (String data) {
          onChangedFunc(data);
        },
        onChanged: (String data) {
          onChangedFunc(data);
        },
        decoration: InputDecoration(labelText: infoText),
      );
    }
  }

  void updateUserWeight(String data) {
    setState(() {
      userWeight = double.tryParse(data) ?? 0.0;
    });
  }

  Widget platformButton(String textButton, void onPressedFunc(),{textColor: Colors.black}) {
    if(PlatformCheck.isIOS) {
      return CupertinoButton.filled(
          child: AppText(textButton,color: textColor),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          onPressed: onPressedFunc);
    }
    return ElevatedButton(
        onPressed: onPressedFunc,
        child: AppText(textButton, color: textColor));
  }

  Color genderColor({clear: false}) {
    if (clear) {
      return gender ? Colors.blue[200] : Colors.pink[200];
    }
    return gender ? Colors.blue : Colors.pink;
  }

  Future<Null> chooseDateOfBirth() async {
    DateTime dob;
    if(PlatformCheck.isIOS) {
      dob = await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext dateContext) {
            return Container(
              height: 300.0,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                          child: AppText('Annuler',color: Colors.red,weight: FontWeight.normal),
                          onPressed: () {
                            Navigator.of(dateContext).pop();
                          }),
                      CupertinoButton(
                          child: AppText('Ok', color: Colors.blue,weight: FontWeight.normal),
                          onPressed: () {
                            Navigator.of(dateContext).pop(dob);
                          })
                    ],
                  ),
                  genderDivider(),
                  Expanded(
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        minimumDate: DateTime(1900),
                        maximumDate: DateTime.now(),
                        backgroundColor: genderColor(clear: true),
                        onDateTimeChanged: (DateTime dt) {
                          dob = dt;
                        }),
                  )
                ],
              ),
            );
          });
    } else {
      dob = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          initialDatePickerMode: DatePickerMode.year
      );
    }
    if(dob != null) {
      Duration age = DateTime.now().difference(dob);
      print('ecart: $age');
      setState(() {
        userAge = age.inDays ~/ 365;
      });
    }
  }

  bool allInfoSet() {
    if(userAge == 0) return false;
    if(userWeight == 0) return false;
    return true;
  }

  Future<Null> showFillInfo() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          if(PlatformCheck.isIOS) {
            return CupertinoAlertDialog(
              title: AppText('Erreur',color: Colors.red, size: 25.0),
              content: AppText('Remplissez tous les champs.'),
              actions: [
                CupertinoButton(
                  color: Colors.grey[200],
                    child: AppText('Ok', color: Colors.red),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    })
              ],
            );
          }
          return AlertDialog(
            title: AppText('Erreur', color: Colors.red, size: 25.0),
            content: AppText('Remplissez tous les champs.'),
            contentPadding: EdgeInsets.all(20.0),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: AppText('Ok', color: Colors.red))
            ],
          );
        }
    );
  }

  Future<Null> showResult() async{
    calorie();
    if(PlatformCheck.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return CupertinoAlertDialog(
              title: AppText('Besoin en calorie journalier', color: genderColor(),),
              content: Column(
                children: [
                  spacePadding(),
                  AppText('Votre besoin de base est de ${userBaseCalorie.toInt()} calories'),
                  spacePadding(),
                  AppText('${userSportCalorie.toInt()} calories avec votre activité sportive'),
                  spacePadding(),
                ],
              ),
              actions: [
                CupertinoButton(
                    child: AppText('Ok', color: Colors.blue),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    })
              ],
            );
          });
    }
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
            title: Center(
              child: AppText('Besoin en calorie journalier',
                color: genderColor(),),
            ),
            titlePadding: EdgeInsets.all(10.0),
            contentPadding: EdgeInsets.all(20.0),
            children: [
              AppText('Votre besoin de base est de ${userBaseCalorie.toInt()} calories'),
              spacePadding(),
              AppText('${userSportCalorie.toInt()} calories avec votre activité sportive'),
              spacePadding(),
              platformButton('Ok', () {Navigator.of(dialogContext).pop();})
            ],
          );
        }
    );
  }

  Row userActivityRadio() {
    List<Column> l = [];
    userActivityState.forEach((key, value) {
      Column c = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
              value: value,
              groupValue: userActivity,
              onChanged: (Object x) {
                setState(() {
                  userActivity = x;
                });
              }),
          AppText(
            key,
            color: gender ? Colors.blue : Colors.pink,
          )
        ],
      );
      l.add(c);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: l,
    );
  }

  void calorie() {
    if(gender) {
      userBaseCalorie = 66.4730 + (13.7516 * userWeight) + (5.0033 * cmSize) - (6.7550 * userAge);
    } else {
      userBaseCalorie = 655.0955 + (9.5634 * userWeight) + (1.8496 * cmSize) - (4.6756 * userAge);
    }
    switch(userActivity) {
      case 0:
        userSportCalorie = userBaseCalorie * 1.2;
        break;
      case 1:
        userSportCalorie = userBaseCalorie * 1.5;
        break;
      case 2:
        userSportCalorie = userBaseCalorie * 1.8;
        break;
    }
  }
}