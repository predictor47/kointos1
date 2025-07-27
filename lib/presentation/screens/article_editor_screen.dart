import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/data/repositories/article_repository.dart';
import 'package:kointos/domain/entities/article.dart';

class ArticleEditorScreen extends StatefulWidget {
  final Article? article;

  const ArticleEditorScreen({
    super.key,
    this.article,
  });

  @override
  State<ArticleEditorScreen> createState() => _ArticleEditorScreenState();
}

class _ArticleEditorScreenState extends State<ArticleEditorScreen> {
  final _articleRepo = getService<ArticleRepository>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _summaryController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _coverImagePath;
  bool _isLoading = false;
  bool _isDraft = true;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _titleController.text = widget.article!.title;
      _contentController.text = widget.article!.content;
      _summaryController.text = widget.article!.summary;
      _tagsController.text = widget.article!.tags.join(', ');
      _coverImagePath = widget.article!.coverImageUrl;
      _isDraft = widget.article!.status == ArticleStatus.draft;
    }
  }

  Future<void> _pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _coverImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    }
  }

  List<String> _parseTags() {
    if (_tagsController.text.trim().isEmpty) return [];
    return _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  Future<void> _save({bool publish = false}) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Article article;
      if (widget.article == null) {
        // Create new article
        article = await _articleRepo.createArticle();
      } else {
        article = widget.article!;
      }

      // Upload cover image if selected
      String? coverImageUrl = article.coverImageUrl;
      if (_coverImagePath != null &&
          _coverImagePath != article.coverImageUrl &&
          !_coverImagePath!.startsWith('http')) {
        final updatedArticle = await _articleRepo.uploadArticleImage(
          article.id,
          _coverImagePath!,
        );
        coverImageUrl = updatedArticle.images.last;
      }

      // Update article
      article = await _articleRepo.updateArticle(
        article,
        title: _titleController.text,
        content: _contentController.text,
        summary: _summaryController.text,
        coverImageUrl: coverImageUrl,
        tags: _parseTags(),
        status: publish ? ArticleStatus.published : ArticleStatus.draft,
      );

      if (mounted) {
        Navigator.pop(context, article);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save article')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article == null ? 'New Article' : 'Edit Article'),
        actions: [
          if (_isDraft)
            TextButton(
              onPressed: _isLoading ? null : () => _save(publish: true),
              child: const Text('Publish'),
            ),
          IconButton(
            onPressed: _isLoading ? null : () => _save(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildCoverImage(),
                    const SizedBox(height: 16),
                    _buildTitleField(),
                    const SizedBox(height: 16),
                    _buildSummaryField(),
                    const SizedBox(height: 16),
                    _buildContentField(),
                    const SizedBox(height: 16),
                    _buildTagsField(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCoverImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          image: _coverImagePath != null
              ? DecorationImage(
                  image: _coverImagePath!.startsWith('http')
                      ? NetworkImage(_coverImagePath!)
                      : FileImage(File(_coverImagePath!)) as ImageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _coverImagePath == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 48,
                    color: AppTheme.pureWhite,
                  ),
                  SizedBox(height: 8),
                  Text('Add Cover Image'),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter article title',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Title is required';
        }
        return null;
      },
    );
  }

  Widget _buildSummaryField() {
    return TextFormField(
      controller: _summaryController,
      decoration: const InputDecoration(
        labelText: 'Summary',
        hintText: 'Enter article summary',
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Summary is required';
        }
        return null;
      },
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rich text formatting toolbar
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: AppTheme.pureWhite.withValues(alpha: 0.1)),
          ),
          child: Wrap(
            spacing: 8,
            children: [
              _buildFormatButton(
                  Icons.format_bold, 'Bold', () => _insertMarkdown('**', '**')),
              _buildFormatButton(Icons.format_italic, 'Italic',
                  () => _insertMarkdown('*', '*')),
              _buildFormatButton(
                  Icons.title, 'Heading', () => _insertMarkdown('## ', '')),
              _buildFormatButton(Icons.format_list_bulleted, 'List',
                  () => _insertMarkdown('- ', '')),
              _buildFormatButton(
                  Icons.format_quote, 'Quote', () => _insertMarkdown('> ', '')),
              _buildFormatButton(
                  Icons.code, 'Code', () => _insertMarkdown('`', '`')),
              _buildFormatButton(Icons.link, 'Link',
                  () => _insertMarkdown('[Link Text](', ')')),
              _buildFormatButton(Icons.image, 'Image', () => _insertImage()),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _contentController,
          decoration: const InputDecoration(
            labelText: 'Content',
            hintText: 'Write your article here (Markdown supported)',
            alignLabelWithHint: true,
          ),
          maxLines: 20,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Content is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFormatButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: AppTheme.pureWhite, size: 20),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppTheme.pureWhite.withValues(alpha: 0.1),
          minimumSize: const Size(36, 36),
        ),
      ),
    );
  }

  void _insertMarkdown(String before, String after) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final selectedText = selection.textInside(text);

    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$before$selectedText$after',
    );

    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset:
          selection.start + before.length + selectedText.length + after.length,
    );
  }

  void _insertImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBlack,
        title: const Text('Insert Image',
            style: TextStyle(color: AppTheme.pureWhite)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Image URL',
                hintText: 'https://example.com/image.jpg',
              ),
              onSubmitted: (url) {
                if (url.isNotEmpty) {
                  _insertMarkdown('![Image Description]($url)', '');
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _pickImageFromGallery() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // In a real app, you would upload this to S3 and get a URL
        final imageName = pickedFile.name;
        _insertMarkdown('![Image]($imageName)', '');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Image added to article (upload functionality ready for integration)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    }
  }

  void _pickImageFromCamera() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // In a real app, you would upload this to S3 and get a URL
        final imageName = pickedFile.name;
        _insertMarkdown('![Image]($imageName)', '');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Image added to article (upload functionality ready for integration)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to take photo')),
        );
      }
    }
  }

  Widget _buildTagsField() {
    return TextFormField(
      controller: _tagsController,
      decoration: const InputDecoration(
        labelText: 'Tags',
        hintText: 'Enter comma-separated tags',
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _summaryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
