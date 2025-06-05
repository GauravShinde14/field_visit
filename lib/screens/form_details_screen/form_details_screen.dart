import 'package:field_visit/auth/auth.dart';
import 'package:field_visit/models/comment_model.dart';
import 'package:field_visit/models/form_ans_model.dart';
import 'package:field_visit/widgets/reply_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:field_visit/widgets/customer_field_visit_appbar.dart';

class FormDetailsScreen extends StatefulWidget {
  final FormAnsModel formData;

  const FormDetailsScreen({super.key, required this.formData});

  @override
  State<FormDetailsScreen> createState() => _FormDetailsScreenState();
}

class _FormDetailsScreenState extends State<FormDetailsScreen> {
  // final List<Map<String, String>> comments = [
  //   {
  //     "officer": "श्री.श्रीकांत खटात",
  //     "formId": "फॉर्म आय डी",
  //     "comment":
  //         "शिक्षणाधिकारी टीमने घेतलेल्या क्षेत्रभेटी उपयुक्त ठरल्या. कृपया प्रमुख निरीक्षकांच्या संक्षिप्त अहवाल तयार करा आणि स्थानिक अधिकाऱ्यांशी पुढील कारवाईही सुनिश्चित करा.",
  //   },
  //   // Add more comments here if needed
  // ];
  late Future<List<CommentModel>> comments;

  @override
  void initState() {
    super.initState();
    comments = Auth.fetchCommentList(widget.formData.id);
  }

  void _refreshComments() {
    setState(() {
      comments = Auth.fetchCommentList(widget.formData.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomFieldVisitAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "भेट दिलेला तालुका ${widget.formData.taluka}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "दि. ${_formatDate(widget.formData.createdAt)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // First row
            _buildAnswerTile(
              "ग्रामपंचायत - ",
              "${widget.formData.officeType}  ${widget.formData.village}",
              isBoldAnswer: true,
            ),

            // Dynamic form answers
            for (var ans in widget.formData.formAnswers)
              ans.type == 'file'
                  ? _buildImageAnswerTile(context, ans.label, ans.answer)
                  : _buildAnswerTile(
                      "${ans.label} ${ans.type == 'radio' ? '- ' : ''}",
                      ans.answer,
                      isBoldAnswer: true,
                    ),

            const SizedBox(height: 20),

            // const Text(
            //   "भेटीचे फोटो",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,
            //   ),
            // ),
            // const SizedBox(height: 12),

            // // Placeholder for two photos
            // Row(
            //   children: [
            //     _buildImagePlaceholder(),
            //     const SizedBox(width: 12),
            //     _buildImagePlaceholder(),
            //   ],
            // ),
            const Text(
              "कमेंट्स",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            FutureBuilder<List<CommentModel>>(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No comments available."));
                }

                final commentList = snapshot.data!;
                return Column(
                  children: commentList.map((comment) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  size: 20, color: Colors.black54),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "${comment.commentByName} (${comment.role})",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                comment.commentAt,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              comment.comment,
                              style: const TextStyle(
                                fontSize: 14.5,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (comment.remark == null &&
                              comment.remarkImage == "")
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Handle 'पिळवा...' button tap
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (context) => ReplyBottomSheet(
                                      name: comment.commentByName,
                                      commentId: comment.id,
                                      onRemarkAdded: _refreshComments,
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.orange.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                ),
                                child: const Text(
                                  "रिप्लाय...",
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          if (comment.remark != null &&
                              comment.remark!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Remark: ${comment.remark}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          if (comment.remarkImage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: comment.remarkImage == "null"
                                  ? const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image,
                                              color: Colors.grey, size: 40),
                                          SizedBox(height: 5),
                                          Text(
                                            "No image found",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Image.network(
                                      comment.remarkImage,
                                      width: double.infinity,
                                      height: 160,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                            child:
                                                CircularProgressIndicator()); // Show loader while image is loading
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.broken_image,
                                                  color: Colors.red, size: 40),
                                              SizedBox(height: 5),
                                              Text(
                                                "Failed to load image",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ); // Show error if image fails
                                      },
                                    ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerTile(String label, String value,
      {bool isBoldAnswer = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(Icons.circle, size: 6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Answer: $value",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight:
                        isBoldAnswer ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageAnswerTile(
      BuildContext context, String label, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 6),
              const SizedBox(width: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _showFullImage(context, imageUrl);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              // child: Image.network(
              //   imageUrl,
              //   height: 160,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              //   errorBuilder: (context, error, stackTrace) => const Center(
              //     child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
              //   ),
              // ),
              child: imageUrl == "null"
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image,
                              color: Colors.grey, size: 40),
                          SizedBox(height: 5),
                          Text(
                            "No image found",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Show loader while image is loading
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image,
                                  color: Colors.red, size: 40),
                              SizedBox(height: 5),
                              Text(
                                "Failed to load image",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ); // Show error if image fails
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Expanded(
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Icon(Icons.image, size: 50, color: Colors.grey),
      ),
    );
  }

  String _formatDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
    } catch (e) {
      return dateTime;
    }
  }

  void _showFullImage(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: image == "null"
                    ? Container(
                        color: Colors.black,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.broken_image,
                                  size: 100, color: Colors.white),
                              SizedBox(height: 20),
                              Text(
                                "No image found",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Image.network(
                        image,
                        errorBuilder: (context, error, stackTrace) {
                          print("Error in full screen image: $error");
                          return Container(
                            color: Colors.black,
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.broken_image,
                                      size: 100, color: Colors.white),
                                  SizedBox(height: 20),
                                  Text(
                                    "Failed to load image",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
