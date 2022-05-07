import 'package:freezed_annotation/freezed_annotation.dart';

part 'fresh.freezed.dart';

@freezed
class Fresh<T> with _$Fresh<T> {
  const Fresh._();
  const factory Fresh({
    required T entity,
    required bool isFresh,
    bool? more,
  }) = _Fresh<T>;

  factory Fresh.yes(
    T entity, {
    bool? more,
  }) =>
      Fresh(
        entity: entity,
        isFresh: true,
        more: more,
      );

  factory Fresh.no(
    T entity, {
    bool? more,
  }) =>
      Fresh(
        entity: entity,
        isFresh: false,
        more: more,
      );
}
