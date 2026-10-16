
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const StudentCompanionApp());
}

const Color primaryColor = Color(0xFF4F46E5);
const Color pageColor = Color(0xFFF6F7FB);

const List<String> semesters = [
  'Semester I', 'Semester II', 'Semester III', 'Semester IV',
  'Semester V', 'Semester VI', 'Semester VII', 'Semester VIII',
];

const List<String> departments = [
  'Computer Engineering',
  'Information Technology',
  'Artificial Intelligence and Machine Learning',
];

const List<String> languages = ['English', 'Hindi', 'Gujarati'];

const List<String> availableCourses = [
  'Mobile Application Development',
  'Artificial Intelligence',
  'Database Management System',
  'Computer Networks',
];

const List<String> moduleNames = [
  'Courses', 'Attendance', 'Timetable', 'Assignments',
  'Notifications', 'Faculty', 'Events', 'Settings',
];

const List<IconData> moduleIcons = [
  Icons.menu_book,
  Icons.fact_check_outlined,
  Icons.calendar_month,
  Icons.assignment_outlined,
  Icons.notifications_outlined,
  Icons.groups_outlined,
  Icons.photo_library_outlined,
  Icons.settings_outlined,
];

// ============================================================
// SHARED APPLICATION STATE + SHARED PREFERENCES
// ============================================================

class StudentAppScope extends InheritedWidget {
  final _StudentCompanionAppState appState;

  const StudentAppScope({
    super.key,
    required this.appState,
    required super.child,
  });

  static _StudentCompanionAppState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<StudentAppScope>();
    assert(scope != null, 'StudentAppScope not found');
    return scope!.appState;
  }

  @override
  bool updateShouldNotify(StudentAppScope oldWidget) => true;
}

// ============================================================
// APPLICATION AND PERSISTENT STATE
// ============================================================

class StudentCompanionApp extends StatefulWidget {
  const StudentCompanionApp({super.key});

  @override
  State<StudentCompanionApp> createState() =>
      _StudentCompanionAppState();
}

class _StudentCompanionAppState extends State<StudentCompanionApp> {
  bool isLoggedIn = false;
  bool isDarkMode = false;

  String studentName = 'Vidhi Patel';
  String enrollment = '24AIML048';
  String department = departments[2];
  String semester = 'Semester V';
  String language = 'English';

  bool assignmentAlerts = true;
  bool examNotifications = true;
  bool placementUpdates = true;
  bool eventAnnouncements = true;

  bool showAttendance = true;
  bool showCourses = true;

  String dashboardLayout = 'Grid';
  double textSize = 16;

  String loginEmail = '';

  final List<String> selectedCourses =
      List<String>.from(availableCourses);

  SharedPreferences? _prefs;

  // Load saved preferences when the app starts.
  Future<void> loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    isLoggedIn = _prefs!.getBool('isLoggedIn') ?? false;
    loginEmail = _prefs!.getString('loginEmail') ?? '';

    studentName = _prefs!.getString('studentName') ?? 'Vidhi Patel';
    enrollment = _prefs!.getString('enrollment') ?? '24AIML048';
    department = _prefs!.getString('department') ?? departments[2];
    semester = _prefs!.getString('semester') ?? 'Semester V';
    language = _prefs!.getString('language') ?? 'English';
    isDarkMode = _prefs!.getBool('isDarkMode') ?? false;

    assignmentAlerts = _prefs!.getBool('assignmentAlerts') ?? true;
    examNotifications = _prefs!.getBool('examNotifications') ?? true;
    placementUpdates = _prefs!.getBool('placementUpdates') ?? true;
    eventAnnouncements = _prefs!.getBool('eventAnnouncements') ?? true;

    showAttendance = _prefs!.getBool('showAttendance') ?? true;
    showCourses = _prefs!.getBool('showCourses') ?? true;

    dashboardLayout = _prefs!.getString('dashboardLayout') ?? 'Grid';
    textSize = _prefs!.getDouble('textSize') ?? 16;

    selectedCourses
      ..clear()
      ..addAll(
        _prefs!.getStringList('selectedCourses') ?? availableCourses,
      );

