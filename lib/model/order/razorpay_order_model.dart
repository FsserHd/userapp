


import 'dart:convert';

class RazorpayOrder {
  final int? amount;
  final int? amountDue;
  final int? amountPaid;
  final int? attempts;
  final int? createdAt;
  final String? currency;
  final String? entity;
  final String? id;
  final Map<String, String>? notes;
  final String? offerId;
  final String? receipt;
  final String? status;

  RazorpayOrder({
    this.amount,
    this.amountDue,
    this.amountPaid,
    this.attempts,
    this.createdAt,
    this.currency,
    this.entity,
    this.id,
    this.notes,
    this.offerId,
    this.receipt,
    this.status,
  });

  factory RazorpayOrder.fromJson(Map<String, dynamic> json) {
    return RazorpayOrder(
      amount: json['amount'],
      amountDue: json['amount_due'],
      amountPaid: json['amount_paid'],
      attempts: json['attempts'],
      createdAt: json['created_at'],
      currency: json['currency'],
      entity: json['entity'],
      id: json['id'],
      notes: Map<String, String>.from(json['notes']),
      offerId: json['offer_id'],
      receipt: json['receipt'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'amount_due': amountDue,
      'amount_paid': amountPaid,
      'attempts': attempts,
      'created_at': createdAt,
      'currency': currency,
      'entity': entity,
      'id': id,
      'notes': notes,
      'offer_id': offerId,
      'receipt': receipt,
      'status': status,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
