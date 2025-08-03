import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/course_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Consumer2<CourseViewModel, CartViewModel>(
        builder: (context, courseViewModel, cartViewModel, child) {
          if (courseViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (courseViewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading courses',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    courseViewModel.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      courseViewModel.loadCourses();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Search and Filter Section
              Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search courses...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        courseViewModel.setSearchQuery(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected:
                                courseViewModel.selectedDay.isEmpty &&
                                courseViewModel.selectedTime.isEmpty,
                            onSelected: (selected) {
                              if (selected) {
                                courseViewModel.clearFilters();
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          ...AppConstants.daysOfWeek.map(
                            (day) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(day),
                                selected: courseViewModel.selectedDay == day,
                                onSelected: (selected) {
                                  courseViewModel.setSelectedDay(
                                    selected ? day : '',
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...AppConstants.timeSlots.map(
                            (time) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(time),
                                selected: courseViewModel.selectedTime == time,
                                onSelected: (selected) {
                                  courseViewModel.setSelectedTime(
                                    selected ? time : '',
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Course List
              Expanded(
                child: courseViewModel.courses.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center_outlined,
                              size: 64,
                              color: AppTheme.textSecondaryColor,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No courses available',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                        ),
                        itemCount: courseViewModel.courses.length,
                        itemBuilder: (context, index) {
                          final course = courseViewModel.courses[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CourseDetailScreen(course: course),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.self_improvement,
                                            color: AppTheme.primaryColor,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course.courseName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Instructor: ${course.instructorName}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Schedule: ${course.weeklySchedule}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '\$${course.coursePrice}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${course.sessionDuration} minutes',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 14,
                                                  color: AppTheme
                                                      .textSecondaryColor,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  course.classTime,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: AppTheme
                                                            .textSecondaryColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (course
                                        .courseDescription
                                        .isNotEmpty) ...[
                                      Text(
                                        course.courseDescription,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CourseDetailScreen(
                                                        course: course,
                                                      ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.info_outline,
                                            ),
                                            label: const Text('Details'),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              await cartViewModel
                                                  .addCourseToCart(course);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Course added to cart!',
                                                    ),
                                                    backgroundColor:
                                                        AppTheme.successColor,
                                                  ),
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.add_shopping_cart,
                                            ),
                                            label: const Text('Book'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Course stats
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.event,
                                          size: 16,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${courseViewModel.getSessionCountForCourse(course.courseId)} sessions',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppTheme.textSecondaryColor,
                                              ),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(
                                          Icons.people,
                                          size: 16,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Max ${course.maxStudents} students',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppTheme.textSecondaryColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
