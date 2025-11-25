import 'package:catalyst/features/student%20requests/presentation/cubits/approve%20reject%20request/approve_reject_request_cubit.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/approve%20reject%20request/approve_reject_request_state.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/get%20students%20requests%20cubit/get_students_requests_cubit.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/get%20students%20requests%20cubit/get_students_requests_state.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/features/student requests/presentation/widgets/student_request_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRequestsView extends StatefulWidget {
  const StudentRequestsView({super.key});

  @override
  State<StudentRequestsView> createState() => _StudentRequestsViewState();
}

class _StudentRequestsViewState extends State<StudentRequestsView> {
  @override
  void initState() {
    super.initState();
    context.read<GetStudentsRequestsCubit>().getStudentsRequests();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetStudentsRequestsCubit, GetStudentsRequestsState>(
            listener: (context, state) {
              if (state is GetStudentsRequestsError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<ApproveRejectRequestCubit, ApproveRejectRequestState>(
            listener: (context, state) {
              if (state is ApproveRejectRequestSuccess) {
                // ✅ بعد الموافقة أو الرفض
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                // اعمل تحديث للطلبات
                context.read<GetStudentsRequestsCubit>().getStudentsRequests();
              } else if (state is ApproveRejectRequestError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: BlocBuilder<GetStudentsRequestsCubit, GetStudentsRequestsState>(
          builder: (context, state) {
            if (state is GetStudentsRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetStudentsRequestsSuccess) {
              final requests = state.studentRequests;
              if (requests.isEmpty) {
                return const Center(child: Text("No pending requests"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final student = requests[index];
                  return StudentRequestItem(student: student);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
