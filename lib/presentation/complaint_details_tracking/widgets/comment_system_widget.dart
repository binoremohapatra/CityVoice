import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentSystemWidget extends StatefulWidget {
  final List<Map<String, dynamic>> comments;

  const CommentSystemWidget({
    Key? key,
    required this.comments,
  }) : super(key: key);

  @override
  State<CommentSystemWidget> createState() => _CommentSystemWidgetState();
}

class _CommentSystemWidgetState extends State<CommentSystemWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'author': 'You',
          'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
          'semanticLabel': 'Profile photo of current user',
          'content': _commentController.text.trim(),
          'timestamp': 'Just now',
          'isOfficial': false,
          'replies': [],
        });
      });
      _commentController.clear();
      _commentFocusNode.unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments & Updates',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ..._comments.map((comment) => _buildCommentItem(comment)).toList(),
                if (_comments.isEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'chat_bubble_outline',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No comments yet',
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Be the first to add a comment or question',
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Add a comment or question...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _addComment(),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: _addComment,
                      child: Container(
                        width: 12.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'send',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 4.w,
                backgroundImage: NetworkImage(comment['avatar']),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment['author'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (comment['isOfficial'] == true) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Official',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          comment['timestamp'],
                          style:
                          AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      comment['content'],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),
                    if ((comment['replies'] as List).isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      ...(comment['replies'] as List)
                          .map((reply) => Container(
                        margin: EdgeInsets.only(left: 8.w, top: 2.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 3.w,
                              backgroundImage:
                              NetworkImage(reply['avatar']),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        reply['author'],
                                        style: AppTheme.lightTheme
                                            .textTheme.bodySmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        reply['timestamp'],
                                        style: AppTheme.lightTheme
                                            .textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .onSurfaceVariant,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    reply['content'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                          .toList(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}