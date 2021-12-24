class Captions {
  final Map<String, String> _default = {
    'PREV': 'Prev',
    'NEXT': 'NEXT',
    'DONE': 'DONE',
    'CARD_NUMBER': 'Card Number',
    'CARDHOLDER_NAME': 'Name on the Card',
    'VALID_THRU': 'Expiry Date',
    'SECURITY_CODE_CVC': 'Secure Code',
    'NAME_SURNAME': 'Name Surname',
    'MM_YY': 'MM/YY',
    'RESET': 'Reset',
    'BANKNAME': 'BANK NAME'
  };

  late Map<String, String> _captions;

  Captions({customCaptions}) {
    _captions = {};
    _captions.addAll(_default);
    if (customCaptions != null) _captions.addAll(customCaptions);
  }

  String? getCaption(String key) {
    return _captions.containsKey(key) ? _captions[key] : key;
  }
}
