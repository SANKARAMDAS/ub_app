import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urbanledger/Models/notification_list_model.dart';
import 'package:urbanledger/Services/APIs/notification_list_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:equatable/equatable.dart';

part 'notificationlist_state.dart';

class NotificationListCubit extends Cubit<NotificationListState>{
  NotificationListCubit() : super(NotificationListStateInitial());

  Repository repository = Repository();
  List<NotificationData> notificationList = [];


  Future<void> getNotificationListData() async {
    if(state is! FetchedNotificationListState)
    emit(FetchingNotificationListState());
    notificationList =  await getDataFromNotificationList();
    emit(FetchedNotificationListState(notificationList));
  }

  Future<void> clearNotification(int index) async {
    NotificationListApi.notificationListApi.deleteNotifications(['${notificationList[index].id}']);
    notificationList.removeAt(index);
    emit(FetchedNotificationListState(notificationList));

  }

  Future<void> clearAllNotification() async {
    List<String> ids = notificationList.map((e) => e.id.toString()).toList();
    NotificationListApi.notificationListApi.deleteNotifications(ids);
    notificationList.clear();
    emit(FetchedNotificationListState(notificationList));

  }

  Future<void> markAllAsRead() async {
    List<String> ids = notificationList.map((e) => e.id.toString()).toList();
    emit(FetchingNotificationListState());
    NotificationListApi.notificationListApi.markAllAsRead(ids);
    notificationList.forEach((element) {element.read = true;});
    emit(FetchedNotificationListState(notificationList));

  }

  Future<void> markAsRead(int index) async {
    emit(FetchingNotificationListState());
    NotificationListApi.notificationListApi.markAllAsRead(['${notificationList[index].id}']);
    notificationList[index].read = true;
    emit(FetchedNotificationListState(notificationList));

  }

  Future<void> deleteNotifications(List<NotificationData> selectedList) async {
    List<String> ids = selectedList.map((e) => e.id.toString()).toList();

    NotificationListApi.notificationListApi.deleteNotifications(ids);
    notificationList.removeWhere((element) => ids.contains(element.id));
    print(notificationList.length);
    emit(FetchedNotificationListState(notificationList));

  }


  Future<List<NotificationData>> getDataFromNotificationList() async {
    List<NotificationData> data =  await NotificationListApi.notificationListApi.getNotificationList();
    return data;
  }

}
