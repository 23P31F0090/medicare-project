import 'package:flutter_test/flutter_test.dart';
import 'package:medicare/main.dart'; // Make sure this matches your app's entry point

void main() {
  testWidgets('App launches and displays Splash Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the splash screen is displayed.
    expect(find.text('MediCare Plus'), findsOneWidget); // Replace 'MediCare Plus' with any text visible in your splash screen
  });
}
