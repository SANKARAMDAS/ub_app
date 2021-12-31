import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:urbanledger/Cubits/Cashbook/cashbook_cubit.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/CustomerRanking/customer_ranking_pay_cubit.dart';
import 'package:urbanledger/Cubits/ImportContacts/import_contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Cubits/Notifications/notificationlist_cubit.dart';
import 'package:urbanledger/Cubits/UserProfile/user_profile_cubit.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/unauth_model.dart';
import 'package:urbanledger/Models/user_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/providers/chats_provider.dart';
import 'package:urbanledger/chat_module/data/repositories/user_repository.dart';
import 'package:urbanledger/screens/AddBankAccount/add_bank_provider.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/DynamicLinks/dynamicLinkService.dart';
import 'package:urbanledger/screens/Freemium/freemium_provider.dart';
import 'package:urbanledger/screens/Kyc%20Screen/kyc_provider.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/UserProfile/ReferAFriend/rewards_provider.dart';
import 'package:urbanledger/screens/WelcomeScreens/splash.dart';

import 'Cubits/CustomerRanking/customer_ranking_request_cubit.dart';
import 'Cubits/Suspense/suspense_cubit.dart';
import 'Cubits/TransactionHistory/trans_history_cubit.dart';
import 'Utility/app_theme.dart';
import 'router.dart' as router;
import 'package:urbanledger/Utility/app_constants.dart';

final _kTestingCrashlytics = false;
final repository = Repository();
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

UserRepository _userRepository = UserRepository();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'high importance notification',
    description: 'Notifications shown on download of a pdf',
    importance: Importance.high,
    playSound: true);

const AndroidInitializationSettings initializationSettingsAndroid =
AndroidInitializationSettings('launcher_icon');

final IOSInitializationSettings initializationSettingsIOS =
IOSInitializationSettings(
    onDidReceiveLocalNotification: (id, title, body, payload) async {
      return null; //TODO: To add logic
    });

final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
/*
bool initialized = false;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (!initialized) {
    initialized = true;
    await Hive.initFlutter();
    Hive.registerAdapter(SignUpModelAdapter(), internal: true, override: true);
    Hive.registerAdapter(BusinessModelAdapter(),
        internal: true, override: true);
    await repository.hiveQueries.openUserBox;
  }
  if (message.data['type'] == 'payment') {
    if (message.data['fromMobileNumber'] != null) {
      final localCustId = await repository.queries
          .getCustomerId(message.data['fromMobileNumber']);
      final previousBalance =
          (await repository.queries.getPaidMinusReceived(localCustId));
      final transactionModel = TransactionModel()
        ..transactionId = message.data['transactionId']
        ..amount = message.data['amount']
        ..transactionType = TransactionType.Receive
        ..customerId = localCustId
        ..date = DateTime.now()
        ..attachments = []
        ..balanceAmount = previousBalance + (message.data['amount'] ?? 0)
        ..isChanged = true
        ..isDeleted = false
        ..isPayment = true
        ..business = repository.hiveQueries.selectedBusiness?.businessId ?? ''
        ..createddate = DateTime.now();
      final response =
          await repository.queries.insertLedgerTransaction(transactionModel);
    }
  }
} */

Future<void> main() async {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  if (kReleaseMode) {
    debugPrint = (message, {wrapWidth}) {};
  }
  // HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isIOS) {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
  }

  await Hive.initFlutter();
  Hive.registerAdapter(SignUpModelAdapter());
  Hive.registerAdapter(BusinessModelAdapter());
  Hive.registerAdapter(UnAuthModelAdapter());
  await repository.hiveQueries.openAuthBox;
  await repository.hiveQueries.openUserBox;
  await repository.hiveQueries.openUnAuthBox;
  _initializeCrashlytics();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {
        if (payload != null) {
          final data = jsonDecode(payload);
          if (data['pdfPath'] != null) {
            OpenFile.open(data['pdfPath']);
          }
        }
      });
