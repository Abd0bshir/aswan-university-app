import 'package:flutter/material.dart';
import 'package:au/shared/constants.dart';

class YearDropdown extends StatelessWidget {
  final String? selectedYear;
  final Function(String?) onChanged;

  const YearDropdown({
    super.key,
    required this.selectedYear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedYear,
      items: ['1', '2', '3', '4'].map((year) {
        return DropdownMenuItem(
          value: year,
          child: Text('Year $year'),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: customInputDecoration.copyWith(
        labelText: 'Year',
        prefixIcon: const Icon(Icons.calendar_month),
      ),
      validator: (value) => value == null ? 'Please select year' : null,
    );
  }
}
