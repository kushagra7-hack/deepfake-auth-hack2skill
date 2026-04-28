import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color trustAccent = Color(0xFF4F46E5);

class TrustButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool fullWidth;
  final bool isForwardAction;

  const TrustButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.isForwardAction = false,
  });

  @override
  State<TrustButton> createState() => _TrustButtonState();
}

class _TrustButtonState extends State<TrustButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          width: widget.fullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: trustAccent.withOpacity(_isHovered ? 0.9 : 0.5),
              width: 1,
            ),
            boxShadow: const [], // NO glowing effects
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              else ...[
                if (widget.icon != null && !widget.isForwardAction) ...[
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
                if (widget.isForwardAction) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
