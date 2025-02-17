import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class PharmacyPage extends StatefulWidget {
  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> medicines = [];
  List<Map<String, dynamic>> filteredMedicines = [];
  final String imageUrl = 'assets/banner1.jpg';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMedicinesFromJson();
  }

  Future<void> loadMedicinesFromJson() async {
    final String response = await rootBundle.loadString('assets/medicines.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      medicines = data.map((item) => Map<String, dynamic>.from(item)).toList();
      filteredMedicines = [];
    });
  }

  void filterMedicines(String query) {
    setState(() {
      filteredMedicines = medicines.where((medicine) {
        final name = medicine['name'].toLowerCase();
        final description = medicine['description'].toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || description.contains(searchLower);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToPaymentPage(Map<String, dynamic> medicine, int quantity) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(medicine: medicine, quantity: quantity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              onChanged: (value) {
                filterMedicines(value);
              },
              decoration: InputDecoration(
                hintText: 'Search medicines...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Show search results above the banner
            if (filteredMedicines.isNotEmpty)
              Column(
                children: filteredMedicines.map((medicine) {
                  return ListTile(
                    title: Text(medicine['name']),
                    subtitle: Text(medicine['description']),
                    trailing: Text('₹${medicine['price']}'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          int quantity = 1;
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Select Quantity for ${medicine['name']}'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Price per unit: ₹${medicine['price']}'),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Quantity:'),
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            if (quantity > 1) {
                                              setState(() {
                                                quantity--;
                                              });
                                            }
                                          },
                                        ),
                                        Text('$quantity'),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              quantity++;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      navigateToPaymentPage(medicine, quantity);
                                    },
                                    child: Text('Confirm (₹${medicine['price'] * quantity})'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }).toList(),
              ),

            // Image Banner
            if (filteredMedicines.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
          if (index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This is Doctor Page')),
            );
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This is Health Tips Page')),
            );
          } else if (index == 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This is Profile Page')),
            );
          }
        },
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Pharmacy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Doctor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Health Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> medicine;
  final int quantity;

  PaymentPage({required this.medicine, required this.quantity});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? currentLocation = "Fetching current location...";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController upiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => currentLocation = "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => currentLocation = "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => currentLocation = "Location permission permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      currentLocation = "Lat: ${position.latitude}, Long: ${position.longitude}";
      addressController.text = currentLocation ?? "";
    });
  }

  void _showOrderSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Placed Successfully'),
        content: Icon(Icons.check_circle, color: Colors.green, size: 60),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

   Widget build(BuildContext context) {
    int totalPrice = widget.medicine['price'] * widget.quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Section'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/medicine_image.png',
              height: 100,
            ),
            SizedBox(height: 10),
            Text(
              widget.medicine['name'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Total Price: ₹$totalPrice'),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: _getCurrentLocation,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: upiController,
              decoration: InputDecoration(
                labelText: 'UPI ID (for UPI Payment)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (upiController.text.isNotEmpty) {
                  _processUpiPayment();
                } else {
                  _showOrderSuccess();
                }
              },
              child: Text('PAY'),
            ),
          ],
        ),
      ),
    );
  }

  void _processUpiPayment() {
    final upiId = upiController.text.trim();

    if (upiId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid UPI ID')),
      );
      return;
    }

    // Mock UPI payment processing
    Future.delayed(Duration(seconds: 2), () {
      _showOrderSuccess();
    });
  }
}

