import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String label;
  final bool searchable;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label = '',
    this.searchable = false,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey<_DropdownMenuState> _menuKey = GlobalKey<_DropdownMenuState>();
  OverlayEntry? _overlayEntry;

  static const double _itemHeight = 48.0;
  static const double _searchBarHeight = 52.0;
  static const double _maxMenuHeight = 300.0;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _menuKey.currentState?.close();
  }

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    final RenderBox buttonBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final buttonSize = buttonBox.size;
    final buttonPosition = buttonBox.localToGlobal(Offset.zero);

    final double listHeight =
        (widget.items.length * _itemHeight).clamp(0.0, _maxMenuHeight);
    final double menuHeight = widget.searchable
        ? (listHeight + _searchBarHeight).clamp(0.0, _maxMenuHeight + _searchBarHeight)
        : listHeight;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double topSafeArea = MediaQuery.of(context).padding.top;
    final double bottomSafeArea = MediaQuery.of(context).padding.bottom;

    final double spaceBelow =
        screenHeight - buttonPosition.dy - buttonSize.height - bottomSafeArea;
    final double spaceAbove = buttonPosition.dy - topSafeArea;

    final bool fitsBelow = menuHeight <= spaceBelow;
    final bool fitsAbove = menuHeight <= spaceAbove;
    final bool openBelow = fitsBelow || !fitsAbove;

    final menu = _DropdownMenu(
      key: _menuKey,
      items: widget.items,
      selectedValue: widget.value,
      menuHeight: menuHeight,
      openBelow: openBelow,
      buttonPosition: buttonPosition,
      buttonWidth: buttonSize.width,
      searchable: widget.searchable,
      onChanged: (value) {
        widget.onChanged(value);
        _menuKey.currentState?.close();
      },
      onClosed: () {
        _overlayEntry?.remove();
        _overlayEntry = null;
        setState(() {});
      },
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
          menu,
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          key: _buttonKey,
          onTap: _toggleDropdown,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  _overlayEntry != null
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownMenu extends StatefulWidget {
  final List<String> items;
  final String selectedValue;
  final double menuHeight;
  final bool openBelow;
  final Offset buttonPosition;
  final double buttonWidth;
  final ValueChanged<String> onChanged;
  final VoidCallback onClosed;
  final bool searchable;

  const _DropdownMenu({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.menuHeight,
    required this.openBelow,
    required this.buttonPosition,
    required this.buttonWidth,
    required this.onChanged,
    required this.onClosed,
    this.searchable = false,
  });

  @override
  State<_DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<_DropdownMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isClosing = false;

  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    final double startOffsetY = widget.openBelow ? -10.0 : 10.0;
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, startOffsetY / widget.menuHeight),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  void close() {
    if (_isClosing) return;
    _isClosing = true;
    _animationController.reverse().then((_) {
      widget.onClosed();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 48.0;
    const double searchBarHeight = 52.0;
    const double emptyStateHeight = 48.0;
    const double maxListHeight = 300.0;

    final double listHeight = _filteredItems.isEmpty
        ? emptyStateHeight
        : (_filteredItems.length * itemHeight).clamp(0.0, maxListHeight);
    final double totalHeight =
        (widget.searchable ? searchBarHeight : 0) + listHeight;

    final screenHeight = MediaQuery.of(context).size.height;
    final double? top = widget.openBelow
        ? widget.buttonPosition.dy + 48
        : null;
    final double? bottom = widget.openBelow
        ? null
        : screenHeight - widget.buttonPosition.dy;

    return Positioned(
      left: widget.buttonPosition.dx,
      top: top,
      bottom: bottom,
      width: widget.buttonWidth,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              height: totalHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  if (widget.searchable)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Поиск...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),

                  Expanded(
                    child: _filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              'Ничего не найдено',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              final isSelected = item == widget.selectedValue;
                              final isFirst = index == 0;
                              final isLast = index == _filteredItems.length - 1;

                              return InkWell(
                                onTap: () => widget.onChanged(item),
                                child: Container(
                                  height: itemHeight,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withValues(alpha: 0.1)
                                        : null,
                                    borderRadius: isFirst && !widget.searchable
                                        ? const BorderRadius.vertical(
                                            top: Radius.circular(16))
                                        : isLast
                                            ? const BorderRadius.vertical(
                                                bottom: Radius.circular(16))
                                            : null,
                                  ),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.black87,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}