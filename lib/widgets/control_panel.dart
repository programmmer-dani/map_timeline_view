import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:map_timeline_view/providers/search_provider.dart';
import 'package:map_timeline_view/widgets/add_event_widget.dart';
import 'package:map_timeline_view/widgets/controlpanel_slider.dart';
import 'package:map_timeline_view/widgets/notifications.dart';
import 'package:map_timeline_view/widgets/researchgroup_selector.dart';
import 'package:map_timeline_view/widgets/search_suggestions.dart';
import 'package:provider/provider.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  late DateTime _selectedTime;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedTime = DateTime.now();
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _handleTimeChanged(DateTime newTime) {
    setState(() {
      _selectedTime = newTime;
      final markerProvider = Provider.of<MapMarkerProvider>(
        context,
        listen: false,
      );
      markerProvider.recalculateMarkers(context);
    });
  }

  void _showGroupSelectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final media = MediaQuery.of(context).size;
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: media.width * 0.9,
            height: media.height * 0.7,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: ResearchGroupSelectorGrid(),
            ),
          ),
        );
      },
    );
  }

  void _onEventSelected(Event event) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.selectEvent(event, context);
    _removeOverlay();
  }

  void _showOverlay(List<Event> suggestions) {
    _removeOverlay();

    if (suggestions.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: widget.isMobile ? 160 : 200,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 40),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: SearchSuggestions(
                  suggestions: suggestions,
                  onEventSelected: _onEventSelected,
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = widget.isMobile;
    final double spacing = isMobile ? 4.0 : 8.0;
    final double fontSize = isMobile ? 13.0 : 16.0;
    final double iconSize = isMobile ? 18.0 : 22.0;
    final double panelHeight = isMobile ? 70 : 72;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.blueGrey.shade900,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: SizedBox(
            height: panelHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  child: SizedBox(
                    width: isMobile ? 160 : 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<SearchProvider>(
                          builder: (context, searchProvider, child) {
                            if (searchProvider.isSearching &&
                                searchProvider.suggestions.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _showOverlay(searchProvider.suggestions);
                              });
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _removeOverlay();
                              });
                            }

                            return CompositedTransformTarget(
                              link: _layerLink,
                              child: SizedBox(
                                height: isMobile ? 28 : 32,
                                child: TextField(
                                  controller: searchProvider.searchController,
                                  style: TextStyle(fontSize: fontSize),
                                  decoration: InputDecoration(
                                    hintText: 'Search events...',
                                    hintStyle: TextStyle(fontSize: fontSize),
                                    filled: true,
                                    fillColor: Colors.white,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon:
                                        searchProvider.isSearching
                                            ? IconButton(
                                              icon: const Icon(
                                                Icons.clear,
                                                size: 16,
                                              ),
                                              onPressed: () {
                                                searchProvider.clearSearch();
                                                _removeOverlay();
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                            )
                                            : null,
                                  ),
                                  onChanged: searchProvider.updateSearchQuery,
                                  onTap: () {
                                    if (searchProvider.isSearching &&
                                        searchProvider.suggestions.isNotEmpty) {
                                      _showOverlay(searchProvider.suggestions);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: spacing / 2),
                        SizedBox(
                          height: isMobile ? 26 : 28,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: iconSize,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const AddEventScreen(),
                                    ),
                                  );
                                },
                              ),
                              if (isMobile)
                                Padding(
                                  padding: EdgeInsets.only(left: spacing),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.filter_alt,
                                      color: Colors.white,
                                      size: iconSize,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed:
                                        () => _showGroupSelectorDialog(context),
                                  ),
                                ),
                              if (isMobile)
                                Padding(
                                  padding: EdgeInsets.only(left: spacing),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: iconSize,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const NotificationCenterWidget(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isMobile ? 16 : 24),
                    child: TimeSlider(onChanged: _handleTimeChanged),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
