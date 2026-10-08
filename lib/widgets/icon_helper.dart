import 'package:flutter/material.dart';

IconData getDisasterIcon(String name) {
  switch (name) {
    case 'landscape_rounded':
      return Icons.landscape_rounded;
    case 'local_fire_department_rounded':
      return Icons.local_fire_department_rounded;
    case 'water_rounded':
      return Icons.water_rounded;
    case 'tsunami_rounded':
      return Icons.waves_rounded;
    case 'backpack_rounded':
      return Icons.backpack_rounded;
    case 'support_agent_rounded':
      return Icons.support_agent_rounded;
    case 'medical_services_rounded':
      return Icons.medical_services_rounded;
    case 'local_police_rounded':
      return Icons.local_police_rounded;
    case 'health_and_safety_rounded':
      return Icons.health_and_safety_rounded;
    case 'search_rounded':
      return Icons.search_rounded;
    default:
      return Icons.warning_amber_rounded;
  }
}
