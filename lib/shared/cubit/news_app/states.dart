
abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsChangeBottomNavState extends NewsStates {}

// business states
class NewsGetBusinessLoadingState extends NewsStates {}

class NewsGetBusinessSuccessState extends NewsStates {}

class NewsGetBusinessErrorState extends NewsStates {
  final String error;

  NewsGetBusinessErrorState(this.error);
}
// sports states
class NewsGetSportsLoadingState extends NewsStates {}
class NewsGetSportsSuccessState extends NewsStates {}
class NewsGetSportsErrorState extends NewsStates {
  final String error;

  NewsGetSportsErrorState(this.error);
}
// science states
class NewsGetScienceLoadingState extends NewsStates {}
class NewsGetScienceSuccessState extends NewsStates {}
class NewsGetScienceErrorState extends NewsStates {
  final String error;

  NewsGetScienceErrorState(this.error);
}
// mode
class AppChangeModeState extends NewsStates {}
//search
class NewsGetSearchLoadingState extends NewsStates {}
class NewsGetSearchSuccessState extends NewsStates {}
class NewsGetSearchErrorState extends NewsStates {
  final String error;

  NewsGetSearchErrorState(this.error);
}


