import 'package:urbanledger/Services/APIs/analytics_api.dart';
import 'package:urbanledger/Services/APIs/business_api.dart';
import 'package:urbanledger/Services/APIs/card_api.dart';
import 'package:urbanledger/Services/APIs/cashbook_api.dart';
import 'package:urbanledger/Services/APIs/change_pin_api.dart';
import 'package:urbanledger/Services/APIs/freemium_api.dart';
import 'package:urbanledger/Services/APIs/ledger_api.dart';
import 'package:urbanledger/Services/APIs/login_api.dart';
import 'package:urbanledger/Services/APIs/payment_through_card.dart';
import 'package:urbanledger/Services/APIs/register_api.dart';
import 'package:urbanledger/Services/APIs/unsubscribe_api.dart';
import 'package:urbanledger/Services/hive_queries.dart';
import 'package:urbanledger/Services/LocalQueries/queries.dart';
import 'package:urbanledger/Services/APIs/payment_through_qr.dart';
import 'package:urbanledger/Services/APIs/user_profile_api.dart';
import 'package:urbanledger/Services/APIs/rewards_api.dart';

import 'APIs/customer_api.dart';

class Repository {
  ///APIS
  ///
  final freemiumApi = FreemiumAPI.freemiumApi;

  final unsubsApi = UnsubsAPI.unsubsApi;

  final registerApi = RegisterAPI.registerApi;

  final loginApi = LoginAPI.loginApi;

  final customerApi = CustomerAPI.customerApi;

  final ledgerApi = LedgerAPI.ledgerApi;

  final cashbookApi = CashbookAPI.cashbookApi;

  final cardPaymentsProvider = PaymentThroughCardAPI.cardPaymentsProvider;

  final cardsProvider = CardAPI.cardsProvider;

  final paymentThroughQRApi = PaymentThroughQRAPI.paymentThroughQRApi;

  final changePinApi = ChangePinAPI.changePinApi;

  final userProfileAPI = UserProfileAPI.userProfileAPI;

  final businessApi = BusinessAPI.businessApi;

  final analyticsAPI = AnalyticsAPI.analyticsAPI;

  final rewardsApi = RewardsApi.rewardsApi;

  ///Local Storage
  final queries = Queries.queries;

  final hiveQueries = HiveQueries.hiveQueries;
}
