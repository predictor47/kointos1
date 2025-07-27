import 'package:flutter/material.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/api_service.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  late final AuthService _authService;
  late final ApiService _apiService;

  List<Map<String, dynamic>> _paymentMethods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize services - in a real app these would come from dependency injection
    _authService = AuthService();
    _apiService = ApiService(
        baseUrl: 'https://api.example.com', authService: _authService);
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId != null) {
        final methods = await _apiService.getPaymentMethods(userId);
        setState(() {
          _paymentMethods = methods;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading payment methods: $e')),
        );
      }
    }
  }

  Future<void> _addPaymentMethod() async {
    // Show add payment method dialog
    await showDialog(
      context: context,
      builder: (context) => _AddPaymentMethodDialog(
        onAdd: (method) async {
          final messenger = ScaffoldMessenger.of(context);
          try {
            final userId = await _authService.getCurrentUserId();
            if (userId != null) {
              await _apiService.createPaymentMethod(
                userId: userId,
                type: method['type'],
                name: method['name'],
                last4: method['last4'],
                expiryMonth: method['expiryMonth'],
                expiryYear: method['expiryYear'],
                bankName: method['bankName'],
                accountType: method['accountType'],
                walletAddress: method['walletAddress'],
                isDefault: method['isDefault'] ?? false,
              );
              _loadPaymentMethods();
            }
          } catch (e) {
            if (mounted) {
              messenger.showSnackBar(
                SnackBar(content: Text('Error adding payment method: $e')),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _paymentMethods.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    return _buildPaymentMethodCard(method);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPaymentMethod,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Payment Methods',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a payment method to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addPaymentMethod,
            icon: const Icon(Icons.add),
            label: const Text('Add Payment Method'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    IconData icon;
    String subtitle;

    switch (method['type']) {
      case 'CREDIT_CARD':
      case 'DEBIT_CARD':
        icon = Icons.credit_card;
        subtitle = '**** **** **** ${method['last4'] ?? '****'}';
        break;
      case 'BANK_ACCOUNT':
        icon = Icons.account_balance;
        subtitle =
            '${method['bankName'] ?? 'Bank'} - ${method['accountType'] ?? 'Account'}';
        break;
      case 'CRYPTO_WALLET':
        icon = Icons.wallet;
        subtitle = method['walletAddress'] ?? 'Crypto Wallet';
        break;
      default:
        icon = Icons.payment;
        subtitle = method['type'];
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(method['name'] ?? 'Payment Method'),
        subtitle: Text(subtitle),
        trailing: method['isDefault'] == true
            ? Chip(
                label: const Text('Default'),
                backgroundColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              )
            : null,
        onTap: () {
          _showPaymentMethodDetails(method);
        },
      ),
    );
  }

  void _showPaymentMethodDetails(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${method['type']} Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(method['icon'] as IconData),
                title: Text(method['title'] as String),
                subtitle: Text(method['subtitle'] as String),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              const Text(
                'Actions:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Payment Method'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Edit ${method['type']} functionality ready')),
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Payment Method'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmRemovePaymentMethod(method);
                },
                contentPadding: EdgeInsets.zero,
              ),
              if (method['type'] == 'Credit Card') ...[
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Security Info'),
                  subtitle: Text('Your card details are encrypted and secure'),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmRemovePaymentMethod(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Payment Method'),
        content: Text('Are you sure you want to remove ${method['title']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _paymentMethods.remove(method);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('${method['type']} removed successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _AddPaymentMethodDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const _AddPaymentMethodDialog({required this.onAdd});

  @override
  State<_AddPaymentMethodDialog> createState() =>
      _AddPaymentMethodDialogState();
}

class _AddPaymentMethodDialogState extends State<_AddPaymentMethodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _last4Controller = TextEditingController();
  final _bankNameController = TextEditingController();
  final _walletAddressController = TextEditingController();

  String _selectedType = 'CREDIT_CARD';
  bool _isDefault = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Payment Method'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(
                      value: 'CREDIT_CARD', child: Text('Credit Card')),
                  DropdownMenuItem(
                      value: 'DEBIT_CARD', child: Text('Debit Card')),
                  DropdownMenuItem(
                      value: 'BANK_ACCOUNT', child: Text('Bank Account')),
                  DropdownMenuItem(
                      value: 'CRYPTO_WALLET', child: Text('Crypto Wallet')),
                ],
                onChanged: (value) {
                  setState(() => _selectedType = value!);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_selectedType == 'CREDIT_CARD' ||
                  _selectedType == 'DEBIT_CARD')
                TextFormField(
                  controller: _last4Controller,
                  decoration: const InputDecoration(labelText: 'Last 4 digits'),
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                ),
              if (_selectedType == 'BANK_ACCOUNT')
                TextFormField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(labelText: 'Bank Name'),
                ),
              if (_selectedType == 'CRYPTO_WALLET')
                TextFormField(
                  controller: _walletAddressController,
                  decoration:
                      const InputDecoration(labelText: 'Wallet Address'),
                ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Set as default'),
                value: _isDefault,
                onChanged: (value) {
                  setState(() => _isDefault = value ?? false);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final method = <String, dynamic>{
                'type': _selectedType,
                'name': _nameController.text,
                'isDefault': _isDefault,
              };

              if (_selectedType == 'CREDIT_CARD' ||
                  _selectedType == 'DEBIT_CARD') {
                method['last4'] = _last4Controller.text;
              } else if (_selectedType == 'BANK_ACCOUNT') {
                method['bankName'] = _bankNameController.text;
              } else if (_selectedType == 'CRYPTO_WALLET') {
                method['walletAddress'] = _walletAddressController.text;
              }

              widget.onAdd(method);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _last4Controller.dispose();
    _bankNameController.dispose();
    _walletAddressController.dispose();
    super.dispose();
  }
}
