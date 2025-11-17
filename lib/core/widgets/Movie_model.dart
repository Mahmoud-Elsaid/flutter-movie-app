import 'package:hive/hive.dart';

part 'Movie_model.g.dart';
@HiveType(typeId: 1)
class MovieModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? posterPath;
  @HiveField(3)
  final double? voteAverage;
  @HiveField(4)
  final String? releaseDate;

  MovieModel({
    this.id,
    this.title,
    this.posterPath,
    this.voteAverage,
    this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json['id'],
        title: json['title'],
        posterPath: json['poster_path'],
        voteAverage: (json['vote_average'] as num?)?.toDouble(),
        releaseDate: json['release_date'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'poster_path': posterPath,
        'vote_average': voteAverage,
        'release_date': releaseDate,
      };
}
