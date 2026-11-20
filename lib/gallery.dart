import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'calculator_view.dart';
import 'designs.dart';

/// Shows every design side by side as a live, usable calculator.
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1F),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculator — design options',
              style: text.headlineMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Every preview is the real app, running live — try them out. '
              '"Choose this design" copies an instruction you can paste to Claude.',
              style: text.bodyLarge?.copyWith(color: const Color(0xFFB0B0B8)),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 28,
              runSpacing: 40,
              children: [
                for (final (i, d) in designs.indexed)
                  _GalleryCard(number: i + 1, design: d),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.number, required this.design});

  final int number;
  final CalculatorDesign design;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SizedBox(
      width: 340,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 640,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFF3A3A40), width: 8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: CalculatorView(design: design, autofocus: false),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '$number. ${design.name}',
            style: text.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            design.tagline,
            style: text.bodyMedium?.copyWith(color: const Color(0xFFB0B0B8)),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            key: Key('choose_${design.id}'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1C1C1F),
            ),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text:
                      'Apply design "${design.id}" (${design.name}) '
                      'to the calculator app',
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Copied: "${design.name}" — paste it to Claude',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Choose this design'),
          ),
        ],
      ),
    );
  }
}