    if (mounted) setState(() {});
  }

  Future<void> savePreferences() async {
    _prefs ??= await SharedPreferences.getInstance();

    await _prefs!.setBool('isLoggedIn', isLoggedIn);
    await _prefs!.setString('loginEmail', loginEmail);
    await _prefs!.setString('studentName', studentName);
    await _prefs!.setString('enrollment', enrollment);
    await _prefs!.setString('department', department);
    await _prefs!.setString('semester', semester);
    await _prefs!.setString('language', language);
    await _prefs!.setBool('isDarkMode', isDarkMode);

    await _prefs!.setBool('assignmentAlerts', assignmentAlerts);
    await _prefs!.setBool('examNotifications', examNotifications);
    await _prefs!.setBool('placementUpdates', placementUpdates);
    await _prefs!.setBool('eventAnnouncements', eventAnnouncements);

    await _prefs!.setBool('showAttendance', showAttendance);
    await _prefs!.setBool('showCourses', showCourses);
    await _prefs!.setString('dashboardLayout', dashboardLayout);
    await _prefs!.setDouble('textSize', textSize);
    await _prefs!.setStringList('selectedCourses', selectedCourses);
  }

  // Demo login: only the provided credentials are accepted.
  Future<void> login(String email) async {
    loginEmail = email;
    isLoggedIn = true;
    await savePreferences();
    if (mounted) setState(() {});
  }

  Future<void> updateProfile({
    required String name,
    required String enrollmentNo,
    required String selectedDepartment,
  }) async {
    setState(() {
      studentName = name;
      enrollment = enrollmentNo;
      department = selectedDepartment;
    });
    await savePreferences();
  }

  Future<void> updateTheme(bool value) async {
    setState(() => isDarkMode = value);
    await savePreferences();
  }

  Future<void> updateSemester(String value) async {
    setState(() => semester = value);
    await savePreferences();
  }

  Future<void> updateLanguage(String value) async {
    setState(() => language = value);
    await savePreferences();
  }

  Future<void> updateNotification(String type, bool value) async {
    setState(() {
      switch (type) {
        case 'assignment':
          assignmentAlerts = value;
          break;
        case 'exam':
          examNotifications = value;
          break;
        case 'placement':
          placementUpdates = value;
          break;
        case 'event':
          eventAnnouncements = value;
          break;
      }
    });
    await savePreferences();
  }

  Future<void> updateCourse(String course, bool selected) async {
    setState(() {
      if (selected && !selectedCourses.contains(course)) {
        selectedCourses.add(course);
      } else if (!selected) {
        selectedCourses.remove(course);
      }
    });
    await savePreferences();
  }

  Future<void> updateLayout(String value) async {
    setState(() => dashboardLayout = value);
    await savePreferences();
  }

  Future<void> updateTextSize(double value) async {
    setState(() => textSize = value);
    await savePreferences();
  }

  Future<void> updateDashboardCard(String type, bool value) async {
    setState(() {
      if (type == 'attendance') {
        showAttendance = value;
      } else {
        showCourses = value;
      }
    });
    await savePreferences();
  }

  Future<void> resetPreferences() async {
    setState(() {
      isDarkMode = false;
      semester = 'Semester V';
      language = 'English';
      assignmentAlerts = true;
      examNotifications = true;
      placementUpdates = true;
      eventAnnouncements = true;
      showAttendance = true;
      showCourses = true;
      dashboardLayout = 'Grid';
      textSize = 16;
      selectedCourses
        ..clear()
        ..addAll(availableCourses);
    });
    await savePreferences();
  }

  // Logout clears the saved session and preferences.
  Future<void> logout() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.clear();

    setState(() {
      isLoggedIn = false;
      loginEmail = '';
      isDarkMode = false;
      studentName = 'Vidhi Patel';
      enrollment = '24AIML048';
      department = departments[2];
      semester = 'Semester V';
      language = 'English';
      assignmentAlerts = true;
      examNotifications = true;
      placementUpdates = true;
      eventAnnouncements = true;
      showAttendance = true;
      showCourses = true;
      dashboardLayout = 'Grid';
      textSize = 16;
      selectedCourses
        ..clear()
        ..addAll(availableCourses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Student Companion',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
      ),

      // Named routes for Practical 5.
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => SplashScreen(app: this),
        '/login': (_) => LoginScreen(app: this),
        '/register': (_) => const RegistrationScreen(),
        '/dashboard': (_) => const MainNavigationScreen(),
        '/profile': (_) => const StudentProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/courses': (_) => const ModuleScreen(title: 'Courses'),
        '/attendance': (_) => const ModuleScreen(title: 'Attendance'),
        '/timetable': (_) => const ModuleScreen(title: 'Timetable'),
        '/assignments': (_) => const ModuleScreen(title: 'Assignments'),
        '/notifications': (_) => const ModuleScreen(title: 'Notifications'),
        '/faculty': (_) => const ModuleScreen(title: 'Faculty'),
        '/events': (_) => const ModuleScreen(title: 'Events'),
      },

      // Wrap Navigator so every route can access shared application state.
      builder: (context, child) {
        return StudentAppScope(
          appState: this,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

// ============================================================
// SPLASH SCREEN: CHECK SAVED LOGIN SESSION
// ============================================================

class SplashScreen extends StatefulWidget {
  final _StudentCompanionAppState app;

  const SplashScreen({super.key, required this.app});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    await widget.app.loadPreferences();
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      widget.app.isLoggedIn ? '/dashboard' : '/login',
    );
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
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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

// ============================================================
// LOGIN SCREEN
// ============================================================

class LoginScreen extends StatefulWidget {
  final _StudentCompanionAppState app;

  const LoginScreen({super.key, required this.app});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool hidePassword = true;
  bool loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email != 'rahul.patel@charusat.edu.in' ||
        password != 'student@123') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password. Please try again.'),
        ),
      );
      return;
    }

    setState(() => loading = true);
    await widget.app.login(email);

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
      (route) => false,
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
                    const Icon(Icons.school, size: 70, color: primaryColor),
                    const SizedBox(height: 20),
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
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(email)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => hidePassword = !hidePassword);
                          },
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: loading ? null : login,
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(0, 52),
                      ),
                      child: Text(loading ? 'Signing in...' : 'Sign In'),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: const Text('Create a new account'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Demo credentials:\n'
                      'rahul.patel@charusat.edu.in\n'
                      'student@123',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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

// ============================================================
// REGISTRATION SCREEN
// ============================================================

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final enrollmentController = TextEditingController();
  final passwordController = TextEditingController();

  String department = departments[2];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    enrollmentController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Join Student Companion',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (v) =>
                  v == null || v.trim().length < 2 ? 'Enter your name' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              validator: (v) =>
                  v == null ||
                          !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(v.trim())
                      ? 'Enter a valid email'
                      : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: enrollmentController,
              decoration:
                  const InputDecoration(labelText: 'Enrollment Number'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Enter enrollment number'
                  : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: department,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Department'),
              items: departments
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => department = v);
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (v) => v == null || v.length < 6
                  ? 'Minimum 6 characters required'
                  : null,
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                final app = StudentAppScope.of(context);

                await app.updateProfile(
                  name: nameController.text.trim(),
                  enrollmentNo: enrollmentController.text.trim(),
                  selectedDepartment: department,
                );

                await app.login(emailController.text.trim());

                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                  (route) => false,
                );
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DRAWER NAVIGATION
// ============================================================

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final app = StudentAppScope.of(context);

    final drawerItems = <List<String>>[
      ['Dashboard', '/dashboard'],
      ['Profile', '/profile'],
      ['Courses', '/courses'],
      ['Attendance', '/attendance'],
      ['Timetable', '/timetable'],
      ['Assignments', '/assignments'],
      ['Notifications', '/notifications'],
      ['Faculty', '/faculty'],
      ['Events', '/events'],
      ['Settings', '/settings'],
    ];

    final drawerIcons = <IconData>[
      Icons.dashboard,
      Icons.person,
      Icons.menu_book,
      Icons.fact_check,
      Icons.calendar_month,
      Icons.assignment,
      Icons.notifications,
      Icons.groups,
      Icons.event,
      Icons.settings,
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(app.studentName),
            accountEmail: Text(app.loginEmail),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 36),
            ),
          ),
          for (int i = 0; i < drawerItems.length; i++)
            ListTile(
              leading: Icon(drawerIcons[i]),
              title: Text(drawerItems[i][0]),
              onTap: () {
                Navigator.pop(context);
                if (drawerItems[i][1] == '/dashboard') {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard',
                    (route) => false,
                  );
                } else {
                  Navigator.pushNamed(context, drawerItems[i][1]);
                }
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              await app.logout();

              if (!context.mounted) return;

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MAIN BOTTOM NAVIGATION
// ============================================================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          DashboardScreen(),
          StudentProfileScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
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
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = StudentAppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      drawer: const StudentDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = app.dashboardLayout == 'List'
              ? 1
              : constraints.maxWidth >= 850
                  ? 4
                  : constraints.maxWidth >= 550
                      ? 3
                      : 2;

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3730A3), Color(0xFF818CF8)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WELCOME BACK 👋',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      app.studentName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: app.textSize + 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${app.enrollment} • ${app.semester}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      app.department,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Academic Overview',
                style: TextStyle(
                  fontSize: app.textSize + 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (app.showAttendance)
                const SummaryCard(
                  title: 'Attendance',
                  value: '91.3%',
                  icon: Icons.fact_check,
                ),
              if (app.showCourses)
                SummaryCard(
                  title: 'Selected Courses',
                  value: '${app.selectedCourses.length}',
                  icon: Icons.menu_book,
                ),
              const SizedBox(height: 18),
              Text(
                'Student Modules',
                style: TextStyle(
                  fontSize: app.textSize + 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: moduleNames.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: app.dashboardLayout == 'List' ? 3 : 1.15,
                ),
                itemBuilder: (context, index) {
                  final title = moduleNames[index];
                  final route = <String>[
                    '/courses',
                    '/attendance',
                    '/timetable',
                    '/assignments',
                    '/notifications',
                    '/faculty',
                    '/events',
                    '/settings',
                  ][index];

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, route),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              moduleIcons[index],
                              color: primaryColor,
                              size: 30,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: app.textSize - 2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: primaryColor, size: 32),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// STUDENT PROFILE
// ============================================================

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = StudentAppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      drawer: const StudentDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Color(0xFFE0E7FF),
                    child: Icon(Icons.person, size: 48, color: primaryColor),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    app.studentName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Enrollment: ${app.enrollment}'),
                  const SizedBox(height: 8),
                  Chip(label: Text(app.semester)),
                ],
              ),
            ),
          ),
          ProfileTile(
            title: 'Department',
            value: app.department,
            icon: Icons.account_balance_outlined,
          ),
          ProfileTile(
            title: 'Semester',
            value: app.semester,
            icon: Icons.school_outlined,
          ),
          ProfileTile(
            title: 'Preferred Language',
            value: app.language,
            icon: Icons.language,
          ),
          ProfileTile(
            title: 'Selected Courses',
            value: '${app.selectedCourses.length}',
            icon: Icons.menu_book,
          ),
          ProfileTile(
            title: 'Login Email',
            value: app.loginEmail,
            icon: Icons.email_outlined,
          ),
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ProfileTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}

