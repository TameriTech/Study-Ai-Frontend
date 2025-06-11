import 'package:flutter/material.dart';

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
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      padding: EdgeInsets.only(left: 30, right: 30, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Color(0xffECECEC),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.children.map((item) {
          var color = item.color ?? widget.itemColor;
          var icon = item.icon;
          var label = item.label;
          int index = widget.children.indexOf(item);
          return GestureDetector(
            onTap: () {
              _changeIndex(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 24,
                  height: 24,
                  child: icon,
                ),
                // Icon(
                //   icon,
                //   size: 20,
                //   color: widget.currentIndex == index ? color : inactive,
                // ),
                Expanded(
                        flex: 2,
                        child: Text(
                          label ?? '',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight:  FontWeight.w600,
                              color: widget.currentIndex == index ? color : Color(0xffADAAAA)),
                        ),
                      )

              ],
            ),
          );
        }).toList(),
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
