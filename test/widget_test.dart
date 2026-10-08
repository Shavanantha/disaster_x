import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:disaster_x/main.dart';

void main() {
  testWidgets('DisasterXApp mounts successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'is_logged_in': false});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const DisasterXApp());

    // Verify that DisasterXApp mounts and renders DISASTER-X text
    expect(find.text('DISASTER-X'), findsOneWidget);

    // Fast-forward past the 2.5s splash screen timer
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
  });
}
