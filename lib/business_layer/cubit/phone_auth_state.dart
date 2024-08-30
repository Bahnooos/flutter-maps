part of 'phone_auth_cubit.dart';


sealed class PhoneAuthState {}

final class PhoneAuthInitial extends PhoneAuthState {}

final class Loadded extends PhoneAuthState{}
final class PhoneOtp extends PhoneAuthState{}
final class PhoneSubmitted extends PhoneAuthState{}
final class ErrorOccured extends PhoneAuthState{
  final String errorOccured;

  ErrorOccured({required this.errorOccured});

}
