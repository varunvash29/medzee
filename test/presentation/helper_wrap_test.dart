import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medzee/core/theme/app_theme.dart';

void main() {
  testWidgets('long helper text wraps instead of being cut off',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    const String helper =
        'If the prescription names a different brand of the same salt';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Prescribed as',
                helperText: helper,
              ),
            ),
          ),
        ),
      ),
    );

    // At this width the sentence needs two lines; if it were cut to one line
    // it would be a single line high.
    final Size size = tester.getSize(find.text(helper));
    expect(size.height, greaterThan(20));
    expect(tester.widget<Text>(find.text(helper)).maxLines, greaterThan(1));
  });
}
