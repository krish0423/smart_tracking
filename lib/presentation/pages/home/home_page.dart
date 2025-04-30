import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tracking_app/presentation/bloc/auth/auth_provider.dart';
import 'package:smart_tracking_app/presentation/bloc/materials/materials_provider.dart';
import 'package:smart_tracking_app/presentation/pages/scanner/scanner_page.dart';
import 'package:smart_tracking_app/presentation/widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final materialsProvider = Provider.of<MaterialsProvider>(context, listen: false);
    await materialsProvider.getAllMaterials();
    await materialsProvider.getLowStockMaterials();

    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final materialsProvider = Provider.of<MaterialsProvider>(context);
    final user = authProvider.user;
    final lowStockCount = materialsProvider.lowStockMaterials.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFab Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement sign out
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: [
                _buildDashboard(),
                _buildInventory(),
                _buildReports(),
                _buildSettings(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScannerPage()),
          ).then((result) {
            if (result == true) {
              _loadData();
            }
          });
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBar.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final materialsProvider = Provider.of<MaterialsProvider>(context);
    final lowStockMaterials = materialsProvider.lowStockMaterials;
    
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Track materials and monitor inventory in real-time',
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Scan Material',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScannerPage()),
                        ).then((result) {
                          if (result == true) {
                            _loadData();
                          }
                        });
                      },
                      icon: Icons.qr_code_scanner,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick stats
            Row(
              children: [
                _buildStatCard(
                  context,
                  'Total Materials',
                  materialsProvider.materials.length.toString(),
                  Icons.category,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  context,
                  'Low Stock',
                  lowStockMaterials.length.toString(),
                  Icons.warning,
                  Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Low stock materials
            Text(
              'Low Stock Materials',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            
            if (lowStockMaterials.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('No materials with low stock'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lowStockMaterials.length > 5 ? 5 : lowStockMaterials.length,
                itemBuilder: (context, index) {
                  final material = lowStockMaterials[index];
                  return ListTile(
                    title: Text(material.name),
                    subtitle: Text(
                      'Stock: ${material.currentStock} ${material.unit.toString().split('.').last}',
                    ),
                    leading: const Icon(Icons.warning, color: Colors.orange),
                    trailing: Text(
                      'Re-order: ${material.reorderLevel}',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  );
                },
              ),
              
            if (lowStockMaterials.length > 5)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to inventory tab
                      _onItemTapped(1);
                    },
                    child: const Text('View all'),
                  ),
                ),
              ),
              
            // Recent activity placeholder
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            
            // Placeholder for recent activity
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('Recent activity will be shown here'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInventory() {
    final materialsProvider = Provider.of<MaterialsProvider>(context);
    final materials = materialsProvider.materials;
    
    return Column(
      children: [
        // Search and filter bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search materials...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        
        // Materials list
        Expanded(
          child: ListView.builder(
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              final isLowStock = material.currentStock <= material.reorderLevel;
              
              return ListTile(
                title: Text(material.name),
                subtitle: Text(
                  'Stock: ${material.currentStock} ${material.unit.toString().split('.').last}',
                ),
                leading: isLowStock 
                  ? const Icon(Icons.warning, color: Colors.orange)
                  : const Icon(Icons.inventory),
                trailing: Text(
                  '\$${material.costPerUnit.toStringAsFixed(2)} / ${material.unit.toString().split('.').last}',
                ),
                onTap: () {
                  // TODO: Navigate to material detail page
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildReports() {
    return const Center(
      child: Text('Reports coming soon'),
    );
  }
  
  Widget _buildSettings() {
    return const Center(
      child: Text('Settings coming soon'),
    );
  }
  
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 