import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;
  double? w;
  double? h;

  DropdownButtonWidget(
      {required this.items, this.selectedItem, this.onChanged, this.w, this.h});

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.w,
      height: widget.h,
      child: DropdownButton<String>(
        value: _selectedItem,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? selectedItem) {
          setState(() {
            _selectedItem = selectedItem;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(selectedItem);
          }
        },
      ),
    );
  }
}
