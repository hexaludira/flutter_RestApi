import 'package:flutter/material.dart';
import 'package:flutter_1/models/profile.dart';
import 'package:flutter_1/screens/form_add_screen.dart';
import 'package:flutter_1/screens/login_view.dart';
import 'package:flutter_1/screens/register_view.dart';
import 'package:flutter_1/utils/api.dart';
import 'package:flutter_1/screens/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Metal App V2',
    theme: ThemeData(
      primaryColor: Colors.grey[600],
      //brightness: Brightness.dark,
    ),
    //home: Pandora(),
    //initialRoute: "/",
    routes: <String, WidgetBuilder>{
      '/' : (BuildContext context) => new SplashScreenPage(),//LoginPage(),
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
  BuildContext context;
  ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    apiService.getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "List Metal Problem V1.0",
          style: TextStyle(color: Colors.white),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     tooltip: 'Tambah Data',
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => FormAddScreen()),);
        //     }
        //   ),
        // ],
      ),
      body: SafeArea(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FormAddScreen()));
        }
      ),
    );
   
  }

  Widget _buildListView(List<Profile> profiles) {
    return RefreshIndicator(
      onRefresh: refreshData, 
      child: Padding(
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
                          profile.location + " \u25BA " + profile.detail,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      //Text(profile.detail, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700]),),
                      Text(profile.date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700]),),
                      Text('Status: ' + profile.status),
                      Text('Ket: ' + profile.remark),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Warning"),
                                    content: Text("Yakinkah kau menghapus data ${profile.location} \u25BA ${profile.detail}?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Pastinya"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => FormAddScreen()),);
                                          apiService.deleteData(profile.id).then((isSuccess) {
                                            if(isSuccess) {
                                              setState(() {});
                                            } else {
                                              return AlertDialog(title: Text("Gagal"), content: Text("gagal terus"),);  
                                            }

                                          });
                                          
                                          
                                          // apiService.deleteProfile(profile.id).then((isSuccess) {
                                          //   if(isSuccess) {
                                          //     setState(() {});
                                              
                                          //     Scaffold.of(context).showSnackBar(SnackBar(content: Text("Hapus data berhasil")));
                                          //   } else {
                                          //     Scaffold.of(context).showSnackBar(SnackBar(content: Text("Yahh.. Hapus data gagal:(")));
                                          //   }
                                          // });
                                        }, 
                                        
                                      ),
                                      FlatButton(
                                        child: Text("Ga jadi"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                }
                              );
                            }, 
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FormAddScreen(profile: profile,),));
                              
                            }, 
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
      ),
    );
     
  }

  Future refreshData() async{
    await Future.delayed(Duration(seconds: 2));
    apiService.getProfiles();
    setState(() {});
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
