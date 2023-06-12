import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryFilterDialog extends StatefulWidget {
  final List<Categories> options;
  final controller;
  const CategoryFilterDialog(
      {Key? key, required this.options, required this.controller})
      : super(key: key);

  @override
  _CategoryFilterDialogState createState() => _CategoryFilterDialogState();
}

class _CategoryFilterDialogState extends State<CategoryFilterDialog> {
  late List<Categories> selectedOptions;

  void _onCategorySelected(Categories category) {
    setState(() {
      if (selectedOptions.contains(category)) {
        selectedOptions.remove(category);
      } else {
        selectedOptions.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedOptions = widget.controller.filters['Category'];
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Wrap(
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.options
                  .map(
                    (category) => FilterChip(
                      label: Text(convertCategoryToString(category)),
                      selected: selectedOptions.contains(category),
                      onSelected: (_) => _onCategorySelected(category),
                    ),
                  )
                  .toList(),
            ),
            Align(
              alignment: Alignment.center,
              child: RoundIconButton(
                icon: const Icon(
                  Icons.verified,
                  color: Colors.white,
                ),
                text: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  widget.controller.filters['Category'] = selectedOptions;
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
