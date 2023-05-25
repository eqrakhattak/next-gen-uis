import 'package:flutter/material.dart';
import '../assets.dart';
import '../styles.dart';
import 'title_screen_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {

  Color get _emitColor => AppColors.emitColors[_difficultyOverride ?? _difficulty];
  Color get _orbColor => AppColors.orbColors[_difficultyOverride ?? _difficulty];

  /// Currently selected difficulty
  int _difficulty = 0;

  /// Currently focused difficulty (if any)
  int? _difficultyOverride;

  void _handleDifficultyPressed(int value) {
    setState(() => _difficulty = value);
  }

  void _handleDifficultyFocused(int? value) {
    setState(() => _difficultyOverride = value);
  }

  final _finalReceiveLightAmt = 0.7;
  final _finalEmitLightAmt = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _AnimatedColors(
          emitColor: _emitColor,
          orbColor: _orbColor,
          builder: (_, orbColor, emitColor) {
            return Stack(
              children: [
                /// Bg-Base
                Image.asset(AssetPaths.titleBgBase),

                /// Bg-Receive
                _LitImage(
                    color: orbColor,
                    imgSrc: AssetPaths.titleBgReceive,
                    lightAmt: _finalReceiveLightAmt),

                /// Mg-Base
                _LitImage(color: orbColor,
                    imgSrc: AssetPaths.titleMgBase,
                    lightAmt: _finalReceiveLightAmt),

                /// Mg-Receive
                _LitImage(color: orbColor,
                    imgSrc: AssetPaths.titleMgReceive,
                    lightAmt: _finalReceiveLightAmt),

                /// Mg-Emit
                _LitImage(color: emitColor,
                    imgSrc: AssetPaths.titleMgEmit,
                    lightAmt: _finalEmitLightAmt),

                /// Fg-Rocks
                Image.asset(AssetPaths.titleFgBase),

                /// Fg-Receive
                _LitImage(color: orbColor,
                    imgSrc: AssetPaths.titleFgReceive,
                    lightAmt: _finalReceiveLightAmt),

                /// Fg-Emit
                _LitImage(color: emitColor,
                    imgSrc: AssetPaths.titleFgEmit,
                    lightAmt: _finalEmitLightAmt),

                /// UI
                Positioned.fill(
                  child: TitleScreenUi(
                    difficulty: _difficulty,
                    onDifficultyPressed: _handleDifficultyPressed,
                    onDifficultyFocused: _handleDifficultyFocused,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 0.3.seconds, duration: 1.seconds);
          }
        ),
      ),
    );
  }
}

class _LitImage extends StatelessWidget {
  const _LitImage({
    required this.color,
    required this.imgSrc,
    required this.lightAmt,
  });
  final Color color;
  final String imgSrc;
  final double lightAmt;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return Image.asset(
      imgSrc,
      color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
      colorBlendMode: BlendMode.modulate,
    );
  }
}

class _AnimatedColors extends StatelessWidget {
  const _AnimatedColors({
    required this.emitColor,
    required this.orbColor,
    required this.builder,
  });

  final Color emitColor;
  final Color orbColor;

  final Widget Function(BuildContext context, Color orbColor, Color emitColor)
  builder;

  @override
  Widget build(BuildContext context) {
    final duration = .5.seconds;
    return TweenAnimationBuilder(
      tween: ColorTween(begin: emitColor, end: emitColor),
      duration: duration,
      builder: (_, emitColor, __) {
        return TweenAnimationBuilder(
          tween: ColorTween(begin: orbColor, end: orbColor),
          duration: duration,
          builder: (context, orbColor, __) {
            return builder(context, orbColor!, emitColor!);
          },
        );
      },
    );
  }
}