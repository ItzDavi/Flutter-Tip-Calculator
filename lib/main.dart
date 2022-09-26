import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    const SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _billController = TextEditingController();

  double _bill = 0.0;
  double _tip = 0.0;
  double _total = 0.0;

  bool done = false;
  bool inputError = false;

  double _tipSliderValue = 20.0;

  IconData _thumbIcon = Icons.thumb_up_alt_rounded;
  MaterialColor _thumbColor = Colors.green;

  MaterialColor manageActiveTrack() {
    var color = Colors.green;

    if (_tipSliderValue < 10.0) {
      color = Colors.red;

    } else if (_tipSliderValue >= 10.0 && _tipSliderValue < 20.0) {
      color = Colors.yellow;

    } else if (_tipSliderValue >= 20.0) {
      color = Colors.green;

    }

    return color;
  }

  Color manageInactiveTrack() {
    var color = Colors.green.shade200;

    if (_tipSliderValue < 10.0) {
      color = Colors.red.shade50;

    } else if (_tipSliderValue >= 10.0 && _tipSliderValue < 20.0) {
      color = Colors.yellow.shade50;

    } else if (_tipSliderValue >= 20.0) {
      color = Colors.green.shade50;

    }

    return color;
  }

  void manageIcon() {
    if (_tipSliderValue < 10.0) {
      _thumbColor = Colors.red;
      _thumbIcon = Icons.thumb_down_alt_rounded;

    } else if (_tipSliderValue >= 10.0 && _tipSliderValue < 20.0) {
      _thumbColor = Colors.yellow;
      _thumbIcon = Icons.thumbs_up_down_rounded;

    } else if (_tipSliderValue >= 20.0) {
      _thumbColor = Colors.green;
      _thumbIcon = Icons.thumb_up_alt_rounded;

    }
  }

  bool checkInput() {
    bool flag = true;

    if (_billController.text.isEmpty) {
      flag = false;

    } else if (double.parse(_billController.text) < 0) {
      flag = false;

    } else {
      flag = true;
    }

    return flag;
  }

  void calculateTip() {
    inputError = false;

    _bill = double.parse(double.parse(_billController.text).toStringAsFixed(2));
    _tip = double.parse((_bill * _tipSliderValue / 100).toStringAsFixed(2));

    _total = double.parse((_bill + _tip).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body:
        SafeArea(
          minimum: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0, top: 15),
                  child: Text(
                    'Tip Calculator',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 40.0),
                  ),
                ),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  shadowColor: manageActiveTrack(),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        ShakeWidget(
                          autoPlay: inputError,
                          enableWebMouseHover: false,
                          duration: const Duration(seconds: 10),
                          shakeConstant: ShakeDefaultConstant1(),
                          child: TextField(
                            controller: _billController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.attach_money_rounded,
                                color: inputError ? Colors.red : Colors.blue,
                              ),
                              labelText: 'Bill',
                              labelStyle: TextStyle(
                                color: inputError ? Colors.red : Colors.blue
                              ),
                              enabledBorder:
                                OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(
                                      color: inputError ? Colors.red : Colors.blue,
                                      width: 2.0
                                  ),
                                ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: BorderSide(
                                    color: inputError ? Colors.red : Colors.blue,
                                    width: 3.0
                                ),
                              ),
                            ),
                            style: TextStyle(color: inputError ? Colors.red : Colors.blue),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child:
                            Icon(
                              _thumbIcon,
                              color: _thumbColor,
                              size: 30.0,
                            ),
                        ),
                        SliderTheme(
                          data:
                            SliderThemeData(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                              activeTrackColor: manageActiveTrack(),
                              activeTickMarkColor: manageActiveTrack(),
                              thumbColor: manageActiveTrack(),
                              inactiveTrackColor: manageInactiveTrack(),
                              inactiveTickMarkColor: manageActiveTrack(),
                          ),
                          child: Slider(
                            value: _tipSliderValue,
                            onChanged: (double value) {
                              setState(() {
                                _tipSliderValue = value;
                                manageIcon();
                              });
                            },
                            min: 0,
                            max: 30,
                            divisions: 6,
                            label: _tipSliderValue.round().toString(),
                          ),
                         )
                        ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 98.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: done,
                        child: Table(
                          children: [
                            TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'Bill',
                                        style:
                                        TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16
                                        )
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        '\$',
                                        textAlign: TextAlign.end,
                                        style:
                                        TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '$_bill',
                                        textAlign: TextAlign.end,
                                        style: const
                                        TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16
                                        ),
                                    ),
                                  ),
                                ]
                            ),
                            TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'Tip',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16
                                        ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '\$',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '$_tip',
                                        textAlign: TextAlign.end,
                                        style: const
                                        TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),
                                    ),
                                  )
                                ]
                            ),
                            TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'Total',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16
                                        ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        '\$',
                                        textAlign: TextAlign.end,
                                        style:
                                        TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16
                                        ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '$_total',
                                        textAlign: TextAlign.end,
                                        style: const
                                        TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                        ),
                                    ),
                                  )
                                ]
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 98.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                done = checkInput();

                                if (done) {
                                  calculateTip();
                                } else {
                                  inputError = true;
                                }
                              });
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(4.0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))
                              ),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(horizontal: 80.0, vertical: 4.0)
                              ),
                            ),
                            child: const Text(
                              'Calculate',
                              style: TextStyle(fontSize: 16),
                            )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
