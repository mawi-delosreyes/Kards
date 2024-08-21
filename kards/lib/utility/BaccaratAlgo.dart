import 'package:kards/database/dao/KardsDao.dart';
import 'package:kards/repository/BaccaratRepoImpl.dart';
import 'package:sqflite/sqflite.dart';

class Baccarat {

  void saveDB(int game_id, String win, double bet_amount, String status) async {
    BaccaratRepoImpl().saveWin(game_id, win, bet_amount, status);
  }

  Map<String, Object> main(int game_id, String win, List win_list, int lose_streak, int sequence_algo_ctr, List bet_list, String current_algo) {
    return BaccaratAlgo().main(win_list, current_algo, lose_streak, sequence_algo_ctr, bet_list);
  }
}

class BaccaratAlgo{

  double getAmount(int sequence_ctr, String algo) {

    List amountSeq1 = [1, 1, 2, 3, 1];
    List amountSeq2 = [1, 2, 1, 2, 3];
    List amountSeq3 = [1, 3, 1, 2, 1];
    
    int multiplier;

    if(algo == "algoSequence") {
      multiplier = amountSeq1[sequence_ctr];
    } else {
      multiplier = amountSeq2[sequence_ctr];
    }

    return 10.0 * multiplier;
  }

  Map<String, Object> getWinFromSeq(List win_list, String current_algo, int lose_streak, int sequence_algo_ctr, List bet_list) {


    //sequence algo
    List algoSequence = ['P', 'B', 'P', 'P', 'B', 'B'];

    //player-banker algo
    List playerSequence = ['PPP', 'PPB', 'BPP', 'BPB'];
    List bankerSequence = ['BBB', 'BBP', 'PBB', 'PBP'];

    Map<String, Object> sequenceReturn = new Map();
    String prediction;
    int lose_threshhold = 6;

    if(win_list.length==0 || win_list.length==1) {
      bet_list.add(algoSequence[win_list.length]);
      sequenceReturn["sequence_return"] = sequence_algo_ctr;
      sequenceReturn["prediction"] = algoSequence[win_list.length];
      sequenceReturn["current_algo"] = current_algo;
      sequenceReturn["lose_streak"] = lose_streak;
      sequenceReturn["bet_list"] = bet_list;
      return sequenceReturn;
    }

    if(bet_list.length >= 1 && bet_list.last == win_list.last){
      if(current_algo != "algoSequence"){
        lose_streak = 0;
      }
      sequence_algo_ctr += 1;
    }
    else{
      if(current_algo == "algoSequence") {
        lose_streak += 1;
      }else{
        lose_streak += 1;
      }
      sequence_algo_ctr = 0;
    }

    if(lose_streak > lose_threshhold) {
      if(current_algo == "algoSequence") {
        current_algo = "player-banker";
      } else{
        // 10 before switch
        current_algo = "algoSequence";
      }
      lose_streak = 0;
    }

    if(algoSequence.length == sequence_algo_ctr) {
      sequence_algo_ctr = 0;
    }

    if(current_algo == "algoSequence") {
      prediction = algoSequence[sequence_algo_ctr];
    } else {
      String last_seq = win_list.getRange(win_list.length-3, win_list.length).join();
      if(playerSequence.contains(last_seq)) {
        prediction = "P";
      } else {prediction = "B";}
    }

    bet_list.add(prediction);

    print("win " + win_list.toString());
    print("bet " + bet_list.toString());
    print(current_algo);
    print(sequence_algo_ctr);


    sequenceReturn["sequence_return"] = sequence_algo_ctr;
    sequenceReturn["prediction"] = prediction;
    sequenceReturn["current_algo"] = current_algo;
    sequenceReturn["lose_streak"] = lose_streak;
    sequenceReturn["bet_list"] = bet_list;
    return sequenceReturn;

  }

  Map<String, Object> main(List win_list, String current_algo, int loss_streak, int sequence_algo_ctr, List bet_list) {


    Map<String, Object> sequence_return = getWinFromSeq(win_list, current_algo, loss_streak, sequence_algo_ctr, bet_list);

    int cur_loss_streak = loss_streak;

    Object sequence_ctr = sequence_return["sequence_return"]?? 0;
    Object algo = sequence_return["current_algo"]!;
    Object prediction = sequence_return["prediction"]!;
    Object lose_streak = sequence_return["lose_streak"]!;
    Object new_bet_list = sequence_return["bet_list"]!;
    double amount = getAmount(sequence_ctr as int, algo as String);
      

    Map<String, Object> baccaratUpdate = {
      "prediction": prediction,
      "amount": amount,
      "ctr": sequence_ctr,
      "lose_streak": lose_streak,
      "current_algo": algo,
      "bet_list": new_bet_list
      };

    return baccaratUpdate;
  }
}