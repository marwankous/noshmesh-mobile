import 'dart:convert';

/// Utility class for JWT operations
class JwtUtils {
  /// Decodes the payload of a JWT token
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      return json.decode(resp) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Checks if a token is expired. 
  /// [threshold] is the number of seconds before actual expiration to consider it expired.
  static bool isExpired(String token, {int threshold = 30}) {
    final payload = decodePayload(token);
    if (payload == null) return true;

    if (!payload.containsKey('exp')) return false; // Assume not expired if no exp claim

    final exp = payload['exp'] as int;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    return (exp - now) < threshold;
  }

  /// Gets the expiration date from a token
  static DateTime? getExpirationDate(String token) {
    final payload = decodePayload(token);
    if (payload == null || !payload.containsKey('exp')) return null;

    final exp = payload['exp'] as int;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }
}
