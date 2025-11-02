import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onArrowTap;
  final String? title;

  const CustomAppBar({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.onArrowTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2563EB),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Profile and Notification icons
          Row(
            children: [
              // Profile icon (SVG)
              InkWell(
                onTap: onProfileTap ?? () {},
                child: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  width: 26,
                  height: 26,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Notification icon with red dot badge (SVG)
              InkWell(
                onTap: onNotificationTap ?? () {},
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/notification.svg',
                      width: 17,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Right side: Title and Arrow icon
          Row(
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              InkWell(
                onTap: onArrowTap ?? () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  'assets/icons/arrow.svg',
                  width: 28,
                  height: 28,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(76);
}
