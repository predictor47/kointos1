import 'package:flutter/material.dart';
import 'package:kointos/core/services/notification_service.dart';
import 'package:kointos/core/services/service_locator.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late final NotificationService _notificationService;
  late final TabController _tabController;

  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _priceAlerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _notificationService = getService<NotificationService>();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final [notifications, alerts] = await Future.wait([
        _notificationService.getNotificationHistory(),
        _notificationService.getUserPriceAlerts(),
      ]);

      setState(() {
        _notifications = notifications;
        _priceAlerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert, color: Colors.white),
            onPressed: _showCreateAlertDialog,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.grey[800],
            onSelected: (value) {
              switch (value) {
                case 'clear_all':
                  _clearAllNotifications();
                  break;
                case 'check_alerts':
                  _checkPriceAlerts();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'check_alerts',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Check Alerts', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Clear All', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Price Alerts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsTab(),
          _buildPriceAlertsTab(),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.amber));
    }

    if (_notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off, color: Colors.grey, size: 64),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'You\'ll see app notifications here',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.amber,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final notificationTypes = _notificationService.getNotificationTypes();
    final type = notification['type'] as String? ?? 'SYSTEM';
    final typeInfo = notificationTypes[type] ?? notificationTypes['SYSTEM']!;
    final isRead = notification['isRead'] as bool? ?? false;

    return Card(
      color: isRead ? Colors.grey[900] : Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _markAsRead(notification),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse(typeInfo['color'])).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    typeInfo['icon'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'] ?? '',
                      style: TextStyle(
                        color: isRead ? Colors.grey[400] : Colors.grey[300],
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          typeInfo['title'],
                          style: TextStyle(
                            color: Color(int.parse(typeInfo['color'])),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatTimestamp(notification['triggeredAt']),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceAlertsTab() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.amber));
    }

    return Column(
      children: [
        // Active alerts
        Expanded(
          child: _priceAlerts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_alert, color: Colors.grey, size: 64),
                      SizedBox(height: 16),
                      Text(
                        'No price alerts set',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap + to create your first alert',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  color: Colors.amber,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _priceAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = _priceAlerts[index];
                      return _buildPriceAlertCard(alert);
                    },
                  ),
                ),
        ),

        // Create alert button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showCreateAlertDialog,
              icon: const Icon(Icons.add_alert),
              label: const Text('Create Price Alert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAlertCard(Map<String, dynamic> alert) {
    final cryptoSymbol = alert['cryptoSymbol'] as String;
    final alertType = alert['alertType'] as String;
    final targetPrice = (alert['targetPrice'] as num).toDouble();
    final isActive = alert['isActive'] as bool? ?? true;

    return Card(
      color: isActive ? Colors.grey[900] : Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Crypto icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  cryptoSymbol.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Alert details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        cryptoSymbol.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              alertType == 'ABOVE' ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          alertType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${targetPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Created ${_formatTimestamp(alert['createdAt'])}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Status and actions
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'ACTIVE' : 'TRIGGERED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () => _deleteAlert(alert['id']),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => CreatePriceAlertDialog(
        notificationService: _notificationService,
        onAlertCreated: _loadData,
      ),
    );
  }

  Future<void> _markAsRead(Map<String, dynamic> notification) async {
    if (notification['isRead'] == true) return;

    await _notificationService.markNotificationAsRead(notification['id']);
    setState(() {
      notification['isRead'] = true;
    });
  }

  Future<void> _deleteAlert(String alertId) async {
    final success = await _notificationService.deletePriceAlert(alertId);
    if (success) {
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Price alert deleted'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _clearAllNotifications() async {
    final success = await _notificationService.clearAllNotifications();
    if (success) {
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications cleared'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _checkPriceAlerts() async {
    final triggeredAlerts = await _notificationService.checkPriceAlerts();
    if (triggeredAlerts.isNotEmpty) {
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${triggeredAlerts.length} alerts triggered!'),
          backgroundColor: Colors.amber,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No alerts triggered'),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return 'Unknown';

    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

class CreatePriceAlertDialog extends StatefulWidget {
  final NotificationService notificationService;
  final VoidCallback onAlertCreated;

  const CreatePriceAlertDialog({
    super.key,
    required this.notificationService,
    required this.onAlertCreated,
  });

  @override
  State<CreatePriceAlertDialog> createState() => _CreatePriceAlertDialogState();
}

class _CreatePriceAlertDialogState extends State<CreatePriceAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cryptoController = TextEditingController();
  final _priceController = TextEditingController();

  String _alertType = 'ABOVE';
  bool _isCreating = false;

  final List<String> _popularCryptos = [
    'BTC',
    'ETH',
    'ADA',
    'SOL',
    'MATIC',
    'DOT',
    'LINK',
    'UNI',
    'AVAX',
    'ATOM'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Create Price Alert',
          style: TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Crypto symbol field
            TextFormField(
              controller: _cryptoController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Cryptocurrency Symbol',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'e.g., BTC, ETH, ADA',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Enter a crypto symbol' : null,
            ),

            const SizedBox(height: 8),

            // Popular cryptos chips
            Wrap(
              spacing: 6,
              children: _popularCryptos
                  .map(
                    (crypto) => ActionChip(
                      label: Text(crypto,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                      backgroundColor: Colors.grey[800],
                      onPressed: () => _cryptoController.text = crypto,
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Alert type selection
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Above',
                        style: TextStyle(color: Colors.white)),
                    value: 'ABOVE',
                    groupValue: _alertType,
                    activeColor: Colors.amber,
                    onChanged: (value) => setState(() => _alertType = value!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Below',
                        style: TextStyle(color: Colors.white)),
                    value: 'BELOW',
                    groupValue: _alertType,
                    activeColor: Colors.amber,
                    onChanged: (value) => setState(() => _alertType = value!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Target price field
            TextFormField(
              controller: _priceController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Price (USD)',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.grey),
                prefixText: '\$',
                prefixStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value?.isEmpty == true) return 'Enter a target price';
                final price = double.tryParse(value!);
                if (price == null || price <= 0) return 'Enter a valid price';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createAlert,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: _isCreating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create Alert',
                  style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Future<void> _createAlert() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    try {
      final success = await widget.notificationService.createPriceAlert(
        cryptoSymbol: _cryptoController.text.toUpperCase(),
        alertType: _alertType,
        targetPrice: double.parse(_priceController.text),
      );

      if (success) {
        Navigator.pop(context);
        widget.onAlertCreated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Price alert created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to create alert');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create price alert. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isCreating = false);
    }
  }
}
