import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/entities/user.dart';
import 'package:map_timeline_view/entities/research_group.dart';
import 'package:map_timeline_view/providers/event_provider.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dataController = TextEditingController();
  final _latController = TextEditingController(text: '51.9225');
  final _lonController = TextEditingController(text: '4.47917');
  DateTime? _start;
  DateTime? _end;
  EventType _selectedType = EventType.values.first;
  ResearchGroup? _selectedGroup;
  final User _dummyUser = User(id: 'temp-user', name: 'Temp User');

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _start != null &&
        _end != null &&
        _selectedGroup != null) {
      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        author: _dummyUser,
        start: _start!,
        end: _end!,
        data: _dataController.text,
        latitude: double.tryParse(_latController.text) ?? 0.0,
        longitude: double.tryParse(_lonController.text) ?? 0.0,
        type: _selectedType,
      );

      final eventProvider = context.read<EventsProvider>();
      eventProvider.addEvent(event);
      eventProvider.loadMockData(context.read<ResearchGroupsProvider>());
      context.read<ResearchGroupsProvider>().addEventToGroup(
        _selectedGroup!.id,
        event,
      );

      context.read<MapMarkerProvider>().recalculateMarkers(context);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Event added')));
    }
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final fullDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isStart) {
        _start = fullDate;
      } else {
        _end = fullDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<ResearchGroupsProvider>().groups;

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _latController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _lonController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<EventType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Event Type'),
                items:
                    EventType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              DropdownButtonFormField<ResearchGroup>(
                value: groups.contains(_selectedGroup) ? _selectedGroup : null,
                decoration: const InputDecoration(labelText: 'Research Group'),
                items:
                    groups.map((group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(group.name),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedGroup = val!),
                validator: (val) => val == null ? 'Select a group' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickDateTime(isStart: true),
                    child: Text(
                      _start == null
                          ? 'Select Start'
                          : 'Start: ${_start!.toLocal()}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _pickDateTime(isStart: false),
                    child: Text(
                      _end == null ? 'Select End' : 'End: ${_end!.toLocal()}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
