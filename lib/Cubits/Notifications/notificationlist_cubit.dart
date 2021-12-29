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
    emit(FetchingNotificationListState());
    notificationList =  await getDataFromNotificationList();
    emit(FetchedNotificationListState(notificationList));
  }

  Future<void> clearNotification(int index) async {
    NotificationListApi.notificationListApi.deleteNotifications(['${notificationList[index].id}']);
    notificationList.remove(index);
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
    await NotificationListApi.notificationListApi.markAllAsRead(ids);
    emit(FetchedNotificationListState(notificationList));

  }
  Future<void> deleteNotifications() async {
   List<NotificationData> data =notificationList.where((NotificationData element) => element.isSelected).toList();
    List<String> ids = data.map((e) => e.id.toString()).toList();

    NotificationListApi.notificationListApi.deleteNotifications(ids);
    notificationList.removeWhere((element) => element.isSelected);
    emit(FetchedNotificationListState(notificationList));

  }


  Future<List<NotificationData>> getDataFromNotificationList() async {
    List<NotificationData> data =  await NotificationListApi.notificationListApi.getNotificationList();
    return data;
  }

}
