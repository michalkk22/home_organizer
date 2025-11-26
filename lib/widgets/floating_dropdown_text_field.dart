import 'package:flutter/material.dart';

class FloatingDropdownTextField extends StatefulWidget {
  const FloatingDropdownTextField({
    super.key,
    required this.body,
    required this.onAdd,
  });
  final Widget body;
  final void Function(String text) onAdd;

  @override
  State<FloatingDropdownTextField> createState() =>
      _FloatingDropdownTextFieldState();
}

class _FloatingDropdownTextFieldState extends State<FloatingDropdownTextField> {
  late final TextEditingController _controller;
  bool addFieldVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _hideButtonFunction() {
    setState(() {
      addFieldVisible = false;
    });
  }

  void _addButtonFunction(BuildContext context) {
    setState(() {
      if (addFieldVisible) {
        if (_controller.text.isNotEmpty) {
          widget.onAdd(_controller.text);
          _controller.clear();
          addFieldVisible = false;
        }
      } else {
        addFieldVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.body,
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            shape: CircleBorder(),
            onPressed: () => _addButtonFunction(context),
            heroTag: 'add',
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
              size: Theme.of(context).iconTheme.size ?? 40,
            ),
          ),
        ),
        if (addFieldVisible)
          Positioned(
            bottom: 15,
            left: 75,
            right: 75,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter category name here'),
            ),
          ),
        if (addFieldVisible)
          Positioned(
            bottom: 15,
            left: 15,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              shape: CircleBorder(),
              onPressed: () => _hideButtonFunction(),
              heroTag: 'hide',
              child: Icon(
                Icons.arrow_right,
                color: Theme.of(context).colorScheme.primary,
                size: Theme.of(context).iconTheme.size ?? 40,
              ),
            ),
          ),
      ],
    );
  }
}
