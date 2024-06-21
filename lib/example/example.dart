import 'package:card_view/src/card_view.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: CardView(
        images: const [
          'https://qph.cf2.quoracdn.net/main-qimg-36f112e87bcda6d9b8e2cb1cfe9bca11-lq',
          'https://static.miraheze.org/greatcharacterswiki/thumb/c/c9/IronMan-Endgame.jpg/1200px-IronMan-Endgame.jpg',
          'https://hips.hearstapps.com/hmg-prod/images/thor-infintywar-1556123529.jpg?crop=0.5272931907709623xw:1xh;center,top&resize=980:*',
          'https://i.pinimg.com/474x/f6/65/5d/f6655d78f3a3550af113fefd5aa5cc43.jpg',
          'https://i.pinimg.com/736x/47/71/f4/4771f436db1d4334d69e657cbcbcce7a.jpg',
          'https://i.pinimg.com/originals/09/58/7b/09587b6d8f899b5c7d41273020e7935c.jpg',
        ],

        // const [
        //   "https://i.pinimg.com/originals/69/dd/54/69dd5416b64b8cab9512970ca3151b32.jpg",
        //   "https://i.pinimg.com/736x/d4/53/07/d453076ca0b5fc48989d3c9a2a2fc209.jpg",
        //   "https://bidunart.com/wp-content/uploads/2019/12/Portrait075a-819x1024.jpg",
        //   "https://t4.ftcdn.net/jpg/06/89/41/99/360_F_689419949_Fd0U3hZsOv8V94niH7MfRzdEAeHbqg1Y.jpg",
        //   "https://i.pinimg.com/474x/25/dd/dd/25dddd86fe06081bad6c6aa1ba87f387.jpg",
        //   "https://webneel.com/daily/sites/default/files/images/daily/08-2018/8-portrait-photography-beautiful-woman-sam.jpg",
        // ],
      ),
    );
  }
}
