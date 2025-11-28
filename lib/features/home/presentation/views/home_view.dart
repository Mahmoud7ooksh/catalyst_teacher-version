import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/core/widgets/custom_box.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const CustomText(text: '  Upcoming Lessons', fontSize: 29),
            const SizedBox(height: 10),

            CarouselSlider(
              options: CarouselOptions(
                height: 190,
                aspectRatio: 16 / 9,
                viewportFraction: 0.85,
                enableInfiniteScroll: true,
                reverse: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
                padEnds: true,
              ),
              items: [
                ScheduleCard(
                  subject: 'Math',
                  time: '10:00 AM - 11:00 AM',
                  day: 'Monday',
                ),
                ScheduleCard(
                  subject: 'Math',
                  time: '10:00 AM - 11:00 AM',
                  day: 'Monday',
                ),
                ScheduleCard(
                  subject: 'Math',
                  time: '10:00 AM - 11:00 AM',
                  day: 'Monday',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String subject;
  final String time;
  final String day;

  const ScheduleCard({
    super.key,
    required this.subject,
    required this.time,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBox(
      shadowOffset: const Offset(0, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: subject,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: Colors.black),
                    const SizedBox(width: 5),
                    CustomText(text: '22', color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const Divider(color: Colors.black, thickness: 1),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: time, fontSize: 13, color: Colors.black),
              CustomText(text: day, fontSize: 13, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
