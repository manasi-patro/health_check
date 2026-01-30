import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  Map<String, dynamic>? config;
  String selectedRole = '';
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  Future<void> loadConfig() async {
    final String response =
    await rootBundle.loadString('assets/common_login_screen.json');
    setState(() {
      config = json.decode(response);
      selectedRole = config!['roles'][0];
    });
  }

  Icon getIcon(String iconName) {
    switch (iconName) {
      case 'mail':
        return const Icon(Icons.mail);
      case 'lock':
        return const Icon(Icons.lock);
      case 'login':
        return const Icon(Icons.login);
      case 'biotech':
        return const Icon(Icons.biotech, color: Color(0xFF137fec)); // blue color
      default:
        return const Icon(Icons.help);
    }
  }


  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final brightness = Theme.of(context).brightness;
    final textDark = Colors.black87;
    final textLight = Colors.white;
    final subTextLight = const Color(0xFF4c739a);

    if (config == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                      config!['app_title'],
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
                    child: getIcon('biotech'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    config!['welcome']['title'],
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
                      config!['welcome']['subtitle'],
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
                  children: List.generate(config!['roles'].length, (index) {
                    final role = config!['roles'][index];
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
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Input Fields
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(config!['fields'].length, (index) {
                  final field = config!['fields'][index];
                  final bool isPassword = field['isPassword'] ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field['label'],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          obscureText: isPassword && !passwordVisible,
                          decoration: InputDecoration(
                            prefixIcon: getIcon(field['icon']),
                            suffixIcon: isPassword
                                ? IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () => setState(
                                      () => passwordVisible = !passwordVisible),
                            )
                                : null,
                            hintText: field['hint'],
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
                        if (field['forgotPassword'] == true)
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
                  );
                }),
              ),

              // Sign In Button
              ElevatedButton.icon(
                onPressed: () {},
                icon: getIcon(config!['sign_in_button']['icon']),
                label: Text(
                  config!['sign_in_button']['text'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  shadowColor: primary.withOpacity(0.2),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 24),

// Footer: Register
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
                        onPressed: () {
                          // Handle register navigation
                        },
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

                  // Optional iOS-style home indicator
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
      ),
    );
  }
}
