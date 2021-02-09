import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_svg/svg.dart';

class SwiperControl extends SwiperPlugin {
  ///IconData for previous
  final String iconPrevious;

  ///iconData fopr next
  final String iconNext;

  ///icon size
  final double size;

  ///Icon normal color, The theme's [ThemeData.primaryColor] by default.
  final Color color;

  ///if set loop=false on Swiper, this color will be used when swiper goto the last slide.
  ///The theme's [ThemeData.disabledColor] by default.
  final Color disableColor;

  final EdgeInsetsGeometry padding;

  final Key key;

  const SwiperControl(
      {this.iconPrevious,
      this.iconNext,
      this.color,
      this.disableColor,
      this.key,
      this.size: 30.0,
      this.padding: const EdgeInsets.all(5.0)});

  Widget buildButton(SwiperPluginConfig config, Color color, String icon,
      int quarterTurns, bool previous) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!config.loop) {
          bool next = config.activeIndex < config.itemCount - 1;
          bool prev = config.activeIndex > 0;
          if (prev && previous) {
            config.controller.previous(animation: true);
          } else if (next && !previous) {
            config.controller.next(animation: true);
          }
        } else {
          if (previous) {
            config.controller.previous(animation: true);
          } else {
            config.controller.next(animation: true);
          }
        }
      },
      child: Padding(
        padding: padding,
        child: RotatedBox(
          quarterTurns: quarterTurns,
          child: SvgPicture.asset(icon, color: color, width: size),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    ThemeData themeData = Theme.of(context);

    Color color = this.color ?? themeData.primaryColor;
    Color disableColor = this.disableColor ?? themeData.disabledColor;
    Color prevColor;
    Color nextColor;

    if (config.loop) {
      prevColor = nextColor = color;
    } else {
      bool next = config.activeIndex < config.itemCount - 1;
      bool prev = config.activeIndex > 0;
      prevColor = prev ? color : disableColor;
      nextColor = next ? color : disableColor;
    }

    Widget child;
    if (config.scrollDirection == Axis.horizontal) {
      child = Row(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildButton(config, prevColor, iconPrevious, 0, true),
          buildButton(config, nextColor, iconNext, 0, false)
        ],
      );
    } else {
      child = Column(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildButton(config, prevColor, iconPrevious, -3, true),
          buildButton(config, nextColor, iconNext, -3, false)
        ],
      );
    }

    return new Container(
      height: double.infinity,
      child: child,
      width: double.infinity,
    );
  }
}
