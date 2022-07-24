import 'package:flutter/material.dart';

class DropdownCustom extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final String dropdownValue;
  final List<Map<String, String>> dropdownItems;
  final bool isLabel;
  final double inputWidth;

  const DropdownCustom({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.dropdownValue,
    required this.dropdownItems,
    required this.isLabel,
    required this.inputWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLabel ? Text(hintText) : Container(),
          Container(
            width: MediaQuery.of(context).size.width * inputWidth,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: DropdownButton<String>(
                value: dropdownValue,
                isExpanded: true,
                items: dropdownItems.map((Map item) {
                  return DropdownMenuItem<String>(
                    value: item['Value'],
                    child: Text(item['Label']),
                  );
                }).toList(),
                onChanged: (value) => onChanged(value!),
              ),
            ),
          ),
          const SizedBox(height: 10.0,),
        ],
      ),
    );
  }
}
