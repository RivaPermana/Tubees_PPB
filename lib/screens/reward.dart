import 'package:flutter/material.dart';
import 'cash_tab.dart';
import 'voucher_tab.dart';

class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final TextEditingController _customAmountController = TextEditingController();
  int _currentIndex = 1; // Set the default selected index to 1 (Reward tab)

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            // Background Image Layer
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Points Display at the Top
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL POIN',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          '10.000 Poin',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // TabBar and TabBarView
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 80, // Leave space for BottomAppBar
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Color.fromRGBO(85, 132, 122, 0.97),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Tukar Uang"),
                      Tab(text: "Tukar Voucher"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        CashTab(
                            customAmountController: _customAmountController),
                        VoucherTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex, // Set the current index
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update the index when a tab is clicked
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard), label: 'Reward'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
