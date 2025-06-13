import 'package:flutter/material.dart';

class HistoricWidget extends StatelessWidget {
  const HistoricWidget({Key? key,
    required this.smallDescription,
    required this.onPressed,
    required this.date,
    required this.course
  }) : super(key: key);

  final String smallDescription;
  final String date;
  final String course;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 1)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric( horizontal: 10),
                  height: 19,
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(course),
                ),
                Text(date)
              ],

            ),
            Text(smallDescription, style: TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis,)
          ],
        ),
      ),
    );
  }
}
