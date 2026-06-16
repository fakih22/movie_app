import 'package:json_annotation/json_annotation.dart';

part 'tv_series.g.dart';

@JsonSerializable()
class TvSeries {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'name')
  final String name;
  
  @JsonKey(name: 'overview')
  final String overview;
  
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;
  
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  
  @JsonKey(name: 'vote_count')
  final int voteCount;
  
  @JsonKey(name: 'popularity')
  final double popularity;
  
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;
  
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  
  @JsonKey(name: 'original_name')
  final String originalName;

  const TvSeries({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.genreIds,
    required this.originalLanguage,
    required this.originalName,
  });

  factory TvSeries.fromJson(Map<String, dynamic> json) => _$TvSeriesFromJson(json);
  Map<String, dynamic> toJson() => _$TvSeriesToJson(this);

  String get posterUrl => posterPath != null 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : 'https://via.placeholder.com/500x750?text=No+Image';
      
  String get backdropUrl => backdropPath != null 
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath' 
      : 'https://via.placeholder.com/1280x720?text=No+Image';
      
  String get firstAirYear {
    if (firstAirDate == null || firstAirDate!.isEmpty) return 'Unknown';
    return firstAirDate!.split('-')[0];
  }
  
  String get formattedRating => voteAverage.toStringAsFixed(1);
}

@JsonSerializable()
class TvSeriesResponse {
  @JsonKey(name: 'results')
  final List<TvSeries> results;
  
  @JsonKey(name: 'page')
  final int page;
  
  @JsonKey(name: 'total_pages')
  final int totalPages;
  
  @JsonKey(name: 'total_results')
  final int totalResults;

  const TvSeriesResponse({
    required this.results,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory TvSeriesResponse.fromJson(Map<String, dynamic> json) => _$TvSeriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TvSeriesResponseToJson(this);
}
