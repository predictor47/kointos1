import 'package:flutter/material.dart';
import 'package:kointos/core/services/faq_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/support_ticket_service.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late final FAQService _faqService;
  late final SupportTicketService _supportService;
  late final TabController _tabController;

  Map<String, List<Map<String, dynamic>>> _faqsByCategory = {};
  bool _isLoading = true;
  String? _selectedCategory;
  List<String> _categories = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _faqService = getService<FAQService>();
    _supportService = getService<SupportTicketService>();
    _tabController = TabController(length: 2, vsync: this);
    _loadFAQs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFAQs() async {
    try {
      final faqsByCategory = await _faqService.getFAQsByCategory();
      setState(() {
        _faqsByCategory = faqsByCategory;
        _categories = faqsByCategory.keys.toList();
        _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredFAQs() {
    List<Map<String, dynamic>> allFAQs = [];

    if (_selectedCategory != null) {
      allFAQs = _faqsByCategory[_selectedCategory!] ?? [];
    } else {
      // Show all FAQs
      _faqsByCategory.forEach((category, faqs) {
        for (final faq in faqs) {
          allFAQs.add({...faq, 'category': category});
        }
      });
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      allFAQs = allFAQs.where((faq) {
        final question = faq['question']?.toString().toLowerCase() ?? '';
        final answer = faq['answer']?.toString().toLowerCase() ?? '';
        return question.contains(query) || answer.contains(query);
      }).toList();
    }

    return allFAQs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text('Help & Support', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'FAQ'),
            Tab(text: 'Contact Support'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFAQTab(),
          _buildSupportTab(),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search FAQs...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Category chips
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCategoryChip('All', _selectedCategory == null);
              }
              final category = _categories[index - 1];
              return _buildCategoryChip(
                  category, _selectedCategory == category);
            },
          ),
        ),

        const SizedBox(height: 16),

        // FAQ list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _getFilteredFAQs().length,
            itemBuilder: (context, index) {
              final faq = _getFilteredFAQs()[index];
              return _buildFAQItem(faq);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
            if (category == 'All') _selectedCategory = null;
          });
        },
        selectedColor: Colors.amber,
        backgroundColor: Colors.grey[800],
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          faq['question'] ?? '',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconColor: Colors.amber,
        collapsedIconColor: Colors.grey,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              faq['answer'] ?? '',
              style: const TextStyle(color: Colors.grey[300], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need more help?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Can\'t find what you\'re looking for? Contact our support team.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Support categories
          const Text(
            'What do you need help with?',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: _supportService.getSupportCategories().length,
              itemBuilder: (context, index) {
                final category = _supportService.getSupportCategories()[index];
                return _buildSupportCategoryCard(category);
              },
            ),
          ),

          // Quick actions
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCreateTicketDialog(),
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Create Ticket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showMyTickets(),
                  icon: const Icon(Icons.history),
                  label: const Text('My Tickets'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCategoryCard(Map<String, dynamic> category) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Text(
          category['icon'] ?? '💬',
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          category['label'] ?? '',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          category['description'] ?? '',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () =>
            _showCreateTicketDialog(selectedCategory: category['value']),
      ),
    );
  }

  void _showCreateTicketDialog({String? selectedCategory}) {
    showDialog(
      context: context,
      builder: (context) => CreateSupportTicketDialog(
        initialCategory: selectedCategory,
        supportService: _supportService,
      ),
    );
  }

  void _showMyTickets() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyTicketsScreen(supportService: _supportService),
      ),
    );
  }
}

class CreateSupportTicketDialog extends StatefulWidget {
  final String? initialCategory;
  final SupportTicketService supportService;

  const CreateSupportTicketDialog({
    super.key,
    this.initialCategory,
    required this.supportService,
  });

  @override
  State<CreateSupportTicketDialog> createState() =>
      _CreateSupportTicketDialogState();
}

class _CreateSupportTicketDialogState extends State<CreateSupportTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  String _selectedPriority = 'MEDIUM';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Create Support Ticket',
          style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
                items: widget.supportService
                    .getSupportCategories()
                    .map((category) {
                  return DropdownMenuItem(
                    value: category['value'],
                    child: Text('${category['icon']} ${category['label']}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // Priority dropdown
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
                items:
                    widget.supportService.getPriorityLevels().map((priority) {
                  return DropdownMenuItem(
                    value: priority['value'],
                    child: Text(priority['label']),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedPriority = value!),
              ),
              const SizedBox(height: 16),

              // Subject field
              TextFormField(
                controller: _subjectController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a subject' : null,
              ),
              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.grey),
                  alignLabelWithHint: true,
                ),
                validator: (value) => value?.isEmpty == true
                    ? 'Please enter a description'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitTicket,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) return;

    setState(() => _isSubmitting = true);

    try {
      final ticketId = await widget.supportService.createSupportTicket(
        subject: _subjectController.text,
        description: _descriptionController.text,
        category: _selectedCategory!,
        priority: _selectedPriority,
      );

      if (ticketId != null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Support ticket created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to create ticket');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create support ticket. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}

class MyTicketsScreen extends StatefulWidget {
  final SupportTicketService supportService;

  const MyTicketsScreen({super.key, required this.supportService});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  List<Map<String, dynamic>> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      final tickets = await widget.supportService.getUserSupportTickets();
      setState(() {
        _tickets = tickets;
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
        title: const Text('My Support Tickets',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _tickets.isEmpty
              ? const Center(
                  child: Text(
                    'No support tickets found',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _tickets[index];
                    return _buildTicketCard(ticket);
                  },
                ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final statusInfo = widget.supportService.getStatusInfo();
    final status = ticket['status'] as String;
    final currentStatus = statusInfo[status] ?? statusInfo['OPEN']!;

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  currentStatus['icon'],
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ticket['subject'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(int.parse(currentStatus['color'])),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    currentStatus['label'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket['description'] ?? '',
              style: const TextStyle(color: Colors.grey[300]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Category: ${ticket['category']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Text(
                  'Priority: ${ticket['priority']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Created: ${_formatDate(ticket['createdAt'])}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
