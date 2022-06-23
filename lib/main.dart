import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth.dart';
import 'providers/inventory_provider.dart';
import 'providers/logbook_provider.dart';
import 'providers/medicine.dart';
import 'providers/medicine_list.dart';
import 'screens/add_medicine.dart';
import 'screens/auth_screen.dart';
import 'screens/edit_medicine.dart';
import 'screens/inventory.dart';
import 'screens/logbook_screen.dart';
import 'screens/medicine_detail.dart';
import 'screens/splash_screen.dart';
import 'services/notifications.dart';
import 'widgets/tabbar_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, MedicineList>(
          update: (context, auth, previousMeds) => MedicineList(auth.token,
              auth.userID, previousMeds == null ? [] : previousMeds.items),
          create: (context) => MedicineList(null, null, []),
        ),
        ChangeNotifierProxyProvider<Auth, LogBookProvider>(
          update: (context, auth, previousLogs) => LogBookProvider(auth.token,
              auth.userID, previousLogs == null ? [] : previousLogs.items),
          create: (context) => LogBookProvider(null, null, []),
        ),
        ChangeNotifierProvider(
          create: (context) => MedicineProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InventoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Notifications(),
        ),
        StreamProvider<User>.value(
          value: FirebaseAuth.instance.authStateChanges(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'CareZone',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? TabBarScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (context, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            MedicineDetail.routeName: (ctx) => MedicineDetail(),
            LogbookScreen.routeName: (ctx) => LogbookScreen(),
            Inventory.routeName: (ctx) => Inventory(),
            AddMedicine.routeName: (ctx) => AddMedicine(),
            EditMedicine.routeName: (ctx) => EditMedicine(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
