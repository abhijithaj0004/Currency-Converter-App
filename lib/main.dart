// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'authentication_repository.dart';
// import 'bloc/app_bloc.dart';
// import 'app.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   // Create authentication repository
//   final authenticationRepository = AuthenticationRepository();

//   runApp(
//     RepositoryProvider.value(
//       value: authenticationRepository,
//       child: BlocProvider(
//         create: (_) => AppBloc(
//           authenticationRepository: authenticationRepository,
//         ),
//         child: const App(),
//       ),
//     ),
//   );
// }
import 'package:currency_converter/bloc/currencyconverter/currency_converter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/authentication_repository.dart';
import 'bloc/app_bloc.dart';
import 'app.dart';

// Import currency conversion dependencies
import 'services/api_client.dart';
import 'repositories/currency_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create authentication repository
  final authenticationRepository = AuthenticationRepository();

  // Create currency conversion dependencies
  final apiClient = ApiClient();
  final currencyRepository = CurrencyRepository(apiClient);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: currencyRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => CurrencyConversionBloc(
              context.read<CurrencyRepository>(),
            ),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}
