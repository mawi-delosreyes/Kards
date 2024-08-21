import 'package:flutter/material.dart';
import 'package:kards/database/Database.dart';
import 'package:kards/database/dao/KardsDao.dart';
import 'package:kards/screens/baccarat/Baccarat.dart';
import 'package:sqflite/sqflite.dart';


void main() {
  //initialize().initDB();
  runApp(const BaccaratScreen());
}


class initialize {  
  void initDB() async{
      KardsDao().dbHelper.getDatabase;
    }
}
