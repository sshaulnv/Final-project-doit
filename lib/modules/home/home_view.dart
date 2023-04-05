import 'package:doit_app/modules/profile/profile_view.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/constants/constants.dart';
import 'package:get/get.dart';

import '../../shared/repositories/authentication_repository/authentication_repository.dart';
import '../add_service/add_service_view.dart';
import '../add_service/search_address_view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoundIconButton(
                color: kColorRoundButton,
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                text: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Get.to(() => ProfileScreen());
                },
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      color: Colors.white,
                      icon: const Icon(
                        Icons.home,
                        color: kColorBlueText,
                      ),
                      text: const Text(
                        'Home',
                        style: TextStyle(
                          color: kColorBlueText,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 20),
                    RoundIconButton(
                      color: kColorRoundButton,
                      icon: Icon(
                        Icons.list_alt,
                        color: Colors.white,
                      ),
                      text: Text(
                        'History',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 20),
                    RoundIconButton(
                      color: kColorRoundButton,
                      icon: Icon(
                        Icons.work,
                        color: Colors.white,
                      ),
                      text: Text(
                        'New Service',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => AddServiceScreen());
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Service Details:',
                style: kTextStyleWhiteHeader.copyWith(
                    fontSize: 25,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // replace with your data length
                  itemBuilder: (BuildContext context, int index) {
                    // replace with your card widget implementation
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text('Service ${index + 1}'),
                        subtitle: Text('Service details goes here...'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Categories:',
                style: kTextStyleWhiteHeader.copyWith(
                    fontSize: 25,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      // replace with your category card widget implementation
                      CategoryCard(
                        icon: Icon(
                          Icons.abc,
                          size: 40,
                        ),
                        title: 'Category 1',
                        servicesCount: 5,
                        onTap: () {},
                      ),
                      CategoryCard(
                        icon: Icon(
                          Icons.live_tv,
                          size: 40,
                        ),
                        title: 'Category 2',
                        servicesCount: 10,
                        onTap: () {},
                      ),
                      CategoryCard(
                        icon: Icon(Icons.person, size: 40),
                        title: 'Category 3',
                        servicesCount: 2,
                        onTap: () {},
                      ),
                      CategoryCard(
                        icon: Icon(Icons.abc),
                        title: 'Category 4',
                        servicesCount: 7,
                        onTap: () {},
                      ),
                    ],
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

class CategoryCard extends StatelessWidget {
  final String title;
  final int servicesCount;
  final Icon icon;
  final VoidCallback onTap;

  const CategoryCard({
    required this.title,
    required this.servicesCount,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text('$servicesCount Services'),
            ],
          ),
        ),
      ),
    );
  }
}
