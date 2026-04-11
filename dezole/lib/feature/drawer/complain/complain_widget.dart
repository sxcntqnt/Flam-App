import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/common_dropdown_box.dart';
import 'package:dezole/common/widget/common_popup_box.dart';
import 'package:dezole/common/widget/custom_text_field.dart';
import 'package:dezole/common/widget/form_validator.dart';
import 'package:dezole/feature/dashboard/dashboard_widget.dart';
import 'package:dezole/feature/drawer/complain/providers/complain_provider.dart';

class ComplainWidget extends ConsumerStatefulWidget {
  const ComplainWidget({super.key});

  @override
  ConsumerState<ComplainWidget> createState() => _ComplainWidgetState();
}

class _ComplainWidgetState extends ConsumerState<ComplainWidget> {
  final topicController = TextEditingController();
  final complainController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> topicList = [
    'Late Arrival',
    'Poor Navigation',
    'Vehicle Condition',
    'Driver Behavior',
    'Fare Dispute',
    'Safety Concerns',
    'App Malfunction',
    'Billing Issue',
  ];

  @override
  void dispose() {
    topicController.dispose();
    complainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final complainState = ref.watch(complainProvider);

    return Form(
      key: _formKey,
      child: CommonContainer(
        buttonName: complainState.isSubmitting ? "Sending..." : "Proceed",
        appBarTitle: "Complain",
        onButtonPressed: () async {
          if (_formKey.currentState!.validate()) {
            ref.read(complainProvider.notifier).setTopic(topicController.text);
            ref
                .read(complainProvider.notifier)
                .setDescription(complainController.text);
            final success = await ref.read(complainProvider.notifier).submit();
            if (success && context.mounted) {
              showCommonPopUpDialog(
                context: context,
                message: "Your complaint has been sent successfully",
                title: "Send successful",
                onEnablePressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardWidget(),
                    ),
                  );
                },
                imageUrl: Assets.successAlertImage,
                enableButtonName: "Done",
              );
            }
          }
        },
        body: Column(
          children: [
            ReusableTextField(
              suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
              controller: topicController,
              hintText: "Topic",
              readOnly: true,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return "Please select your category";
                }
                return null;
              },
              onTap: () {
                showPopUpMenuWithItems(
                  context: context,
                  title: "Select",
                  onItemPressed: (p0) {
                    topicController.text = p0;
                  },
                  dataItems: topicList,
                );
              },
            ),
            ReusableTextField(
              controller: complainController,
              validator: (p0) =>
                  FormValidator.validateFieldNotEmpty(p0, "This Field"),
              textInputType: TextInputType.multiline,
              hintText: "Write your complain here (minimum 10 characters)",
            ),
          ],
        ),
      ),
    );
  }
}
