import 'package:flutter/material.dart';

import '../../shared/constants/constants.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x88171717),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'History',
                    style: kTextStyleWhiteHeader.copyWith(fontSize: 40),
                  ),
                ),
              ),
              TextField(
                keyboardType: TextInputType.text,
                style: kTextStyleTextFiled,
                decoration: kTextFieldInputDecoration.copyWith(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: kColorBlueText,
                  ),
                  labelText: 'Search Service',
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 4.0,
                  color: Colors.transparent,
                  child: Container(
                    height: 300.0,
                    child: ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: Icon(Icons.local_car_wash),
                              title: Text('Car Wash'),
                              subtitle: Text('March 21, 2023'),
                              trailing: Text('\$20'),
                              onTap: () {
                                // handle tapping on an item
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5),
                child: Divider(
                  height: 20,
                  thickness: 2,
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Service Description",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Service Price: \$X",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