// ============================================================
// SETTINGS SCREEN
// ============================================================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _enrollmentController = TextEditingController();

  String? _department;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final app = StudentAppScope.of(context);
      _nameController.text = app.studentName;
      _enrollmentController.text = app.enrollment;
      _department = app.department;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _enrollmentController.dispose();
    super.dispose();
  }

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentAppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Student Settings')),
      drawer: const StudentDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Personalize your campus experience.',
            style: TextStyle(color: Colors.grey),
          ),

          sectionTitle('Student Profile', Icons.person_outline),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _enrollmentController,
                    decoration: const InputDecoration(
                      labelText: 'Enrollment Number',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _department,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Department'),
                    items: departments
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _department = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        if (_nameController.text.trim().isEmpty ||
                            _enrollmentController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please complete all profile fields.'),
                            ),
                          );
                          return;
                        }

                        await state.updateProfile(
                          name: _nameController.text.trim(),
                          enrollmentNo: _enrollmentController.text.trim(),
                          selectedDepartment: _department ?? departments[2],
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile saved successfully!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          sectionTitle('Theme Selection', Icons.palette_outlined),
          Card(
            child: SwitchListTile(
              secondary: Icon(
                state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(
                state.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
              ),
              value: state.isDarkMode,
              onChanged: state.updateTheme,
            ),
          ),

          sectionTitle('Semester Selection', Icons.school_outlined),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<String>(
                value: state.semester,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Choose Semester'),
                items: semesters
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) state.updateSemester(value);
                },
              ),
            ),
          ),

          sectionTitle('Language Selection', Icons.language),
          Card(
            child: Column(
              children: languages
                  .map(
                    (item) => RadioListTile<String>(
                      title: Text(item),
                      value: item,
                      groupValue: state.language,
                      onChanged: (value) {
                        if (value != null) state.updateLanguage(value);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),

          sectionTitle(
            'Notification Preferences',
            Icons.notifications_active_outlined,
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Assignment Alerts'),
                  value: state.assignmentAlerts,
                  onChanged: (v) => state.updateNotification('assignment', v),
                ),
                SwitchListTile(
                  title: const Text('Examination Notifications'),
                  value: state.examNotifications,
                  onChanged: (v) => state.updateNotification('exam', v),
                ),
                SwitchListTile(
                  title: const Text('Placement Updates'),
                  value: state.placementUpdates,
                  onChanged: (v) => state.updateNotification('placement', v),
                ),
                SwitchListTile(
                  title: const Text('Event Announcements'),
                  value: state.eventAnnouncements,
                  onChanged: (v) => state.updateNotification('event', v),
                ),
              ],
            ),
          ),

          sectionTitle('Course Preferences', Icons.menu_book_outlined),
          Card(
            child: Column(
              children: availableCourses
                  .map(
                    (course) => CheckboxListTile(
                      title: Text(course),
                      value: state.selectedCourses.contains(course),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        state.updateCourse(course, value ?? false);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),

          sectionTitle('Dashboard Customization', Icons.dashboard_customize),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard Layout',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  RadioListTile<String>(
                    title: const Text('Grid Layout'),
                    value: 'Grid',
                    groupValue: state.dashboardLayout,
                    onChanged: (value) {
                      if (value != null) state.updateLayout(value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('List Layout'),
                    value: 'List',
                    groupValue: state.dashboardLayout,
                    onChanged: (value) {
                      if (value != null) state.updateLayout(value);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Show Attendance'),
                    value: state.showAttendance,
                    onChanged: (v) => state.updateDashboardCard('attendance', v),
                  ),
                  SwitchListTile(
                    title: const Text('Show Courses'),
                    value: state.showCourses,
                    onChanged: (v) => state.updateDashboardCard('courses', v),
                  ),
                  const SizedBox(height: 12),
                  Text('Dashboard Text Size: ${state.textSize.round()}'),
                  Slider(
                    value: state.textSize,
                    min: 12,
                    max: 24,
                    divisions: 6,
                    label: state.textSize.round().toString(),
                    onChanged: state.updateTextSize,
                  ),
                  Text(
                    'Live preview of dashboard text.',
                    style: TextStyle(fontSize: state.textSize),
                  ),
                ],
              ),
            ),
          ),

          sectionTitle('Current Preferences', Icons.check_circle_outline),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${state.studentName}'),
                  Text('Enrollment: ${state.enrollment}'),
                  Text('Department: ${state.department}'),
                  Text('Semester: ${state.semester}'),
                  Text('Language: ${state.language}'),
                  Text('Theme: ${state.isDarkMode ? 'Dark' : 'Light'}'),
                  Text('Layout: ${state.dashboardLayout}'),
                  Text('Selected courses: ${state.selectedCourses.length}'),
                  Text(
                    'Enabled notifications: '
                    '${[
                      state.assignmentAlerts,
                      state.examNotifications,
                      state.placementUpdates,
                      state.eventAnnouncements,
                    ].where((v) => v).length} of 4',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () async {
              await state.savePreferences();

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preferences saved successfully!'),
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Save Preferences'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await state.resetPreferences();

              _nameController.text = state.studentName;
              _enrollmentController.text = state.enrollment;
              setState(() => _department = state.department);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preferences reset.')),
              );
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset Preferences'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await state.logout();

              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ============================================================
