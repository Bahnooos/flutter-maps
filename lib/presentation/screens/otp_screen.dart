import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/business_layer/cubit/phone_auth_cubit.dart';
import 'package:maps/constants/colors.dart';
import 'package:maps/constants/strings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  OtpScreen({super.key, this.phonenumber});
  final TextEditingController _textController = TextEditingController();
  String? phonenumber;
  late String otp;
  Widget buildInteroText() {
    return Column(
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
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(
                  text: 'verify your phone number',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              TextSpan(
                text: phonenumber,
                style: const TextStyle(color: MyColors.redLight, fontSize: 16),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget buildPinCodeField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          selectedColor: MyColors.redLight,
          inactiveColor: MyColors.redLight,
          selectedFillColor: MyColors.redLight,
          inactiveFillColor: Colors.white,
        ),
        keyboardType: TextInputType.number,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.blue.shade50,
        enableActiveFill: true,
        controller: _textController,
        onCompleted: (value) {
          otp = value;
        },
        onChanged: (value) {},
        beforeTextPaste: (text) {
          return true;
        },
      ),
    );
  }

  Widget buildPhoneNumberSubmitedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loadded) {
          showDialogProgressIndicator(context);
        }
        if (state is PhoneOtp) {
          Navigator.pop(context);
          Navigator.pushNamed(context, mapScreen, arguments: phonenumber);
        }
        if (state is ErrorOccured) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('there is an error')));
        }
      },
      child: Container(),
    );
  }

  void showDialogProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
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

  Widget buildVerifyButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showDialogProgressIndicator(context);
          loggedIn(context);
        },
        
        style: ElevatedButton.styleFrom(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: (Colors.black)),
            child: const Center(
          child: Text(
            'Verify',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
 void loggedIn(BuildContext context){
  BlocProvider.of<PhoneAuthCubit>(context).phoneOtp(otp);
 }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Form(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
          child: Column(
            children: [
              buildInteroText(),
              const SizedBox(
                height: 30,
              ),
              buildPinCodeField(context),
              buildVerifyButton(context),
              buildPhoneNumberSubmitedBloc(),
            ],
          ),
        ),
      ),
    ));
  }
}
