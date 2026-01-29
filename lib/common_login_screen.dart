import 'package:flutter/material.dart';

void main() {
  runApp(const PathologyLoginApp());
}

class PathologyLoginApp extends StatelessWidget {
  const PathologyLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pathology Login',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF137fec),
        scaffoldBackgroundColor: const Color(0xFFF6F7F8),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF137fec),
        scaffoldBackgroundColor: const Color(0xFF101922),
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      home: const PathologyLoginPage(),
    );
  }
}

class PathologyLoginPage extends StatefulWidget {
  const PathologyLoginPage({super.key});

  @override
  State<PathologyLoginPage> createState() => _PathologyLoginPageState();
}

class _PathologyLoginPageState extends State<PathologyLoginPage> {
  String selectedRole = 'User';
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final brightness = Theme.of(context).brightness;
    final textDark = Colors.black87;
    final textLight = Colors.white;
    final subTextLight = const Color(0xFF4c739a);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top App Bar
                    Row(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(Icons.chevron_left,
                              color: brightness == Brightness.light
                                  ? textDark
                                  : textLight),
                        ),
                        Expanded(
                          child: Text(
                            "Pathology Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: brightness == Brightness.light
                                  ? textDark
                                  : textLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Brand / Welcome Section
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.biotech, size: 40, color: primary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: brightness == Brightness.light
                                ? textDark
                                : textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 280,
                          child: Text(
                            "Access your diagnostic reports and lab management tools.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: brightness == Brightness.light
                                  ? subTextLight
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Role Selector
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: brightness == Brightness.light
                            ? const Color(0xFFE7EDF3)
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: ['User', 'Lab', 'Admin'].map((role) {
                          final selected = selectedRole == role;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedRole = role),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? (brightness == Brightness.light
                                      ? Colors.white
                                      : primary)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: selected
                                      ? [
                                    BoxShadow(
                                      color: primary.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                      : [],
                                ),
                                child: Text(
                                  role,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? (brightness == Brightness.light
                                        ? textDark
                                        : textLight)
                                        : brightness == Brightness.light
                                        ? subTextLight
                                        : Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Input Fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email / Phone
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(
                                "Email or Phone Number",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.mail,
                                    color: brightness == Brightness.light
                                        ? subTextLight
                                        : Colors.grey[500]),
                                hintText: "e.g. name@email.com",
                                filled: true,
                                fillColor: brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.grey[900],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: brightness == Brightness.light
                                        ? const Color(0xFFCFDBE7)
                                        : Colors.grey[700]!,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Password
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(
                                "Password",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            TextField(
                              obscureText: !passwordVisible,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock,
                                    color: brightness == Brightness.light
                                        ? subTextLight
                                        : Colors.grey[500]),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: brightness == Brightness.light
                                        ? subTextLight
                                        : Colors.grey[500],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                                hintText: "••••••••",
                                filled: true,
                                fillColor: brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.grey[900],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: brightness == Brightness.light
                                        ? const Color(0xFFCFDBE7)
                                        : Colors.grey[700]!,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(color: primary, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sign In Button
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.login),
                      label: const Text(
                        "Sign In",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadowColor: primary.withOpacity(0.2),
                        elevation: 5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: brightness == Brightness.light
                                    ? subTextLight
                                    : Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Register Now",
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // iOS Home Indicator Simulation
                        Container(
                          width: 128,
                          height: 6,
                          decoration: BoxDecoration(
                            color: brightness == Brightness.light
                                ? Colors.grey[300]
                                : Colors.grey[700],
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}