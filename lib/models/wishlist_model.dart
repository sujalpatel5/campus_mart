class WishlistModel {
  final String id;
  final String userId;
  final String listingId;
  final DateTime createdAt;

  WishlistModel({
    required this.id,
    required this.userId,
    required this.listingId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'listingId': listingId,
      'createdAt': createdAt,
    };
  }

  factory WishlistModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return WishlistModel(
      id: id,
      userId: map['userId'] ?? '',
      listingId: map['listingId'] ?? '',
      createdAt: map['createdAt'].toDate(),
    );
  }
}