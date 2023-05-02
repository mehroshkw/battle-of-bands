enum MediaType { NONE, IMAGE, VIDEO, AUDIO, LOCATION, DOCUMENT}

extension StringExtension on String {
  String get removeExceptionTextIfContains {
    if (contains('Exception:')) return replaceFirst('Exception:', '');
    return this;
  }
}

extension MediaTypeExtension on MediaType {
  String get name {
    switch (this) {
      case MediaType.IMAGE:
        return 'IMAGE';
      case MediaType.AUDIO:
        return 'AUDIO';
      case MediaType.VIDEO:
        return 'VIDEO';
      case MediaType.LOCATION:
        return 'LOCATION';
        case MediaType.DOCUMENT:
        return 'DOCUMENT';
      default:
        'NONE';
    }
    return 'NONE';
  }
}

extension MediaTypeNameExtension on String {
  MediaType get mediaType {
    switch (toUpperCase()) {
      case 'IMAGE':
        return MediaType.IMAGE;
      case 'AUDIO':
        return MediaType.AUDIO;
      case 'VIDEO':
        return MediaType.VIDEO;
      case 'LOCATION':
        return MediaType.LOCATION;
        case 'DOCUMENT':
        return MediaType.DOCUMENT;
      default:
        return MediaType.NONE;
    }
  }
}
