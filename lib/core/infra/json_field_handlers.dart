// The reson we need this function is because some json field could be null, but
// we want to keep our DTO fields non-nullable. So this function checks if the
// field is null, return empty string if yes.
String nullableJsonString(Object? field) {
  return (field as String?) ?? '';
}
