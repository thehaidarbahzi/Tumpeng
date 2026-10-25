/// Vendor-neutral payment contract. Implement this after choosing a provider.
abstract interface class PaymentGateway {
  Future<PaymentSession> createPayment(PaymentRequest request);
  Future<PaymentStatus> checkStatus(String paymentId);
}

class PaymentRequest {
  const PaymentRequest({
    required this.orderId,
    required this.amount,
    required this.currency,
    this.description,
  });

  final String orderId;
  final int amount;
  final String currency;
  final String? description;
}

class PaymentSession {
  const PaymentSession({required this.paymentId, this.checkoutUrl});

  final String paymentId;
  final Uri? checkoutUrl;
}

enum PaymentStatus { pending, paid, failed, cancelled, expired }
