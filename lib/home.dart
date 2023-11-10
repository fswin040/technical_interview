import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:technical_interview/provider/home_provider.dart';

import 'model/accounts_model.dart';
import 'ui/card_ui.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateBackgroundColor);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Color> _rainbowColors = [
    Colors.blue,
    Colors.orange,
    Colors.yellow,
    Colors.green,
  ];
  //切換背景顏色
  void _updateBackgroundColor() {
    double scrollPercentage =
        _scrollController.offset / _scrollController.position.maxScrollExtent;
    int colorIndex = (scrollPercentage * (_rainbowColors.length - 1)).floor();
    ref.read(backgroundColorProvider.notifier).state =
        _rainbowColors[colorIndex.clamp(0, _rainbowColors.length - 1)];
  }

  @override
  Widget build(BuildContext context) {
    final isSortedAscending = ref.watch(sortedOrderProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('List'),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(sortedOrderProvider.notifier).state =
                      !isSortedAscending;
                },
                child: Text(isSortedAscending ? '升序排序' : '降序排序'),
              ),
              Expanded(
                child: FutureBuilder<List<AccountsModel>>(
                  future: ref.watch(sortedSittersProvider.future),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('讀取失敗'));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return CardUI(data: snapshot.data![index]);
                        },
                      );
                    } else {
                      return const Center(child: Text('沒有資料'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
