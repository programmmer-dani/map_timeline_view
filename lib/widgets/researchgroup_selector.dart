import 'package:flutter/material.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';

class ResearchGroupSelectorGrid extends StatelessWidget {
  const ResearchGroupSelectorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<ResearchGroupsProvider>().groups;

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blueGrey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select research groups',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3.5, 
              ),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return GestureDetector(
                  onTap: () {
                    final groupProvider =
                        context.read<ResearchGroupsProvider>();
                    final markerProvider = context.read<MapMarkerProvider>();

                    groupProvider.toggleGroupSelection(group.id);
                    markerProvider.recalculateMarkers(context);
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          group.isSelected
                              ? Colors.blueAccent.withOpacity(0.7)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            group.isSelected
                                ? Colors.blueAccent
                                : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow:
                          group.isSelected
                              ? [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : [],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      group.name,
                      style: TextStyle(
                        color: group.isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
