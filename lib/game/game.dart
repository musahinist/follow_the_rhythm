import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  List<Rect> rectList = [];
  late Rect dino;
  late Size size;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    List.generate(
        7,
        (index) => rectList.add(Rect.fromLTWH(
            200,
            (index == 0 ? -400 : rectList[index - 1].bottom + 8),
            20,
            10 + index * 10)));
    print(rectList);
    dino = Rect.fromLTWH(size.width / 2 - 10, size.height * .5, 20, 40);
    ticker = createTicker((elapsed) {
      setState(() {
        for (var i = 0; i < rectList.length; i++) {
          rectList[i] = rectList[i].translate(0, 2);
          if (rectList[i].bottom > (dino.top + 50)) {
            ticker.stop();
          }
          if (dino.contains(rectList[i].bottomCenter)) {
            dino = Rect.fromLTWH(dino.left, dino.top, dino.width,
                dino.height + rectList[i].height);
            rectList.remove(rectList[i]);
          }
        }
      });
    });
    ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body: Listener(
        onPointerMove: (event) {
          setState(() {
            dino = Rect.fromLTWH(
                event.localPosition.dx.clamp((size.width - 180) / 2,
                        (size.width - 200) / 2 + 9 * 20) -
                    10,
                size.height * 0.5,
                dino.width,
                dino.height);
          });
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                painter: LinePainter(),
                size: size,
              ),
              for (var rect in rectList)
                Positioned(
                  left: rect.left,
                  top: rect.top,
                  child: Container(
                    width: rect.width,
                    height: rect.height,
                    color: Colors.blue,
                  ),
                ),
              Positioned(
                left: dino.left,
                top: dino.top,
                child: Container(
                  width: dino.width,
                  height: dino.height,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  LinePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 10; i++)
      canvas.drawLine(
          Offset((size.width - 200) / 2 + i * 20, size.height * .5 + 100),
          Offset((size.width - 180) / 2 + i * 20, size.height * .5 + 100),
          paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
