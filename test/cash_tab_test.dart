import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cleanquest/screens/cash_tab.dart'; // Sesuaikan path-nya

void main() {
  testWidgets('Validasi tanpa memilih metode pembayaran', (WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(MaterialApp(home: CashTab(customAmountController: controller)));

    // Tekan tombol 'Tukar'
    final tombol = find.text('Tukar');
    await tester.tap(tombol);
    await tester.pump();

    // Verifikasi pesan muncul
    expect(find.text('Tolong pilih metode pembayaran!'), findsOneWidget);
  });
}
