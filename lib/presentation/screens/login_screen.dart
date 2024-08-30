import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/business_layer/cubit/phone_auth_cubit.dart';
import 'package:maps/constants/colors.dart';

import 'package:maps/constants/strings.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  LoginScreen({super.key});
   late String phonenumber;
  GlobalKey<FormState> _key= GlobalKey();

  Widget  interoText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your phone number ?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 2,
            ),
            child: const Text(
              'Please enter your phone number to verify your account',
              style: TextStyle(
                fontSize: 16,
              ),
            )),
      ],
    );
  }

  Widget buildphoneTextField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Colors.black),
            ),
            child: Text(
              countryFlag() + ' + 20',
              style: const TextStyle(fontSize: 16, letterSpacing: 2.0),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Colors.black),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(fontSize: 16, letterSpacing: 2.0),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.blueAccent,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('please enter your phone number');
                } else if (value.length < 11) {
                  return ('this is too short for phone number');
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                phonenumber=value!;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showDialogProgressIndicator(context);
          registeredSucess(context);
        },
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            backgroundColor: Colors.black,
            minimumSize: const Size(110, 55)),
        child: const Text(
          'Next',
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }
  void registeredSucess(BuildContext context){
    if (!_key.currentState!.validate()) {
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
      _key.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).verifyPhoneNumber(phonenumber);
    }
  }

  String countryFlag() {
    String countryflag = 'eg';
    return countryflag.toUpperCase().replaceAllMapped(
        RegExp('[A-Z]'),
        (replace) =>
            String.fromCharCode(replace.group(0)!.codeUnitAt(0) + 127397));
  }

  Widget buildPhoneNumberSubmitedBloc() {
  return  BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
       return previous != current;
      },
      listener: (context, state) {
        if (state is Loadded) {
           showDialogProgressIndicator(context);
        } if(state is PhoneSubmitted){
          Navigator.pop(context);
          Navigator.pushNamed(context, otpScreen,arguments: phonenumber);

        } if(state is ErrorOccured){
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('there is an error'))) ;
        }
      },
      child: Container(),
    );
  }
  

  void showDialogProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor:Colors.transparent,
      elevation: 6,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  interoText(),
                  const SizedBox(
                    height: 60,
                  ),
                  buildphoneTextField(),
                  const SizedBox(
                    height: 30,
                  ),
                  buildNextButton(context),
                  buildPhoneNumberSubmitedBloc(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
