/// Model class to handle Facebook user data
class FacebookUserData {
  /// User's unique Facebook ID
  final String? id;

  /// User's name from Facebook profile
  final String? name;

  /// User's email address
  final String? email;

  FacebookUserData({
    this.id,
    this.name,
    this.email,
  });

  /// Create FacebookUserData from a Map (typically from getUserData response)
  factory FacebookUserData.fromMap(Map<dynamic, dynamic>? data) {
    if (data == null) {
      return FacebookUserData();
    }

    return FacebookUserData(
      id: data['id']?.toString(),
      name: data['name']?.toString(),
      email: data['email']?.toString(),
    );
  }

  /// Convert FacebookUserData to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  /// Check if user data is valid (has required fields)
  bool get isValid => id != null && id!.isNotEmpty;

  @override
  String toString() {
    return 'FacebookUserData(id: $id, name: $name, email: $email)';
  }
}