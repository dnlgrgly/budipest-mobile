import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';
import 'dart:core';

import '../models/toilet.dart';
import './bitmapFromSvg.dart';

Widget descriptionIcon(EdgeInsetsGeometry padding, String mode, String iconPath,
    bool smaller, String text) {
  return Padding(
    padding: padding,
    child: Container(
      constraints: BoxConstraints(
          minHeight: 35,
          minWidth: 35,
          maxWidth: text != null ? double.infinity : 35,
          maxHeight: 35),
      decoration: BoxDecoration(
        color: mode == "light" ? Colors.black : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SvgPicture.asset(
              iconPath,
              width: smaller ? 17.5 : 20,
              height: smaller ? 17.5 : 20,
            ),
            if (text != null)
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  text,
                  style: TextStyle(
                    color: mode == "light" ? Colors.white : Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget entryMethodIcon(Toilet toilet, EdgeInsetsGeometry padding) {
  switch (toilet.entryMethod) {
    case EntryMethod.FREE:
      return descriptionIcon(
          padding, "dark", "assets/icons/bottom/dark/tag_free.svg", true, null);
    case EntryMethod.CONSUMERS:
      return descriptionIcon(padding, "dark",
          "assets/icons/bottom/dark/tag_guests.svg", true, null);
    case EntryMethod.PRICE:
      var priceIcons = List<Widget>();
      if (toilet.price != null) {
        toilet.price.forEach((dynamic currency, dynamic value) {
          priceIcons.add(
            descriptionIcon(
              padding,
              "dark",
              "assets/icons/bottom/dark/tag_paid.svg",
              true,
              "$value $currency",
            ),
          );
        });
      } else {
        priceIcons.add(
          descriptionIcon(
            padding,
            "dark",
            "assets/icons/bottom/dark/tag_paid.svg",
            true,
            null,
          ),
        );
      }

      return Row(
        children: priceIcons,
      );
    case EntryMethod.CODE:
      return descriptionIcon(
          padding,
          "dark",
          "assets/icons/bottom/dark/tag_key.svg",
          true,
          toilet.code != null ? toilet.code : "");
    default:
      return null;
  }
}

String openState(List<int> openHours) {
  if (openHours[0] >= openHours[1]) {
    return "_unknown";
  }

  DateTime dateTime = DateTime.now();
  int curr = (dateTime.hour * 60) + dateTime.minute;
  int start = 0;
  int end = 1;

  if (openHours.length > 2) {
    start = (dateTime.weekday - 1) * 2;
    end = start + 1;
  }

  if (openHours[start] <= curr && curr <= openHours[end]) {
    return "_open";
  } else {
    return "_closed";
  }
}

Color coloredOpenState(List<int> openHours) {
  if (openHours[0] >= openHours[1]) {
    return Colors.grey;
  }

  DateTime dateTime = DateTime.now();
  int curr = (dateTime.hour * 60) + dateTime.minute;
  int start = 0;
  int end = 1;

  if (openHours.length > 2) {
    start = (dateTime.weekday - 1) * 2;
    end = start + 1;
  }

  if (openHours[start] <= curr && curr <= openHours[end]) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

List<String> readableOpenState(List<int> openHours) {
  List<String> result = [];
  if (openHours[0] >= openHours[1]) {
    result.add("Ismeretlen nyitvatartási idő");
    result.add("");
    return result;
  }

  DateTime dateTime = DateTime.now();
  int curr = (dateTime.hour * 60) + dateTime.minute;
  int start = 0;
  int end = 1;

  if (openHours.length > 2) {
    start = (dateTime.weekday - 1) * 2;
    end = start + 1;
  }

  if (openHours[start] <= curr && curr <= openHours[end]) {
    result.add("Nyitva ");
    if (openHours[0] == 0 && openHours[1] == 1440) {
      result.add("24/7");
    } else {
      result.add("${minuteToHourFormat(openHours[end])}-ig");
    }
  } else {
    result.add("Zárva ");
    if (openHours[start] > curr) {
      result.add("ma ${minuteToHourFormat(openHours[start])}-ig");
    } else {
      if (end > 1) {
        if (end > 14) {
          result.add("holnap ${minuteToHourFormat(openHours[0])}-ig");
        } else {
          result.add("holnap ${minuteToHourFormat(openHours[end + 1])}-ig");
        }
      } else {
        result.add("holnap ${minuteToHourFormat(openHours[start])}-ig");
      }
    }
  }

  return result;
}

String stringFromCategory(Category category) {
  switch (category) {
    case Category.GENERAL:
      return "general";
    case Category.SHOP:
      return "shop";
    case Category.RESTAURANT:
      return "restaurant";
    case Category.GAS_STATION:
      return "gas_station";
    case Category.PORTABLE:
      return "portable";
    default:
      return "general";
  }
}

List<Widget> describeToiletIcons(
    Toilet toilet, String mode, bool isDetailed, bool smaller) {
  var result = new List<Widget>();
  EdgeInsets padding;
  String categoryStr = stringFromCategory(toilet.category);

  padding = EdgeInsets.fromLTRB(0, 0, 10.0, 0);

  // Add category icon
  result.add(
    descriptionIcon(
      padding,
      mode,
      "assets/icons/bottom/$mode/cat_$categoryStr.svg",
      smaller,
      null,
    ),
  );

  // Loop over tags, add corresponding icons
  if (toilet.tags != null) {
    toilet.tags.forEach((Tag tag) {
      String tagStr = tag
          .toString()
          .substring(tag.toString().indexOf('.') + 1)
          .toLowerCase();
      result.add(
        descriptionIcon(
          padding,
          mode,
          "assets/icons/bottom/$mode/tag_$tagStr.svg",
          smaller,
          null,
        ),
      );
    });
  }

  if (isDetailed) {
    if (toilet.entryMethod != EntryMethod.UNKNOWN) {
      result.add(
        entryMethodIcon(
          toilet,
          padding,
        ),
      );
    }

    if (toilet.upvotes != 0 || toilet.downvotes != 0)
      result.add(
        descriptionIcon(
          padding,
          mode,
          "assets/icons/bottom/$mode/tag_key.svg",
          smaller,
          '${((toilet.upvotes / (toilet.upvotes + toilet.downvotes)) * 100).round()}%',
        ),
      );
  }

  return result;
}

Future<BitmapDescriptor> determineMarkerIcon(
    Category category, List<int> openHours, BuildContext context) async {
  String result = "";

  result += stringFromCategory(category);
  result += openState(openHours);

  return await bitmapDescriptorFromSvgAsset(
    context,
    'assets/icons/pin/l_$result.svg',
  );
}

String minuteToHourFormat(int minutes) {
  String res = "";
  int hours = minutes ~/ 60;
  res += hours.toString();
  res += ':';
  res += '${minutes % 60}'.padLeft(2, '0');
  return res;
}

int hourToMinuteFormat(String input) {
  List<String> splitted = input.split(":");
  int hours = int.parse(splitted[0]);
  int minutes = int.parse(splitted[1]);
  return hours * 60 + minutes;
}
