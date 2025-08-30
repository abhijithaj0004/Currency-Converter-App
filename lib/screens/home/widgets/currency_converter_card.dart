// import 'package:currency_converter/screens/home/widgets/currency_input_field.dart';
// import 'package:flutter/material.dart';

// /// Currency converter card widget
// class CurrencyConverterCard extends StatefulWidget {
//   const CurrencyConverterCard();

//   @override
//   State<CurrencyConverterCard> createState() => _CurrencyConverterCardState();
// }

// class _CurrencyConverterCardState extends State<CurrencyConverterCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _swapController;
//   late Animation<double> _swapAnimation;
  
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
//   }

//   @override
//   void dispose() {
//     _swapController.dispose();
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
//           children: [
//             Text(
//               'Currency Converter',
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
            
//             const SizedBox(height: 24),
            
//             // From Currency
//             CurrencyInputField(
//               label: 'From',
//               currency: fromCurrency,
//               amount: amount,
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
//             CurrencyInputField(
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
//             SizedBox(
//               width: double.infinity,
//               height: 50,
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
