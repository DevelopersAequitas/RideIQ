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
      errorMessage: errorMessage, // We want to clear error message if null is passed
      userData: userData ?? this.userData,
    );
  }

  String get fullName {
    if (userData == null) return "User Name";
    return "${userData!['first_name'] ?? ''} ${userData!['last_name'] ?? ''}".trim();
  }

  String get initials {
    if (userData == null) return "U";
    final first = userData!['first_name']?.toString().trim() ?? "";
    final last = userData!['last_name']?.toString().trim() ?? "";
    String result = "";
    if (first.isNotEmpty) result += first[0];
    if (last.isNotEmpty) result += last[0];
    return result.isEmpty ? "U" : result.toUpperCase();
  }

  String get email {
    if (userData == null) return "user@email.com";
    return userData!['email'] ?? "user@email.com";
  }

  String get phone {
    if (userData == null) return "+1 000-0000";
    return userData!['phone'] ?? "+1 000-0000";
  }
}
