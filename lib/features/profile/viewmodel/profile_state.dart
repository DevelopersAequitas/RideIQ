class ProfileState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic>? userData;

  const ProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.userData,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? userData,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }

  String get fullName {
    if (userData == null) return "User Name";
    final name = userData!['name']?.toString() ?? "";
    if (name.isNotEmpty) return name;
    
    final fName = userData!['first_name']?.toString() ?? "";
    final lName = userData!['last_name']?.toString() ?? "";
    if (fName.isEmpty && lName.isEmpty) return "User Name";
    return "$fName $lName".trim();
  }

  String get initials {
    if (userData == null) return "U";
    
    // Prioritize generating initials from the combined 'name' field
    final name = userData!['name']?.toString() ?? "";
    if (name.isNotEmpty) {
      final parts = name.trim().split(' ');
      if (parts.length > 1) {
        return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
      }
      return name[0].toUpperCase();
    }

    final fName = userData!['first_name']?.toString() ?? "";
    final lName = userData!['last_name']?.toString() ?? "";
    
    if (fName.isNotEmpty || lName.isNotEmpty) {
      String res = "";
      if (fName.isNotEmpty) res += fName[0];
      if (lName.isNotEmpty) res += lName[0];
      return res.toUpperCase();
    }
    
    return "U";
  }

  String get email => userData?['email']?.toString() ?? "user@email.com";
  String get phone => userData?['phone']?.toString() ?? "+1 000-0000";
}
