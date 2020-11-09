import 'package:eathlete/misc/message_handler.dart';
import 'package:eathlete/misc/network_handler.dart';
import 'package:eathlete/misc/user_repository.dart';
import 'package:eathlete/models/diary_model.dart';
import 'package:eathlete/models/goal_model.dart';
import 'package:eathlete/models/user_model.dart';
import 'package:eathlete/screens/log_in_screen.dart';
import 'package:eathlete/screens/main_page.dart';
import 'package:eathlete/screens/new_loading_screen.dart';
import 'package:eathlete/screens/notifications.dart';
import 'package:eathlete/screens/profile_edit_page.dart';
import 'package:eathlete/screens/settings.dart';
import 'package:eathlete/screens/sign_up_screen.dart';
import 'package:eathlete/screens/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';

import 'blocs/authentification/authentification_bloc.dart';
import 'misc/simple_bloc_delegate.dart';
import 'models/class_definitions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(GeneralDayAdapter());
  Hive.registerAdapter(CompetitionAdapter());
  Hive.registerAdapter(ResultAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(ObjectiveAdapter());
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  SyncfusionLicense.registerLicense("NT8mJyc2IWhia31hfWN9Z2ZoYmF8YGJ8ampqanNiYmlmamlmanMDHmgjOzo/OiM+MiEgO2JmYRM0PjI6P30wPD4=");
  runApp(ProxyProvider0(
    update: (a, b) => PageNumber(),
    child: ListenableProvider<UserRepository>(
      create: (context) => UserRepository(),
      child: BlocProvider(
          create: (context) => AuthenticationBloc(
              userRepository:
                  Provider.of<UserRepository>(context, listen: false))
            ..add(AppStarted()),
          child: MyApp(userRepository: userRepository)),
    ),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        super(key: key);


  @override
  Widget build(BuildContext context) {

    return NetworkHandler(
      child: MyMessageHandler(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            buttonColor: Colors.grey,
            primarySwatch: Colors.grey,

          ),
          routes: {
            LoginPage.id: (context) => LoginPage(),
            SignUpPage.id: (context) => SignUpPage(),
            MainPage.id: (context) => MainPage(),
            ProfileEditPage.id: (context) => ProfileEditPage(),
            TimerPageActual.id: (context) => TimerPageActual(),
            Notifications.id: (context) => Notifications(),
            Settings.id: (context) => Settings(),
          },
          home:

          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                Provider.of<PageNumber>(context).pageNumber = 0;
                if (state is Loading) {
                  return NewLoadingScreen();
                }
                if (state is Uninitialized) {
                  return LoginPage();
                }
                if (state is Authenticated) {
                  return MainPage(

                    pageNumber: Provider.of<PageNumber>(context).pageNumber,
                  );
                }
                if (state is Unauthenticated) {
                  return LoginPage();
                }
                return Container();
              },
            ),
        ),
      ),
    );
  }
}
