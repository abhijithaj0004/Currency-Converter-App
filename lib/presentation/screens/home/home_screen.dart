import 'package:currency_converter/bloc/app_bloc.dart';
import 'package:currency_converter/bloc/app_event.dart';
import 'package:currency_converter/bloc/currencyconverter/currency_converter_bloc.dart';
import 'package:currency_converter/bloc/currencyconverter/currency_converter_state.dart';
import 'package:currency_converter/presentation/screens/home/widgets/currency_converter_card.dart';
import 'package:currency_converter/model/user.dart';
import 'package:currency_converter/presentation/screens/trendscreen/trend_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Home screen with Material 3 theming, animations, and real API integration
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;
  late AnimationController _cardController;
  late Animation<double> _fabAnimation;
  late Animation<double> _cardAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fabAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    ));

    _cardAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _cardController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _fabController.forward();
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.brightness_6),
          //   onPressed: () {
          //     // Theme toggle would be implemented here
          //   },
          // ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                // context.read<AppBloc>().add(const AppLogoutRequested());
                _showLogoutConfirmationDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
              theme.colorScheme.primaryContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _cardAnimation,
                    child: _WelcomeCard(user: user),
                  ),
                ),

                const SizedBox(height: 24),

                // Currency Converter Section
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _cardAnimation,
                    child: const CurrencyConverterCard(),
                  ),
                ),

                const SizedBox(height: 16),

                // // Add bottom padding to account for FAB
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: BlocBuilder<CurrencyConversionBloc, CurrencyConversionState>(
          builder: (context, state) {
            // return if (state.result != null)
            return FloatingActionButton.extended(
              heroTag: "trend_fab",
              onPressed: () {
                showTrendBottomSheet(
                  context,
                  fromCurrency: state.fromCurrency,
                  toCurrency: state.toCurrency,
                );
              },
              backgroundColor: state.result != null
                  ? null
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
              // foregroundColor: Theme.of(context).colorScheme.onSecondary,
              icon: const Icon(Icons.trending_up),
              label: const Text('View 5-day trend'),
            );
          },
        ),
      ),
   
    );
  }

}

/// Welcome card widget
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: theme.colorScheme.onPrimary,
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.email ?? 'User',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatter.format(now),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.currency_exchange,
                  color: theme.colorScheme.onPrimary,
                  size: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced version with Material 3 styling and animations
void _showLogoutConfirmationDialog(BuildContext context) {
  final theme = Theme.of(context);

  showDialog<void>(
    context: context,
    barrierDismissible: true, // Allow tap outside to dismiss
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,

        // Icon at the top
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.logout_rounded,
            color: theme.colorScheme.error,
            size: 32,
          ),
        ),

        title: Text(
          'Logout Confirmation',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to logout from your account?',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You will need to sign in again to access your account.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),

        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close dialog first

                    // Then perform logout with a slight delay for smooth UX
                    Future.delayed(const Duration(milliseconds: 200), () {
                      context.read<AppBloc>().add(const AppLogoutRequested());

                      // Show logout success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: Colors.white),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Logged out successfully',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: theme.colorScheme.primary,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

// Alternative: If you want a simple confirmation with just Yes/No
void _showSimpleLogoutDialog(BuildContext context) {
  final theme = Theme.of(context);

  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Do you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
