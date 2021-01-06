import 'package:flutter/material.dart';
import 'package:flutter_1/models/profile.dart';
import 'package:flutter_1/utils/api.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Profile profile;

  FormAddScreen({this.profile});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  var _valPerbaikan;
  var _listStatus = ["Sedang dikerjakan", "LP selesai service", "Lapor QIP", "Kirim Vendor", "Sensor datang"];

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
  void initState() {
    if(widget.profile != null){
      _isFieldDateValid = true;
      _controllerDate.text = widget.profile.date;
      _isFieldDetailValid = true;
      _controllerDetail.text = widget.profile.detail;
      _isFieldLocationValid = true;
      _controllerLocation.text = widget.profile.location;
      _isFieldStatusValid = true;
      _controllerStatus.text = widget.profile.status;
      _isFieldRemarkValid = true;
      _controllerRemark.text = widget.profile.remark;
    }
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.profile == null ? "Tambah Data" : "Ubah data",
          style: TextStyle(color: Colors.white),
        ),
        leading: null,
        automaticallyImplyLeading: true,
      ),

      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Stack(children: <Widget>[
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

                          Profile profile = Profile(date: date, detail: detail, location: location, status: status, remark: remark);

                          if (widget.profile == null) {
                              _apiService.createProfile(profile).then((isSuccess) {
                              setState (() => _isLoading = false);
                              if (isSuccess) {
                                Navigator.pop(_scaffoldState.currentState.context);
                              } else {
                                _scaffoldState.currentState.showSnackBar(SnackBar(content: Text("Submit data gagal"),));
                              }
                            });
                          } else {
                            profile.id = widget.profile.id;
                            _apiService.createProfile(profile).then((isSuccess) {
                              setState(() => _isLoading = false);
                              if (isSuccess) {
                                Navigator.pop(_scaffoldState.currentState.context);
                              } else {
                                _scaffoldState.currentState.showSnackBar(SnackBar(content: Text("Update data gagal"),));
                              }
                            });
                          }
                          
                        },
                        child: Text(
                          widget.profile == null ? "Submit".toUpperCase() : "Update Data".toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.orange[600],
                      ),
                    ),
                  ],
                  ),
                ),
                _isLoading ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
                : Container(),
              ],
              )
            ])
          ),

          SliverFillRemaining(
            hasScrollBody: false,
              child: Container (
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  
                ),
              ),
          ),
        ],
      )
      
    );
      // body: Stack(
      //   children: <Widget>[
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: <Widget>[
      //           _buildTextFieldDate(),
      //           _buildTextFieldDetail(),
      //           _buildTextFieldLocation(),
      //           _buildTextFieldStatus(),
      //           _buildTextFieldRemark(),
      //           Padding(
      //             padding: const EdgeInsets.only(top: 8.0),
      //             child: RaisedButton(
      //               onPressed: () {
      //                 if (_isFieldDateValid == null || _isFieldDetailValid == null || _isFieldLocationValid == null|| _isFieldStatusValid == null || _isFieldRemarkValid == null || !_isFieldDateValid || !_isFieldDetailValid || !_isFieldLocationValid || !_isFieldStatusValid || !_isFieldRemarkValid) {
      //                   _scaffoldState.currentState.showSnackBar(SnackBar(content: Text("Tolong isi semua data"),),);
      //                   return;
      //                 }
      //                 setState(() => _isLoading = true);
      //                 String date = _controllerDate.text.toString();
      //                 String detail = _controllerDetail.text.toString();
      //                 String location = _controllerLocation.text.toString();
      //                 String status = _controllerStatus.text.toString();
      //                 String remark = _controllerRemark.text.toString();

      //                 Profile profile = Profile(date: date, detail: detail, location: location, status: status, remark: remark);

      //                 if (widget.profile == null) {
      //                     _apiService.createProfile(profile).then((isSuccess) {
      //                     setState (() => _isLoading = false);
      //                     if (isSuccess) {
      //                       Navigator.pop(_scaffoldState.currentState.context);
      //                     } else {
      //                       _scaffoldState.currentState.showSnackBar(SnackBar(content: Text("Submit data gagal"),));
      //                     }
      //                   });
      //                 } else {
      //                   profile.id = widget.profile.id;
      //                   _apiService.createProfile(profile).then((isSuccess) {
      //                     setState(() => _isLoading = false);
      //                     if (isSuccess) {
      //                       Navigator.pop(_scaffoldState.currentState.context);
      //                     } else {
      //                       _scaffoldState.currentState.showSnackBar(SnackBar(content: Text("Update data gagal"),));
      //                     }
      //                   });
      //                 }
                      
      //               },
      //               child: Text(
      //                 widget.profile == null ? "Submit".toUpperCase() : "Update Data".toUpperCase(),
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //               color: Colors.orange[600],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     _isLoading ? Stack(
      //       children: <Widget>[
      //         Opacity(
      //           opacity: 0.3,
      //           child: ModalBarrier(
      //             dismissible: false,
      //             color: Colors.grey,
      //           ),
      //         ),
      //         Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //       ],
      //     )
      //     : Container(),
      //   ],
      // ),


   
  }

  //DateTime Field
  Widget _buildTextFieldDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: DateTimeField(
        format: DateFormat('dd-MMM-yyyy'),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context, 
            initialDate: DateTime.now(), 
            firstDate: DateTime(2019), 
            lastDate: DateTime(2025)
          );
        },
        controller: _controllerDate,
        decoration: InputDecoration(
          labelText: "Tanggal",
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorText: _isFieldDateValid == null || _isFieldDateValid ? null : "Tanggal harus diisi"
        ),
        onChanged: (value) {
          bool isFieldValid = value.toString().trim().isNotEmpty;
          if(isFieldValid != _isFieldDateValid) {
            setState(() => _isFieldDateValid = isFieldValid);
          }
        },
      ),
    );
  }

  //Detail Field
  Widget _buildTextFieldDetail() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: _controllerDetail,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Detail",
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          errorText: _isFieldDetailValid == null || _isFieldDetailValid ? null : "Detail harus diisi",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _isFieldDetailValid) {
            setState(() => _isFieldDetailValid = isFieldValid);
          }
        },
      ),
    );

    // return TextField(
    //   controller: _controllerDetail,
    //   keyboardType: TextInputType.text,
    //   decoration: InputDecoration(
    //     labelText: "Detail",
    //     fillColor: Colors.white,
    //     filled: true,
    //     focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(25),
    //       borderSide: BorderSide(color: Colors.grey),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: BorderSide(color: Colors.grey),
    //     ),
    //     errorText: _isFieldDetailValid == null || _isFieldDetailValid ? null : "Detail harus diisi",
    //   ),
    //   onChanged: (value) {
    //     bool isFieldValid = value.trim().isNotEmpty;
    //     if (isFieldValid != _isFieldDetailValid) {
    //       setState(() => _isFieldDetailValid = isFieldValid);
    //     }
    //   },
    // );
  }

  //Location Field
  Widget _buildTextFieldLocation() {
    return TextField(
      controller: _controllerLocation,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Lokasi",
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorText: _isFieldLocationValid == null || _isFieldLocationValid ? null : "Lokasi harus diisi"
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldLocationValid) {
          setState(() => _isFieldLocationValid = isFieldValid);
        }
      },
    ); 
  }

  //Status Field
  Widget _buildTextFieldStatus() {
    //isEmpty: _valPerbaikan == '';
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorText: _isFieldStatusValid == null || _isFieldStatusValid ? null : "Status harus diisi"
          ),
          isEmpty: _valPerbaikan == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text("Status Perbaikan"),
              value: _valPerbaikan,
              isDense: true,

              onChanged: (String newValue) {
                setState(() {
                  _valPerbaikan = newValue;
                  state.didChange(newValue);
                });
              },

              items: _listStatus.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ),
        );
      }
    ); 
  }

  //Remark field
  Widget _buildTextFieldRemark() {
    return TextField(
      controller: _controllerRemark,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Keterangan",
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorText: _isFieldRemarkValid == null || _isFieldRemarkValid ? null : "Remark harus diisi"
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldRemarkValid) {
          setState(() => _isFieldRemarkValid = isFieldValid);
        }
      },
    );
  }

  
}