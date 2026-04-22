import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dezole/app/text_style.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/utils/size_utils.dart';
import 'package:dezole/common/widget/common_container.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/feature/dashboard/wallet/add_money_widget.dart';
import 'package:dezole/feature/dashboard/wallet/providers/wallet_provider.dart';

class WalletWidget extends ConsumerWidget {
  const WalletWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);

    return CommonContainer(
      appBarTitle: "Wallet",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: SizeUtils.width / 3,
              child: CustomRoundedButtom(
                fontWeight: FontWeight.w500,
                title: "Add Money",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddMoneyWidget(),
                    ),
                  );
                },
                borderColor: CustomTheme.appColor,
                color: Colors.transparent,
                textColor: CustomTheme.appColor,
              ),
            ),
          ),
          SizedBox(height: 10.hp),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: SizeUtils.width / 3,
                  decoration: BoxDecoration(
                    color: CustomTheme.appColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CustomTheme.appColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "\$${walletState.availableBalance.toStringAsFixed(0)}",
                        style: PoppinsTextStyles.titleMediumRegular,
                      ),
                      Text(
                        "Available Balance",
                        style: PoppinsTextStyles.subheadSmallRegular.copyWith(
                          color: CustomTheme.darkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30.wp),
              Expanded(
                child: Container(
                  height: SizeUtils.width / 3,
                  decoration: BoxDecoration(
                    color: CustomTheme.appColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CustomTheme.appColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "\$${walletState.totalExpenditure.toStringAsFixed(0)}",
                        style: PoppinsTextStyles.titleMediumRegular,
                      ),
                      Text(
                        "Total Expend",
                        style: PoppinsTextStyles.subheadSmallRegular.copyWith(
                          color: CustomTheme.darkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.hp),
          Text(
            "Transaction",
            style: PoppinsTextStyles.subheadLargeRegular.copyWith(
              fontWeight: FontWeight.w600,
              color: CustomTheme.darkColor,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: walletState.transactions.length,
            itemBuilder: (context, index) {
              final tx = walletState.transactions[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CustomTheme.appColor.withValues(alpha: 0.5),
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tx.isCredit
                          ? const Color(0xFFC8E6C9)
                          : const Color(0xFFFFCDD2),
                    ),
              child: SvgPicture.asset(
                tx.isCredit ? Assets.upIcon : Assets.downIcon,
                colorFilter: ColorFilter.mode(
                  tx.isCredit
                      ? const Color(0xFF388E3D)
                      : const Color(0xFFD32F2F),
                  BlendMode.srcIn,
                ),
              ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.name,
                        style: PoppinsTextStyles.subheadLargeRegular.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CustomTheme.darkColor,
                        ),
                      ),
                      Text(
                        tx.date,
                        style: PoppinsTextStyles.bodyMediumRegular.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    "${tx.isCredit ? "" : "-"}\$${tx.amount.toStringAsFixed(0)}",
                    style: PoppinsTextStyles.subheadLargeRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CustomTheme.darkColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
