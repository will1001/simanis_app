import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget inputFormStyle4(
    var _icon,
    String _hintText,
    String _keyboardType,
    String _labelText,
    String validatorMessage,
    bool errorSign,
    TextEditingController _controller,
    bool _obscureText,
    var _initialValue,
    var _iconPressed) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 46,
        child: TextFormField(
          keyboardType: _keyboardType == "number"
              ? TextInputType.number
              : TextInputType.text,
          controller: _controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                    opacity: _icon == null ? 0 : 1,
                    child: IconButton(
                      onPressed: _iconPressed,
                      icon: Icon(_icon == null ? Icons.ac_unit : _icon),
                      color: Colors.grey,
                    )),
                errorSign
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.error),
                        color: Color(0xffCB3A31),
                      )
                    : Container(),
              ],
            ),
            // prefixIcon: Padding(
            //   padding: const EdgeInsets.only(left: 5.0, right: 9),
            //   child: Image.asset(
            //     _icon,
            //     width: 30,
            //     height: 30,
            //   ),
            // ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: errorSign ? Color(0xffCB3A31) : Color(0xffE4E5E7),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: errorSign ? Color(0xffCB3A31) : Color(0xffE4E5E7),
              ),
            ),
            fillColor: Colors.white,
            hintText: _hintText,
            hintStyle: TextStyle(color: Color(0xff848A95)),
            // labelStyle: TextStyle(color: Color(0xff848A95)),
            // labelText: _labelText,
          ),
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return validatorMessage;
          //   }
          //   return null;
          // },
        ),
      ),
      errorSign
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                validatorMessage,
                style: TextStyle(color: Color(0xffCB3A31)),
              ),
            )
          : Container()
    ],
  );
}
