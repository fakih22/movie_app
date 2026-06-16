import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'media_type')
  final String mediaType;
  
  @JsonKey(name: 'title')
  final String? title;
  
  @JsonKey(name: 'name')
  final String? name;
  
  @JsonKey(name: 'overview')
  final String overview;
  
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;
  
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  
  @JsonKey(name: 'popularity')
  final double popularity;

  const SearchResult({
    required this.id,
    required this.mediaType,
    this.title,
    this.name,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.firstAirDate,
    required this.voteAverage,
    required this.popularity,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

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
}

@JsonSerializable()
class SearchResultResponse {
  @JsonKey(name: 'results')
  final List<SearchResult> results;
  
  @JsonKey(name: 'page')
  final int page;
  
  @JsonKey(name: 'total_pages')
  final int totalPages;
  
  @JsonKey(name: 'total_results')
  final int totalResults;

  const SearchResultResponse({
    required this.results,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) => _$SearchResultResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultResponseToJson(this);
}
