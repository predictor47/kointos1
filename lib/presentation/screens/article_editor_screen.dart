import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/theme/app_theme.dart';
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
                    color: AppTheme.primaryColor,
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
    return TextFormField(
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
    );
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
