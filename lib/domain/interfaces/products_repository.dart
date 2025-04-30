import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/product_model.dart';
import 'package:dartz/dartz.dart';

abstract class ProductsRepository {
  /// Get all products
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  
  /// Get products by category
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(String category);
  
  /// Get product by ID
  Future<Either<Failure, ProductModel>> getProductById(String id);
  
  /// Get product by barcode
  Future<Either<Failure, ProductModel>> getProductByBarcode(String barcode);
  
  /// Get product by QR code
  Future<Either<Failure, ProductModel>> getProductByQRCode(String qrCode);
  
  /// Add new product
  Future<Either<Failure, ProductModel>> addProduct(ProductModel product);
  
  /// Update product
  Future<Either<Failure, ProductModel>> updateProduct(ProductModel product);
  
  /// Delete product
  Future<Either<Failure, void>> deleteProduct(String id);
  
  /// Calculate product cost
  Future<Either<Failure, double>> calculateProductCost(
    List<ProductMaterial> materials,
    List<ProductProcess> processes,
  );
  
  /// Calculate suggested price
  Future<Either<Failure, double>> calculateSuggestedPrice(
    double totalCost,
    double profitMargin,
  );
  
  /// Get product categories
  Future<Either<Failure, List<String>>> getProductCategories();
  
  /// Generate QR code for product
  Future<Either<Failure, String>> generateProductQRCode(String productId);
  
  /// Generate barcode for product
  Future<Either<Failure, String>> generateProductBarcode(String productId);
} 