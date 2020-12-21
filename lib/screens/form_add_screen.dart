import 'package:flutter/material.dart';
import 'package:flutter_1/models/profile.dart';
import 'package:flutter_1/utils/api.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}
//Aan cutting C = 10.10.46.118
class _FormAddScreenState extends State<FormAddScreen> {
  var _valPerbaikan;
  var _listStatus = ["Sedang dikerjakan", "Sudah selesai", "Lapor QIP", "Kirim Vendor"];

  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldDateValid;
  bool _isFieldDetailValid;
  bool _isFieldLocationValid;
  bool _isFieldStatusValid;
  bool _isFieldRemarkValid;

  TextEditingController _controllerDate = TextEditingController();
  TextEditingController _controllerDetail = TextEditingController();
  TextEditingController _controllerLocation = TextEditingController();
  TextEditingController _controllerStatus = TextEditingController();
  TextEditingController _controllerRemark = TextEditingController();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Tambah Data",
          style: TextStyle(color: Colors.white),
        ),
        leading: null,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldDate(),
                _buildTextFieldDetail(),
                _buildTextFieldLocation(),
                _buildTextFieldStatus(),
                _buildTextFieldRemark(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_isFieldDateValid == null || _isFieldDetailValid == null || _isFieldLocationValid == null|| _isFieldStatusValid == null || _isFieldRemarkValid == null || !_isFieldDateValid || !_isFieldDetailValid || !_isFieldLocationValid || !_isFieldStatusValid || !_isFieldRemarkValid) {
                        _scaffoldState.currentState.showSnackBar(SnackBar(content: Text("Tolong isi semua data"),),);
                        return;
                      }
                      setState(() => _isLoading = true);
                      String date = _controllerDate.text.toString();
                      String detail = _controllerDetail.text.toString();
                      String location = _controllerLocation.text.toString();
                      String status = _controllerStatus.text.toString();
                      String remark = _controllerRemark.text.toString();

                      Profile profile = Profile()
                    }
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}