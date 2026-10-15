import 'package:flutter/material.dart';

void main() {
  runApp(const StudentCompanionApp());
}

const Color primaryColor = Color(0xFF4F46E5);

class StudentCompanionApp extends StatelessWidget {
  const StudentCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F7FB),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// Sample student information
class StudentData {
  static const name = 'Vidhi Patel';
  static const id = '24AIML048';
  static const department = 'Artificial Intelligence and Machine Learning';
  static const semester = 'V';
  static const attendance = '91%';
  static const subjects = ['MAD', 'DBMS', 'AI', 'CN'];
}

// 1. Splash Screen - StatelessWidget UI with timed navigation
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
            colors: [Color(0xFF312E81), Color(0xFF6366F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school_rounded,
                  size: 86, color: Colors.white),
              const SizedBox(height: 22),
              const Text(
                'Student Companion',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your campus life, organized.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Login Screen with validation
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
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandIcon(),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome back!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to continue to your student space.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 28),
                    const FieldLabel('Email address'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Please enter your email';
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
                        hintText: 'Enter password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(_hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must contain at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(label: 'Sign In', onPressed: _login),
                    const SizedBox(height: 18),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegistrationScreen(),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Demo only: no backend authentication is connected.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.black45),
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

// 3. Registration Screen with form validation
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  String _department = 'Computer Engineering';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration form validated successfully')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
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
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 22),
                    const FieldLabel('Full name'),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().length < 2)
                              ? 'Enter your full name'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Email address'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(value.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const FieldLabel('Student ID'),
                    TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. 24CE001',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Enter your student ID'
                              : null,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    const FieldLabel('Password'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'At least 6 characters',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) =>
                          (value == null || value.length < 6)
                              ? 'Password must contain at least 6 characters'
                              : null,
                    ),
                    const SizedBox(height: 24),
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

// 4. Student Dashboard
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardHome(
        onOpenProfile: () => setState(() => _selectedIndex = 1),
      ),
      const StudentProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
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
  final VoidCallback onOpenProfile;

  const DashboardHome({super.key, required this.onOpenProfile});

  @override
  Widget build(BuildContext context) {
    final modules = [
      const DashboardModule('Attendance', Icons.fact_check_outlined,
          Color(0xFFE0F2FE), Color(0xFF0369A1)),
      const DashboardModule('Timetable', Icons.calendar_month_outlined,
          Color(0xFFEDE9FE), Color(0xFF6D28D9)),
      const DashboardModule('Assignments', Icons.assignment_outlined,
          Color(0xFFFFEDD5), Color(0xFFC2410C)),
      const DashboardModule('Notes', Icons.menu_book_outlined,
          Color(0xFFDCFCE7), Color(0xFF15803D)),
      const DashboardModule('Events', Icons.event_outlined,
          Color(0xFFFCE7F3), Color(0xFFBE185D)),
      const DashboardModule('Notifications', Icons.notifications_outlined,
          Color(0xFFFEF3C7), Color(0xFF92400E)),
      const DashboardModule('Settings', Icons.settings_outlined,
          Color(0xFFE5E7EB), Color(0xFF374151)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 3 : 2;

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
                            'STUDENT COMPANION',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showMessage(context, 'No new alerts'),
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE0E7FF),
                      child: Text('RP',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: StudentWelcomeCard(onProfileTap: onOpenProfile),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Academic Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Row(
                  children: const [
                    Expanded(
                      child: SummaryCard(
                        title: 'Attendance',
                        value: '91%',
                        subtitle: 'Good progress',
                        icon: Icons.fact_check_outlined,
                        color: Color(0xFF059669),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Subjects',
                        value: '04',
                        subtitle: 'Enrolled courses',
                        icon: Icons.menu_book_outlined,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'Student Modules',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => DashboardCard(
                    module: modules[index],
                    onTap: () => _showMessage(
                      context,
                      '${modules[index].title} selected',
                    ),
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

// 5. Student Profile Screen
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xFFE0E7FF),
                      child: Icon(Icons.person,
                          size: 52, color: primaryColor),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      StudentData.name,
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text('Student ID: ${StudentData.id}',
                        style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 12),
                    const Chip(label: Text('Semester V')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Academic Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ProfileDetailTile(
              icon: Icons.account_balance_outlined,
              title: 'Department',
              value: StudentData.department,
            ),
            const ProfileDetailTile(
              icon: Icons.fact_check_outlined,
              title: 'Attendance',
              value: StudentData.attendance,
            ),
            const ProfileDetailTile(
              icon: Icons.school_outlined,
              title: 'Semester',
              value: StudentData.semester,
            ),
            const SizedBox(height: 18),
            const Text(
              'Subjects',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: StudentData.subjects
                  .map((subject) => Chip(
                        avatar: const Icon(Icons.book_outlined, size: 17),
                        label: Text(subject),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable widget: app logo
class BrandIcon extends StatelessWidget {
  const BrandIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E7FF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.school, size: 44, color: primaryColor),
      ),
    );
  }
}

// Reusable widget: form label
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

// Reusable widget: primary action button
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
      height: 52,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// Reusable widget: student welcome card
class StudentWelcomeCard extends StatelessWidget {
  final VoidCallback onProfileTap;

  const StudentWelcomeCard({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4338CA), Color(0xFF6366F1)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WELCOME BACK 👋',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  StudentData.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Semester V • Computer Engineering',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'View profile',
            onPressed: onProfileTap,
            icon: const Icon(Icons.arrow_circle_right_outlined,
                size: 38, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Reusable widget: academic summary card
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 12),
            Text(value,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

// Reusable widget: dashboard module data
class DashboardModule {
  final String title;
  final IconData icon;
  final Color background;
  final Color foreground;

  const DashboardModule(
      this.title, this.icon, this.background, this.foreground);
}

// Reusable widget: interactive dashboard card
class DashboardCard extends StatelessWidget {
  final DashboardModule module;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
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
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: module.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(module.icon,
                    color: module.foreground, size: 25),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      module.title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 12, color: Colors.black45),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable widget: profile information
class ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileDetailTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(title,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        subtitle: Text(
          value,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87),
        ),
      ),
    );
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
