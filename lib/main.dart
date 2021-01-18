import 'package:flutter/material.dart';
import 'package:flutter_1/models/profile.dart';
import 'package:flutter_1/screens/form_add_screen.dart';
import 'package:flutter_1/screens/login_view.dart';
import 'package:flutter_1/screens/register_view.dart';
import 'package:flutter_1/utils/api.dart';
import 'package:flutter_1/screens/splash_screen.dart';
import 'package:http/http.dart';

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
  final TextEditingController _filter = TextEditingController();
  Icon _searchIcon = Icon(Icons.search);
  String _searchText = "";
  Widget _appBarTitle = Text("Metal Problem", style: TextStyle(color: Colors.white),);
  List<Profile> metalList = List();
  List<Profile> filteredData = List();
  
  BuildContext context;
  ApiService apiService;

  _HomeScreenState() {
    _filter.addListener(() {
       if(_filter.text.isEmpty){
      setState(() {
        _searchText = "";
       filteredData = metalList;
      });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
   
  }

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
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            tooltip: 'Cari Data',
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => FormAddScreen()),);
              _cariData();
            }
          ),
        ],
      ),
      body: SafeArea(
        child: _futureBuilder(),
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


  Widget _futureBuilder(){
    return FutureBuilder(
          future: apiService.getProfiles(),
          builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            //List<Profile> profiles = snapshot.data;
            filteredData = snapshot.data;
            return _buildListView(filteredData);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
            }
          },
        );
  }

  Widget _buildListView(List<Profile> profiles) {
    if(_searchText.isNotEmpty){
        List<Profile> tempList = List();
          profiles.forEach((element) {
        if(element.location.toLowerCase().contains(_searchText.toLowerCase()) || element.detail.toLowerCase().contains(_searchText.toLowerCase()) || element.date.toLowerCase().contains(_searchText.toLowerCase())){
          tempList.add(element);
        }
        
      });
      filteredData = tempList;
    }
    
    return RefreshIndicator(
      onRefresh: refreshData, 
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            Profile profile = filteredData[index];
            // if () {
              
            // }
           
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
                                      content: Text("Hapus data ${profile.location} \u25BA ${profile.detail}?"),
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
          itemCount: filteredData.length,
        ),
      ),
                      
    );
     
  }

  Future refreshData() async{
    await Future.delayed(Duration(seconds: 2));
    apiService.getProfiles();
    setState(() {});
  }

  void _cariData() {
    setState(() {
      if (this._searchIcon.icon == Icons.search){
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white,),
            hintText: 'Cari...',
            hintStyle: TextStyle(color: Colors.white),
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text("Metal Problem", style: TextStyle(color: Colors.white),);
        filteredData = metalList;
        _filter.clear();
      }
    });
  }
  
}