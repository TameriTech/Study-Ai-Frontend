import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../color_constants.dart';

const Color PRIMARY_COLOR = inactive;
const Color BACKGROUND_COLOR = Color(0xffECECEC);

class CustomBottomNavigationBar extends StatefulWidget {
  final Color backgroundColor;
  final Color itemColor;
  final List<CustomBottomNavigationItem> children;
  final Function(int) onChange;
  final int currentIndex;

  const
  CustomBottomNavigationBar({super.key, this.backgroundColor = BACKGROUND_COLOR, this.itemColor = PRIMARY_COLOR, this.currentIndex = 0, required this.children, required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _changeIndex(int index) {
    if (widget.onChange != null) {
      widget.onChange(index);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Column(
          children: [
            // Top indicator bar
            SizedBox(
              height: 3,
              child: Row(
                children: widget.children.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Expanded(
                    child: Container(
                      color: widget.currentIndex == index
                          ? (entry.value.color ?? widget.itemColor)
                          : Colors.transparent,
                    ),
                  );
                }).toList(),
              ),
            ),
            // Navigation items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.children.map((item) {
                    var color = item.color ?? widget.itemColor;
                    var icon = item.icon;
                    var label = item.label;
                    int index = widget.children.indexOf(item);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _changeIndex(index);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: icon,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                label ?? '',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Get.textTheme.labelSmall?.merge(
                                TextStyle(
                                    color: widget.currentIndex == index ? color :  primaryColor,
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNavigationItem {
  final Widget? icon;
  final String? label;
  final Color? color;

  CustomBottomNavigationItem({@required this.icon, @required this.label, this.color});
}