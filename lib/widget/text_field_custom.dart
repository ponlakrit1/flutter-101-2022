import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final String hintText;
  final Function(String)? onFieldSubmitted;
  final TextEditingController controller;
  final bool isLabel;
  final TextInputType keyboardType;
  final double inputWidth;

  const TextFieldCustom({
    Key? key,
    required this.hintText,
    this.onFieldSubmitted,
    required this.controller,
    required this.isLabel,
    required this.keyboardType,
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
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                textInputAction: TextInputAction.go,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: hintText,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius:
                    BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius:
                    BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                ),
                onFieldSubmitted: onFieldSubmitted,
              ),
            ),
          ),
          const SizedBox(height: 10.0,),
        ],
      ),
    );
  }
}
