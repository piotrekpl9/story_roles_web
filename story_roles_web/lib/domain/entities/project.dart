import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final int id;
  final String name;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  Project copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt];
}
