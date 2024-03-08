import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:taxi_driver_simulation_flutter_1/utils/notification_utils.dart';

void main() {
  runApp(MaterialApp(home: DriverTestApp()));
}

class DriverTestApp extends StatefulWidget {
  @override
  _DriverTestAppState createState() => _DriverTestAppState();
}

class _DriverTestAppState extends State<DriverTestApp> {
  late HubConnection _hubConnection;
  bool _isConnected = false;
  final NotificationUtils _notificationUtils = NotificationUtils();


  @override
  void initState() {
    super.initState();
    _initializeSignalR();
  }

  void _initializeSignalR() async {
    print('Initializing SignalR...');
    _hubConnection = HubConnectionBuilder().withUrl("http://192.168.8.168:5120/maphub").build();

    _hubConnection.on("NewRideNotification", (List<Object?>? rideData) {
      // Handle new ride notification
      if (rideData != null && rideData.length >= 4) {
        String pickupLatitude = rideData[0] as String;
        var pickupLongitude = rideData[1];
        var dropoffLatitude = rideData[2];
        var dropoffLongitude = rideData[3];

        var notificationString = 'Received New Ride Notification: '
            'Pickup Latitude: $pickupLatitude, '
            'Pickup Longitude: $pickupLongitude, '
            'Dropoff Latitude: $dropoffLatitude, '
            'Dropoff Longitude: $dropoffLongitude';

        print(notificationString);
        _notificationUtils.showNotification(pickupLatitude);
        _showSnackbar(context,'Received New Ride Notification');
      } else {
        print('Received incomplete or empty New Ride Notification');
      }
    });


    _hubConnection.on("RideAccepted", (List<Object?>? rideData) {
      // Handle ride acceptance
      if (rideData != null && rideData.length >= 4) {
        var pickupLatitude = rideData[0];
        String pickupLongitude = rideData[1] as String;
        var dropoffLatitude = rideData[2];
        var dropoffLongitude = rideData[3];

        var acceptanceString = 'Ride Accepted: '
            'Pickup Latitude: $pickupLatitude, '
            'Pickup Longitude: $pickupLongitude, '
            'Dropoff Latitude: $dropoffLatitude, '
            'Dropoff Longitude: $dropoffLongitude';

        print(acceptanceString);
        //_notificationUtils.showNotification(pickupLongitude);
        _showSnackbar(context,'RideAccepted Notification');
        // Add logic here to start the ride
      } else {
        print('Received incomplete or empty Ride Accepted notification');
      }
    });


    try {
      await _hubConnection.start();
      print('SignalR connected successfully');
      setState(() {
        _isConnected = true;
      });
    } catch (e) {
      print('Error connecting to SignalR: $e');
    }
  }

  void _disconnectFromServer() async {
    print('Disconnecting from SignalR...');
    await _hubConnection.stop();
    setState(() {
      _isConnected = false;
    });
    print('Disconnected from SignalR');
  }

  void _acceptRide() {
    print('Method called : _acceptRide');
    String pickupLatitude = '9.66687948479565';
    String pickupLongitude = '80.01168550372809';
    String dropoffLatitude = '9.384301041231042';
    String dropoffLongitude = '80.40887204157906';
    _hubConnection.invoke("AcceptRide", args: [pickupLatitude, pickupLongitude, dropoffLatitude, dropoffLongitude]);
  }

  void _startTrip() {
      print('Method called : _startTrip');
      String pickupLatitude = '9.66687948479565';
      String pickupLongitude = '80.01168550372809';
      String dropoffLatitude = '9.668249468406872';
      String dropoffLongitude = '80.01819666913711';
      _hubConnection.invoke("SimulateDriverTrip", args: [pickupLatitude, pickupLongitude, dropoffLatitude, dropoffLongitude]);
  }

  void _sayHai() {
    print('try to invooke sayHi');
    String pickupLatitude = '9.66687948479565';
    _hubConnection.invoke("SayHi", args: [pickupLatitude]);
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.yellow,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DriverTestApp'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: !_isConnected ? _initializeSignalR : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Connect to Server'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isConnected ? _disconnectFromServer : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Disconnect from Server'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Button Clicked : Accept Ride');
                  // Add functionality for other buttons
                  _acceptRide();
                },
                child: Text('Accept Ride'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Button Clicked : Pick Passenger');
                  // Add functionality for other buttons
                  _startTrip();
                },
                child: Text('Pick Passenger'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Button Clicked : Drop Passenger');
                  // Add functionality for other buttons
                },
                child: Text('Drop Passenger'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Button Clicked : Confirm Payment');
                  // Add functionality for other buttons
                },
                child: Text('Confirm Payment'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Button Clicked : Complete Ride');
                  // Add functionality for other buttons
                },
                child: Text('Complete Ride'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
