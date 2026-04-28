import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

class BrowserNavButtons extends StatelessWidget {
  const BrowserNavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: NavigationService.instance,
      builder: (context, child) {
        final canGoBack = NavigationService.instance.canGoBack;
        final canGoForward = NavigationService.instance.canGoForward;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavIconButton(
              icon: Icons.arrow_back,
              isEnabled: canGoBack,
              onPressed: NavigationService.instance.goBack,
            ),
            const SizedBox(width: 8),
            _NavIconButton(
              icon: Icons.arrow_forward,
              isEnabled: canGoForward,
              onPressed: NavigationService.instance.goForward,
            ),
          ],
        );
      },
    );
  }
}

class _NavIconButton extends StatefulWidget {
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _NavIconButton({
    required this.icon,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  State<_NavIconButton> createState() => _NavIconButtonState();
}

class _NavIconButtonState extends State<_NavIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.isEnabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.isEnabled 
                  ? (_isHovered ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(0.1))
                  : Colors.transparent,
            ),
            color: widget.isEnabled
                ? (_isHovered ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.05))
                : Colors.white.withOpacity(0.02),
            boxShadow: _isHovered && widget.isEnabled
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: widget.isEnabled ? Colors.white : Colors.white.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
