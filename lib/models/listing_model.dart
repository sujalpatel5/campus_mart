import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String condition;
  final String imageUrl;
  final String sellerId;
  final DateTime createdAt;
  final String status;

  ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.imageUrl,
    required this.sellerId,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'condition': condition,
      'imageUrl': imageUrl,
      'sellerId': sellerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  factory ListingModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return ListingModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      condition: map['condition'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      sellerId: map['sellerId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
    );
  }
}