import 'package:dartz/dartz.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/domain/entities/product.dart';

abstract class ProductRepository {
  /// Get all products
  Future<Either<Failure, List<Product>>> getAllProducts();
  
  /// Get product by ID
  Future<Either<Failure, Product>> getProductById(String id);
  
  /// Add new product
  Future<Either<Failure, Product>> addProduct(Product product);
  
  /// Update product
  Future<Either<Failure, Product>> updateProduct(Product product);
  
  /// Delete product
  Future<Either<Failure, bool>> deleteProduct(String id);
  
  /// Calculate product cost
  Future<Either<Failure, double>> calculateProductCost(String productId);
  
  /// Get products that use a specific material
  Future<Either<Failure, List<Product>>> getProductsByMaterial(String materialId);
  
  /// Generate QR code for a product
  Future<Either<Failure, String>> generateProductQRCode(String productId);
  
  /// Get product production history
  Future<Either<Failure, List<Map<String, dynamic>>>> getProductionHistory(
    String productId, 
    {
      DateTime? startDate,
      DateTime? endDate,
    }
  );
} 