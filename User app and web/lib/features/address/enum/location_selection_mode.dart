/// Enum representing the context in which SelectLocationScreen is opened
/// This determines the behavior when a location is selected
enum LocationSelectionMode {
  /// User is selecting a location from map to set as current location
  /// Selected location will be saved as the current location
  setCurrentLocation,
  
  /// User is selecting a location from map for other purposes (e.g., adding new address)
  /// Selected location will not be automatically saved as current location
  pickLocation,
}
