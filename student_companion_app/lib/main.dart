import 'package:flutter/material.dart';

void main() => runApp(const StudentCompanionApp());

const Color primaryColor = Color(0xFF4F46E5);
const Color pageColor = Color(0xFFF6F7FB);

class StudentData {
  static const name = 'Vidhi Patel';
  static const enrollment = '24AIML048';
  static const semester = 'V';
  static const department = 'Artificial Intelligence and Machine Learning';
}

class StudentCompanionApp extends StatelessWidget {
  const StudentCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Student Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: pageColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: pageColor,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// -------------------- SPLASH SCREEN --------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF312E81), Color(0xFF818CF8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_rounded, size: 85, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Smart Student Companion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your campus life, organized.',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 28),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- LOGIN SCREEN --------------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandIcon(),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to continue to your student space.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    const FieldLabel('Email Address'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'student@example.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(email)) {
                          return 'Enter a valid email address';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel('Password'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        hintText: 'At least 6 characters',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must contain 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Sign In',
                      onPressed: _login,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegistrationScreen(),
                              ),
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                    const Text(
                      'Demo login: no backend authentication is connected.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------- REGISTRATION SCREEN --------------------

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _enrollmentController = TextEditingController();
  final _passwordController = TextEditingController();

  String _department = 'Artificial Intelligence and Machine Learning';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _enrollmentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Join Student Companion',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const FieldLabel('Full Name'),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) =>
                          v == null || v.trim().length < 2
                              ? 'Enter your full name'
                              : null,
                    ),
                    const SizedBox(height: 14),
                    const FieldLabel('Email Address'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'student@example.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) =>
                          v == null ||
                                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                      .hasMatch(v.trim())
                              ? 'Enter a valid email'
                              : null,
                    ),
                    const SizedBox(height: 14),
                    const FieldLabel('Enrollment Number'),
                    TextFormField(
                      controller: _enrollmentController,
                      decoration: const InputDecoration(
                        hintText: '24CE001',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Enter enrollment number'
                              : null,
                    ),
                    const SizedBox(height: 14),
                    const FieldLabel('Department'),
                    DropdownButtonFormField<String>(
                      value: _department,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_balance_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Computer Engineering',
                          child: Text('Computer Engineering'),
                        ),
                        DropdownMenuItem(
                          value: 'Information Technology',
                          child: Text('Information Technology'),
                        ),
                        DropdownMenuItem(
                          value: 'Artificial Intelligence',
                          child: Text('Artificial Intelligence'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _department = value);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    const FieldLabel('Password'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'At least 6 characters',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) =>
                          v == null || v.length < 6
                              ? 'Password must contain 6 characters'
                              : null,
                    ),
                    const SizedBox(height: 22),
                    PrimaryButton(
                      label: 'Create Account',
                      onPressed: _register,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------- MAIN DASHBOARD --------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _openModule(String title) {
    final Widget page;

    switch (title) {
      case 'Courses':
        page = const CourseDashboardScreen();
        break;
      case 'Attendance':
        page = const AttendanceScreen();
        break;
      case 'Timetable':
        page = const TimetableScreen();
        break;
      case 'Assignments':
        page = const AssignmentScreen();
        break;
      case 'Notifications':
        page = const NotificationsScreen();
        break;
      case 'Faculty':
        page = const FacultyScreen();
        break;
      case 'Events':
        page = const EventGalleryScreen();
        break;
      default:
        page = const StudentProfileScreen();
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            DashboardHome(onOpenModule: _openModule),
            const StudentProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  final ValueChanged<String> onOpenModule;

  const DashboardHome({super.key, required this.onOpenModule});

  @override
  Widget build(BuildContext context) {
    final modules = [
      const ModuleData('Courses', Icons.menu_book,
          Color(0xFFE0E7FF), Color(0xFF4338CA)),
      const ModuleData('Attendance', Icons.fact_check_outlined,
          Color(0xFFDCFCE7), Color(0xFF15803D)),
      const ModuleData('Timetable', Icons.calendar_month,
          Color(0xFFEDE9FE), Color(0xFF6D28D9)),
      const ModuleData('Assignments', Icons.assignment_outlined,
          Color(0xFFFFEDD5), Color(0xFFC2410C)),
      const ModuleData('Notifications', Icons.notifications_outlined,
          Color(0xFFFEF3C7), Color(0xFF92400E)),
      const ModuleData('Faculty', Icons.groups_outlined,
          Color(0xFFDBEAFE), Color(0xFF1D4ED8)),
      const ModuleData('Events', Icons.photo_library_outlined,
          Color(0xFFFCE7F3), Color(0xFFBE185D)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1000 ? 4 : width >= 600 ? 3 : 2;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMART STUDENT COMPANION',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 11,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => onOpenModule('Notifications'),
                      icon: const Icon(Icons.notifications_none),
                    ),
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE0E7FF),
                      child: Text(
                        'RP',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3730A3), Color(0xFF818CF8)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WELCOME BACK 👋',
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 8),
                            Text(
                              StudentData.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Enrollment: 24AIML048 • Semester V',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => onOpenModule('Courses'),
                        icon: const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Academic Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width < 360 ? 1 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 120,
                ),
                delegate: SliverChildListDelegate([
                  const SummaryCard(
                    title: 'Attendance',
                    value: '91.3%',
                    icon: Icons.fact_check,
                    color: Color(0xFF059669),
                  ),
                  const SummaryCard(
                    title: 'Courses',
                    value: '04',
                    icon: Icons.menu_book,
                    color: primaryColor,
                  ),
                ]),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'Student Modules',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: width < 360 ? 1.5 : 1.15,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => DashboardCard(
                    module: modules[index],
                    onTap: () => onOpenModule(modules[index].title),
                  ),
                  childCount: modules.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// -------------------- 1. COURSE DASHBOARD --------------------

class CourseDashboardScreen extends StatelessWidget {
  const CourseDashboardScreen({super.key});

  static const courses = [
    CourseData('DBMS', 'Database Management Systems', '92%', 92),
    CourseData('MAD', 'Mobile Application Development', '88%', 88),
    CourseData('AI', 'Artificial Intelligence', '95%', 95),
    CourseData('CN', 'Computer Networks', '90%', 90),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      title: 'Course Dashboard',
      subtitle: 'Your Semester V courses',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 850
              ? 3
              : constraints.maxWidth >= 520
                  ? 2
                  : 1;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 190,
            ),
            itemBuilder: (context, index) {
              final course = courses[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFE0E7FF),
                        child: Text(
                          course.code,
                          style: const TextStyle(color: primaryColor),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        course.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text('Attendance: ${course.attendance}'),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: course.percent / 100,
                        color: primaryColor,
                        minHeight: 7,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CourseData {
  final String code;
  final String name;
  final String attendance;
  final int percent;

  const CourseData(this.code, this.name, this.attendance, this.percent);
}

// -------------------- 2. ATTENDANCE SUMMARY --------------------

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  static const subjects = [
    CourseData('DBMS', 'Database Management Systems', '92%', 92),
    CourseData('MAD', 'Mobile Application Development', '88%', 88),
    CourseData('AI', 'Artificial Intelligence', '95%', 95),
    CourseData('CN', 'Computer Networks', '90%', 90),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      title: 'Attendance Summary',
      subtitle: 'Monitor your subject-wise attendance',
      child: Column(
        children: [
          const Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFDCFCE7),
                child: Icon(Icons.fact_check, color: Colors.green),
              ),
              title: Text('Overall Attendance'),
              subtitle: Text(
                '91.3%',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...subjects.map(
            (subject) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subject.code,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          subject.attendance,
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: subject.percent / 100,
                      minHeight: 8,
                      color: primaryColor,
                      backgroundColor: const Color(0xFFE0E7FF),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        subject.name,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- 3. TIMETABLE --------------------

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  static const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  static const schedule = [
    ['DBMS', 'MAD', 'AI', 'Break', 'CN'],
    ['AI', 'DBMS', 'CN', 'Break', 'MAD'],
    ['MAD', 'CN', 'DBMS', 'Break', 'AI'],
    ['CN', 'AI', 'MAD', 'Break', 'DBMS'],
    ['DBMS', 'MAD', 'CN', 'Break', 'AI'],
  ];

  static const times = [
    '09:00–10:00',
    '10:00–11:00',
    '11:00–12:00',
    '12:00–12:30',
    '12:30–13:30',
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      title: 'Timetable',
      subtitle: 'Weekly lecture schedule',
      child: Column(
        children: List.generate(days.length, (dayIndex) {
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    days[dayIndex],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(times.length, (periodIndex) {
                    final subject = schedule[dayIndex][periodIndex];
                    final isBreak = subject == 'Break';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              times[periodIndex],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: isBreak
                                    ? const Color(0xFFF3F4F6)
                                    : const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                subject,
                                style: TextStyle(
                                  color: isBreak
                                      ? Colors.black54
                                      : primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// -------------------- 4. ASSIGNMENT LIST --------------------

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  static const assignments = [
    AssignmentData(
      'Flutter UI Design',
      'MAD',
      '20 Oct 2026',
      'In Progress',
    ),
    AssignmentData(
      'Database CRUD',
      'DBMS',
      '22 Oct 2026',
      'Pending',
    ),
    AssignmentData(
      'REST API Integration',
      'MAD',
      '25 Oct 2026',
      'Pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      title: 'Assignments',
      subtitle: 'Track your academic work and deadlines',
      child: Column(
        children: assignments.map((assignment) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE0E7FF),
                child: Icon(Icons.assignment_outlined, color: primaryColor),
              ),
              title: Text(
                assignment.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subject: ${assignment.subject}'),
                    const SizedBox(height: 4),
                    Text('Due: ${assignment.dueDate}'),
                    const SizedBox(height: 7),
                    Chip(
                      label: Text(assignment.status),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              isThreeLine: true,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AssignmentData {
  final String title;
  final String subject;
  final String dueDate;
  final String status;

  const AssignmentData(
      this.title, this.subject, this.dueDate, this.status);
}

// -------------------- 5. NOTIFICATIONS --------------------

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const notifications = [
    NoticeData(
      'Internal Exam Schedule',
      'The internal examination timetable has been announced.',
      Icons.calendar_month,
    ),
    NoticeData(
      'Assignment Deadline',
      'Submit your pending assignments before the due date.',
      Icons.assignment_outlined,
    ),
    NoticeData(
      'Technical Event Registration',
      'Registration is open for upcoming technical events.',
      Icons.campaign_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      title: 'Notifications',
      subtitle: 'Stay updated with academic announcements',
      child: Column(
        children: notifications.map((notice) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFE0E7FF),
                child: Icon(notice.icon, color: primaryColor),
              ),
              title: Text(
                notice.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(notice.message),
              ),
              isThreeLine: true,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NoticeData {
  final String title;
  final String message;
  final IconData icon;

  const NoticeData(this.title, this.message, this.icon);
}

// -------------------- 6. FACULTY INFORMATION --------------------

class FacultyScreen extends StatelessWidget {
  const FacultyScreen({super.key});

  static const faculty = [
    FacultyData(
      'Prof. Mehta',
      'Database Management Systems',
      'mehta@college.edu',
    ),
    FacultyData(
      'Prof. Shah',
      'Mobile Application Development',
      'shah@college.edu',
    ),
    FacultyData(
      'Dr. Desai',
      'Artificial Intelligence',
      'desai@college.edu',
    ),
    FacultyData(
      'Prof. Patel',
      'Computer Networks',
      'patel@college.edu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      title: 'Faculty Information',
      subtitle: 'Meet your Semester V faculty',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 850
              ? 3
              : constraints.maxWidth >= 520
                  ? 2
                  : 1;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faculty.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 200,
            ),
            itemBuilder: (context, index) {
              final person = faculty[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFE0E7FF),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        person.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        person.subject,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        person.email,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FacultyData {
  final String name;
  final String subject;
  final String email;

  const FacultyData(this.name, this.subject, this.email);
}

// -------------------- 7. EVENT GALLERY --------------------

class EventGalleryScreen extends StatelessWidget {
  const EventGalleryScreen({super.key});

  static const events = [
    EventData(
      'Tech Fest',
      'Innovation and technology showcase',
      Icons.memory,
      Color(0xFF4F46E5),
    ),
    EventData(
      'Code Sprint',
      'Competitive programming challenge',
      Icons.code,
      Color(0xFF059669),
    ),
    EventData(
      'AI Workshop',
      'Hands-on artificial intelligence session',
      Icons.smart_toy_outlined,
      Color(0xFFDB2777),
    ),
    EventData(
      'Robotics Day',
      'Robots, sensors and automation',
      Icons.precision_manufacturing,
      Color(0xFFD97706),
    ),
    EventData(
      'Cultural Night',
      'Music, dance and student performances',
      Icons.music_note,
      Color(0xFF7C3AED),
    ),
    EventData(
      'Sports Meet',
      'Annual inter-department sports',
      Icons.sports_basketball,
      Color(0xFF0284C7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      title: 'Event Gallery',
      subtitle: 'Explore campus activities and events',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 900
              ? 3
              : constraints.maxWidth >= 560
                  ? 2
                  : 1;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 220,
            ),
            itemBuilder: (context, index) {
              final event = events[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              event.color,
                              event.color.withOpacity(0.65),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -10,
                              top: -10,
                              child: Icon(
                                event.icon,
                                size: 110,
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            Center(
                              child: Icon(
                                event.icon,
                                color: Colors.white,
                                size: 55,
                              ),
                            ),
                            Positioned(
                              left: 12,
                              top: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'CAMPUS EVENT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            event.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EventData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const EventData(this.title, this.description, this.icon, this.color);
}

// -------------------- STUDENT PROFILE --------------------

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 43,
                    backgroundColor: Color(0xFFE0E7FF),
                    child: Icon(
                      Icons.person,
                      size: 52,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    StudentData.name,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('Enrollment No.: 24CE001'),
                  const SizedBox(height: 10),
                  const Chip(label: Text('Semester V')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Academic Details',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const ProfileTile(
            icon: Icons.account_balance_outlined,
            title: 'Department',
            value: StudentData.department,
          ),
          const ProfileTile(
            icon: Icons.school_outlined,
            title: 'Semester',
            value: StudentData.semester,
          ),
          const ProfileTile(
            icon: Icons.fact_check_outlined,
            title: 'Overall Attendance',
            value: '91.3%',
          ),
        ],
      ),
    );
  }
}

// -------------------- REUSABLE WIDGETS --------------------

class ResponsivePage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const ResponsivePage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth >= 900 ? 32.0 : 18.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(padding, 8, padding, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        subtitle,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 18),
                      child,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BrandIcon extends StatelessWidget {
  const BrandIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E7FF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.school,
          size: 44,
          color: primaryColor,
        ),
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ModuleData {
  final String title;
  final IconData icon;
  final Color background;
  final Color foreground;

  const ModuleData(
    this.title,
    this.icon,
    this.background,
    this.foreground,
  );
}

class DashboardCard extends StatelessWidget {
  final ModuleData module;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: module.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  module.icon,
                  color: module.foreground,
                  size: 24,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      module.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.black45,
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

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}