//DYNAMIC LINKS
  await DynamicLinkService().handleInitialDynamicLinks();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  Bloc.observer = BlocObserver();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  updateKey();
  runZonedGuarded<Future<void>>(() async {
    runApp(RestartWidget(
      child: (_uniqueKey) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ContactsCubit(),
          ),
          BlocProvider(
            create: (context) => SuspenseCubit(),
          ),
          BlocProvider(
            create: (context) => ImportContactsCubit(),
          ),
          BlocProvider(
            create: (context) => LedgerCubit(),
          ),
          BlocProvider<CashbookCubit>(
            create: (context) => CashbookCubit(),
          ),
          BlocProvider<CustomerRankingPayCubit>(
            create: (context) => CustomerRankingPayCubit(),
          ),
          BlocProvider<CustomerRankingRequestCubit>(
            create: (context) => CustomerRankingRequestCubit(),
          ),
          BlocProvider<TransHistoryCubit>(
            create: (context) => TransHistoryCubit(),
          ),
          BlocProvider<NotificationListCubit>(
            create: (context) => NotificationListCubit(),
          ),
          BlocProvider<UserProfileCubit>(
            create: (context) => UserProfileCubit(),
          )
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<BusinessProvider>(
              create: (context) => BusinessProvider(),
            ),
            ChangeNotifierProvider<ChatsProvider>(
              create: (context) => ChatsProvider(),
            ),
            ChangeNotifierProvider<AddCardsProvider>(
              create: (context) => AddCardsProvider(),
            ),
            ChangeNotifierProvider<AddBankProvider>(
              create: (context) => AddBankProvider(),
            ),
            ChangeNotifierProvider<UserBankAccountProvider>(
              create: (context) => UserBankAccountProvider(),
            ),
            ChangeNotifierProvider<FreemiumProvider>(
              create: (context) => FreemiumProvider(),
            ),
            ChangeNotifierProvider<KycProvider>(
              create: (context) => KycProvider(),
            ),
            Provider<FirebaseAnalytics>.value(value: analytics),
            Provider<FirebaseAnalyticsObserver>.value(value: observer),
            ChangeNotifierProvider<RewardsProvider>(
              create: (context) => RewardsProvider(),
            ),
          ],
          child: MyApp(),
        ),
      ),
    ));
  }, FirebaseCrashlytics.instance.recordError);
}

class RestartWidget extends StatefulWidget {
  final Widget Function(Key) child;

  RestartWidget({required this.child});

  static void restartApp(BuildContext context) {
    final state = context.findAncestorStateOfType<_RestartWidgetState>();
//    final _RestartWidgetState state =
//        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    updateKey();
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child(key),
    );
  }
}

class MyApp extends StatelessWidget {
  final MaterialColor blueDefault = MaterialColor(0xFF1058ff, AppTheme().color);

  @override
  Widget build(BuildContext context) {
    FirebaseAnalyticsObserver observer =
    Provider.of<FirebaseAnalyticsObserver>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        return ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(600, name: TABLET),
            // ResponsiveBreakpoint.autoScale(900, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(
            color: Color(0xFFF5F5F5),
          ),
        );
      },
      title: 'UrbanLedger',
      supportedLocales: [
        Locale('en'),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      theme: ThemeData(
          primarySwatch: blueDefault,
          fontFamily: AppAssets.sFProDisplayFont,
          primaryColor: AppTheme.electricBlue,
          accentColor: AppTheme.electricBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: ThemeData.light()
              .appBarTheme
              .copyWith(elevation: 0, color: AppTheme.electricBlue))
          .copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
          },
        ),
      ),
      home: SplashScreen(),
      onGenerateRoute: router.Router.generateRoutes,
      navigatorObservers: <NavigatorObserver>[observer],
      // navigatorKey: globalNavigatorKey,
    );
  }
}

Future<void> _initializeCrashlytics() async {
  // Wait for Firebase to initialize

  if (_kTestingCrashlytics) {
    // Force enable crashlytics collection enabled if we're testing it.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    // Else only enable it in non-debug builds.
    // You could additionally extend this to allow users to opt-in.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
  }
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}
