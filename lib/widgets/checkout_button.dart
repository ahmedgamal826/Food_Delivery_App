// import 'package:flutter/material.dart';
// import 'package:food_ordering_app/widgets/get_current_location.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;

// class CheckoutButton extends StatefulWidget {
//   CheckoutButton({
//     super.key,
//     required this.deliveryPrice,
//     required this.total,
//     required this.customerName,
//     required this.items,
//   });

//   double deliveryPrice;
//   double total;
//   String customerName;
//   final List<dynamic> items;

//   @override
//   State<CheckoutButton> createState() => _CheckoutButtonState();
// }

// class _CheckoutButtonState extends State<CheckoutButton> {
//   int selectedCard = 1;
//   String selectedCardName = 'Credit card';

//   String deliveryAddress = "Default Delivery Address";

//   bool isloading = false;

//   // Method to update the address
//   void _updateAddress(String newAddress) {
//     setState(() {
//       deliveryAddress = newAddress;
//     });
//   }

//   // Method to get the current location
//   Future<loc.LocationData?> _getCurrentLocation() async {
//     loc.Location location = loc.Location();
//     bool serviceEnabled;
//     loc.PermissionStatus permissionGranted;

//     // Check if location service is enabled
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return null;
//       }
//     }

//     // Check for location permissions
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == loc.PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != loc.PermissionStatus.granted) {
//         return null;
//       }
//     }

//     // Return current location
//     return await location.getLocation();
//   }

//   // Method to get the address and show it in a dialog
//   Future<void> getLocation(BuildContext context, StateSetter setState) async {
//     loc.LocationData? _currentLocation = await _getCurrentLocation();

//     if (_currentLocation == null) {
//       // Handle the error if location is not available
//       return;
//     }

//     // Convert coordinates to address
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//       _currentLocation.latitude!,
//       _currentLocation.longitude!,
//     );

//     String _address;

//     if (placemarks.isNotEmpty) {
//       final placemark = placemarks.first;
//       _address = '${placemark.street}';
//     } else {
//       _address = 'Address not found';
//     }

//     // Show the address in a dialog
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Current Address", style: TextStyle(color: Colors.orange)),
//         content: isloading
//             ? Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.orange,
//                 ),
//               )
//             : Text(
//                 _address,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//         actions: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _navigateToMap(context, _currentLocation);
//                 },
//                 child: Text(
//                   "View on Map",
//                   style: TextStyle(
//                       fontSize: 17,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                 onPressed: () {
//                   if (mounted) {
//                     setState(() {
//                       _updateAddress(_address); // Update the address here
//                       Navigator.of(context).pop(); // Close the dialog
//                     });
//                   }
//                 },
//                 child: Text(
//                   "OK",
//                   style: TextStyle(
//                       fontSize: 17,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );

//     // Update the address and rebuild the UI
//     setState(() {
//       deliveryAddress = _address;
//     });
//   }

//   void _navigateToMap(
//       BuildContext context, loc.LocationData? locationData) async {
//     if (locationData == null) {
//       locationData = await _getCurrentLocation();
//     }

//     if (locationData == null) {
//       // Handle the error if location is not available
//       return;
//     }

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => MapScreen(
//           locationData: locationData!,
//         ),
//       ),
//     );
//   }

//   void _showSelectedCard(BuildContext context, String cardName) {
//     final snackBar = SnackBar(
//       content: Text('You selected: $cardName'),
//       duration: Duration(seconds: 2),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   void _selectCard(int cardValue, String cardName, StateSetter setState) {
//     if (mounted) {
//       setState(() {
//         selectedCard = cardValue;
//         selectedCardName = cardName; // تحديث اسم البطاقة المختارة
//         _showSelectedCard(context, cardName);
//       });
//     }
//   }

//   void _showInvoiceDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Invoice',
//             style: TextStyle(
//               color: Colors.orange,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Row(
//                   children: [
//                     Text(
//                       'Customer Name: ',
//                       style: TextStyle(
//                         color: Colors.orange,
//                       ),
//                     ),
//                     Container(
//                       constraints: BoxConstraints(maxWidth: 150),
//                       child: Text(
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         widget.customerName,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Text(
//                       'Card Type: ',
//                       style: TextStyle(
//                         color: Colors.orange,
//                       ),
//                     ),
//                     Container(
//                       constraints: BoxConstraints(maxWidth: 150),
//                       child: Text(
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         selectedCardName,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Text(
//                       'Delivery Address: ',
//                       style: TextStyle(
//                         color: Colors.orange,
//                       ),
//                     ),
//                     Container(
//                       constraints: BoxConstraints(maxWidth: 150),
//                       child: Text(
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         '$deliveryAddress',
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Text(
//                       'Delivery Price: ',
//                       style: TextStyle(
//                         color: Colors.orange,
//                       ),
//                     ),
//                     Text(
//                       '\$${widget.deliveryPrice.toStringAsFixed(2)}',
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Products:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//                 ...widget.items.map((item) {
//                   final product =
//                       item['product'] as Map<String, dynamic>? ?? {};
//                   final productName = product['name'] as String? ?? '';
//                   final quantity = item['quantity'] as int? ?? 0;
//                   final itemTotalPrice = item['totalPrice'] as double? ?? 0.0;

//                   return ListTile(
//                     leading: Text(
//                       '$quantity',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     title: Text('$productName'),
//                     trailing: Text(
//                       '\$${itemTotalPrice.toStringAsFixed(2)}',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   );

//                   // return Text(
//                   //   '$productName - Qty: $quantity - \$${itemTotalPrice.toStringAsFixed(2)}',
//                   // );
//                 }).toList(),
//                 Divider(
//                   indent: 25,
//                   endIndent: 25,
//                   color: Colors.orange,
//                   thickness: 3,
//                 ),
//                 ListTile(
//                   leading: Text(
//                     'Total: ',
//                     style: TextStyle(
//                       fontSize: 23,
//                       color: Colors.orange,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   trailing: Text(
//                     '\$${widget.total.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//               ),
//               child: Text(
//                 'Close',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Container(
//       width: screenWidth,
//       decoration: BoxDecoration(
//         color: Colors.orange,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: MaterialButton(
//         elevation: 5,
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (BuildContext context) {
//               return Container(
//                 height: screenHeight * 0.8,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Color(0xffF4F4F4),
//                 ),
//                 child: StatefulBuilder(
//                   builder: (BuildContext context, StateSetter setState) {
//                     return Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           children: [
//                             const Align(
//                               alignment: Alignment.centerLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5),
//                                 child: Text(
//                                   'Order Confirmation',
//                                   style: TextStyle(
//                                     fontSize: 23,
//                                     color: Colors.orange,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 _selectCard(1, 'Credit card', setState);
//                               },
//                               child: Container(
//                                 // padding: EdgeInsets.symmetric(horizontal: 16),
//                                 width: double.infinity,
//                                 height: 100,
//                                 child: Card(
//                                   color: Colors.white,
//                                   elevation: 5,
//                                   child: ListTile(
//                                     leading: Image.asset(
//                                       'assets/images/master_card.png',
//                                       width: 100,
//                                       fit: BoxFit.cover,
//                                     ),
//                                     title: Text(
//                                       'Credit card',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.orange,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     subtitle: Text(
//                                       '1326 **** **** 6214',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.orange,
//                                       ),
//                                     ),
//                                     trailing: Radio<int>(
//                                       value: 1,
//                                       groupValue: selectedCard,
//                                       onChanged: (int? value) {
//                                         _selectCard(1, 'Credit card', setState);
//                                         _showSelectedCard(
//                                             context, 'Credit card');
//                                       },
//                                       activeColor: Colors.orange,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 _selectCard(2, 'Debit card', setState);
//                               },
//                               child: Container(
//                                 //padding: EdgeInsets.symmetric(horizontal: 16),
//                                 width: double.infinity,
//                                 height: 100,
//                                 child: Card(
//                                   color: Colors.white,
//                                   elevation: 5,
//                                   child: ListTile(
//                                     leading: Image.asset(
//                                       'assets/images/visa_image.png',
//                                       width: 100,
//                                       fit: BoxFit.cover,
//                                     ),
//                                     title: Text(
//                                       'Debit card',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.orange,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     subtitle: Text(
//                                       '2451 **** **** 2584',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.orange,
//                                       ),
//                                     ),
//                                     trailing: Radio<int>(
//                                       value: 2,
//                                       groupValue: selectedCard,
//                                       onChanged: (int? value) {
//                                         _selectCard(2, 'Debit card', setState);
//                                         _showSelectedCard(
//                                             context, 'Debit card');
//                                       },
//                                       activeColor: Colors.orange,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10),
//                                     child: Text(
//                                       'Delivery Address',
//                                       style: TextStyle(
//                                         fontSize: 23,
//                                         color: Colors.orange,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () async {
//                                     isloading = true;
//                                     await getLocation(context, setState);
//                                   },
//                                   child: StatefulBuilder(
//                                     builder: (context, setState) {
//                                       return Card(
//                                         color: Colors.white,
//                                         child: ListTile(
//                                           leading: Image.asset(
//                                             'assets/images/delivery_man.png',
//                                           ),
//                                           title: Row(
//                                             children: [
//                                               Icon(
//                                                 Icons.location_on,
//                                                 size: 35,
//                                               ),
//                                               Container(
//                                                 constraints: BoxConstraints(
//                                                     maxWidth:
//                                                         screenWidth * 0.34,
//                                                     maxHeight: 100),
//                                                 child: Text(
//                                                   deliveryAddress,
//                                                   maxLines: 2,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           trailing: IconButton(
//                                             onPressed: () {
//                                               getLocation(context, setState);
//                                             },
//                                             icon: Icon(
//                                               Icons.edit,
//                                               size: 25,
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Divider(
//                                   indent: 10,
//                                   endIndent: 10,
//                                   thickness: 3,
//                                   color: Colors.orange,
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Delivery time:',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.orange,
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Text(
//                                       '15-20 Min',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 15,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Delivery services:',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.orange,
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Text(
//                                       '\$${widget.deliveryPrice}',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 15,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Total:',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.orange,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Text(
//                                       '\$${widget.total}',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.orange,
//                                   ),
//                                   width: screenWidth,
//                                   child: MaterialButton(
//                                     onPressed: () {
//                                       _showInvoiceDialog(context);
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Make a payment',
//                                         style: TextStyle(
//                                           fontSize: 25,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(20),
//               ),
//             ),
//             isScrollControlled: true,
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Checkout',
//             style: TextStyle(
//               fontSize: 25,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:food_ordering_app/widgets/map_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class CheckoutButton extends StatefulWidget {
  CheckoutButton({
    super.key,
    required this.deliveryPrice,
    required this.total,
    required this.customerName,
    required this.items,
  });

  double deliveryPrice;
  double total;
  String customerName;
  final List<dynamic> items;

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  int selectedCard = 1;
  String selectedCardName = 'Credit card';

  String deliveryAddress = "Default Delivery Address";

  bool isLoading = false;

  // Method to update the address
  void _updateAddress(String newAddress) {
    setState(() {
      deliveryAddress = newAddress;
    });
  }

  // Method to get the current location
  Future<loc.LocationData?> _getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    // Return current location
    return await location.getLocation();
  }

  // Method to get the address and show it in a dialog
  Future<void> getLocation(BuildContext context, StateSetter setState) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    loc.LocationData? _currentLocation = await _getCurrentLocation();

    if (_currentLocation == null) {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      // Handle the error if location is not available
      return;
    }

    // Convert coordinates to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentLocation.latitude!,
      _currentLocation.longitude!,
    );

    String _address;

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      _address = '${placemark.street}';
    } else {
      _address = 'Address not found';
    }

    // Update the address and hide loading indicator
    setState(() {
      deliveryAddress = _address;
      isLoading = false;
    });

    // Show the address in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Current Address", style: TextStyle(color: Colors.orange)),
        content: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              )
            : Text(
                _address,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToMap(context, _currentLocation);
                },
                child: Text(
                  "View on Map",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _updateAddress(_address); // Update the address here
                      Navigator.of(context).pop(); // Close the dialog
                    });
                  }
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToMap(
      BuildContext context, loc.LocationData? locationData) async {
    if (locationData == null) {
      locationData = await _getCurrentLocation();
    }

    if (locationData == null) {
      // Handle the error if location is not available
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(
          locationData: locationData!,
        ),
      ),
    );
  }

  void _showSelectedCard(BuildContext context, String cardName) {
    final snackBar = SnackBar(
      content: Text('You selected: $cardName'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _selectCard(int cardValue, String cardName, StateSetter setState) {
    if (mounted) {
      setState(() {
        selectedCard = cardValue;
        selectedCardName = cardName; // Update the selected card name
        _showSelectedCard(context, cardName);
      });
    }
  }

  void _showInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Invoice',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Customer Name: ',
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        widget.customerName,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Card Type: ',
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        selectedCardName,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Delivery Address: ',
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        '$deliveryAddress',
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Delivery Price: ',
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      '\$${widget.deliveryPrice.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Products:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                ...widget.items.map((item) {
                  final product =
                      item['product'] as Map<String, dynamic>? ?? {};
                  final productName = product['name'] as String? ?? '';
                  final quantity = item['quantity'] as int? ?? 0;
                  final itemTotalPrice = item['totalPrice'] as double? ?? 0.0;

                  return ListTile(
                    leading: Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    title: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      '$productName',
                    ),
                    trailing: Text(
                      '\$${itemTotalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                const Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Colors.orange,
                  thickness: 3,
                ),
                ListTile(
                  leading: const Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    '\$${widget.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        elevation: 5,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: screenHeight * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffF4F4F4),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  'Order Confirmation',
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                _selectCard(1, 'Credit card', setState);
                              },
                              child: Container(
                                // padding: EdgeInsets.symmetric(horizontal: 16),
                                width: double.infinity,
                                height: 100,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/master_card.png',
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      'Credit card',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '1326 **** **** 6214',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    trailing: Radio<int>(
                                      value: 1,
                                      groupValue: selectedCard,
                                      onChanged: (int? value) {
                                        _selectCard(1, 'Credit card', setState);
                                        _showSelectedCard(
                                            context, 'Credit card');
                                      },
                                      activeColor: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                _selectCard(2, 'Debit card', setState);
                              },
                              child: Container(
                                //padding: EdgeInsets.symmetric(horizontal: 16),
                                width: double.infinity,
                                height: 100,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/images/visa_image.png',
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      'Debit card',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '2451 **** **** 2584',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    trailing: Radio<int>(
                                      value: 2,
                                      groupValue: selectedCard,
                                      onChanged: (int? value) {
                                        _selectCard(2, 'Debit card', setState);
                                        _showSelectedCard(
                                            context, 'Debit card');
                                      },
                                      activeColor: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Delivery Address',
                                      style: TextStyle(
                                        fontSize: 23,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    isLoading = true;
                                    await getLocation(context, setState);
                                  },
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: Image.asset(
                                            'assets/images/delivery_man.png',
                                          ),
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 35,
                                              ),
                                              isLoading
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 40,
                                                      ),
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.orange,
                                                      ),
                                                    )
                                                  : Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  screenWidth *
                                                                      0.34,
                                                              maxHeight: 100),
                                                      child: Text(
                                                        deliveryAddress,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              getLocation(context, setState);
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  thickness: 3,
                                  color: Colors.orange,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery time:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '15-20 Min',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery services:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '\$${widget.deliveryPrice}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '\$${widget.total}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange,
                                  ),
                                  width: screenWidth,
                                  child: MaterialButton(
                                    onPressed: () {
                                      _showInvoiceDialog(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Make a payment',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            isScrollControlled: true,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Checkout',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
