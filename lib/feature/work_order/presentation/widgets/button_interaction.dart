import 'package:flutter/material.dart';

class ButtonInteraction extends StatefulWidget {
  final int? status;
  final VoidCallback? onPressed;
  final bool isDisabled;

  const ButtonInteraction(
      {super.key, this.status, this.onPressed, this.isDisabled = false});

  @override
  State<ButtonInteraction> createState() => _ButtonInteractionState();
}

class _ButtonInteractionState extends State<ButtonInteraction> {
  String buttonText = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: widget.isDisabled ? null : widget.onPressed,
        child: _buttonText(),
      ),
    );
  }

  Widget _buttonText() {
    switch (widget.status) {
      case 1:
        return const Text('Menunggu Persetujuan');
      case 2:
        return const Text('Disetujui');
      case 3:
        return const Text('Revisi');
      case 4:
        return const Text('Ditolak');
      case 5:
        return const Text('Selesai');
      default:
        return const Text('Ajukan');
    }
  }
}
