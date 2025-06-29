import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/services/visible_events_service.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:provider/provider.dart';

/// Widget that provides visual indication of whether an event is highlighted
/// based on the current selected time and/or if it's the selected event
class EventHighlightIndicator extends StatelessWidget {
  final Event event;
  final Color groupColor;
  final Widget child;
  final double opacity;
  final bool showHighlightBorder;
  final double highlightBorderWidth;
  final Color? highlightBorderColor;
  final Color? selectedEventColor;

  const EventHighlightIndicator({
    super.key,
    required this.event,
    required this.groupColor,
    required this.child,
    this.opacity = 1.0,
    this.showHighlightBorder = true,
    this.highlightBorderWidth = 2.0,
    this.highlightBorderColor,
    this.selectedEventColor,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEventsService = VisibleEventsService.instance;
    final isTimeHighlighted = visibleEventsService.isEventHighlighted(
      context: context,
      event: event,
    );
    
    // Check if this event is the selected event
    final selectedEventProvider = Provider.of<SelectedEventProvider>(context, listen: false);
    final isSelectedEvent = selectedEventProvider.event?.id == event.id;

    // Determine the visual style based on highlighting state
    final isHighlighted = isTimeHighlighted || isSelectedEvent;
    final effectiveOpacity = isHighlighted ? 1.0 : opacity;
    
    // Choose border color and style based on highlighting type
    Color? borderColor;
    double borderWidth = highlightBorderWidth;
    
    if (isSelectedEvent) {
      // Selected event gets a distinct color (gold/yellow) and thicker border
      borderColor = selectedEventColor ?? const Color(0xFFFFD700); // Gold color
      borderWidth = highlightBorderWidth * 1.5; // Thicker border
    } else if (isTimeHighlighted) {
      // Time-based highlighting uses group color
      borderColor = highlightBorderColor ?? groupColor;
    }

    return Opacity(
      opacity: effectiveOpacity,
      child: Container(
        decoration: showHighlightBorder && isHighlighted
            ? BoxDecoration(
                border: Border.all(
                  color: borderColor!,
                  width: borderWidth,
                ),
                borderRadius: BorderRadius.circular(8),
                // Add a subtle background for selected events
                color: isSelectedEvent 
                    ? borderColor.withValues(alpha: 0.1) 
                    : null,
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
  final Color? selectedEventColor;

  const PulsingEventHighlight({
    super.key,
    required this.event,
    required this.groupColor,
    required this.child,
    this.opacity = 1.0,
    this.showHighlightBorder = true,
    this.highlightBorderWidth = 2.0,
    this.highlightBorderColor,
    this.selectedEventColor,
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
    final isTimeHighlighted = visibleEventsService.isEventHighlighted(
      context: context,
      event: widget.event,
    );
    
    // Check if this event is the selected event
    final selectedEventProvider = Provider.of<SelectedEventProvider>(context, listen: false);
    final isSelectedEvent = selectedEventProvider.event?.id == widget.event.id;

    // Determine the visual style based on highlighting state
    final isHighlighted = isTimeHighlighted || isSelectedEvent;
    final effectiveOpacity = isHighlighted ? 1.0 : widget.opacity;
    
    // Choose border color and style based on highlighting type
    Color? borderColor;
    double borderWidth = widget.highlightBorderWidth;
    
    if (isSelectedEvent) {
      // Selected event gets a distinct color (gold/yellow) and thicker border
      borderColor = widget.selectedEventColor ?? const Color(0xFFFFD700); // Gold color
      borderWidth = widget.highlightBorderWidth * 1.5; // Thicker border
    } else if (isTimeHighlighted) {
      // Time-based highlighting uses group color
      borderColor = widget.highlightBorderColor ?? widget.groupColor;
    }

    // Start/stop animation based on highlight state
    if (isHighlighted) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
      _animationController.reset();
    }

    return Opacity(
      opacity: effectiveOpacity,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isHighlighted ? _pulseAnimation.value : 1.0,
            child: Container(
              decoration: widget.showHighlightBorder && isHighlighted
                  ? BoxDecoration(
                      border: Border.all(
                        color: borderColor!,
                        width: borderWidth,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      // Add a subtle background for selected events
                      color: isSelectedEvent 
                          ? borderColor.withValues(alpha: 0.1) 
                          : null,
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
  final Color? selectedEventColor;

  const GlowingEventHighlight({
    super.key,
    required this.event,
    required this.groupColor,
    required this.child,
    this.opacity = 1.0,
    this.glowRadius = 10.0,
    this.glowColor,
    this.selectedEventColor,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEventsService = VisibleEventsService.instance;
    final isTimeHighlighted = visibleEventsService.isEventHighlighted(
      context: context,
      event: event,
    );
    
    // Check if this event is the selected event
    final selectedEventProvider = Provider.of<SelectedEventProvider>(context, listen: false);
    final isSelectedEvent = selectedEventProvider.event?.id == event.id;

    // Determine the visual style based on highlighting state
    final isHighlighted = isTimeHighlighted || isSelectedEvent;
    final effectiveOpacity = isHighlighted ? 1.0 : opacity;
    
    // Choose glow color based on highlighting type
    Color? effectiveGlowColor;
    
    if (isSelectedEvent) {
      // Selected event gets a distinct glow color (gold/yellow)
      effectiveGlowColor = selectedEventColor ?? const Color(0xFFFFD700);
    } else if (isTimeHighlighted) {
      // Time-based highlighting uses group color
      effectiveGlowColor = glowColor ?? groupColor;
    }

    return Opacity(
      opacity: effectiveOpacity,
      child: Container(
        decoration: isHighlighted
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: effectiveGlowColor!.withValues(alpha: 0.6),
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