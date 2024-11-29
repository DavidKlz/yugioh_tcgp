import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yugioh_tcgp/logic/data/card_info.dart';

part 'card_provider.g.dart';

@riverpod
class CardService extends _$CardService {
  final dio = Dio();
  bool isLoading = false;
  String name = "";
  int rowsRemaining = 1;
  int nextOffset = 0;
  
  @override
  List<CardInfo> build() {
    state = [];
    _load(50, nextOffset);
    return state;
  }

  void loadNext() {
    if(rowsRemaining > 0 && !isLoading) {
      _load(50, nextOffset);
    }
  }

  void searchName(String name) {
    this.name = name;
    _refresh();
  }

  void _refresh() async {
    state = [];
    rowsRemaining = 1;
    nextOffset = 0;
    _load(50, nextOffset);
  }

  _load(int amount, offset) async {
    isLoading = true;
    final response = await dio.get("https://db.ygoprodeck.com/api/v7/cardinfo.php?&startdate=1995-01-01&enddate=2004-12-31&num=$amount&offset=$offset&fname=$name");
    if(response.statusCode == 200) {
      rowsRemaining = response.data["meta"]["rows_remaining"] ?? 0;
      nextOffset = response.data["meta"]["next_page_offset"] ?? 0;
      List<dynamic> data = response.data["data"];
      for (var item in data) {
        var card = CardInfo.fromJson(item);
        if (!state.contains(card)) {
          state = [...state, card];
        }
      }
    } else {
      state = [];
    }
    isLoading = false;
  }
}