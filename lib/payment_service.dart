import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> initiateUPIPayment({
  required String upiId,
  required String name,
  required double amount,
  required String note,
}) async {
  String upiUrl = 'upi://pay?pa=$upiId&pn=$name&am=$amount&tn=$note&cu=INR';

  if (await canLaunchUrl(Uri.parse(upiUrl))) {
    await launchUrl(Uri.parse(upiUrl));
  } else {
    throw PlatformException(
      code: 'UPI_APP_NOT_AVAILABLE',
      message: 'No UPI app available to handle the request',
    );
  }
}
