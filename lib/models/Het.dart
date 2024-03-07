class Het {
  final String namaBuku;
  final String imgUrl;
final String pdf;
  Het(this.namaBuku, this.imgUrl,this.pdf);
  factory Het.fromMap(Map<String, dynamic> data) {
    return Het(data["judul"], data["cover"],data["pdf"]);
  }
}
