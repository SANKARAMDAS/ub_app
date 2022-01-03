part of 'notificationlist_cubit.dart';

abstract class NotificationListState extends Equatable{

  const NotificationListState();

  @override
  List<Object> get props => [];
}
class NotificationListStateInitial extends NotificationListState{}

class FetchingNotificationListState extends NotificationListState{}

class FetchedNotificationListState extends NotificationListState
{
  final  List<NotificationData> notificationList;

  FetchedNotificationListState(this.notificationList);

  @override
  List<Object> get props => [notificationList];

}

