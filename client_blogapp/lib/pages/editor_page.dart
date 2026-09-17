import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';

class EditorPage extends StatefulWidget {
  final Post? post; // null = mode tambah, terisi = mode edit
  const EditorPage({super.key, this.post});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _imageCtrl;
  int? _categoryId;
  // Sesuaikan value ini dengan isi POST_STATUS di schema backend kamu.
  String _status = 'published';
  bool _saving = false;

  bool get isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.post?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.post?.content ?? '');
    _imageCtrl = TextEditingController(text: widget.post?.imageUrl ?? '');
    _categoryId = widget.post?.categoryId;
    _status = widget.post?.status ?? 'published';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final provider = context.read<PostProvider>();
    final post = Post(
      id: widget.post?.id ?? 0,
      categoryId: _categoryId,
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      imageUrl: _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
      status: _status,
    );
    try {
      if (isEditing) {
        await provider.editPost(widget.post!.id, post);
      } else {
        await provider.addPost(post);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<PostProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Artikel' : 'Tulis Artikel'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Simpan'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
            value: _categoryId,
            isExpanded: true,   // ← tambahkan ini
            decoration: const InputDecoration(labelText: 'Kategori'),
            items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
            onChanged: (v) => setState(() => _categoryId = v),
          ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageCtrl,
              decoration: const InputDecoration(labelText: 'URL Gambar (opsional)'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
            value: _status,
            isExpanded: true,   // ← tambahkan ini
            decoration: const InputDecoration(labelText: 'Status'),
            items: const [
              DropdownMenuItem(value: 'published', child: Text('Published')),
              DropdownMenuItem(value: 'draft', child: Text('Draft')),
            ],
            onChanged: (v) => setState(() => _status = v ?? 'published'),
          ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentCtrl,
              decoration: const InputDecoration(labelText: 'Isi Artikel'),
              maxLines: 12,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
          ],
        ),
      ),
    );
  }
}
