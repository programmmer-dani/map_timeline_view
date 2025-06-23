import 'package:flutter/material.dart';

class EventType {
  final String name;
  final IconData icon;

  const EventType._(this.name, this.icon);

  static const EventType earthquake = EventType._('Earthquake', Icons.warning);
  static const EventType flood = EventType._('Flood', Icons.water);
  static const EventType fire = EventType._('Fire', Icons.local_fire_department);
  static const EventType storm = EventType._('Storm', Icons.cloud);

  static const List<EventType> values = [earthquake, flood, fire, storm];

  @override
  String toString() => name;
}
