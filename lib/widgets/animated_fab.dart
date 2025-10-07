import 'package:flutter/material.dart';

class AnimatedFAB extends StatefulWidget {
  final Function() onAddText;
  final Function() onAddVoice;
  final Function() onAddChecklist;

  const AnimatedFAB({
    super.key,
    required this.onAddText,
    required this.onAddVoice,
    required this.onAddChecklist,
  });

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void toggle() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen)
        _controller.forward();
      else
        _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildButton(IconData icon, Color color, VoidCallback onPressed,
      {required double angle}) {
    final double rad = angle * (3.1415926 / 180);
    return Transform.translate(
      offset: Offset.fromDirection(rad, 70 * _animation.value),
      child: FloatingActionButton(
        mini: true,
        backgroundColor: color,
        onPressed: onPressed,
        child: Icon(icon, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Checklist button
          _buildButton(Icons.check_box, Colors.green, () {
            widget.onAddChecklist();
            toggle();
          }, angle: 210),

          // Voice note button
          _buildButton(Icons.mic, Colors.orange, () {
            widget.onAddVoice();
            toggle();
          }, angle: 150),

          // Text note button
          _buildButton(Icons.note_add, Colors.blue, () {
            widget.onAddText();
            toggle();
          }, angle: 90),

          // Main FAB
          FloatingActionButton(
            onPressed: toggle,
            child: AnimatedRotation(
              turns: isOpen ? 0.125 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
