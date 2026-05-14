/// Helper for unwrapping JSON API structures.
///
/// Handles several response shapes:
///   1. Standard JSON API:        { "data": { "attributes": { ... } } }
///   2. Nested entity key:        { "data": { "user": { "attributes": { ... } } } }
///   3. Flat attributes wrapper:  { "attributes": { ... } }
///   4. Plain flat JSON:          { "id": 1, "name": "..." }
///
/// In all cases [extractAttributes] returns a non-null [Map<String, dynamic>]
/// that can be accessed directly for field values. When [data] or [attributes]
/// are absent the raw (or partially-unwrapped) map is returned as the fallback,
/// preserving the existing behaviour of every DTO.
class JsonApiParser {
  const JsonApiParser._();

  /// Extracts the attributes map from a JSON API response.
  ///
  /// [json]        – The raw decoded JSON object.
  /// [entityKey]   – Optional nested key inside `data` (e.g. `'user'`).
  ///                 When provided the lookup path is `data -> entityKey -> attributes`.
  ///                 When omitted the lookup path is `data -> attributes`.
  ///
  /// Fallback chain:
  ///   1. `json['data'][entityKey]['attributes']`  (when entityKey given)
  ///   2. `json['data']['attributes']`             (when no entityKey)
  ///   3. `json['attributes']`
  ///   4. `json`                                   (plain flat JSON)
  static Map<String, dynamic> extractAttributes(
    Map<String, dynamic> json, {
    String? entityKey,
  }) {
    // Step 1: drill into `data`, optionally through an entity key.
    final dataRaw = json['data'];
    if (dataRaw is Map<String, dynamic>) {
      Map<String, dynamic> dataNode = dataRaw;

      if (entityKey != null) {
        final entityRaw = dataNode[entityKey];
        if (entityRaw is Map<String, dynamic>) {
          dataNode = entityRaw;
        }
        // If entityKey not found, fall through with dataNode as-is.
      }

      final attrsRaw = dataNode['attributes'];
      if (attrsRaw is Map<String, dynamic>) {
        return attrsRaw;
      }

      // data present but no attributes – use the data node itself.
      return dataNode;
    }

    // Step 2: no `data` key – check for top-level `attributes`.
    final topAttrsRaw = json['attributes'];
    if (topAttrsRaw is Map<String, dynamic>) {
      return topAttrsRaw;
    }

    // Step 3: plain flat JSON.
    return json;
  }
}
