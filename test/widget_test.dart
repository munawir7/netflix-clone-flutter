import 'package:flutter_test/flutter_test.dart';
import 'package:netflix_clone/app.dart';

void main() {
testWidgets('Netflix Clone app displays its title', (
WidgetTester tester,
) async {
await tester.pumpWidget(const NetflixApp());


expect(find.text('Netflix Clone'), findsOneWidget);


});
}
