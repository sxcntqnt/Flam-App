import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/common/widget/custom_text_field.dart';
import 'package:share_plus/share_plus.dart';

class ReferralWidget extends ConsumerStatefulWidget {
  const ReferralWidget({super.key});

  @override
  ConsumerState<ReferralWidget> createState() => _ReferralWidgetState();
}

class _ReferralWidgetState extends ConsumerState<ReferralWidget> {
  final referralCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    referralCodeController.text = "RkMFucd";
  }

  @override
  void dispose() {
    referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      appBarTitle: "Referral",
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ReusableTextField(
                  readOnly: true,
                  onTap: () {},
                  suffixIcon: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.copyIcon, height: 30.hp),
                    ],
                  ),
                  hintText: "Code",
                  controller: referralCodeController,
                  title: "Refer a friend and Earn \$20",
                ),
              ),
              IconButton(
                onPressed: () {
                  _copyToClipboard(context, referralCodeController.text);
                },
                icon: const Icon(Icons.copy, color: CustomTheme.darkColor),
              ),
            ],
          ),
          CustomRoundedButtom(
            title: "Invite",
            onPressed: () async {
              await Share.share(
                'Unlock exclusive benefits by using my referral code ${referralCodeController.text} on Ride!',
              );
            },
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Text copied to clipboard')));
  }
}
