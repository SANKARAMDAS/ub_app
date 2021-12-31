import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urbanledger/Models/user_profile_model.dart';
import 'package:urbanledger/Services/APIs/user_profile_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:equatable/equatable.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState>{
  UserProfileCubit() : super(UserProfileInitialState());

  Repository repository = Repository();
  UserProfileModel userProfileModel=new UserProfileModel();


  Future<void> getUserProfileData() async {
    emit(FetchingUserProfileState());
    userProfileModel =  await getDataFromUserProfile();
    emit(FetchedUserProfileState(userProfileModel));
  }

  Future<UserProfileModel> getDataFromUserProfile() async {
    UserProfileModel data =  await UserProfileAPI.userProfileAPI.getUserProfileApi();
    return data;
  }

}