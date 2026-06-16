import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'title')
  final String title;
  
  @JsonKey(name: 'overview')
  final String overview;
  
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  
  @JsonKey(name: 'vote_count')
  final int voteCount;
  
  @JsonKey(name: 'popularity')
  final double popularity;
  
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;
  
  @JsonKey(name: 'adult')
  final bool adult;
  
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  
  @JsonKey(name: 'original_title')
  final String originalTitle;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  String get posterUrl => posterPath != null 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : 'https://via.placeholder.com/500x750?text=No+Image';
      
  String get backdropUrl => backdropPath != null 
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath' 
      : 'https://via.placeholder.com/1280x720?text=No+Image';
      
  String get releaseYear {
    if (releaseDate == null || releaseDate!.isEmpty) return 'Unknown';
    return releaseDate!.split('-')[0];
  }
  
  String get formattedRating => voteAverage.toStringAsFixed(1);
}

@JsonSerializable()
class MovieResponse {
  @JsonKey(name: 'results')
  final List<Movie> results;
  
  @JsonKey(name: 'page')
  final int page;
  
  @JsonKey(name: 'total_pages')
  final int totalPages;
  
  @JsonKey(name: 'total_results')
  final int totalResults;

  const MovieResponse({
    required this.results,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) => _$MovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}
