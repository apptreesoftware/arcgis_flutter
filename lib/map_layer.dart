class MapLayer {
  final String name;
  final String url;
  final bool visibleByDefault;

  MapLayer(this.name, this.url, this.visibleByDefault);

  factory MapLayer.fromJson(Map<String, dynamic> json) {
    return new MapLayer(
      json['name'] as String,
      json['url'] as String,
      json['visible_by_default'] as bool,
    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'url': url,
        'visible_by_default': visibleByDefault,
      };
}
