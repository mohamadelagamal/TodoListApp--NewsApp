import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/layout/news_app/news_layout.dart';
import 'package:todo/layout/todo_app/home_layout.dart';
import 'package:todo/shared/components/Constants.dart';
import 'package:todo/shared/cubit/news_app/cubit.dart';
import 'package:todo/shared/cubit/news_app/states.dart';
import 'package:todo/shared/cubit/todo_app/bloc_observer.dart';
import 'package:todo/shared/cubit/todo_app/cubit.dart';
import 'package:todo/shared/cubit/todo_app/states.dart';
import 'package:todo/shared/network/local/cache_helper.dart';
import 'package:todo/shared/network/remote/dio_helper.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();// to make sure that all the plugins are initialized before running the app

  Bloc.observer = MyBlocObserver();
  DioHelper.init(); // to initialize the Dio package
  await CacheHelper.init(); // to initialize the shared preferences

  bool? isDark = CacheHelper.getData(key: 'isDark');
  runApp(
    MyApp(isDark),
  );
}

class MyApp extends StatelessWidget {

  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  final bool? isDark;
  MyApp(this.isDark);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit()..getBusiness()..getScience()..getSports()
        ),
        BlocProvider(
          create: (context) => NewsCubit()..changeAppMode(fromShared: isDark),
        ),
      ],
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {
          // check if isDark is true then set the status bar color to black.
        },
        builder: (context, state) {

          //print(NewsCubit.get(context).isDark);
          return ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (_, ThemeMode currentMode, __) {

                return MaterialApp(
                  // debugShowCheckedModeBanner: false, means that the debug banner will not be shown in the top right corner of the app.
                  debugShowCheckedModeBanner: false,
                  // theme: ThemeData() is used to set the theme of the app.
                  theme: ThemeData(
                    // scaffoldBackgroundColor: Colors.white, means that the background color of the app will be white.
                    scaffoldBackgroundColor: Colors.white,
                    // appBarTheme: AppBarTheme() is used to set the theme of the app bar.
                    appBarTheme: AppBarTheme(
                      // systemOverlayStyle: SystemUiOverlayStyle() is used to set the style of the system overlay.
                        systemOverlayStyle: SystemUiOverlayStyle(
                          // statusBarColor: Colors.transparent, means that the status bar color will be transparent.
                          statusBarColor: Colors.transparent,
                          // statusBarIconBrightness: Brightness.dark, means that the status bar icon brightness will be dark.
                          statusBarIconBrightness: Brightness.dark,
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0, // to remove the shadow under the app bar
                        iconTheme: IconThemeData(
                            color: Colors
                                .black), // to change the color of the icons in the app bar
                        titleTextStyle: TextStyle(
                          // to change the style of the title in the app bar
                            color: Colors
                                .black, // to change the color of the title in the app bar
                            fontSize:
                            20, // to change the font size of the title in the app bar
                            fontWeight: FontWeight.bold)),
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Colors.blue,
                      unselectedItemColor: Colors.grey,
                      elevation: 20,
                      backgroundColor: Colors.white,
                    ),
                    textTheme: TextTheme(
                      bodyText1: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  // darkTheme: ThemeData() is used to set the dark theme of the app.
                  darkTheme: ThemeData(
                    scaffoldBackgroundColor: HexColor('333739'),
                    appBarTheme: AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: HexColor('333739'),
                        statusBarIconBrightness: Brightness.light,
                      ),
                      backgroundColor: HexColor('333739'),
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.white),
                      titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Colors.blue,
                      unselectedItemColor: Colors.grey,
                      elevation: 20,
                      backgroundColor: HexColor('333739'),
                    ),
                    textTheme: TextTheme(
                      bodyText1: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  themeMode: currentMode,
                  home: NewsLayout(),
                );
              });
        },
      ),
    );
  }
}
