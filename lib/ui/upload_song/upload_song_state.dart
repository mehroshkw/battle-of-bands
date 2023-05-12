import 'package:equatable/equatable.dart';

class UploadSongState extends Equatable {
  final bool isShowTrim;

  const UploadSongState({
    required this.isShowTrim,
  });

  const UploadSongState.initial()
      : this(
    isShowTrim: false,
  );

  UploadSongState copyWith({
    bool? isShowTrim}) => UploadSongState(isShowTrim: isShowTrim ?? this.isShowTrim);

  @override
  // TODO: implement props
  List<Object?> get props => [isShowTrim];
}
