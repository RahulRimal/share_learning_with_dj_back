// enum PaymentStatus {
//   PENDING,
//   COMPLETE,
//   FAILED,
// }

// enum DeliveryStatus {
//   IN_TRANSIT,
//   DELIVERED,
//   CANCELED,
// }
// enum DeliveryMethod {
//   STANDARD,
//   EMERGENCY,
// }

// class ModelsHelper {
//   static PaymentStatus paymentStatusFromString(String value) {
//     switch (value) {
//       case 'P':
//         return PaymentStatus.PENDING;
//       case 'C':
//         return PaymentStatus.COMPLETE;
//       case 'F':
//         return PaymentStatus.FAILED;
//       default:
//         return PaymentStatus.PENDING;
//     }
//   }

//   static String paymentStatusToString(PaymentStatus status) {
//     switch (status) {
//       case PaymentStatus.PENDING:
//         return "P";

//       case PaymentStatus.COMPLETE:
//         return "C";

//       case PaymentStatus.FAILED:
//         return "F";

//       default:
//         return "P";
//     }
//   }

//   static DeliveryStatus deliveryStatusFromString(String value) {
//     switch (value) {
//       case 'D':
//         return DeliveryStatus.DELIVERED;

//       case 'T':
//         return DeliveryStatus.IN_TRANSIT;

//       case 'C':
//         return DeliveryStatus.CANCELED;

//       default:
//         return DeliveryStatus.IN_TRANSIT;
//     }
//   }

//   static String deliveryStatusToString(DeliveryStatus status) {
//     switch (status) {
//       case DeliveryStatus.DELIVERED:
//         return "D";

//       case DeliveryStatus.IN_TRANSIT:
//         return "T";

//       case DeliveryStatus.CANCELED:
//         return "C";

//       default:
//         return "D";
//     }
//   }

//   static DeliveryMethod deliveryMethodFromString(String value) {
//     switch (value) {
//       case 'S':
//         return DeliveryMethod.STANDARD;

//       case 'E':
//         return DeliveryMethod.EMERGENCY;

//       default:
//         return DeliveryMethod.STANDARD;
//     }
//   }

//   static String deliveryMethodToString(DeliveryMethod method) {
//     switch (method) {
//       case DeliveryMethod.STANDARD:
//         return "S";
//       case DeliveryMethod.EMERGENCY:
//         return "E";
//       default:
//         return "S";
//     }
//   }
// }