// OTHER STUDENT MODULES
// ============================================================

class ModuleScreen extends StatelessWidget {
  final String title;

  const ModuleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final descriptions = <String, List<String>>{
      'Courses': availableCourses,
      'Attendance': [
        'Database Management System — 92%',
        'Mobile Application Development — 88%',
        'Artificial Intelligence — 95%',
        'Computer Networks — 90%',
      ],
      'Timetable': [
        '09:00–10:00  Database Management System',
        '10:00–11:00  Mobile Application Development',
        '11:00–12:00  Artificial Intelligence',
        '12:00–12:30  Break',
        '12:30–13:30  Computer Networks',
      ],
      'Assignments': [
        'Flutter UI Design — 20 Oct 2026',
        'Database CRUD — 22 Oct 2026',
        'REST API Integration — 25 Oct 2026',
      ],
      'Notifications': [
        'Internal examination timetable announced.',
        'Submit pending assignments before the due date.',
        'Technical event registration is open.',
      ],
      'Faculty': [
        'Prof. Mehta — Database Management System',
        'Prof. Shah — Mobile Application Development',
        'Dr. Desai — Artificial Intelligence',
        'Prof. Patel — Computer Networks',
      ],
      'Events': [
        'Tech Fest',
        'Code Sprint',
        'AI Workshop',
        'Robotics Day',
        'Cultural Night',
        'Sports Meet',
      ],
    };

    final items = descriptions[title] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const StudentDrawer(),
      body: items.isEmpty
          ? const Center(child: Text('No information available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE0E7FF),
                      child: Icon(
                        title == 'Attendance'
                            ? Icons.fact_check_outlined
                            : title == 'Assignments'
                                ? Icons.assignment_outlined
                                : title == 'Notifications'
                                    ? Icons.notifications_outlined
                                    : title == 'Faculty'
                                        ? Icons.person_outline
                                        : title == 'Events'
                                            ? Icons.event
                                            : title == 'Timetable'
                                                ? Icons.calendar_month
                                                : Icons.menu_book,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(items[index]),
                  ),
                );
              },
            ),
    );
  }
}
