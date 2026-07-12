import 'package:flutter/material.dart';
import 'package:kards/utility/BlackjackAlgo.dart';

class BlackjackScreen extends StatefulWidget {
  const BlackjackScreen({super.key});

  @override
  State<BlackjackScreen> createState() => _BlackjackScreenState();
}

class _BlackjackScreenState extends State<BlackjackScreen> {
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

  /// Running count = sum over each card of (times tapped * that card's
  /// Hi-Lo value), e.g. tapping "K" three times contributes 3 * -1 = -3.
  int get _runningCount {
    int total = 0;
    for (int i = 0; i < cardAssignments.length; i++) {
      final value = cardAssignments[i].values.first;
      total += _tapCounts[i] * value;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: MaterialApp should normally only be created once, at the root
    // of your app (e.g. in main.dart). Nesting another MaterialApp/Scaffold
    // here works but is not standard practice and can cause subtle issues
    // (lost Navigator context, theming, etc). Consider making this screen
    // just return a Scaffold and have main.dart's MaterialApp point to it.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        "BLACKJACK COUNTER",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text("RUNNING COUNT", textAlign: TextAlign.center),
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text("$_runningCount", textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              // Expanded is required here: CardGrid contains a GridView,
              // which needs a bounded height. Without Expanded, the Column
              // gives it unbounded height and Flutter throws an
              // "infinite size" layout error.
              Expanded(
                child: BlackjackGrid(
                  cardAssignments: cardAssignments,
                  tapCounts: _tapCounts,
                  onCardTap: _onCardTap,
                  onReset: _resetCounts,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}