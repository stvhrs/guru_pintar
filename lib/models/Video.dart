class Video {
  final String? ytId;
  final String? namaVideo;
  final String? linkVideo;

  Video(this.ytId, this.namaVideo, this.linkVideo);
  factory Video.fromMap(Map<String, dynamic> data) {
    return Video(
        (data["ytid"] == null) ? (data["ytidDmp"]) : (data["ytid"]),
        (data["namaSubMateri"] == null)
            ? data["namaVideoDmp"]
            : data["namaSubMateri"],
        (data["linkVideo"] == null) ? data["linkDmp"] : "https://www.youtube.com/watch?v=${data["ytid"]}");
  }
}
