import 'package:card_view/src/card_view.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: CardView(
        images: const [
          "https://i.pinimg.com/originals/69/dd/54/69dd5416b64b8cab9512970ca3151b32.jpg",
          "https://i.pinimg.com/736x/d4/53/07/d453076ca0b5fc48989d3c9a2a2fc209.jpg",
          "https://bidunart.com/wp-content/uploads/2019/12/Portrait075a-819x1024.jpg",
          "https://t4.ftcdn.net/jpg/06/89/41/99/360_F_689419949_Fd0U3hZsOv8V94niH7MfRzdEAeHbqg1Y.jpg",
          "https://i.pinimg.com/474x/25/dd/dd/25dddd86fe06081bad6c6aa1ba87f387.jpg",
          "https://webneel.com/daily/sites/default/files/images/daily/08-2018/8-portrait-photography-beautiful-woman-sam.jpg",
        ],
      ),
    );
  }
}
