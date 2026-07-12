import 'package:flutter/material.dart';

/// Card labels mapped to their Hi-Lo counting value.
/// Each map has exactly one key (the label shown on the card) and one
/// value (added to the running count each time that card is tapped).
const List<Map<String, int>> cardAssignments = [
  {"2": 1},
  {"3": 1},
  {"4": 1},
  {"5": 1},
  {"6": 1},
  {"7": 0},
  {"8": 0},
  {"9": 0},
  {"10": -1},
  {"J": -1},
  {"Q": -1},
  {"K": -1},
  {"A": -1},
];

/// Screen showing a grid of tappable card slots (labelled with their key)
/// and a reset button, matching the provided mockup.
class BlackjackAlgo extends StatefulWidget {
  const BlackjackAlgo({super.key});

  @override
  State<BlackjackAlgo> createState() => _BlackjackAlgoState();
}

class _BlackjackAlgoState extends State<BlackjackAlgo> {
  late List<int> _tapCounts;

  @override
  void initState() {
    super.initState();
    _tapCounts = List<int>.filled(cardAssignments.length, 0);
  }

  void _onCardTap(int index) {
    setState(() {
      _tapCounts[index]++;
    });
  }

  void _resetCounts() {
    setState(() {
      _tapCounts = List<int>.filled(cardAssignments.length, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // NOTE: this now points at BlackjackGrid, not BlackjackAlgo —
        // a class can't reference itself by the same name it's declared
        // with in this circular way.
        child: BlackjackGrid(
          cardAssignments: cardAssignments,
          tapCounts: _tapCounts,
          onCardTap: _onCardTap,
          onReset: _resetCounts,
        ),
      ),
    );
  }
}

/// The grid + reset button content, with NO Scaffold wrapper.
/// Use this when you want to embed the grid inside another screen
/// (wrap it in Expanded if the parent is a Column).
/// Use [BlackjackAlgo] instead when you want it as a standalone page.
class BlackjackGrid extends StatelessWidget {
  const BlackjackGrid({
    super.key,
    required this.cardAssignments,
    required this.tapCounts,
    required this.onCardTap,
    required this.onReset,
  });

  final List<Map<String, int>> cardAssignments;
  final List<int> tapCounts;
  final void Function(int index) onCardTap;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: cardAssignments.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 0.72, // roughly matches the mockup card shape
              ),
              itemBuilder: (context, index) {
                final label = cardAssignments[index].keys.first;
                return _CardSlot(
                  label: label,
                  tapCount: tapCounts[index],
                  onTap: () => onCardTap(index),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _ResetButton(onPressed: onReset),
          ),
        ],
      ),
    );
  }
}

class _CardSlot extends StatelessWidget {
  const _CardSlot({
    required this.label,
    required this.tapCount,
    required this.onTap,
  });

  final String label;
  final int tapCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(2),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (tapCount > 0) ...[
              const SizedBox(height: 4),
              Text(
                '×$tapCount',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD9D9D9),
      borderRadius: BorderRadius.circular(2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(2),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Center(
            child: Text(
              'RESET COUNT',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 0.5,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}