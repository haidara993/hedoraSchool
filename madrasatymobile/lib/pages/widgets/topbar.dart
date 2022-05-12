// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  Widget? child;
  VoidCallback? onPressed;
  VoidCallback? onTitleTapped;
  String? buttonHeroTag;

  TopBar(
      {this.title,
      this.child,
      this.onPressed,
      this.onTitleTapped,
      this.buttonHeroTag = 'topBarBtn'})
      : preferredSize = Size.fromHeight(60.0);

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  // TODO: implement preferredSize
  final Size preferredSize;
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Hero(
            tag: widget.buttonHeroTag!,
            transitionOnUserGestures: true,
            child: Container(
              child: MaterialButton(
                onPressed: widget.onPressed,
                height: 90,
                minWidth: 90,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                child: widget.child,
              ),
            ),
          ),
          Hero(
            tag: 'title',
            transitionOnUserGestures: true,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: InkWell(
                onTap: widget.onTitleTapped,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          widget.title!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
