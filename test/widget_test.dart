import 'package:flutter_test/flutter_test.dart';
import 'package:one_stroke/main.dart';

void main() {
  testWidgets('shows DRIP splash branding', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('DRIP'), findsOneWidget);
    expect(find.text('Minimal motion art studio'), findsOneWidget);
  });
}
