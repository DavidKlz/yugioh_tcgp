import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yugioh_tcgp/logic/data/card_info.dart';

part 'card_provider.g.dart';

@riverpod
class CardService extends _$CardService {
  final dio = Dio();
  bool isLoading = false;
  int rowsRemaining = 1;
  int nextOffset = 0;
  
  @override
  List<CardInfo> build() {
    state = [];
    _load(50, nextOffset);
    return state;
  }

  void loadNext() async {
    if(rowsRemaining > 0 && !isLoading) {
      _load(50, nextOffset);
    }
  }

  _load(int amount, offset) async {
    isLoading = true;
    final response = await dio.get("https://db.ygoprodeck.com/api/v7/cardinfo.php?&startdate=1995-01-01&enddate=2004-12-31&num=$amount&offset=$offset");
    rowsRemaining = response.data["meta"]["rows_remaining"];
    nextOffset = response.data["meta"]["next_page_offset"];
    List<dynamic> data = response.data["data"];
    for(var item in data) {
      var card = CardInfo.fromJson(item);
      if(!state.contains(card)) {
        state = [...state, card];
      }
    }
    isLoading = false;
  }
}