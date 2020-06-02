import 'dart:convert';

class Order {
  dynamic id;
  dynamic orderId;
  dynamic customerName;
  dynamic customerId;
  dynamic customerPhone;
  dynamic customerAddress;
  dynamic customerLatitude;
  dynamic customerLongitude;
  dynamic medicineName;
  dynamic medicineId;
  dynamic qty;
  dynamic driverId;
  dynamic driverLocation;
  dynamic driverLatitude;
  dynamic driverLongitude;
  dynamic orderStatus;
  dynamic dropNo;
  dynamic notes;
  dynamic userImage;
  dynamic phoneCode;
  dynamic phoneNumber;
  dynamic city;
  dynamic state;
  dynamic zipCode;
  dynamic date;
  dynamic noteStatus;

  Order(
      {this.id,
      this.orderId,
      this.customerId,
      this.customerName,
      this.customerPhone,
      this.customerAddress,
      this.customerLatitude,
      this.customerLongitude,
      this.medicineName,
      this.medicineId,
      this.qty,
      this.driverId,
      this.driverLocation,
      this.driverLatitude,
      this.driverLongitude,
      this.orderStatus,
      this.dropNo,
      this.notes,
      this.userImage,
      this.phoneCode,
      this.phoneNumber,
      this.city,
      this.state,
      this.zipCode,
      this.date,
      this.noteStatus});

  factory Order.fromRawJson(dynamic str) => Order.fromJson(json.decode(str));

  factory Order.fromJson(Map<dynamic, dynamic> json) => Order(
        id: json["id"],
        orderId: json["order_id"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerPhone: json["customer_phone"],
        customerAddress: json["customer_address"],
        customerLatitude: json["customer_latitude"],
        customerLongitude: json["customer_longitude"],
        medicineName: json["medicine_name"],
        medicineId: json["medicine_id"],
        qty: json["qty"],
        driverId: json["driver_id"],
        driverLocation: json["driver_location"],
        driverLatitude: json["driver_latitude"],
        driverLongitude: json["driver_longitude"],
        orderStatus: json["order_status"],
        dropNo: json["drop_no"],
        notes: json["notes"],
        userImage: json["user_image"],
        phoneCode: json["phone_code"],
        phoneNumber: json["phone_number"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zipcode"],
        date: json["date"],
        noteStatus: json["noteStatus"],
      );
}
