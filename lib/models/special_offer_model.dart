class SpecialOfferModel {
  int? id;
  String? productName;
  String? imageUrl;
  int? price;
  int? offPrice;
  int? offPrecent;

  SpecialOfferModel({
    this.id,
    this.imageUrl,
    this.productName,
    this.offPrecent,
    this.offPrice,
    this.price,
  });
}
