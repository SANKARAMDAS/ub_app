part of 'user_profile_cubit.dart';

abstract class UserProfileState extends Equatable{

  const UserProfileState();

  @override
  List<Object> get props => [];
}
class UserProfileInitialState extends UserProfileState{}

class FetchingUserProfileState extends UserProfileState{}

class FetchedUserProfileState extends UserProfileState
{
  final  UserProfileModel userProfile;

  FetchedUserProfileState(this.userProfile);

  @override
  List<Object> get props => [userProfile];

}
