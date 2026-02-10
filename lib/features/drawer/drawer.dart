import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:catalyst/core/databases/cache/constant.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/utils/assets.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/features/drawer/drawer_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5F6FA),

      width: MediaQuery.of(context).size.width * 0.7,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  Assets.drawer123,
                  width: constraints.maxWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.appbar,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  const SizedBox(height: 61),
                  SvgPicture.asset(
                    Assets.catalyst,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),

                  const SizedBox(height: 82),

                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 45),
                    child: Column(
                      children: [
                        DrawerItem(
                          icon: CupertinoIcons.gear_alt_fill,
                          label: "Settings",
                          onTap: () {},
                        ),
                        const SizedBox(height: 30),
                        DrawerItem(
                          icon: CupertinoIcons.globe,
                          label: "English",
                          hasDropdown: true,
                          onTap: () {},
                        ),
                        const SizedBox(height: 30),
                        DrawerItem(
                          icon: CupertinoIcons.moon_fill,
                          label: "Dark",
                          onTap: () {},
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        // ➊ DrawerItem بيتمدد ياخد باقي المساحة
                        Expanded(
                          child: DrawerItem(
                            icon: Icons.person,
                            label: "Unknown",
                            height: 60,
                            onTap: () {}, // افتح صفحة بروفايل لو عايز
                          ),
                        ),
                        const SizedBox(width: 10),

                        // ➋ زر خروج دائري نفس ستايل الـ pills
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFDCDEE1,
                            ).withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: const Offset(0, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: AppColors.color1,
                            ),
                            iconSize: 24,
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              // =================== signOut ===================

                              await CacheHelper.removeData(
                                key: Constant.tokenKey,
                              );
                              await CacheHelper.removeData(
                                key: Constant.userKey,
                              );

                              GoRouter.of(context).go(Routs.login);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
