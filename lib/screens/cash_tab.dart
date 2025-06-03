import 'package:flutter/material.dart';

class CashTab extends StatefulWidget {
  final TextEditingController customAmountController;

  CashTab({required this.customAmountController});

  @override
  _CashTabState createState() => _CashTabState();
}

class _CashTabState extends State<CashTab> {
  String? selectedPaymentMethod;
  String? _selectedNominal;
  int _requiredPoints = 0;
  final String email = "test@gmail.com"; // Email default (dummy)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEDEDED),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentOption('assets/images/gopay.png', 'GoPay'),
            SizedBox(height: 20),
            Text(
              'Nominal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildNominalOptions(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(thickness: 1, color: Colors.black),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Penukaran', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            '$_requiredPoints',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_validateInputs(context)) {
                            showRewardDialog(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(85, 132, 122, 0.969),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                        child: Text('Tukar', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs(BuildContext context) {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tolong pilih metode pembayaran!')),
      );
      return false;
    }

    if (_selectedNominal == null && widget.customAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tolong pilih nominal atau masukkan nominal custom!')),
      );
      return false;
    }

    if (_requiredPoints == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Poin Anda tidak mencukupi!')),
      );
      return false;
    }

    return true;
  }

  void showRewardDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Masukkan Informasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                String phone = phoneController.text;
                int? balance = int.tryParse(widget.customAmountController.text);

                if (phone.isNotEmpty && RegExp(r'^\d+$').hasMatch(phone) && balance != null && balance >= 5000) {
                  // Dummy success logic
                  bool success = true;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Berhasil menyimpan data!'
                          : 'Gagal menyimpan data!'),
                    ),
                  );
                  if (success) Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Pastikan semua informasi valid dan nominal minimal Rp 5000'),
                    ),
                  );
                }
              },
              child: Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption(String assetPath, String title) {
    bool isSelected = selectedPaymentMethod == title;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPaymentMethod = isSelected ? null : title;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(85, 132, 122, 0.969)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color.fromRGBO(85, 132, 122, 0.969)
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Image.asset(assetPath, width: 40),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNominalOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 10,
            children: [
              _buildNominalButton('Rp 5.000', 500),
              _buildNominalButton('Rp 10.000', 1000),
              _buildNominalButton('Rp 30.000', 3000),
              _buildNominalButton('Rp 50.000', 5000),
            ],
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: widget.customAmountController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _selectedNominal = null;
              if (value.isNotEmpty) {
                int? nominal = int.tryParse(value);
                if (nominal != null && nominal >= 5000) {
                  _requiredPoints = nominal ~/ 10;
                } else {
                  _requiredPoints = 0;
                }
              } else {
                _requiredPoints = 0;
              }
            });
          },
          decoration: InputDecoration(
            hintText: 'Masukkan nominal lain',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Minimal Rp 5.000 untuk penukaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: const Color.fromARGB(255, 84, 84, 84),
          ),
        ),
      ],
    );
  }

  Widget _buildNominalButton(String text, int points) {
    bool isSelected = _selectedNominal == text;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            _selectedNominal = null;
            widget.customAmountController.clear();
            _requiredPoints = 0;
          } else {
            _selectedNominal = text;
            widget.customAmountController.text = text.replaceAll(RegExp(r'\D'), '');
            _requiredPoints = points;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color.fromRGBO(85, 132, 122, 0.969)
            : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: Colors.grey.shade300),
        elevation: 2,
      ),
      child: Text(text),
    );
  }
}