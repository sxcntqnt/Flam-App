import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/common_list_tile.dart';
import 'package:dezole/common/widget/common_popup_box.dart';
import 'package:dezole/common/widget/custom_text_field.dart';
import 'package:dezole/common/widget/form_validator.dart';
import 'package:dezole/feature/dashboard/dashboard_widget.dart';
import 'package:dezole/feature/dashboard/wallet/providers/wallet_provider.dart';

class AddMoneyWidget extends ConsumerStatefulWidget {
  const AddMoneyWidget({super.key});

  @override
  ConsumerState<AddMoneyWidget> createState() => _AddMoneyWidgetState();
}

class _AddMoneyWidgetState extends ConsumerState<AddMoneyWidget> {
  final _amountController = TextEditingController();
  int _currentIndex = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CommonContainer(
        appBarTitle: "Add Money",
        buttonName: "Confirm",
        onButtonPressed: () {
          if (_formKey.currentState!.validate()) {
            final amount = double.tryParse(_amountController.text) ?? 0;
            ref.read(walletProvider.notifier).addMoney(amount);
            showCommonPopUpDialog(
              imageUrl: Assets.successAlertImage,
              context: context,
              title: "\$${_amountController.text} Add Success",
              message: "Your money has been added successfully",
              enableButtonName: "Done",
              onEnablePressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardWidget(),
                  ),
                  (route) => false,
                );
              },
            );
          }
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _amountController,
              hintText: "Enter Amount",
              textInputType: TextInputType.number,
              validator: (value) => FormValidator.validateAmount(
                val: value.toString(),
                minAmount: 10,
                maxAmount: 5000,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Select Payment Method",
                style: PoppinsTextStyles.subheadLargeRegular.copyWith(
                  fontWeight: FontWeight.w500,
                  color: CustomTheme.darkColor,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: walletDataList.length,
              itemBuilder: (context, index) => Opacity(
                opacity: _currentIndex == index ? 1 : 0.5,
                child: CustomListTile(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  leading: Image.asset(
                    walletDataList[index]["image"],
                    height: 30.hp,
                  ),
                  title: walletDataList[index]["title"],
                  subtitle: walletDataList[index]["subtitle"],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const List<Map<String, dynamic>> walletDataList = [
    {
      "title": "**** **** **** 8970",
      "image": Assets.visaLogo,
      "subtitle": "Expires: 12/26",
    },
    {
      "title": "**** **** **** 7870",
      "image": Assets.masterCardLogo,
      "subtitle": "Expires: 12/26",
    },
    {
      "title": "mailaddress@mail.com",
      "image": Assets.paypalLogo,
      "subtitle": "Expires: 12/26",
    },
    {
      "image": Assets.cashAppLogo,
      "title": "Cash",
      "subtitle": "Expires: 12/26",
    },
  ];
}
