import 'package:esewa_client/esewa_client.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentHelper {
  static Future<bool> payWithKhalti(BuildContext context) async {
    bool paymentSuccess = false;
    await KhaltiScope.of(context).pay(
        config: PaymentConfig(
          amount: 1000,
          productIdentity: 'cart/product id',
          productName: 'productName',
        ),
        preferences: [
          PaymentPreference.khalti,
          PaymentPreference.connectIPS,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking,
          PaymentPreference.sct,
        ],
        onSuccess: (PaymentSuccessModel success) {
          paymentSuccess = true;
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       title: Text('Payment Successful'),

          //     );
          //   },
          // );
        },
        onFailure: (PaymentFailureModel failure) {
          print(failure.toString());
          paymentSuccess = false;
        },
        onCancel: () {
          print('Khalti Canceled');
          paymentSuccess = false;
        });

    return paymentSuccess;
  }

  static Future<bool> payWithEsewa() {
    EsewaClient _esewaClient = EsewaClient.configure(
      clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
      secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
      environment: EsewaEnvironment.TEST,
    );
    /*
    * Enter your own callback url to receive response callback from esewa to your client server
    * */
    EsewaPayment payment = EsewaPayment(
        productId: "test_id",
        amount: "10",
        name: "Test Product",
        callbackUrl: "http://example.com/");

    // start your payment procedure
    _esewaClient.startPayment(
        esewaPayment: payment,
        onSuccess: (data) {
          print("success");
          return false;
        },
        onFailure: (data) {
          print("failure");
          return false;
        },
        onCancelled: (data) {
          print("cancelled");
          return false;
        });

    return Future(() => false);
  }
}
