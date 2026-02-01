import 'package:flutter/material.dart';

/// Helper class for extracting and constructing human-readable addresses
/// from Google Geocoding API responses.
///
/// This helper provides methods to:
/// - Extract address components from geocoding results
/// - Build detailed addresses with street, locality, district, state, country
/// - Filter out low-quality addresses (unnamed roads, plus codes only, etc.)
class AddressHelper {
  /// Builds a detailed address by extracting and combining address components.
  /// 
  /// Constructs address in format: [Road], [Locality], [District], [State], [Country]
  /// Filters out "Unnamed Road" and prioritizes quality information.
  static String buildDetailedAddress(List<dynamic> results) {
    if (results.isEmpty) return '';

    // Try to build custom address from multiple results
    String? bestCustomAddress = _constructAddressFromComponents(results);
    if (bestCustomAddress != null && bestCustomAddress.isNotEmpty) {
      return bestCustomAddress;
    }

    // Fallback to formatted_address from best result
    for (var result in results) {
      final String formattedAddress = result['formatted_address']?.toString() ?? '';
      if (isGoodQualityAddress(formattedAddress)) {
        debugPrint('Using formatted address: $formattedAddress');
        return formattedAddress;
      }
    }

    // Last resort: use first result even if not ideal
    final String fallback = results[0]['formatted_address']?.toString() ?? '';
    debugPrint('Using fallback address: $fallback');
    return fallback;
  }

  /// Constructs a custom address by extracting specific components.
  /// 
  /// Component types by priority:
  /// - premise, street_number, route (Street info)
  /// - sublocality, locality (City/Area)
  /// - administrative_area_level_2 (District)
  /// - administrative_area_level_1 (State/Division)
  /// - country
  static String? _constructAddressFromComponents(List<dynamic> results) {
    // Collect all unique components from all results
    final Map<String, String> componentMap = {};
    
    for (var result in results) {
      final List<dynamic>? addressComponents = result['address_components'];
      if (addressComponents == null) continue;

      for (var component in addressComponents) {
        final String longName = component['long_name']?.toString() ?? '';
        final List<dynamic> types = component['types'] ?? [];
        
        if (longName.isEmpty) continue;

        // Extract components by type priority
        for (var type in types) {
          if (!componentMap.containsKey(type)) {
            componentMap[type] = longName;
          }
        }
      }
    }

    // Build address string with available components
    List<String> addressParts = [];

    // Street/Road information
    String? street = _buildStreetAddress(componentMap);
    if (street != null && street.isNotEmpty) {
      addressParts.add(street);
    }

    // Locality/Area (City, Neighborhood)
    if (componentMap.containsKey('sublocality_level_1')) {
      addressParts.add(componentMap['sublocality_level_1']!);
    } else if (componentMap.containsKey('sublocality')) {
      addressParts.add(componentMap['sublocality']!);
    } else if (componentMap.containsKey('locality')) {
      addressParts.add(componentMap['locality']!);
    }

    // District
    if (componentMap.containsKey('administrative_area_level_2')) {
      addressParts.add(componentMap['administrative_area_level_2']!);
    }

    // State/Division
    if (componentMap.containsKey('administrative_area_level_1')) {
      addressParts.add(componentMap['administrative_area_level_1']!);
    }

    // Country
    if (componentMap.containsKey('country')) {
      addressParts.add(componentMap['country']!);
    }

    // Remove duplicates while preserving order
    addressParts = addressParts.toSet().toList();

    if (addressParts.isEmpty) {
      return null;
    }

    final String constructedAddress = addressParts.join(', ');
    debugPrint('Constructed custom address: $constructedAddress');
    debugPrint('Components used: ${componentMap.keys.join(", ")}');
    
    return constructedAddress;
  }

  /// Builds street address from components, filtering out "Unnamed Road"
  static String? _buildStreetAddress(Map<String, String> components) {
    final List<String> streetParts = [];

    // Add street number if available
    if (components.containsKey('street_number')) {
      streetParts.add(components['street_number']!);
    }

    // Add premise (building/house name) if available
    if (components.containsKey('premise')) {
      streetParts.add(components['premise']!);
    }

    // Add route (street name) - but filter out "Unnamed Road"
    if (components.containsKey('route')) {
      final String route = components['route']!;
      // Skip if it's an unnamed or generic road
      if (!isUnnamedOrGenericRoad(route)) {
        streetParts.add(route);
      }
    }

    // Add neighborhood as alternative to route
    if (streetParts.isEmpty && components.containsKey('neighborhood')) {
      streetParts.add(components['neighborhood']!);
    }

    return streetParts.isNotEmpty ? streetParts.join(' ') : null;
  }

  /// Checks if a road name is unnamed or too generic
  static bool isUnnamedOrGenericRoad(String roadName) {
    final String lower = roadName.toLowerCase();
    
    // Common unnamed road patterns
    final List<String> unnamedPatterns = [
      'unnamed',
      'unnamed road',
      'unnamed street',
      'unnamed way',
      'road',  // Just "Road" alone
      'street', // Just "Street" alone
      'রাস্তা', // Bengali for "road"
      'nambihin rasta', // Bengali transliteration for "unnamed road"
      'nambiheen rasta', // Alternative transliteration
      'Nambihin', // Alternative transliteration
      'নামবিহীন রাস্তা', // Bengali script for "unnamed road"
    ];

    return unnamedPatterns.any((pattern) => lower == pattern || lower.contains('unnamed') || lower.contains('nambihin'));
  }

  /// Checks if an address is of good quality
  static bool isGoodQualityAddress(String address) {
    if (address.isEmpty || address.length < 5) return false;

    // Filter out addresses with unnamed roads
    if (isUnnamedOrGenericRoad(address)) return false;

    // Filter out addresses that are only plus codes
    final RegExp plusCodePattern = RegExp(r'^[A-Z0-9]{4}\+[A-Z0-9]{2,3}\s');
    if (plusCodePattern.hasMatch(address) && address.split(',').length <= 2) {
      return false;
    }

    return true;
  }
}
