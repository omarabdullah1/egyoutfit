import 'package:egyoutfit/shared/components/components.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key key}) : super(key: key);
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var otpFieldController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            defaultFormField(
              controller: otpFieldController,
              type: TextInputType.phone,
              validate: (value){},
              label: 'phone',
              prefix: Icons.phone,
              onSubmit: (value) async {
                // await FirebaseAuth.instance.verifyPhoneNumber(
                //   phoneNumber: '+2001023096929',
                //   codeSent: (String verificationId, int resendToken) async {
                //     // Update the UI - wait for the user to enter the SMS code
                //     String smsCode = otpFieldController.text;
                //
                //     // Create a PhoneAuthCredential with the code
                //     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                //
                //     // Sign the user in (or link) with the credential
                //     await FirebaseAuth.instance.signInWithCredential(credential);
                //   },
                // );
              }
            ),
          ],
        ),
      ),
    );
  }
}
