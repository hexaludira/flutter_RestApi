import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_1/models/profile.dart';
import 'package:flutter_1/screens/form_add_screen.dart';
import 'package:flutter_1/screens/login_view.dart';
import 'package:flutter_1/screens/register_view.dart';
import 'package:flutter_1/utils/api.dart';
import 'package:flutter_1/screens/splash_screen.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Metal App',
    theme: ThemeData(
      primaryColor: Colors.grey[600],
      //brightness: Brightness.dark,
    ),
    //home: Pandora(),
    //initialRoute: "/",
    routes: <String, WidgetBuilder>{
      '/' : (BuildContext context) => new SplashScreenPage(),//LoginPage(),
      // '/hal_satu': (BuildContext context) => new Pandora(),
      // '/hal_dua': (BuildContext context) => new Pandora2(),
      // '/hal_tiga': (BuildContext context) => new PandoraList(),
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
  TextEditingController _filter = TextEditingController();
  List<Profile> profiles = List();
  List<Profile> filteredProfiles = List();
  Profile profile = Profile();
  String _searchText = "";



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
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.white),
      //   title: Text(
      //     "Metal Problem",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   // actions: <Widget>[
      //   //   IconButton(
      //   //     icon: const Icon(Icons.add),
      //   //     tooltip: 'Tambah Data',
      //   //     onPressed: () {
      //   //       Navigator.push(context, MaterialPageRoute(builder: (context) => FormAddScreen()),);
      //   //     }
      //   //   ),
      //   // ],
      // ),
      body: SafeArea(
        child: FutureBuilder(
          future: apiService.getProfiles(),
          builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.hasError) {
            
            return Center(
              child: Text("Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if(filteredProfiles.isEmpty){
              
               //List<Profile> profiles = snapshot.data;
               profiles = snapshot.data;
               print (profiles[0]);
               return FloatingSearchAppBar(
                  title: Text('Metal Problem', style: TextStyle(color: Colors.white),),
                  iconColor: Colors.white,
                  transitionDuration: const Duration(milliseconds: 800),
                  colorOnScroll: Colors.grey[600],
                  liftOnScrollElevation: 10.0,
                  color: Colors.grey[600],
                  hint: 'Cari...',
                  hintStyle: TextStyle(color: Colors.white54),
                  onQueryChanged: (_filter) => onSearch(_filter, profiles),
                  
                  body: _buildListView(profiles),
              
              );
            }
            else {
                profiles = filteredProfiles;
               print (profiles[0]);
               return FloatingSearchAppBar(
                  title: Text('Metal Problem', style: TextStyle(color: Colors.white),),
                  iconColor: Colors.white,
                  transitionDuration: const Duration(milliseconds: 800),
                  colorOnScroll: Colors.grey[600],
                  liftOnScrollElevation: 10.0,
                  color: Colors.grey[600],
                  hint: 'Cari...',
                  hintStyle: TextStyle(color: Colors.white54),
                  onQueryChanged: (_filter) => onSearch(_filter, profiles),
                  
                  body: _buildListView(profiles),
              
              );
              
              //print(filteredProfiles[0]);
              //List<Profile> profiles = snapshot.data;
               
            }
            
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
                                    content: Text("Yakinkah kau menghapus data ${profile.id}?"),
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
          itemCount: filteredProfiles.isEmpty ? profiles.length : filteredProfiles.length,
        ),
      ),
      );
    
     
  }

  List<Profile> onSearch(String textFilter, List<Profile> listCari) {
    setState(() {
        if (!(textFilter.isEmpty)){
        List<Profile> tempList = List();
        listCari.forEach((element) { 
          if (element.location.toLowerCase().contains(textFilter)){
            //print(element);
            tempList.add(element);
          }
        });
        filteredProfiles = tempList;
      }
   
      // filteredProfiles.forEach((element) {
      //   print(element);
      // });
      
    });

          // return 
          //   FloatingSearchAppBar(
          //     title: Text('Metal Problem', style: TextStyle(color: Colors.white),),
          //     iconColor: Colors.white,
          //     transitionDuration: const Duration(milliseconds: 800),
          //     colorOnScroll: Colors.grey[600],
          //     liftOnScrollElevation: 10.0,
          //     color: Colors.grey[600],
          //     hint: 'Cari...',
          //     hintStyle: TextStyle(color: Colors.white54),
          //     onQueryChanged: (query) => onSearch(query, profiles),
          //     //automaticallyImplyDrawerHamburger: true,
          //     debounceDelay: Duration(milliseconds: 800),
              
          //     body: _buildListView(filteredProfiles),
              
              
          //   );

    return filteredProfiles;
         
  }
  
  Future refreshData() async{
    await Future.delayed(Duration(seconds: 2));
    apiService.getProfiles();
    setState(() {});
  }
  
}



