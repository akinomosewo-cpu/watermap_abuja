import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'domain/services/auth_service.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/booking_bloc.dart';
import 'presentation/blocs/tanker_bloc.dart';
import 'presentation/blocs/water_bloc.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AuthService.instance.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.background,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const WaterMapApp());
}

class WaterMapApp extends StatelessWidget {
  const WaterMapApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => WaterBloc()),
        BlocProvider(create: (_) => TankerBloc()),
        BlocProvider(create: (_) => BookingBloc()),
      ],
      child: MaterialApp(
        title: 'WaterMap Abuja',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.light,
        themeMode: ThemeMode.light,
        home: const SplashPage(),
      ),
    );
  }
}
