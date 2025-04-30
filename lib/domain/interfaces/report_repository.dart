import 'package:dartz/dartz.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/domain/entities/consumption_log.dart';

abstract class ReportRepository {
  /// Generate material consumption report
  Future<Either<Failure, List<ConsumptionLog>>> generateConsumptionReport({
    DateTime? startDate,
    DateTime? endDate,
    String? materialId,
    String? userId,
    String? productId,
  });
  
  /// Generate inventory value report
  Future<Either<Failure, Map<String, dynamic>>> generateInventoryValueReport();
  
  /// Generate cost analysis report
  Future<Either<Failure, Map<String, dynamic>>> generateCostAnalysisReport({
    DateTime? startDate,
    DateTime? endDate,
    String? productId,
  });
  
  /// Generate low stock report
  Future<Either<Failure, List<Map<String, dynamic>>>> generateLowStockReport();
  
  /// Generate consumption trends report
  Future<Either<Failure, Map<String, dynamic>>> generateConsumptionTrendsReport({
    required String materialId,
    required DateTime startDate,
    required DateTime endDate,
    String? groupBy, // 'day', 'week', 'month'
  });
  
  /// Export report to PDF
  Future<Either<Failure, String>> exportReportToPdf(
    String reportType,
    Map<String, dynamic> reportData,
  );
  
  /// Export report to CSV
  Future<Either<Failure, String>> exportReportToCsv(
    String reportType,
    Map<String, dynamic> reportData,
  );
  
  /// Get user activity report
  Future<Either<Failure, Map<String, dynamic>>> getUserActivityReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
} 