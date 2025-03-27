import 'package:equatable/equatable.dart';

class LocationTypeEntity extends Equatable {
  final int? id;
  final String locationType; // Lokasi yang sudah ditentukan sebelumnya

  const LocationTypeEntity({
    this.id,
    required this.locationType,
  });

  @override
  List<Object?> get props => [id, locationType];

  LocationTypeEntity copyWith({
    int? id,
    String? locationType,
  }) {
    return LocationTypeEntity(
      id: id ?? this.id,
      locationType: locationType ?? this.locationType,
    );
  }
}
