import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Admin dashboard screen - Web only
/// Provides moderation tools and analytics visualization
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isAdmin = false;
  bool _isLoading = true;
  String _selectedSection = 'overview';

  // Mock data for demo
  final Map<String, dynamic> _analyticsData = {
    'totalUsers': 15234,
    'activeUsers': 8921,
    'totalPosts': 45678,
    'totalComments': 123456,
    'reportedContent': 23,
    'pendingReviews': 12,
  };

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    try {
      // Check if running on web
      if (!kIsWeb) {
        setState(() {
          _isLoading = false;
          _isAdmin = false;
        });
        return;
      }

      // Check if user is authenticated
      final user = await Amplify.Auth.getCurrentUser();

      // Check if user is in admin group
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final groups = attributes
          .firstWhere(
            (attr) => attr.userAttributeKey.key == 'custom:groups',
            orElse: () => const AuthUserAttribute(
              userAttributeKey: CognitoUserAttributeKey.custom('groups'),
              value: '',
            ),
          )
          .value;

      setState(() {
        _isAdmin = groups.contains('Admins') || groups.contains('Moderators');
        _isLoading = false;
      });
    } catch (e) {
      LoggerService.error('Error checking admin access: $e');
      setState(() {
        _isAdmin = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Access Denied'),
        ),
        body: const Center(
          child: Text(
            'Admin dashboard is only available on web',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Access Denied'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'You do not have permission to access this page',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Admin access required',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Admin Panel',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Menu items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildMenuItem(
                        'overview',
                        Icons.dashboard,
                        'Overview',
                      ),
                      _buildMenuItem(
                        'users',
                        Icons.people,
                        'User Management',
                      ),
                      _buildMenuItem(
                        'content',
                        Icons.article,
                        'Content Moderation',
                      ),
                      _buildMenuItem(
                        'analytics',
                        Icons.analytics,
                        'Analytics',
                      ),
                      _buildMenuItem(
                        'reports',
                        Icons.report,
                        'Reports',
                      ),
                      _buildMenuItem(
                        'settings',
                        Icons.settings,
                        'Settings',
                      ),
                    ],
                  ),
                ),
                // Logout
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await Amplify.Auth.signOut();
                    if (mounted) {
                      Navigator.of(context).pushReplacementNamed('/auth');
                    }
                  },
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getSectionTitle(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Refresh button
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _refreshData,
                      ),
                      const SizedBox(width: 8),
                      // Notification bell
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String id, IconData icon, String title) {
    final isSelected = _selectedSection == id;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedSection = id;
        });
      },
    );
  }

  String _getSectionTitle() {
    switch (_selectedSection) {
      case 'overview':
        return 'Dashboard Overview';
      case 'users':
        return 'User Management';
      case 'content':
        return 'Content Moderation';
      case 'analytics':
        return 'Analytics';
      case 'reports':
        return 'Reports';
      case 'settings':
        return 'Settings';
      default:
        return 'Admin Dashboard';
    }
  }

  Widget _buildContent() {
    switch (_selectedSection) {
      case 'overview':
        return _buildOverview();
      case 'users':
        return _buildUserManagement();
      case 'content':
        return _buildContentModeration();
      case 'analytics':
        return _buildAnalytics();
      case 'reports':
        return _buildReports();
      case 'settings':
        return _buildSettings();
      default:
        return const Center(child: Text('Select a section'));
    }
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Users',
                _analyticsData['totalUsers'].toString(),
                Icons.people,
                Colors.blue,
              ),
              _buildStatCard(
                'Active Users',
                _analyticsData['activeUsers'].toString(),
                Icons.person,
                Colors.green,
              ),
              _buildStatCard(
                'Total Posts',
                _analyticsData['totalPosts'].toString(),
                Icons.article,
                Colors.orange,
              ),
              _buildStatCard(
                'Reported Content',
                _analyticsData['reportedContent'].toString(),
                Icons.report,
                Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Charts
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildUserGrowthChart(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildActivityChart(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                const Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 16,
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserGrowthChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Growth',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 1000),
                        const FlSpot(1, 2500),
                        const FlSpot(2, 4000),
                        const FlSpot(3, 6500),
                        const FlSpot(4, 9000),
                        const FlSpot(5, 12000),
                        const FlSpot(6, 15234),
                      ],
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      title: 'Posts',
                      color: Colors.blue,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 30,
                      title: 'Comments',
                      color: Colors.green,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: 'Likes',
                      color: Colors.orange,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 10,
                      title: 'Shares',
                      color: Colors.purple,
                      radius: 80,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list),
                label: const Text('Filter'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Users table
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Joined')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List.generate(
                  10,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('USR${1000 + index}')),
                      DataCell(Text('user$index')),
                      DataCell(Text('user$index@example.com')),
                      DataCell(
                        Chip(
                          label: Text(
                            index % 3 == 0 ? 'Suspended' : 'Active',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: index % 3 == 0
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                        ),
                      ),
                      DataCell(Text('2024-0${index % 9 + 1}-15')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.block, size: 18),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentModeration() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Reported Posts'),
                    Tab(text: 'Reported Comments'),
                    Tab(text: 'Flagged Users'),
                  ],
                ),
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    children: [
                      _buildReportedContent('posts'),
                      _buildReportedContent('comments'),
                      _buildFlaggedUsers(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportedContent(String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text('U${index + 1}'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'user$index',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '2 hours ago',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Chip(
                      label: const Text(
                        'Spam',
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.orange.withOpacity(0.1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'This is a sample reported content that needs moderation...',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Remove'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Dismiss'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Warn User'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFlaggedUsers() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('U${index + 1}'),
            ),
            title: Text('user$index'),
            subtitle: const Text('Multiple violations reported'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Suspend'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Ban'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalytics() {
    return const Center(
      child: Text('Analytics section - Coming soon'),
    );
  }

  Widget _buildReports() {
    return const Center(
      child: Text('Reports section - Coming soon'),
    );
  }

  Widget _buildSettings() {
    return const Center(
      child: Text('Settings section - Coming soon'),
    );
  }

  void _refreshData() {
    // Refresh data implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data refreshed')),
    );
  }
}
