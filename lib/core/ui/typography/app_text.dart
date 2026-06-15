import 'package:flutter/material.dart';

enum _AppTextStyle { displayLg, headlineMd, titleSm, bodyMd, bodySm, labelMd, metadata }

class AppText extends StatelessWidget {
  const AppText.displayLg(this.text,
      {super.key, this.color, this.maxLines, this.overflow, this.textAlign})
      : _s = _AppTextStyle.displayLg;
  const AppText.headlineMd(this.text,
      {super.key, this.color, this.maxLines, this.overflow, this.textAlign})
      : _s = _AppTextStyle.headlineMd;
  const AppText.titleSm(this.text,
      {super.key, this.color, this.maxLines, this.overflow, this.textAlign})
      : _s = _AppTextStyle.titleSm;
  const AppText.bodyMd(this.text,
      {super.key, this.color, this.maxLines, this.overflow, this.textAlign})
      : _s = _AppTextStyle.bodyMd;
  const AppText.bodySm(this.text,
      {super.key, this.color, this.maxLines, this.overflow, this.textAlign})
      : _s = _AppTextStyle.bodySm;
  const AppText.labelMd(this.text,
      {super.key, this.color, this.maxLines, this.overflow, this.textAlign})
      : _s = _AppTextStyle.labelMd;
  const AppText.metadata(this.text,
      {super.key, this.color, this.maxLines, this.overflow, this.textAlign})
      : _s = _AppTextStyle.metadata;

  final String text;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final _AppTextStyle _s;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final base = switch (_s) {
      _AppTextStyle.displayLg  => tt.displayLarge,
      _AppTextStyle.headlineMd => tt.headlineMedium,
      _AppTextStyle.titleSm    => tt.titleSmall,
      _AppTextStyle.bodyMd     => tt.bodyLarge,
      _AppTextStyle.bodySm     => tt.bodyMedium,
      _AppTextStyle.labelMd    => tt.labelMedium,
      _AppTextStyle.metadata   => tt.bodySmall,
    };
    assert(base != null, 'AppText: TextTheme slot for $_s is null — ensure the theme populates this slot.');
    return Text(
      text,
      style: color != null ? base?.copyWith(color: color) : base,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
