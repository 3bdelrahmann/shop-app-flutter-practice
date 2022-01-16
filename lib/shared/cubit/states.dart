abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeNavBarState extends AppStates {}

class AppOnLoadingHomeState extends AppStates {}

class AppOnSuccessHomeState extends AppStates {}

class AppOnFailedHomeState extends AppStates {}

class AppOnSuccessCategoriesState extends AppStates {}

class AppOnFailedCategoriesState extends AppStates {}

class AppChangeFavoriteState extends AppStates {}

class AppOnSuccessChangeFavoriteState extends AppStates {}

class AppOnFailedChangeFavoriteState extends AppStates {}

class AppOnLoadingFavoritesState extends AppStates {}

class AppOnSuccessFavoritesState extends AppStates {}

class AppOnFailedFavoritesState extends AppStates {}

class AppOnLoadingCartState extends AppStates {}

class AppOnSuccessCartState extends AppStates {}

class AppOnFailedCartState extends AppStates {}

class AppChangeCartState extends AppStates {}

class AppOnSuccessChangeCartState extends AppStates {}

class AppOnFailedChangeCartState extends AppStates {}

class AppOnLoadingProfileState extends AppStates {}

class AppOnSuccessProfileState extends AppStates {}

class AppOnFailedProfileState extends AppStates {}

class AppOnLoadingUpdateState extends AppStates {}

class AppOnSuccessUpdateState extends AppStates {}

class AppOnFailedUpdateState extends AppStates {
  final String error;

  AppOnFailedUpdateState(this.error);
}

class AppChangeUpdateState extends AppStates {}

class AppOnLoadingSearchState extends AppStates {}

class AppOnSuccessSearchState extends AppStates {}

class AppOnFailedSearchState extends AppStates {}
