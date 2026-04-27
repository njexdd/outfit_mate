import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String label;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label = '',
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey<_DropdownMenuState> _menuKey = GlobalKey<_DropdownMenuState>();
  OverlayEntry? _overlayEntry;

  static const double _itemHeight = 48.0;
  static const double _maxMenuHeight = 300.0;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    // Запускаем анимацию закрытия, которая затем вызовет onClosed и удалит оверлей
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

    final double menuHeight =
        (widget.items.length * _itemHeight).clamp(0.0, _maxMenuHeight);
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
      key: _menuKey,   // <-- ключ для доступа к состоянию
      items: widget.items,
      selectedValue: widget.value,
      menuHeight: menuHeight,
      openBelow: openBelow,
      buttonPosition: buttonPosition,
      buttonWidth: buttonSize.width,
      onChanged: (value) {
        widget.onChanged(value);
        _menuKey.currentState?.close(); // закрываем меню после выбора
      },
      onClosed: () {
        _overlayEntry?.remove();
        _overlayEntry = null;
        setState(() {}); // обновить стрелку
      },
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeOverlay, // закрытие по тапу вне меню
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
          menu,
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {}); // стрелка вверх
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
            height: 48, // фиксированная высота как у стандартного DropdownButton
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

// Внутренний виджет меню с анимацией
class _DropdownMenu extends StatefulWidget {
  final List<String> items;
  final String selectedValue;
  final double menuHeight;
  final bool openBelow;
  final Offset buttonPosition;
  final double buttonWidth;
  final ValueChanged<String> onChanged;
  final VoidCallback onClosed;

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    // «Выезд» меню из кнопки
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

  // Публичный метод для закрытия с анимацией
  void close() {
    if (_isClosing) return;
    _isClosing = true;
    _animationController.reverse().then((_) {
      widget.onClosed(); // уведомляем родителя, чтобы удалил оверлей
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Точное позиционирование: стыкуемся к кнопке без зазоров
    final double? top = widget.openBelow
        ? widget.buttonPosition.dy + 48 // высота кнопки
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
            child: Container(
              height: widget.menuHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = item == widget.selectedValue;
                  return InkWell(
                    onTap: () => widget.onChanged(item),
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.1)
                            : null,
                        borderRadius: index == 0
                            ? const BorderRadius.vertical(
                                top: Radius.circular(16))
                            : index == widget.items.length - 1
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
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}