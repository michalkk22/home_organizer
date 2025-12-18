import 'package:flutter/material.dart';
import 'package:home_organizer/widgets/themed_text_field.dart';

class NumberInputWithArrows extends StatefulWidget {
  const NumberInputWithArrows({
    super.key,
    this.initialValue = 0,
    this.onChanged,
  });
  final double initialValue;
  final void Function(double value)? onChanged;

  @override
  State<NumberInputWithArrows> createState() => _NumberInputWithArrowsState();
}

class _NumberInputWithArrowsState extends State<NumberInputWithArrows> {
  late final TextEditingController _controller;
  late final void Function(double value) _onChanged =
      widget.onChanged ?? (_) {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _increment() {
    double currentValue = double.parse(_controller.text);
    setState(() {
      currentValue++;
      _controller.text = (currentValue).toString();
    });
    _onChanged(currentValue);
  }

  void _decrement() {
    double currentValue = double.parse(_controller.text);
    setState(() {
      currentValue--;
      _controller.text = (currentValue > 0 ? currentValue : 0).toString();
    });
    _onChanged(currentValue);
  }

  void _edit() {
    double currentValue = double.parse(_controller.text);
    setState(() {
      _controller.text = (currentValue > 0 ? currentValue : 0).toString();
    });
    _onChanged(currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 40.0,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ThemedTextField(
              textAlign: TextAlign.center,
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              onChanged: () => _edit(),
            ),
          ),
          SizedBox(
            height: 38.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  child: InkWell(
                    child: Icon(Icons.arrow_drop_up, size: 18.0),
                    onTap: () => _increment(),
                  ),
                ),
                InkWell(
                  child: Icon(Icons.arrow_drop_down, size: 18.0),
                  onTap: () => _decrement(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
