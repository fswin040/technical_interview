import 'package:flutter/material.dart';

import '../model/accounts_model.dart';

class CardUI extends StatefulWidget {
  final AccountsModel data;

  const CardUI({Key? key, required this.data}) : super(key: key);

  @override
  _CardUIState createState() => _CardUIState();
}

class _CardUIState extends State<CardUI> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _picController;
  late Animation<double> _heightFactorAnimation;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _picController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _heightFactorAnimation = Tween<double>(begin: 200.0, end: 400.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.ease));
  }

  @override
  void dispose() {
    _picController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void rotateImage() {
    _picController.forward(from: 0.0);
  }

  //年齡換算
  int age(DateTime date) {
    DateTime now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
            height: 400,
            width: 400,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: _heightFactorAnimation.value,
                child: child,
              ),
            ));
      },
      child: Stack(
        children: [
          Container(
              width: 350,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Text(
                      '${widget.data.lastName} ${widget.data.firstName}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Text(
                      '性別 : ${widget.data.gender}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  isExpanded
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: ListView(
                              children: [
                                const Divider(),
                                const Text(
                                  '自我介紹',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.grey),
                                ),
                                Text(
                                    '年齡: ${age(widget.data.dateOfBirth!.toDate())}'),
                                Text(
                                    '平均評價: ${widget.data.ratingAvg?.toInt()} (${widget.data.ratingNum} 平價數量)'),
                                Text('\$${widget.data.weekdaySitterRate}/hr'),
                                const Divider(),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: _toggleCard,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.unfold_more_outlined,
                                size: 40,
                              ),
                              Text(
                                '更多',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ))
                ],
              )),
          _headPic(),
          if (isExpanded)
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: _toggleCard,
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.cancel,
                        size: 40,
                      ),
                    )))
        ],
      ),
    );
  }

  //大頭照
  Widget _headPic() {
    return GestureDetector(
      onTap: rotateImage,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.yellow, Colors.red], // 这里是渐变色的设置
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_picController),
            child: ClipOval(
              child: Image.network(
                widget.data.profilePicURL ?? "",
                height: 70,
                width: 70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
