import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeSignalR();
  }

  void _initializeSignalR() async {
    print('Initializing SignalR...');
    _hubConnection = HubConnectionBuilder().withUrl("http://192.168.8.168:5120/maphub").build();

    _hubConnection.on("Notification", (List<Object?>? notificationData) {
      // Handle notification from server
      print('Received Notification: $notificationData');
      // You can add logic here to handle the notification
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
                  // Add functionality for other buttons
                },
                child: Text('Accept Ride'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for other buttons
                },
                child: Text('Pick Passenger'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for other buttons
                },
                child: Text('Drop Passenger'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for other buttons
                },
                child: Text('Confirm Payment'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
