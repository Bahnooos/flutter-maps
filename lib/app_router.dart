import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/business_layer/cubit/maps_cubit.dart';
import 'package:maps/business_layer/cubit/phone_auth_cubit.dart';
import 'package:maps/constants/strings.dart';
import 'package:maps/data/repo/place_repo.dart';
import 'package:maps/data/web_services.dart';
import 'package:maps/presentation/screens/login_screen.dart';
import 'package:maps/presentation/screens/map_screen.dart';
import 'package:maps/presentation/screens/otp_screen.dart';

class AppRouter {
  
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => phoneAuthCubit,
                  child: LoginScreen(),
                ));
      case otpScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => phoneAuthCubit,
                  child: OtpScreen(),
                ));
      case mapScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => MapsCubit(PlaceRepo(WebServices())),
                  child:const MapScreen(),
                ));

      default:
    }
  }
}
