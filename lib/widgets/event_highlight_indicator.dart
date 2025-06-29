import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/services/visible_events_service.dart';

/// Widget that provides visual indication of whether an event is highlighted
/// based on the current selected time
class EventHighlightIndicator extends StatelessWidget {
  final Event event;
  final Color groupColor;
  final Widget child;
  final double opacity;
  final bool showHighlightBorder;
  final double highlightBorderWidth;
  final Color? highlightBorderColor;

  const EventHighlightIndicator({
    super.key,
    required this.event,
    required this.groupColor,
    required this.child,
    this.opacity = 1.0,
    this.showHighlightBorder = true,
    this.highlightBorderWidth = 2.0,
    this.highlightBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEventsService = VisibleEventsService.instance;
    final isHighlighted = visibleEventsService.isEventHighlighted(
      context: context,
      event: event,
    );

    return Opacity(
      opacity: isHighlighted ? 1.0 : opacity,
      child: Container(
        decoration: showHighlightBorder && isHighlighted
            ? BoxDecoration(
                border: Border.all(
                  color: highlightBorderColor ?? groupColor,
                  width: highlightBorderWidth,
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: child,
      ),
    );
  }
}

/// Widget that provides a pulsing highlight effect for highlighted events
class PulsingEventHighlight extends StatefulWidget {
  final Event event;
  final Color groupColor;
  final Widget child;
  final double opacity;
  final bool showHighlightBorder;
  final double highlightBorderWidth;
  final Color? highlightBorderColor;

  const PulsingEventHighlight({
    super.key,
    required this.event,
    required this.groupColor,
    required this.child,
    this.opacity = 1.0,
    this.showHighlightBorder = true,
    this.highlightBorderWidth = 2.0,
    this.highlightBorderColor,
  });

  @override
  State<PulsingEventHighlight> createState() => _PulsingEventHighlightState();
}

class _PulsingEventHighlightState extends State<PulsingEventHighlight>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleEventsService = VisibleEventsService.instance;
    final isHighlighted = visibleEventsService.isEventHighlighted(
      context: context,
      event: widget.event,
    );

    // Start/stop animation based on highlight state
    if (isHighlighted) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
      _animationController.reset();
    }

    return Opacity(
      opacity: isHighlighted ? 1.0 : widget.opacity,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isHighlighted ? _pulseAnimation.value : 1.0,
            child: Container(
              decoration: widget.showHighlightBorder && isHighlighted
                  ? BoxDecoration(
                      border: Border.all(
                        color: widget.highlightBorderColor ?? widget.groupColor,
                        width: widget.highlightBorderWidth,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Widget that provides a glow effect for highlighted events
class GlowingEventHighlight extends StatelessWidget {
  final Event event;
  final Color groupColor;
  final Widget child;
  final double opacity;
  final double glowRadius;
  final Color? glowColor;

  const GlowingEventHighlight({
    super.key,
    required this.event,
    required this.groupColor,
    required this.child,
    this.opacity = 1.0,
    this.glowRadius = 10.0,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEventsService = VisibleEventsService.instance;
    final isHighlighted = visibleEventsService.isEventHighlighted(
      context: context,
      event: event,
    );

    return Opacity(
      opacity: isHighlighted ? 1.0 : opacity,
      child: Container(
        decoration: isHighlighted
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: (glowColor ?? groupColor).withValues(alpha: 0.6),
                    blurRadius: glowRadius,
                    spreadRadius: 2,
                  ),
                ],
              )
            : null,
        child: child,
      ),
    );
  }
} 