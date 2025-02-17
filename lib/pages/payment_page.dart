import 'package:flutter/material.dart';
import 'package:medicare/payment_service.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await initiateUPIPayment(
                upiId: '9182667127@ptsbi', // Replace with your UPI ID
                name: 'MediCare Payment',
                amount: 500.0,
                note: 'Medicine Payment',
              );
            } catch (e) {
              print('Payment Error: $e');
            }
          },
          child: Text('Pay ₹500 via UPI'),
        ),
      ),
    );
  }
}
