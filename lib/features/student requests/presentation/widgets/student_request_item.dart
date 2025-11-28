import 'package:catalyst/core/widgets/custom_box.dart';
import 'package:catalyst/features/student%20requests/data/models/student_requests_model.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/approve%20reject%20request/approve_reject_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:catalyst/core/utils/routs.dart';

class StudentRequestItem extends StatelessWidget {
  const StudentRequestItem({super.key, required this.student});

  final StudentRequest student;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(Routs.studentProfile, extra: 'requests');
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CustomBox(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuAXnfQKXuYef1Ku-dVXWWp0cnQbiTJomHGhfShYUfXT8g7L9m3aufFfSbDkW3OmgVo1wVg5F00o89gB89CyHWpy0p0ZO7jj2zBE4vGdBWw6d-dnWzKntMxEo6_v8Dk0QHZqXTLvbscFqPmj5E5ro-IThaUoGL1yI9SWvwt6_qah8PCX-uvFEOTHuyu2QsVtb2hE-D-sZB2lmfL4gUqBX1m4SbxFOvzXi0Xoar868lbztFqIa22DiKSQnrqalGK2Tdq-Tl_pX94lgH4d",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: student.studentName,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        CustomText(
                          text: student.lessonSubject,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        CustomText(
                          text: student.createdAt.toString(),
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 12),

              // =========== Buttons Row ===========
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ApproveRejectRequestCubit>().rejectRequest(
                        student.id.toString(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CustomText(text: "Reject", color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ApproveRejectRequestCubit>().approveRequest(
                        student.id.toString(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CustomText(text: "Accept", color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
