import 'package:flutter/material.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/enums/transaction_type_enum.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late final AuthService _authService;
  late final ApiService _apiService;

  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  TransactionTypeEnum? _filter;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _apiService = ApiService(
        baseUrl: 'https://api.example.com', authService: _authService);
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId != null) {
        final transactions =
            await _apiService.getTransactionHistory(userId: userId);
        setState(() {
          _transactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading transactions: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_filter == null) return _transactions;
    return _transactions.where((tx) => tx['type'] == _filter!.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filter = value == 'ALL' ? null : TransactionTypeEnum.fromString(value);
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'ALL', child: Text('All Transactions')),
              ...TransactionTypeEnum.values.map((type) => PopupMenuItem(
                  value: type.value, child: Text(type.displayName))),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredTransactions.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadTransactions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Transactions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _filter != null
                ? 'No transactions found for the selected filter'
                : 'Your transaction history will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final type = transaction['type'] ?? 'UNKNOWN';
    final amount = (transaction['amount'] ?? 0.0).toString();
    final symbol = transaction['cryptoSymbol'] ?? 'UNKNOWN';
    final totalValue = (transaction['totalValue'] ?? 0.0).toString();
    final date = DateTime.tryParse(transaction['transactionDate'] ?? '') ??
        DateTime.now();

    Color typeColor;
    IconData typeIcon;
    String typeText;

    switch (type) {
      case 'BUY':
        typeColor = Colors.green;
        typeIcon = Icons.arrow_downward;
        typeText = 'Buy';
        break;
      case 'SELL':
        typeColor = Colors.red;
        typeIcon = Icons.arrow_upward;
        typeText = 'Sell';
        break;
      case 'TRANSFER_IN':
        typeColor = Colors.blue;
        typeIcon = Icons.arrow_forward;
        typeText = 'Transfer In';
        break;
      case 'TRANSFER_OUT':
        typeColor = Colors.orange;
        typeIcon = Icons.arrow_back;
        typeText = 'Transfer Out';
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.help;
        typeText = type;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: typeColor.withValues(alpha: 0.1),
          child: Icon(typeIcon, color: typeColor),
        ),
        title: Text('$typeText $symbol'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: $amount $symbol'),
            Text('Value: \$${double.parse(totalValue).toStringAsFixed(2)}'),
            Text('Date: ${_formatDate(date)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            final transactionType = TransactionTypeEnum.fromString(type);
            Text(
              '${transactionType?.isIncoming == true ? '+' : '-'}$amount',
              style: TextStyle(
                color: typeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              symbol,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () {
          _showTransactionDetails(transaction);
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', transaction['type'] ?? 'Unknown'),
              _buildDetailRow(
                  'Symbol', transaction['cryptoSymbol'] ?? 'Unknown'),
              _buildDetailRow('Amount', '${transaction['amount'] ?? 0}'),
              _buildDetailRow('Price',
                  '\$${(transaction['price'] ?? 0.0).toStringAsFixed(2)}'),
              _buildDetailRow('Total Value',
                  '\$${(transaction['totalValue'] ?? 0.0).toStringAsFixed(2)}'),
              _buildDetailRow('Fees',
                  '\$${(transaction['fees'] ?? 0.0).toStringAsFixed(2)}'),
              if (transaction['notes'] != null &&
                  transaction['notes'].isNotEmpty)
                _buildDetailRow('Notes', transaction['notes']),
              _buildDetailRow(
                  'Date',
                  _formatDate(
                      DateTime.tryParse(transaction['transactionDate'] ?? '') ??
                          DateTime.now())),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
