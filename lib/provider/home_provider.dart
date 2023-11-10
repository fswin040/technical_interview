import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/accounts_model.dart';

//背景顏色
final backgroundColorProvider = StateProvider<Color>((ref) {
  return Colors.white;
});

//排序切換
final sortedOrderProvider = StateProvider<bool>((ref) => true);

//暫時儲存資料
final sittersDataProvider = StateProvider<List<AccountsModel>>((ref) {
  return [];
});

final sortedSittersProvider =
    FutureProvider.autoDispose<List<AccountsModel>>((ref) async {
  final isSortedAscending = ref.watch(sortedOrderProvider);
  List<AccountsModel> sitters = ref.watch(sittersDataProvider);

  //避免多次取得
  if (sitters.isEmpty) {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pseudo_sitter').get();
    sitters = querySnapshot.docs.map((doc) {
      return AccountsModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    ref.read(sittersDataProvider.notifier).state = sitters; // 存储数据
  }
  //排序判斷
  sitters.sort((a, b) {
    var ratingA = a.ratingAvg ?? double.minPositive;
    var ratingB = b.ratingAvg ?? double.minPositive;
    return isSortedAscending
        ? ratingA.compareTo(ratingB)
        : ratingB.compareTo(ratingA);
  });

  return sitters;
});
