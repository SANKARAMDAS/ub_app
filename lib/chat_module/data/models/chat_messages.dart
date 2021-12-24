import 'dart:convert';

ChatMessages chatMessagesFromJson(String str) => ChatMessages.fromJson(json.decode(str));

String chatMessagesToJson(ChatMessages data) => json.encode(data.toJson());

class ChatMessages {
    ChatMessages({
        this.amount,
        this.details,
        this.messages,
    });

    double? amount;
    String? details;
    String? messages;

    factory ChatMessages.fromJson(Map<String, dynamic> json) => ChatMessages(
        amount: json["amount"].toDouble(),
        details: json["details"],
        messages: json["messages"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "details": details,
        "messages": messages,
    };
}
