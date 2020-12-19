import 'package:flutter/material.dart';
import 'package:flutter_1/models/profile.dart';
import 'package:flutter_1/screens/login_view.dart';
import 'package:flutter_1/screens/register_view.dart';
import 'package:flutter_1/utils/api.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: Pandora(),
    //initialRoute: "/",
    routes: <String, WidgetBuilder>{
      '/' : (BuildContext context) => new HomeScreen(),//LoginPage(),
      '/hal_satu': (BuildContext context) => new Pandora(),
      '/hal_dua': (BuildContext context) => new Pandora2(),
      '/hal_tiga': (BuildContext context) => new PandoraList(),
      RegisterPage.routeName : (context) => RegisterPage(),
    },
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: apiService.getProfiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Profile> profiles = snapshot.data;
            return _buildListView(profiles);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Profile> profiles) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Profile profile = profiles[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.nama,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(profile.nomor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {}, 
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {}, 
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: profiles.length,
      ),
    );
  }
}

// class ApiTes extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     ApiService().getProfiles().then((value) => print("value: $value"));
//     return Container(
      
//     );
//   }
// }

 
class Pandora2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Halaman Dua",
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.lime,
        centerTitle: true,
      ),
      body: Center(
        child : Container(
          child: new Text("data"),
        )
      ),
    );
  }
}

//halaman awal
class Pandora extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          leading: IconButton(icon: Icon(Icons.translate), onPressed: null),
         actions: <Widget>[IconButton(icon: Icon(Icons.tag_faces), onPressed: null)],
          title: Text(
            "Pandora List",
            style: TextStyle(color: Colors.grey[900]),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Container(
          child: ListView(
            
          ),
        ),
        // body: Center(
        //   child: RaisedButton(
            
        //     child: Text("Selanjutnya", style: TextStyle(fontSize: 30)),
        //     onPressed: (){
        //       Navigator.pushNamed(context, '/hal_dua');
        //     },
        //   ),
        // )
        );
  }
}



class PandoraList extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return ListView(
     children: <Widget>[
       ListTile(
         title : Text("Final Fantasy VII Remake"),
         leading: Icon(Icons.games),
       ),
       ListTile(
         title : Text("Resident Evil 7"),
         leading: Icon(Icons.gradient),
       ),
     ],
      
    );
  }
}

// class ListView extends

//     // return MaterialApp(
//     //   title: 'Sego Kucing',
//     //   home: Scaffold(
//     //     backgroundColor: Colors.lightGreenAccent,
//     //     appBar: AppBar(
//     //       title: Text('Sego Kucing pak No'),
//     //       backgroundColor: Colors.blueGrey,
//     //     ),
//     //     body: Column(
//     //       children:<Widget>[
//     //         Image.network('https://www.petanikode.com')
//     //       ],
//     //       ),
//     //   ),
//     // );
//   }

// }
