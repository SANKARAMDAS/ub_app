import 'package:flutter/cupertino.dart';
import 'package:urbanledger/Models/rewards.dart';
import 'package:urbanledger/Services/APIs/rewards_api.dart';

class RewardsProvider extends ChangeNotifier {
  GetRewards? rewards;

  Future<GetRewards?>? getRewards() async {
    rewards = await RewardsApi.rewardsApi.getRewardsOfUsers();
    rewards?.data?.sort((a, b) {
      if (b.firstPayment ?? false) {
        return 1;
      }
      return -1;
    });
    notifyListeners();
    return rewards;
  }

  Future triggerNotification(id) async {
    notifyListeners();
    return await RewardsApi.rewardsApi.triggerNotification(id);
  }
}
