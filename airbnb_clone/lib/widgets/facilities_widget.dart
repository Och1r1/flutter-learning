import 'package:flutter/material.dart';

class FacilitiesWidget extends StatefulWidget {
  final String type;
  final int startValue;
  final Function decreaseValue;
  final Function increaseValue;

  const FacilitiesWidget({
    super.key,
    required this.type,
    required this.startValue,
    required this.decreaseValue,
    required this.increaseValue,
  });

  @override
  State<FacilitiesWidget> createState() => _FacilitiesWidgetState();
}

class _FacilitiesWidgetState extends State<FacilitiesWidget> {
  int? _value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _value = widget.startValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.type,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  widget.decreaseValue();
                  _value = (_value! - 1).clamp(0, 9999);
                  setState(() {});
                },
                icon: const Icon(Icons.remove, color: Colors.white),
              ),

              Text(
                _value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              IconButton(
                onPressed: () {
                  widget.increaseValue();
                  _value = (_value! + 1).clamp(0, 9999);
                  setState(() {});
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
