import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/material_model.dart';
import 'package:smart_tracking_app/presentation/bloc/auth/auth_provider.dart';
import 'package:smart_tracking_app/presentation/bloc/materials/materials_provider.dart';
import 'package:smart_tracking_app/presentation/widgets/custom_button.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasPermission = false;
  bool _isScanning = true;
  String? _scanError;
  MaterialModel? _scannedMaterial;
  bool _isLoggingConsumption = false;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isFlashOn = false;
  bool _isQuantityValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _hasPermission = status.isGranted;
    });

    if (!status.isGranted) {
      await _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isNotEmpty) {
      _isScanning = false;
      final barcode = barcodes.first;
      
      if (barcode.rawValue == null) {
        setState(() {
          _scanError = 'Failed to read barcode/QR code';
        });
        return;
      }
      
      _processCode(barcode.rawValue!);
    }
  }

  Future<void> _processCode(String code) async {
    // Try to get material by barcode or QR code
    final materialsProvider = Provider.of<MaterialsProvider>(context, listen: false);
    
    try {
      // First try to get by QR code (might contain more data)
      await materialsProvider.getMaterialByQRCode(code);
      setState(() {
        _scannedMaterial = materialsProvider.selectedMaterial;
        _scanError = materialsProvider.errorMessage;
        _isScanning = false;
      });
      
      if (_scannedMaterial == null) {
        // If not found by QR code, try by barcode
        await materialsProvider.getMaterialByBarcode(code);
        setState(() {
          _scannedMaterial = materialsProvider.selectedMaterial;
          _scanError = materialsProvider.errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _scanError = 'Error processing code: ${e.toString()}';
      });
    }
  }

  void _resetScan() {
    setState(() {
      _isScanning = true;
      _scanError = null;
      _scannedMaterial = null;
      _quantityController.clear();
      _notesController.clear();
      _isQuantityValid = false;
    });
  }

  Future<void> _logConsumption() async {
    if (_scannedMaterial == null) return;
    
    setState(() {
      _isLoggingConsumption = true;
    });
    
    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      setState(() {
        _scanError = 'Please enter a valid quantity';
        _isLoggingConsumption = false;
      });
      return;
    }
    
    final materialsProvider = Provider.of<MaterialsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.user == null) {
      setState(() {
        _scanError = 'User information not available';
        _isLoggingConsumption = false;
      });
      return;
    }
    
    try {
      final success = await materialsProvider.logConsumption(
        _scannedMaterial!.id,
        quantity,
        authProvider.user!.id,
        authProvider.user!.name,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consumption logged successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return success
      } else {
        setState(() {
          _scanError = materialsProvider.errorMessage ?? 'Failed to log consumption';
          _isLoggingConsumption = false;
        });
      }
    } catch (e) {
      setState(() {
        _scanError = 'Error logging consumption: ${e.toString()}';
        _isLoggingConsumption = false;
      });
    }
  }

  void _validateQuantity(String value) {
    final quantity = double.tryParse(value);
    setState(() {
      _isQuantityValid = quantity != null && quantity > 0 && quantity <= (_scannedMaterial?.currentStock ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Material'),
        actions: [
          if (_hasPermission && _scannedMaterial == null)
            IconButton(
              icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
              onPressed: () {
                _controller.toggleTorch();
                setState(() {
                  _isFlashOn = !_isFlashOn;
                });
              },
            ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (!_hasPermission) {
      return _buildPermissionDenied();
    }
    
    if (_scannedMaterial != null) {
      return _buildMaterialConsumptionForm();
    }
    
    return _buildScanner();
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.no_photography,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Camera permission is required',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please allow camera access to scan materials',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Grant Permission',
            onPressed: _requestPermission,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  Widget _buildScanner() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
              ),
              // Scanner overlay
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Transparent scan area
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Scanner animation
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: _buildScannerAnimation(),
                    ),
                  ],
                ),
              ),
              // Error message
              if (_scanError != null)
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _scanError!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Scan a QR code or barcode on your material',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Position the code within the frame above',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
                type: ButtonType.outline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScannerAnimation() {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ScannerPainter(),
      ),
    );
  }

  Widget _buildMaterialConsumptionForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Material info card
          Card(
            margin: const EdgeInsets.only(bottom: 24),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Material name and details
                  Text(
                    _scannedMaterial!.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${_scannedMaterial!.category}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stock info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Stock',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: _scannedMaterial!.currentStock.toString(),
                                ),
                                TextSpan(
                                  text: ' ${_scannedMaterial!.unit}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Unit Cost',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${_scannedMaterial!.unitCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _scannedMaterial!.location,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stock level indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _scannedMaterial!.stockPercentage / 100,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      minHeight: 10,
                      color: _getStockLevelColor(_scannedMaterial!.stockPercentage),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Consumption form
          const Text(
            'Log Consumption',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Quantity input
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter amount',
                    errorText: _quantityController.text.isNotEmpty && !_isQuantityValid
                        ? 'Enter a valid quantity'
                        : null,
                    suffixText: _scannedMaterial!.unit,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: _validateQuantity,
                ),
              ),
              const SizedBox(width: 16),
              // Quick buttons for common quantities
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () {
                        _quantityController.text = '1';
                        _validateQuantity('1');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('1'),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 60,
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () {
                        _quantityController.text = '5';
                        _validateQuantity('5');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('5'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Notes input
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Add notes about this consumption',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
          ),
          
          if (_scanError != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _scanError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 32),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                  type: ButtonType.outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Log Consumption',
                  onPressed: _isQuantityValid ? () { _logConsumption(); } : () {},
                  disabled: !_isQuantityValid,
                  isLoading: _isLoggingConsumption,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Center(
            child: TextButton.icon(
              onPressed: _resetScan,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan another material'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStockLevelColor(double percentage) {
    if (percentage <= 15) {
      return Colors.red;
    } else if (percentage <= 40) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}

class ScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
      
    // Draw corners
    const double cornerSize = 30;
    
    // Corner edges (fix non-constant expression)
    final double cornerY = 250 - cornerSize;
    canvas.drawLine(
      const Offset(0, 0), 
      const Offset(cornerSize, 0), 
      paint
    );
    canvas.drawLine(
      const Offset(0, 0), 
      const Offset(0, cornerSize), 
      paint
    );
    
    canvas.drawLine(
      Offset(size.width - cornerSize, 0), 
      Offset(size.width, 0), 
      paint
    );
    canvas.drawLine(
      Offset(size.width, 0), 
      Offset(size.width, cornerSize), 
      paint
    );
    
    canvas.drawLine(
      Offset(0, cornerY), 
      Offset(0, size.height), 
      paint
    );
    canvas.drawLine(
      Offset(0, size.height), 
      Offset(cornerSize, size.height), 
      paint
    );
    
    canvas.drawLine(
      Offset(size.width - cornerSize, size.height), 
      Offset(size.width, size.height), 
      paint
    );
    canvas.drawLine(
      Offset(size.width, cornerY), 
      Offset(size.width, size.height), 
      paint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
} 