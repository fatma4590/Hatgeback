import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hatgeback/paymobmanger/paymobmanager.dart';
class payscreen extends StatelessWidget {
  static String id="paypage";
  const payscreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paymob Integration"),),
      body: ElevatedButton(
        onPressed: ()async=>_pay(),
        child: const Text("Pay "),
      ),
    );
  }

  Future<void> _pay() async{
    PaymobManager().getPaymentKey(
        10,"EGP"
    ).then((String paymentKey) {
      launchUrl(
        Uri.parse("https://accept.paymob.com/api/acceptance/iframes/852900?payment_token=$paymentKey"),
      );
    });

  }
}