// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvSeries _$TvSeriesFromJson(Map<String, dynamic> json) => TvSeries(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: (json['vote_count'] as num).toInt(),
      popularity: (json['popularity'] as num).toDouble(),
      genreIds: (json['genre_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      originalLanguage: json['original_language'] as String,
      originalName: json['original_name'] as String,
    );

Map<String, dynamic> _$TvSeriesToJson(TvSeries instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'first_air_date': instance.firstAirDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'popularity': instance.popularity,
      'genre_ids': instance.genreIds,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
    };

TvSeriesResponse _$TvSeriesResponseFromJson(Map<String, dynamic> json) =>
    TvSeriesResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => TvSeries.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$TvSeriesResponseToJson(TvSeriesResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
