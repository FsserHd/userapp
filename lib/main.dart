import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:userapp/model/firebase/firebase_order_response.dart';
import 'package:userapp/page/splash/splash_page.dart';
import 'constants/app_colors.dart';
import 'constants/app_style.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'language/app_localizations.dart';
import 'navigation/navigation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCD307r1TTsBbvJ_9ibBwUp4254v5ySHPc',
        appId: '1:211166356684:android:725cc940483a1be6968e69',
        messagingSenderId: '211166356684',
        projectId: 'square-new-d8e68',
        storageBucket: 'square-new-d8e68.firebasestorage.app',
      ),
    );
  }else{
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyB_C6fCv84DP1PWD-8s4nTNP6ZbzNProuE',
          appId: '1:211166356684:ios:622a235e52d8f5cf968e69',
          messagingSenderId: '211166356684',
          projectId: 'square-new-d8e68',
          storageBucket: 'square-new-d8e68.firebasestorage.app',
          iosBundleId:"com.fsserhd.user"
      ),
    );
  }
  _requestPermissions();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    FirebaseOrderResponse firebaseOrderResponse = FirebaseOrderResponse();
    firebaseOrderResponse.vendorId = message.data['vendor_id'];
    firebaseOrderResponse.type = message.data['type'];
    firebaseOrderResponse.message = message.data['message'];
    firebaseOrderResponse.orderid = message.data['orderid'];
    if(firebaseOrderResponse.type == "on_track" ) {
      playOrderSound();
      showSimpleNotification(
        Text("#${firebaseOrderResponse.orderid} \nYour order is preparing"),
        leading: Icon(Icons.add_alert, color: Colors.white),
        background: Colors.green,
        duration: Duration(seconds: 3),
      );
    }else if(firebaseOrderResponse.type == "on_picked" ){
      showSimpleNotification(
        Text("#${firebaseOrderResponse.orderid} \nYour order is picked"),
        leading: Icon(Icons.add_alert, color: Colors.white),
        background: Colors.green,
        duration: Duration(seconds: 3),
      );
    }else if(firebaseOrderResponse.type == "on_reached" ){
      showSimpleNotification(
        Text("Order is reached your location"),
        leading: Icon(Icons.add_alert, color: Colors.white),
        background: Colors.green,
        duration: Duration(seconds: 3),
      );
    }else if(firebaseOrderResponse.type == "on_user_cancel" ){
      showSimpleNotification(
        Text("#${firebaseOrderResponse.orderid} \nOrder is cancelled"),
        leading: Icon(Icons.add_alert, color: Colors.white),
        background: Colors.green,
        duration: Duration(seconds: 3),
      );
    }else if(firebaseOrderResponse.type == "order_message" ) {
      showSimpleNotification(
        Text("New Order Note Message\n#${firebaseOrderResponse.orderid} \n${firebaseOrderResponse.message}"),
        leading: Icon(Icons.add_alert, color: Colors.white),
        background: Colors.green,
        duration: Duration(seconds: 3),
      );
    }else if(firebaseOrderResponse.type == "on_review" ) {
      showSimpleNotification(
        Text("Review your #${firebaseOrderResponse.orderid} order."),
        leading: Icon(Icons.add_alert, color: Colors.white),
        background: Colors.green,
        duration: Duration(seconds: 3),
      );
    }
  });
  runApp(const MyApp());
}


final AudioPlayer _audioPlayer = AudioPlayer();

playOrderSound() async {
  await _audioPlayer.play(AssetSource("sound/alert1.mp3"));
}

Future<void> _requestPermissions() async {
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
}

class MyApp extends StatefulWidget {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp>  {

  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isDialogOpen = false;


  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
    FlutterFlowTheme.saveThemeMode(mode);
  });

  DateTime? lastPressed;



  void _showNoInternetPopup() {
    if (!_isDialogOpen) {
      _isDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please check your internet connection."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isDialogOpen = false;
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _checkNetwork();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return OverlaySupport(
      child: GlobalLoaderOverlay(
        overlayColor: Colors.grey.withOpacity(0.5),
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) { //ignored progress for the moment
          return Center(
            child: SpinKitThreeBounce(
              color: AppColors.themeColor,
              size: 50.0,
            ),
          );
        },
        child: MaterialApp(
          navigatorKey: NavigationService.navigatorKey, // set property
          locale: Locale('en'), // Default locale
          supportedLocales: [
            Locale('en', ''),
            Locale('es', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale!.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(brightness: Brightness.light),
          themeMode: ThemeMode.light,
          title: 'Thee4square',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.themeColor),
              useMaterial3: true,
              fontFamily: AppStyle.robotoRegular,

          ),
          home: SplashPage(),
        ),
      ),
    );
  }

}
