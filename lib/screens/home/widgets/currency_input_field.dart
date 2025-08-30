// import 'package:flutter/material.dart';

// class CurrencyInputField extends StatelessWidget {
//   const CurrencyInputField({
//     required this.label,
//     required this.currency,
//     required this.amount,
//     this.readOnly = false,
//     this.onAmountChanged,
//     this.onCurrencyChanged,
//   });

//   final String label;
//   final String currency;
//   final double amount;
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
//         children: [
//           Text(
//             label,
//             style: theme.textTheme.labelMedium?.copyWith(
//               color: theme.colorScheme.onSurfaceVariant,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: TextFormField(
//                   initialValue: amount.toStringAsFixed(2),
//                   readOnly: readOnly,
//                   keyboardType: TextInputType.number,
//                   style: theme.textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: '0.00',
//                   ),
//                   onChanged: (value) {
//                     final parsedValue = double.tryParse(value) ?? 0.0;
//                     onAmountChanged?.call(parsedValue);
//                   },
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: DropdownButtonFormField<String>(
//                   value: currency,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                   ),
//                   items: ['USD', 'EUR', 'GBP', 'JPY', 'INR']
//                       .map((currency) => DropdownMenuItem(
//                             value: currency,
//                             child: Text(currency),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       onCurrencyChanged?.call(value);
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }