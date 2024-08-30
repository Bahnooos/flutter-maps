import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maps/app_router.dart';
import 'package:maps/constants/strings.dart';
import 'package:maps/firebase_options.dart';

late String initialRoute;
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
    FirebaseAuth.instance.authStateChanges().listen(( user){
if (user==null) {
  initialRoute=loginScreen;
}else{
  initialRoute=mapScreen;
}

    });
  runApp( MyApp(appRouter: AppRouter(), ));

}

class MyApp extends StatelessWidget {
 const  MyApp({super.key,required this.appRouter});
final AppRouter appRouter;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
   onGenerateRoute: appRouter.generateRoute,
   initialRoute: initialRoute ,
    );
    


    
  }
   
}

