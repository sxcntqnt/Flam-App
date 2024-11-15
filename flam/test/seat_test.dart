import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bus_reservation_udemy/main.dart'; // Ensure this path is correct

void main() {
  testWidgets('Initial State: No seats selected', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BusApp());

    // Verify that no seats are selected initially.
    expect(find.text('Show my selected seat numbers'), findsOneWidget);
    expect(find.text('[]'), findsOneWidget); // Should show an empty list
  });

  testWidgets('Selecting a seat adds it to the selected seats list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BusApp());

    // Find the first available seat and tap it (seat at row 1, col 1).
    final seat = find.byKey(Key('seat_1_1')); // Assuming you add keys for seats
    await tester.tap(seat);
    await tester.pump();

    // Verify that the seat has been added to the selected seats list.
    expect(find.text('[1][1]'), findsOneWidget); // Assuming [1][1] is the seat number
  });

  testWidgets('Show my selected seat numbers button displays selected seats', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BusApp());

    // Select some seats.
    final seat1 = find.byKey(Key('seat_1_1')); // Select seat [1][1]
    await tester.tap(seat1);
    await tester.pump();

    final seat2 = find.byKey(Key('seat_2_3')); // Select seat [2][3]
    await tester.tap(seat2);
    await tester.pump();

    // Tap the 'Show my selected seat numbers' button.
    await tester.tap(find.text('Show my selected seat numbers'));
    await tester.pump();

    // Verify that the selected seats are displayed correctly.
    expect(find.text('[1][1] , [2][3]'), findsOneWidget);
  });

  testWidgets('Selecting and deselecting seats updates the selected seats list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BusApp());

    // Select some seats.
    final seat1 = find.byKey(Key('seat_1_1')); // Select seat [1][1]
    await tester.tap(seat1);
    await tester.pump();

    final seat2 = find.byKey(Key('seat_2_3')); // Select seat [2][3]
    await tester.tap(seat2);
    await tester.pump();

    // Deselect the first seat.
    await tester.tap(seat1); // Deselect seat [1][1]
    await tester.pump();

    // Tap the 'Show my selected seat numbers' button.
    await tester.tap(find.text('Show my selected seat numbers'));
    await tester.pump();

    // Verify that only seat [2][3] remains selected.
    expect(find.text('[2][3]'), findsOneWidget);
    expect(find.text('[1][1]'), findsNothing); // Seat [1][1] should not be shown anymore
  });

  testWidgets('Seats with different statuses (disabled, sold, available, selected) display correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BusApp());

    // Check that the seat statuses are displayed correctly.
    // You may want to set specific seats to certain states in the `SeatLayoutStateModel`.

    // Find and check the disabled seat (example at row 0, col 0)
    final disabledSeat = find.byKey(Key('seat_0_0'));
    expect(disabledSeat, findsOneWidget);

    // Check for a sold seat (example at row 2, col 5)
    final soldSeat = find.byKey(Key('seat_2_5'));
    expect(soldSeat, findsOneWidget);

    // Check for available seats (example at row 5, col 1)
    final availableSeat = find.byKey(Key('seat_5_1'));
    expect(availableSeat, findsOneWidget);

    // Check for selected seats (example at row 1, col 2)
    final selectedSeat = find.byKey(Key('seat_1_2'));
    expect(selectedSeat, findsOneWidget);
  });
}
