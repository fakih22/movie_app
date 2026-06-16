import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorite_item.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class FavoriteItem extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;
  
  @HiveField(1)
  @JsonKey(name: 'media_type')
  final String mediaType; // 'movie' or 'tv'
  
  @HiveField(2)
  @JsonKey(name: 'title')
  final String? title;
  
  @HiveField(3)
  @JsonKey(name: 'name')
  final String? name;
  
  @HiveField(4)
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  
  @HiveField(5)
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  
  @HiveField(6)
  @JsonKey(name: 'overview')
  final String overview;
  
  @HiveField(7)
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  
  @HiveField(8)
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  
  @HiveField(9)
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;
  
  @HiveField(10)
  @JsonKey(name: 'added_at')
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.mediaType,
    this.title,
    this.name,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.voteAverage,
    this.releaseDate,
    this.firstAirDate,
    required this.addedAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => _$FavoriteItemFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteItemToJson(this);

  factory FavoriteItem.fromMovie(dynamic movie, DateTime addedAt) {
    return FavoriteItem(
      id: movie.id,
      mediaType: 'movie',
      title: movie.title,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      overview: movie.overview,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      addedAt: addedAt,
    );
  }

  factory FavoriteItem.fromTvSeries(dynamic tvSeries, DateTime addedAt) {
    return FavoriteItem(
      id: tvSeries.id,
      mediaType: 'tv',
      name: tvSeries.name,
      posterPath: tvSeries.posterPath,
      backdropPath: tvSeries.backdropPath,
      overview: tvSeries.overview,
      voteAverage: tvSeries.voteAverage,
      firstAirDate: tvSeries.firstAirDate,
      addedAt: addedAt,
    );
  }

  String get displayTitle => title ?? name ?? 'Unknown';
  
  String get posterUrl => posterPath != null 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : 'https://via.placeholder.com/500x750?text=No+Image';
      
  String get backdropUrl => backdropPath != null 
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath' 
      : 'https://via.placeholder.com/1280x720?text=No+Image';
      
  String get year {
    if (mediaType == 'movie' && releaseDate != null && releaseDate!.isNotEmpty) {
      return releaseDate!.split('-')[0];
    } else if (mediaType == 'tv' && firstAirDate != null && firstAirDate!.isNotEmpty) {
      return firstAirDate!.split('-')[0];
    }
    return 'Unknown';
  }
  
  String get formattedRating => voteAverage.toStringAsFixed(1);
  
  String get formattedDate {
    return '${addedAt.day.toString().padLeft(2, '0')}/${addedAt.month.toString().padLeft(2, '0')}/${addedAt.year}';
  }
}
