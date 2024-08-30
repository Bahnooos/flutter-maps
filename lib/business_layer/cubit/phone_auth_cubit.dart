import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
   late String verificationId;
  
  PhoneAuthCubit() : super(PhoneAuthInitial());
  FirebaseAuth auth = FirebaseAuth.instance;
 
  void verifyPhoneNumber(String phoneNumber) async {
    emit(Loadded());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void verificationCompleted(PhoneAuthCredential credential)async{
    await signIn(credential);
  }
  void verificationFailed(FirebaseAuthException error)async{
       print('$error');
       emit(ErrorOccured(errorOccured: error.toString()));
    }
  
  void codeSent(String verificationId, int? resendToken)async{
   this.verificationId=verificationId;
    emit(PhoneSubmitted());
  }
   void codeAutoRetrievalTimeout(String verificationId){
    this.verificationId=verificationId;
   }
   Future<void> signIn(PhoneAuthCredential credential)async{
  try {
   await FirebaseAuth.instance.signInWithCredential(credential);
   emit(PhoneOtp());
  } catch (error) {
    emit(ErrorOccured(errorOccured: error.toString()));
  }
  

}
  Future<void> signOut()async{
   await FirebaseAuth.instance.signOut();
  }

  Future<void> phoneOtp( String otp)async{
  PhoneAuthCredential credential =PhoneAuthProvider.credential(verificationId: this.verificationId, smsCode: otp);
 await signIn(credential);
  }
  User loggedInUser(){
    return FirebaseAuth.instance.currentUser!;
  }

  }




