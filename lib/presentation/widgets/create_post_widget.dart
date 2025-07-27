import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/api_service.dart';

class CreatePostWidget extends StatefulWidget {
  final VoidCallback? onPostCreated;

  const CreatePostWidget({super.key, this.onPostCreated});

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _cryptoSearchController = TextEditingController();
  bool _isLoading = false;
  List<String> _filteredCryptos = [];
  bool _showCryptoSuggestions = false;

  // Popular cryptocurrencies for search
  final List<String> _popularCryptos = [
    'BTC',
    'ETH',
    'SOL',
    'ADA',
    'DOT',
    'MATIC',
    'AVAX',
    'ATOM',
    'LINK',
    'UNI',
    'AAVE',
    'COMP',
    'MKR',
    'SNX',
    'YFI',
    'SUSHI'
  ];

  @override
  void dispose() {
    _controller.dispose();
    _cryptoSearchController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = getService<ApiService>();
      await apiService.createPost(
        content: _controller.text.trim(),
        isPublic: true,
      );

      _controller.clear();
      widget.onPostCreated?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.cryptoGold,
              child: Text(
                'U',
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: "What's happening in crypto?",
                  hintStyle: TextStyle(
                    color: AppTheme.greyText,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.image,
                    color: AppTheme.greyText,
                  ),
                  onPressed: () {
                    _showImageUploadDialog();
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.attach_money,
                    color: AppTheme.cryptoGold,
                  ),
                  onPressed: () {
                    _showCryptoMentionDialog();
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _isLoading || _controller.text.trim().isEmpty
                  ? null
                  : _createPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cryptoGold,
                foregroundColor: AppTheme.primaryBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryBlack,
                        ),
                      ),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  void _showImageUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageSelection('camera');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageSelection('gallery');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _handleImageSelection(String source) async {
    // Show feedback to user about image selection
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Image $source selection ready - would integrate with image_picker package'),
          duration: const Duration(seconds: 2),
        ),
      );

      // In production, would integrate with image_picker:
      // final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(
      //   source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
      //   maxWidth: 1024,
      //   maxHeight: 1024,
      //   imageQuality: 85,
      // );
      // if (image != null) {
      //   setState(() {
      //     _selectedImages.add(image);
      //   });
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCryptoMentionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mention Cryptocurrency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add a cryptocurrency mention to your post:'),
              const SizedBox(height: 16),
              TextField(
                controller: _cryptoSearchController,
                decoration: const InputDecoration(
                  labelText: 'Search cryptocurrency...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _filteredCryptos = [];
                      _showCryptoSuggestions = false;
                    } else {
                      _filteredCryptos = _popularCryptos
                          .where((crypto) => crypto
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                      _showCryptoSuggestions = _filteredCryptos.isNotEmpty;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              // Show filtered suggestions or popular cryptocurrencies
              if (_showCryptoSuggestions)
                Wrap(
                  spacing: 8,
                  children: _filteredCryptos.map((symbol) {
                    return ActionChip(
                      label: Text('\$$symbol'),
                      backgroundColor: Colors.blue.shade50,
                      onPressed: () {
                        Navigator.pop(context);
                        _insertCryptoMention(symbol);
                      },
                    );
                  }).toList(),
                )
              else
                // Popular cryptocurrencies
                Wrap(
                  spacing: 8,
                  children: _popularCryptos.take(5).map((symbol) {
                    return ActionChip(
                      label: Text('\$$symbol'),
                      onPressed: () {
                        Navigator.pop(context);
                        _insertCryptoMention(symbol);
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _insertCryptoMention(String symbol) {
    final currentText = _controller.text;
    final cryptoMention = ' \$$symbol ';
    _controller.text = currentText + cryptoMention;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added \$$symbol mention to your post'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
