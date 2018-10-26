import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> boxAnimation;
  AnimationController boxController;

  initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );

    boxController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );

    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );

    boxController.addStatusListener((status) {
      if (status == AnimationStatus.completed && catController.isAnimating) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed &&
          catController.isAnimating) {
        boxController.forward();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation"),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
            overflow: Overflow.visible,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (BuildContext context, Widget child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  onTap() {
    if (AnimationStatus.completed == catController.status) {
      catController.reverse();
      boxController.stop();
    } else if (AnimationStatus.dismissed == catController.status) {
      catController.forward();
    }

    if (boxController.status == AnimationStatus.dismissed) {
      boxController.forward();
    } else if (boxController.status == AnimationStatus.completed) {
      boxController.reverse();
    }
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      top: 2.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          color: Colors.brown,
          height: 10.0,
          width: 125.0,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      top: 2.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          color: Colors.brown,
          height: 10.0,
          width: 125.0,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topRight,
            angle: boxAnimation.value * -1,
          );
        },
      ),
    );
  }
}
