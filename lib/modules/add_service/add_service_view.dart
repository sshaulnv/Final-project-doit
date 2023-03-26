import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';

import '../../shared/constants/constants.dart';

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  String? _title;
  String? _category;
  DateTime? _date;
  String? _sourceAddress;
  String? _destinationAddress;
  String? _description;
  double? _price;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'New Service',
                      style: kTextStyleWhiteHeader.copyWith(fontSize: 40),
                    ),
                  ),
                ),
                TextFormField(
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.title,
                      color: kColorBlueText,
                    ),
                    labelText: 'Service Title',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description for your service request';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _description = value!;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.category_rounded,
                      color: kColorBlueText,
                    ),
                    labelText: 'Service Category',
                    labelStyle: kTextStyleTextFiled,
                  ),
                  value: _category,
                  items: <String>[
                    'Category 1',
                    'Category 2',
                    'Category 3',
                    'Category 4',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: kTextStyleTextFiled,
                      ),
                    );
                  }).toList(),
                  validator: (String? value) {
                    if (value == null) {
                      return 'Please select a category for your service request';
                    }
                    return null;
                  },
                  onChanged: (String? value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  onSaved: (String? value) {
                    _category = value!;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text(_date == null
                      ? 'Select Date'
                      : 'Date: ${_date.toString().substring(0, 10)}'),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _date = picked;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: kColorRoundButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: kColorBlueText,
                    ),
                    labelText: 'Source Address',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a source address for your service request';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _sourceAddress = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: kColorBlueText,
                    ),
                    labelText: 'Destination Address',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a destination address for your service request';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _destinationAddress = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    labelText: 'Service Description',
                  ),
                  maxLines: 4,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description for your service request';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _description = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: kColorBlueText,
                    ),
                    labelText: 'Service Price',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price for your service request';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _price = double.parse(value!);
                  },
                ),
                SizedBox(height: 16.0),
                RoundIconButton(
                  color: kColorRoundButton,
                  icon: Icon(
                    Icons.verified,
                    color: Colors.white,
                  ),
                  text: Text(
                    'Create Service',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: Implement create service functionality here
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
