import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_1/screens/farmer_register_successful.dart';
import 'package:project_1/screens/home_farmer.dart';
import 'package:project_1/screens/setupacc.dart';
import 'package:project_1/screens/signup_page.dart';
import 'package:project_1/screens/supplier_harvest_update.dart';
import 'package:project_1/screens/widgets/auth_wrapper.dart';
import 'screens/welcome.dart'; // Import WelcomePage
import 'screens/login_page.dart'; // Import LoginPage
import 'screens/selectveg.dart'; // Import SelectVegPage
import 'screens/setbankdet.dart'; // updated import
import 'screens/selectfruits.dart'; // Import SelectVegPage
import 'package:project_1/screens/farmer_notification.dart';
import 'package:project_1/screens/farmer_notification2.dart';
import 'package:project_1/screens/farmerharvest_update.dart';
import 'package:project_1/screens/farmerharvest_update2.dart';
// import 'package:project_1/screens/payment.dart';
// import 'package:project_1/screens/payment2.dart';
// import 'package:project_1/screens/payment3.dart';
import 'package:project_1/screens/ClientOrderCard1.dart';
import 'package:project_1/screens/ClientOrderCard2.dart';
import 'package:project_1/screens/ClientOrderCard3.dart';
import 'package:project_1/screens/order1_screen1.dart';
import 'package:project_1/screens/order1_screen2.dart';
import 'package:project_1/screens/order2_screen1.dart';
import 'package:project_1/screens/order2_screen2.dart';
import 'package:project_1/screens/order3_screen1.dart';
import 'package:project_1/screens/order3_screen2.dart';
import 'package:project_1/screens/supplier_homepage.dart';
import 'package:project_1/screens/supplier_homepage2.dart';
import 'package:project_1/screens/supplier_homepage3.dart';
import 'package:project_1/screens/supplier_homepage4.dart';
import 'package:project_1/screens/supplier_homepage5.dart';
import 'package:project_1/screens/supplier_homepage6.dart';
import 'package:project_1/screens/supplier_notification.dart';
import 'package:project_1/screens/supplier_notification2.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 869), // Pixel 4XL resolution
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/', // Set initial route to WelcomePage
          routes: {
            '/':
                (context) =>
                    const AuthWrapper(), // WelcomePage as initial screen
            '/login': (context) => const LoginPage(), // LoginPage route
            '/signup': (context) => SignUpPage(), // SignUpPage route
            '/setup_account':
                (context) => SetupAccountPage(), // SetupAccountPage route
            '/setbankdet': (context) => SetupBankPage(), // Correct route name
            '/selectveg':
                (context) => VegetableSelectionScreen(), // SelectVegPage route
            '/selectfruits':
                (context) => FruitSelectionScreen(), // SelectVegPage route
            '/homeFarmer': (context) => FarmerHomePage(),
            '/homeSupplier': (context) => SupplierHomepage(),
            '/farmerRegisterSuccessfull':
                (context) => FarmerRegisterSuccessfulPage(),
            '/farmerDetails': (context) => Harvest_detail_page(),
            '/carrot': (context) => CarrotProductScreen(),
            '/cabbage': (context) => CabbageProductScreen(),
            '/potato': (context) => PotatoProductScreen(),
            '/beans': (context) => BeansProductScreen(),
            '/details': (context) => const SupplierHarvestUpdate(),
            // '/farmHarvest2': (context) => ,
          },
        );
      },
    );
  }
}
