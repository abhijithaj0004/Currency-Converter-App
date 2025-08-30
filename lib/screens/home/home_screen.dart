// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../app_bloc.dart';
// import '../../app_event.dart';
// import '../../user.dart';

// /// Home screen with Material 3 theming and animations
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   late AnimationController _fabController;
//   late AnimationController _cardController;
//   late Animation<double> _fabAnimation;
//   late Animation<double> _cardAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _fabController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _cardController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _fabAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _fabController,
//       curve: Curves.elasticOut,
//     ));

//     _cardAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _cardController,
//       curve: Curves.easeOutCubic,
//     ));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _cardController,
//       curve: Curves.easeOutCubic,
//     ));

//     // Start animations
//     _cardController.forward();
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _fabController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _fabController.dispose();
//     _cardController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final user = context.select((AppBloc bloc) => bloc.state.user);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Currency Converter'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: theme.colorScheme.surface,
//         foregroundColor: theme.colorScheme.onSurface,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.brightness_6),
//             onPressed: () {
//               // Theme toggle would be implemented here
//             },
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'logout') {
//                 context.read<AppBloc>().add(const AppLogoutRequested());
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'logout',
//                 child: Row(
//                   children: [
//                     Icon(Icons.logout),
//                     SizedBox(width: 8),
//                     Text('Logout'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               theme.colorScheme.surface,
//               theme.colorScheme.surface.withOpacity(0.8),
//               theme.colorScheme.primaryContainer.withOpacity(0.1),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Welcome Section
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: FadeTransition(
//                     opacity: _cardAnimation,
//                     child: _WelcomeCard(user: user),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Currency Converter Section
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: FadeTransition(
//                     opacity: _cardAnimation,
//                     child: const _CurrencyConverterCard(),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Quick Actions
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: FadeTransition(
//                     opacity: _cardAnimation,
//                     child: const _QuickActionsCard(),
//                   ),
//                 ),

//                 // Add bottom padding to account for FAB
//                 const SizedBox(height: 80),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: ScaleTransition(
//         scale: _fabAnimation,
//         child: FloatingActionButton.extended(
//           onPressed: () {
//             // Add conversion to favorites or history
//           },
//           icon: const Icon(Icons.favorite),
//           label: const Text('Save'),
//         ),
//       ),
//     );
//   }
// }

// /// Welcome card widget
// class _WelcomeCard extends StatelessWidget {
//   const _WelcomeCard({required this.user});

//   final User user;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             colors: [
//               theme.colorScheme.primary,
//               theme.colorScheme.primary.withOpacity(0.8),
//             ],
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundColor: theme.colorScheme.onPrimary,
//                   child: Icon(
//                     Icons.person,
//                     color: theme.colorScheme.primary,
//                     size: 30,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Welcome back!',
//                         style: theme.textTheme.titleMedium?.copyWith(
//                           color: theme.colorScheme.onPrimary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         user.email ?? 'User',
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.onPrimary.withOpacity(0.9),
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.currency_exchange,
//                   color: theme.colorScheme.onPrimary,
//                   size: 32,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Currency converter card widget
// class _CurrencyConverterCard extends StatefulWidget {
//   const _CurrencyConverterCard();

//   @override
//   State<_CurrencyConverterCard> createState() => _CurrencyConverterCardState();
// }

// class _CurrencyConverterCardState extends State<_CurrencyConverterCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _swapController;
//   late Animation<double> _swapAnimation;
//   late TextEditingController _amountController;

//   String fromCurrency = 'USD';
//   String toCurrency = 'EUR';
//   double amount = 100.0;
//   double convertedAmount = 85.0; // Mock conversion

//   @override
//   void initState() {
//     super.initState();
//     _swapController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _swapAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _swapController,
//       curve: Curves.easeInOut,
//     ));
//     _amountController = TextEditingController(text: amount.toStringAsFixed(2));
//   }

//   @override
//   void dispose() {
//     _swapController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }

//   void _swapCurrencies() {
//     _swapController.forward().then((_) {
//       setState(() {
//         final temp = fromCurrency;
//         fromCurrency = toCurrency;
//         toCurrency = temp;
//         // Mock conversion update
//         convertedAmount = amount * 1.18; // Mock rate
//       });
//       _swapController.reverse();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Currency Converter',
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 24),

//             // From Currency
//             _CurrencyInputField(
//               label: 'From',
//               currency: fromCurrency,
//               controller: _amountController,
//               onAmountChanged: (value) {
//                 setState(() {
//                   amount = value;
//                   convertedAmount = value * 0.85; // Mock conversion
//                 });
//               },
//               onCurrencyChanged: (currency) {
//                 setState(() {
//                   fromCurrency = currency;
//                 });
//               },
//             ),

//             const SizedBox(height: 16),

//             // Swap Button
//             Center(
//               child: AnimatedBuilder(
//                 animation: _swapAnimation,
//                 builder: (context, child) {
//                   return Transform.rotate(
//                     angle: _swapAnimation.value * 3.14159,
//                     child: IconButton.filled(
//                       onPressed: _swapCurrencies,
//                       icon: const Icon(Icons.swap_vert),
//                       style: IconButton.styleFrom(
//                         backgroundColor: theme.colorScheme.primary,
//                         foregroundColor: theme.colorScheme.onPrimary,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 16),

//             // To Currency
//             _CurrencyInputField(
//               label: 'To',
//               currency: toCurrency,
//               amount: convertedAmount,
//               readOnly: true,
//               onCurrencyChanged: (currency) {
//                 setState(() {
//                   toCurrency = currency;
//                 });
//               },
//             ),

//             const SizedBox(height: 24),

//             // Convert Button
//             ConstrainedBox(
//               constraints: const BoxConstraints(
//                 minWidth: double.infinity,
//                 minHeight: 50,
//                 maxHeight: 50,
//               ),
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   // Perform conversion
//                   setState(() {
//                     convertedAmount = amount * 0.85; // Mock conversion
//                   });
//                 },
//                 icon: const Icon(Icons.calculate),
//                 label: const Text('Convert'),
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Currency input field widget
// class _CurrencyInputField extends StatelessWidget {
//   const _CurrencyInputField({
//     required this.label,
//     required this.currency,
//     this.amount,
//     this.controller,
//     this.readOnly = false,
//     this.onAmountChanged,
//     this.onCurrencyChanged,
//   });

//   final String label;
//   final String currency;
//   final double? amount;
//   final TextEditingController? controller;
//   final bool readOnly;
//   final ValueChanged<double>? onAmountChanged;
//   final ValueChanged<String>? onCurrencyChanged;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: theme.colorScheme.outline.withOpacity(0.2),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             label,
//             style: theme.textTheme.labelMedium?.copyWith(
//               color: theme.colorScheme.onSurfaceVariant,
//             ),
//           ),
//           const SizedBox(height: 8),
//           IntrinsicHeight(
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: TextFormField(
//                     controller: controller,
//                     initialValue: controller == null && amount != null
//                         ? amount!.toStringAsFixed(2)
//                         : null,
//                     readOnly: readOnly,
//                     keyboardType: const TextInputType.numberWithOptions(
//                       decimal: true,
//                       signed: false,
//                     ),
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: '0.00',
//                       isDense: true,
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                     onChanged: (value) {
//                       final parsedValue = double.tryParse(value) ?? 0.0;
//                       onAmountChanged?.call(parsedValue);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Flexible(
//                   child: DropdownButtonFormField<String>(
//                     value: currency,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       isDense: true,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                     ),
//                     items: ['USD', 'EUR', 'GBP', 'JPY', 'INR']
//                         .map((currency) => DropdownMenuItem(
//                               value: currency,
//                               child: Text(currency),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         onCurrencyChanged?.call(value);
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Quick actions card widget
// class _QuickActionsCard extends StatelessWidget {
//   const _QuickActionsCard();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Quick Actions',
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 // Calculate button width based on available space
//                 final buttonWidth = (constraints.maxWidth - 48) / 4; // 48 = 3 gaps * 16
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _QuickActionButton(
//                       icon: Icons.history,
//                       label: 'History',
//                       onTap: () {},
//                       width: buttonWidth,
//                     ),
//                     _QuickActionButton(
//                       icon: Icons.favorite,
//                       label: 'Favorites',
//                       onTap: () {},
//                       width: buttonWidth,
//                     ),
//                     _QuickActionButton(
//                       icon: Icons.trending_up,
//                       label: 'Rates',
//                       onTap: () {},
//                       width: buttonWidth,
//                     ),
//                     _QuickActionButton(
//                       icon: Icons.settings,
//                       label: 'Settings',
//                       onTap: () {},
//                       width: buttonWidth,
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Quick action button widget
// class _QuickActionButton extends StatelessWidget {
//   const _QuickActionButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     this.width,
//   });

//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   final double? width;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         width: width,
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.primaryContainer,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: theme.colorScheme.onPrimaryContainer,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: theme.textTheme.labelMedium,
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// lib/screens/home_screen.dart
import 'package:currency_converter/bloc/app_bloc.dart';
import 'package:currency_converter/bloc/app_event.dart';
import 'package:currency_converter/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Theme toggle would be implemented here
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AppBloc>().add(const AppLogoutRequested());
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
                    child: const _CurrencyConverterCard(),
                  ),
                ),

                const SizedBox(height: 16),

                // Quick Actions
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _cardAnimation,
                    child: const _QuickActionsCard(),
                  ),
                ),

                // Add bottom padding to account for FAB
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
            return FloatingActionButton.extended(
              onPressed: state.result != null ? () {
                // Add conversion to favorites or history
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Saved: ${state.amount} ${state.fromCurrency} = ${state.result!.convertedAmount.toStringAsFixed(2)} ${state.toCurrency}',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } : null,
              icon: const Icon(Icons.favorite),
              label: const Text('Save'),
              backgroundColor: state.result != null 
                  ? null 
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                          color: theme.colorScheme.onPrimary,fontWeight: FontWeight.w600,
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

/// Currency converter card widget with API integration
class _CurrencyConverterCard extends StatefulWidget {
  const _CurrencyConverterCard();

  @override
  State<_CurrencyConverterCard> createState() => _CurrencyConverterCardState();
}

class _CurrencyConverterCardState extends State<_CurrencyConverterCard>
    with TickerProviderStateMixin {
  late AnimationController _swapController;
  late AnimationController _resultController;
  late Animation<double> _swapAnimation;
  late Animation<double> _resultScaleAnimation;
  late Animation<Offset> _resultSlideAnimation;
  late TextEditingController _amountController;

  bool _hasInvalidInput = false;

  @override
  void initState() {
    super.initState();
    
    _swapController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _swapAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _swapController,
      curve: Curves.easeInOut,
    ));

    _resultScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    ));

    _resultSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOutCubic,
    ));

    final state = context.read<CurrencyConversionBloc>().state;
    _amountController = TextEditingController(text: state.amount.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _swapController.dispose();
    _resultController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    _swapController.forward().then((_) {
      context.read<CurrencyConversionBloc>().add(const SwapCurrenciesEvent());
      _swapController.reverse();
    });
  }

  void _showCurrencyPicker({required bool isFromCurrency}) {
    final state = context.read<CurrencyConversionBloc>().state;
    final selectedCurrency = CurrencyData.getCurrencyByCode(
      isFromCurrency ? state.fromCurrency : state.toCurrency,
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencyPickerModal(
        selectedCurrency: selectedCurrency,
        onCurrencySelected: (currency) {
          if (isFromCurrency) {
            context.read<CurrencyConversionBloc>()
                .add(UpdateFromCurrencyEvent(currency.code));
          } else {
            context.read<CurrencyConversionBloc>()
                .add(UpdateToCurrencyEvent(currency.code));
          }
        },
      ),
    );
  }

  void _validateAndUpdateAmount(String value) {
    final parsedValue = double.tryParse(value);
    if (parsedValue == null || parsedValue < 0) {
      setState(() => _hasInvalidInput = true);
      HapticFeedback.lightImpact();
    } else {
      setState(() => _hasInvalidInput = false);
      context.read<CurrencyConversionBloc>()
          .add(UpdateAmountEvent(parsedValue));
    }
  }

  String _formatCurrency(double amount, String currencyCode) {
    final currency = CurrencyData.getCurrencyByCode(currencyCode);
    return '${currency.symbol}${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<CurrencyConversionBloc, CurrencyConversionState>(
      listener: (context, state) {
        if (state.status == ConversionStatus.success && state.result != null) {
          _resultController.forward();
        } else {
          _resultController.reset();
        }
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<CurrencyConversionBloc, CurrencyConversionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Currency Converter',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // From Currency Section
                  _buildCurrencySection(
                    label: 'From',
                    currency: CurrencyData.getCurrencyByCode(state.fromCurrency),
                    isInput: true,
                    onCurrencyTap: () => _showCurrencyPicker(isFromCurrency: true),
                    state: state,
                  ),

                  const SizedBox(height: 16),

                  // Swap Button
                  Center(
                    child: AnimatedBuilder(
                      animation: _swapAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _swapAnimation.value * 3.14159,
                          child: IconButton.filled(
                            onPressed: _swapCurrencies,
                            icon: const Icon(Icons.swap_vert),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // To Currency Section
                  _buildCurrencySection(
                    label: 'To',
                    currency: CurrencyData.getCurrencyByCode(state.toCurrency),
                    isInput: false,
                    onCurrencyTap: () => _showCurrencyPicker(isFromCurrency: false),
                    state: state,
                  ),

                  const SizedBox(height: 24),

                  // Convert Button with loading states
                  _buildConvertButton(state),

                  // Result Card
                  if (state.result != null) ...[
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _resultSlideAnimation,
                      child: ScaleTransition(
                        scale: _resultScaleAnimation,
                        child: _buildResultCard(state),
                      ),
                    ),
                  ],

                  // Error handling
                  if (state.status == ConversionStatus.failure) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Failed to convert currency. Please try again.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencySection({
    required String label,
    required Currency currency,
    required bool isInput,
    required VoidCallback onCurrencyTap,
    required CurrencyConversionState state,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CurrencyChip(
                currency: currency,
                onTap: onCurrencyTap,
                heroTag: '${label}_currency_chip',
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (isInput) 
            BounceWrapper(
              shouldBounce: _hasInvalidInput,
              onBounceComplete: () => setState(() => _hasInvalidInput = false),
              child: TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _hasInvalidInput ? theme.colorScheme.error : null,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0.00',
                  prefix: Text(
                    currency.symbol,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  suffixIcon: _hasInvalidInput
                      ? Icon(Icons.error, color: theme.colorScheme.error)
                      : null,
                ),
                onChanged: _validateAndUpdateAmount,
              ),
            )
          else if (state.result != null)
            AnimatedCounter(
              value: state.result!.convertedAmount,
              prefix: currency.symbol,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            )
          else
            Text(
              '${currency.symbol}0.00',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConvertButton(CurrencyConversionState state) {
    final theme = Theme.of(context);
    final isLoading = state.status == ConversionStatus.loading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : () {
          if (state.amount > 0) {
            context.read<CurrencyConversionBloc>().add(
              ConvertCurrencyEvent(
                fromCurrency: state.fromCurrency,
                toCurrency: state.toCurrency,
                amount: state.amount,
              ),
            );
          }
        },
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : const Icon(Icons.currency_exchange),
        label: Text(isLoading ? 'Converting...' : 'Convert'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isLoading ? 0 : 2,
        ),
      ),
    );
  }

  Widget _buildResultCard(CurrencyConversionState state) {
    final theme = Theme.of(context);
    final result = state.result!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Conversion Result',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exchange Rate:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                ),
              ),
              Text(
                '1 ${state.fromCurrency} = ${result.rate.toStringAsFixed(4)} ${state.toCurrency}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Processing Time:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                ),
              ),
              Text(
                '${result.ms}ms',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quick actions card widget
class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final buttonWidth = (constraints.maxWidth - 48) / 4;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _QuickActionButton(
                      icon: Icons.history,
                      label: 'History',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('History feature coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      width: buttonWidth,
                    ),
                    _QuickActionButton(
                      icon: Icons.favorite,
                      label: 'Favorites',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Favorites feature coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      width: buttonWidth,
                    ),
                    _QuickActionButton(
                      icon: Icons.trending_up,
                      label: 'Rates',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Live rates feature coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      width: buttonWidth,
                    ),
                    _QuickActionButton(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings feature coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      width: buttonWidth,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick action button widget
class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.width,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}