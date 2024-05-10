
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/shared/cubit/news_app/states.dart';
import 'package:todo/shared/network/local/cache_helper.dart';

import '../../../modules/news_app/business/business_screen.dart';
import '../../../modules/news_app/science/science_screen.dart';
import '../../../modules/news_app/settings/settings_screen.dart';
import '../../../modules/news_app/sports/sports_screen.dart';
import '../../network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{

  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),


  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Business',
    'Sports',
    'Science',
  ];

  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> search = [];


  void changeBottomNavBar(int index){
    currentIndex = index;
    if(index == 1){
      getSports();
    }
    if(index == 2){
      getScience();
    }

    emit(NewsChangeBottomNavState());
  }
  void getBusiness(){
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
        path: 'v2/top-headlines',
        query: {
          'country': 'us',
          'category': 'business',
          'apiKey': '834d53b59f4f4bd4a56fc30399e17be2'
        }
    ).then((value) {
      business = value.data['articles'];
      // print descrption of the first article
      print(business);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }
  // get sports
  void getSports(){
    emit(NewsGetSportsLoadingState());
    if(sports.length==0){
      DioHelper.getData(
          path: 'v2/top-headlines',
          query: {
            'country': 'us',
            'category': 'sports',
            'apiKey': '834d53b59f4f4bd4a56fc30399e17be2'
          }
      ).then((value) {
        sports = value.data['articles'];
        // print descrption of the first article
        print(business);
        emit(NewsGetSportsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessState());
    }
  }
  // get science
  void getScience(){
    emit(NewsGetScienceLoadingState());
    if(science.length==0){
      DioHelper.getData(
          path: 'v2/top-headlines',
          query: {
            'country': 'us',
            'category': 'science',
            'apiKey': '834d53b59f4f4bd4a56fc30399e17be2'
          }
      ).then((value) {
        science = value.data['articles'];
        // print descrption of the first article
        print(business);
        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    }else{
      emit(NewsGetScienceSuccessState());
    }
  }
  void getSearch(String value){

     emit(NewsGetBusinessLoadingState());

     DioHelper.getData(
         path: 'v2/everything',
         query: {
           'q': '${value}',
           'apiKey': '834d53b59f4f4bd4a56fc30399e17be2'
         }
     ).then((value) {
       search = value.data['articles'];
       // print descrption of the first article
       print(search);
       emit(NewsGetSearchSuccessState());
     }).catchError((error) {
       print(error.toString());
       emit(NewsGetSearchErrorState(error.toString()));
     });
  }


  bool isDark = false;
  void changeAppMode({bool? fromShared}){

    if(fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    }
    else{
      isDark = !isDark;

      CacheHelper.putData(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });

    }

  }



}