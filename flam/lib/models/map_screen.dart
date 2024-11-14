class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isLoggedIn = false;   // Checks if the user is logged in
  String userRole = '';      // Stores the role of the logged-in user (e.g., Driver, Customer)
  
  @override
  void initState() {
    super.initState();
    // Initialization logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.zero,  // Padding for system bar
        child: Builder(
          builder: (context) {
            return Container(
              color: Colors.blueGrey,  // Placeholder for the map content
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.0),  // Padding for content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Map content goes here.',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Logged in as: $userRole',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
