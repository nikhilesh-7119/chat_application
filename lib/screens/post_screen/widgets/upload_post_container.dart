
import 'package:flutter/material.dart';

class UploadPostContainer extends StatefulWidget {
  final Future<void> Function(
    String title,
    String category,
    String description,
    String authorId,
  ) onSubmitted;

  const UploadPostContainer({Key? key, required this.onSubmitted})
      : super(key: key);

  @override
  State<UploadPostContainer> createState() => _UploadPostContainerState();
}

class _UploadPostContainerState extends State<UploadPostContainer> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  String? _category;

  bool _submitting = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create New Post',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              // Title
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Looking for ML Study Partner',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLength: 120,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title required' : null,
              ), // [3]

              const SizedBox(height: 8),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: _category,
                items: const [
                  DropdownMenuItem(value: 'Data Science', child: Text('Data Science')),
                  DropdownMenuItem(value: 'Mobile Development', child: Text('Mobile Development')),
                  DropdownMenuItem(value: 'Web Development', child: Text('Web Development')),
                  DropdownMenuItem(value: 'AI', child: Text('AI')),
                  DropdownMenuItem(value: 'UI/UX', child: Text('UI/UX')),
                ],
                onChanged: (v) => setState(() => _category = v),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Select a category' : null,
              ), // [3]

              const SizedBox(height: 8),

              // Description
              TextFormField(
                controller: _desc,
                minLines: 3,
                maxLines: 6,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: "Describe what you're looking for in detail...",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description required'
                    : null,
              ), // [3]

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _submitting = true);
                          try {
                            // Replace authorId with the actual signed-in user id
                            const authorId = 'CURRENT_USER_UID';
                            await widget.onSubmitted(
                              _title.text,
                              _category!,
                              _desc.text,
                              authorId,
                            ); // [3]
                            // Clear fields on success
                            _title.clear();
                            _desc.clear();
                            setState(() => _category = null);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post uploaded'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed: $e')),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _submitting = false);
                          }
                        },
                  child: _submitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Post Requirement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}