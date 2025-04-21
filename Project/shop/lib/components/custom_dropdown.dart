import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final TextEditingController? controller; // Optional controller to store selected value
  final String label;
  final IconData? icon; // Optional icon, nullable
  final List<Map<String, dynamic>> items; // List of options
  final String displayKey; // Key to display from the map
  final String valueKey; // Key to store as the selected value
  final ValueChanged<String?>? onChanged; // Callback for when selection changes
  final bool readOnly; // To disable interaction if needed

  const CustomDropdown({
    super.key,
    this.controller,
    required this.label,
    this.icon,
    required this.items,
    this.displayKey = 'name', // Default key for display text
    this.valueKey = 'id', // Default key for value
    this.onChanged,
    this.readOnly = false,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize with controller value if provided, else null
    _selectedValue = widget.controller?.text.isNotEmpty == true ? widget.controller!.text : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        validator: (widget.readOnly
            ? null // No validation if readOnly is true
            : (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null; // No error if a value is selected
              }),
        value: _selectedValue,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: Colors.grey)
              : null,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade400, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: widget.items.map((Map<String, dynamic> item) {
          return DropdownMenuItem<String>(
            value: item[widget.valueKey].toString(), // Store the valueKey as the value
            child: Text(
              item[widget.displayKey].toString(), // Display the displayKey
              style: TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: widget.readOnly
            ? null // Disable if readOnly is true
            : (String? newValue) {
                setState(() {
                  _selectedValue = newValue;
                  if (widget.controller != null) {
                    widget.controller!.text = newValue ?? '';
                  }
                  if (widget.onChanged != null) {
                    widget.onChanged!(newValue);
                  }
                });
              },
        isExpanded: true, // Ensure dropdown takes full width
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
        dropdownColor: Colors.white, // Background color of dropdown
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
