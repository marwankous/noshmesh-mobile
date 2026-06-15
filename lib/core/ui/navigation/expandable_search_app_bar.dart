import 'package:flutter/material.dart';
import 'package:noshmesh/l10n/l10n.dart';

class ExpandableSearchAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ExpandableSearchAppBar({
    super.key,
    required this.title,
    required this.controller,
    this.actions = const [],
    this.hintText,
    this.onSearchChanged,
    this.onSearchToggled,
    this.bottom,
  });

  final String title;
  final TextEditingController controller;
  final List<Widget> actions;
  final String? hintText;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<bool>? onSearchToggled;
  final PreferredSizeWidget? bottom;

  @override
  State<ExpandableSearchAppBar> createState() => _ExpandableSearchAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class _ExpandableSearchAppBarState extends State<ExpandableSearchAppBar> {
  bool _isSearching = false;
  final FocusNode _focusNode = FocusNode();

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        widget.controller.clear();
        widget.onSearchChanged?.call('');
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      }
    });
    widget.onSearchToggled?.call(_isSearching);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTitleStyle = theme.appBarTheme.titleTextStyle;
    final color = appBarTitleStyle?.color;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _isSearching ? _buildSearchAppBar(color) : _buildDefaultAppBar(),
    );
  }

  Widget _buildSearchAppBar(Color? textColor) {
    return AppBar(
      key: const ValueKey('searching'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _toggleSearch,
      ),
      title: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: widget.onSearchChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: textColor, fontSize: 18),
        cursorColor: textColor,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: context.tr('search'),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          hintStyle: TextStyle(color: textColor?.withValues(alpha: 0.6)),
        ),
      ),
      actions: [
        // Optimizing the "Clear" button to only rebuild itself
        ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            if (widget.controller.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                widget.controller.clear();
                widget.onSearchChanged?.call('');
              },
            );
          },
        ),
      ],
      bottom: widget.bottom,
    );
  }

  Widget _buildDefaultAppBar() {
    return AppBar(
      key: const ValueKey('default'),
      leading: IconButton(
        icon: const Icon(Icons.search),
        onPressed: _toggleSearch,
      ),
      title: Text(widget.title),
      actions: [...widget.actions],
      bottom: widget.bottom,
    );
  }
}
