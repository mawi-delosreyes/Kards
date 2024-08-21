import 'package:flutter/material.dart';
import 'package:kards/utility/BaccaratAlgo.dart';

class BaccaratScreen extends StatefulWidget {
  const BaccaratScreen({super.key});

  @override
  State<BaccaratScreen> createState() => _BaccaratScreenState();
}

class _BaccaratScreenState extends State<BaccaratScreen> {
  
  int lose_streak = 0;
  int sequence_algo_ctr = 0;
  List win_list = [];
  List bet_list = ["P"];
  String current_algo = "algoSequence";
  String bet_predictions = "";
  int games = -1;
  Map<String, Object> baccarat_algo = Map();

  @override 
  Widget build(BuildContext context) {
    games += 1;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false,),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 20,
              child: Container(
                child: Text(
                  "Game Number ${games} bet: ${bet_predictions} \n"
                  "Previous Bet: ${bet_list.length>1? bet_list.elementAt(bet_list.length-2):""}, Previous Win: ${win_list.length>0? win_list.last:""}"
                ),
              )
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        win_list.add("P");
                        baccarat_algo = Baccarat().main(1, "Player", win_list, lose_streak, sequence_algo_ctr, bet_list, current_algo);
                        lose_streak = baccarat_algo["lose_streak"]==null ? 0:baccarat_algo["lose_streak"] as int ;
                        bet_predictions = "${baccarat_algo["prediction"] == 'P' ? "Player":'Banker'} for ${baccarat_algo["amount"]}";
                        sequence_algo_ctr = baccarat_algo["ctr"] as int;
                        current_algo = baccarat_algo["current_algo"] as String;
                      });
                    }, 
                    child: const Text("Player"),
                  ), 
              
                  TextButton(
                    onPressed: () {
                      setState(() { 
                        //Baccarat().main(1, "Tie", cur_bet, win_list, lose_streak, sequence_algo_ctr);
                      });
                    }, 
                    child: const Text("Tie")
                  ), 
              
                  TextButton(
                    onPressed: () {
                      setState(() {
                        win_list.add("B");
                        baccarat_algo = Baccarat().main(1, "Banker", win_list, lose_streak, sequence_algo_ctr, bet_list, current_algo);
                        lose_streak = baccarat_algo["lose_streak"]==null ? 0:baccarat_algo["lose_streak"] as int ;
                        bet_predictions = "${baccarat_algo["prediction"] == 'B' ? "Banker":'Player'} for ${baccarat_algo["amount"]}";
                        sequence_algo_ctr = baccarat_algo["ctr"] as int;
                        current_algo = baccarat_algo["current_algo"] as String;
                      });
                    }, 
                    child: const Text("Banker")
                  ), 
                ],
              ),
            )
          ],
        ),

      ),
    );
  }

}

