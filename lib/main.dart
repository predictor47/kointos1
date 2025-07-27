import 'package:flutter/material.dart';
import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/kointos_amplify_config.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/presentation/screens/auth_screen.dart';
import 'package:kointos/presentation/screens/adaptive_main_screen.dart';
import 'package:kointos/presentation/widgets/first_time_tutorial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator
  await setupServiceLocator();

  // Configure Amplify
  await KointosAmplifyConfig.configureAmplify();

  runApp(const KointosApp());
}

class KointosApp extends StatelessWidget {
  const KointosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kointos',
      theme: AppTheme.darkTheme,
      home: const AppEntryPoint(),
    );
  }
}

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  final _authService = getService<AuthService>();
  bool _isLoading = true;
  bool _isAuthenticated = false;
  StreamSubscription<AuthHubEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initAuthListener();
    _checkAuthStatus();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _initAuthListener() {
    // Listen to Amplify auth events
    _authSubscription =
        Amplify.Hub.listen(HubChannel.Auth, (AuthHubEvent event) {
      switch (event.type) {
        case AuthHubEventType.signedIn:
        case AuthHubEventType.signedOut:
        case AuthHubEventType.sessionExpired:
          _checkAuthStatus();
          break;
        default:
          break;
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      if (mounted) {
        setState(() {
          _isAuthenticated = isAuthenticated;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    }
  }

  void _onAuthStateChanged() {
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: FirstTimeTutorial(
        child: _isAuthenticated
            ? const AdaptiveMainScreen()
            : AuthScreen(onAuthStateChanged: _onAuthStateChanged),
      ),
    );
  }
}
