import 'dart:async';

import 'package:flutter/material.dart';

enum StaggeredAnimatedDirection { horizontal, vertical }

class StaggeredAnimatedColumn extends StatefulWidget {
  const StaggeredAnimatedColumn({
    required this.children,
    Key? key,
    this.mainAxisAlignment,
    this.duration,
    this.delay,
    this.crossAxisAlignment,
    this.direction = StaggeredAnimatedDirection.vertical,
    this.mainAxisSize,
  }) : super(key: key);

  final List<Widget> children;
  final Duration? duration;
  final Duration? delay;
  final MainAxisAlignment? mainAxisAlignment;
  final StaggeredAnimatedDirection? direction;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize? mainAxisSize;

  @override
  _StaggeredAnimatedColumnState createState() =>
      _StaggeredAnimatedColumnState();
}

class _StaggeredAnimatedColumnState extends State<StaggeredAnimatedColumn>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer delay;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: widget.duration ??
            Duration(
              milliseconds: widget.children.length * 300,
            ));
    delay = Timer(widget.delay ?? const Duration(milliseconds: 300), () {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    delay.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
          crossAxisAlignment:
              widget.crossAxisAlignment ?? CrossAxisAlignment.start,
          mainAxisAlignment:
              widget.mainAxisAlignment ?? MainAxisAlignment.start,
          children: <Widget>[
            ...List.generate(widget.children.length, (index) {
              return FadeTransition(
                opacity: Tween<double>(
                  begin: 0,
                  end: 1,
                ).animate(
                  CurvedAnimation(
                    curve: Interval(
                      1 / widget.children.length * index * 0.1,
                      1 / widget.children.length * index,
                      curve: Curves.easeInOut,
                    ),
                    parent: _animationController,
                  ),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin:
                        widget.direction == StaggeredAnimatedDirection.vertical
                            ? const Offset(0.0, 1.0)
                            : const Offset(1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(
                    CurvedAnimation(
                      curve: Interval(
                        1 / widget.children.length * index * 0.1,
                        1 / widget.children.length * index,
                        curve: Curves.linearToEaseOut,
                      ),
                      parent: _animationController,
                    ),
                  ),
                  child: widget.children[index],
                ),
              );
            })
          ],
        );
      },
    );
  }
}
