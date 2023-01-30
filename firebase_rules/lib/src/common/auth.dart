/// Identity providers
enum RulesIdentityProvider {
  /// email
  email,

  /// phone
  phone,

  /// google.com
  google,

  /// facebook.com
  facebook,

  /// github.com
  github,

  /// twitter.com
  twitter;

  /// The string representation of the identity provider
  @override
  String toString() {
    switch (this) {
      case RulesIdentityProvider.email:
        return 'email';
      case RulesIdentityProvider.phone:
        return 'phone';
      case RulesIdentityProvider.google:
        return 'google.com';
      case RulesIdentityProvider.facebook:
        return 'facebook.com';
      case RulesIdentityProvider.github:
        return 'github.com';
      case RulesIdentityProvider.twitter:
        return 'twitter.com';
    }
  }
}

/// Sign in providers
enum RulesSignInProvider {
  /// custom
  custom,

  /// password
  password,

  /// phone
  phone,

  /// anonymous
  anonymous,

  /// google.com
  google,

  /// facebook.com
  facebook,

  /// github.com
  github,

  /// twitter.com
  twitter;

  /// The string representation of the sign in provider
  @override
  String toString() {
    switch (this) {
      case RulesSignInProvider.custom:
        return 'custom';
      case RulesSignInProvider.password:
        return 'password';
      case RulesSignInProvider.phone:
        return 'phone';
      case RulesSignInProvider.anonymous:
        return 'anonymous';
      case RulesSignInProvider.google:
        return 'google.com';
      case RulesSignInProvider.facebook:
        return 'facebook.com';
      case RulesSignInProvider.github:
        return 'github.com';
      case RulesSignInProvider.twitter:
        return 'twitter.com';
    }
  }
}
