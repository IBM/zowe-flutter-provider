import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zowe_flutter/enums.dart';
import 'package:zowe_flutter/models/response_status_message.dart';

import 'package:zowe_flutter/providers/auth.dart';
import 'package:zowe_flutter/providers/data_set_create.dart';

class DataSetCreateScreen extends StatefulWidget {
  @override
  _DataSetCreateScreenState createState() => _DataSetCreateScreenState();
}

class _DataSetCreateScreenState extends State<DataSetCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextEditingController _name, _deviceType, _recordFormat, _volumeSerial, _averageBlock, _blockSize,
    _directoryBlocks, _primary, _secondary, _recordLength;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => DataSetCreateProvider(),
      child: Consumer(
        builder: (context, DataSetCreateProvider dsCreateProvider, _) {
          _name = TextEditingController(text: dsCreateProvider.dataSet.name);
          _deviceType = TextEditingController(text: dsCreateProvider.dataSet.deviceType);
          _recordFormat = TextEditingController(text: dsCreateProvider.dataSet.recordFormat);
          _volumeSerial = TextEditingController(text: dsCreateProvider.dataSet.volumeSerial);
          _averageBlock = TextEditingController(text: dsCreateProvider.dataSet.averageBlock.toString());
          _blockSize = TextEditingController(text: dsCreateProvider.dataSet.blockSize.toString());
          _directoryBlocks = TextEditingController(text: dsCreateProvider.dataSet.directoryBlocks.toString());
          _primary = TextEditingController(text: dsCreateProvider.dataSet.primary.toString());
          _secondary = TextEditingController(text: dsCreateProvider.dataSet.secondary.toString());
          _recordLength = TextEditingController(text: dsCreateProvider.dataSet.recordLength.toString());

          return Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text("Create data set"),
            ),
            body: Form(
              key: _formKey,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    // Name
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _name,
                        validator: (value) =>
                            (value.isEmpty || value == null) ? "Please enter data set name!" : null,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.wb_iridescent),
                            labelText: "Data Set Name (*)",
                            border: OutlineInputBorder()),
                        onChanged: (name) => dsCreateProvider.dataSet.name = name,
                      ),
                    ),

                    // Data set organization
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField<DataSetOrganization>(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.format_list_numbered_rtl),
                              labelText: "Data Set Organization (*)",
                              border: OutlineInputBorder()),
                          value: dsCreateProvider.dataSet.dataSetOrganization == null ? null : DataSetOrganization.values.firstWhere((unit) => unit.toString() == dsCreateProvider.dataSet.dataSetOrganization),
                          hint: Text('Data Set Organization'),
                          onChanged: (DataSetOrganization newValue) {
                            setState(() {
                              dsCreateProvider.dataSet.dataSetOrganization = newValue.toString();
                            });
                          },
                          items: DataSetOrganization.values
                              .map((DataSetOrganization org) {
                            return DropdownMenuItem<DataSetOrganization>(
                                value: org,
                                child: Text(org.toString().split('.')[1]));
                          }).toList()),
                    ),

                    // Record format
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _recordFormat,
                        validator: (value) =>
                            (value.isEmpty) ? "Please enter record format!" : null,
                        style: style,
                        decoration: InputDecoration(
                          
                            prefixIcon: Icon(Icons.format_align_center),
                            labelText: "Record Format (*)",
                            border: OutlineInputBorder()),
                        onChanged: (recf) => dsCreateProvider.dataSet.recordFormat = recf,
                      ),
                    ),

                    // Primary
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _primary,
                        keyboardType: TextInputType.number,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.looks_one),
                            labelText: "Primary (*)",
                            border: OutlineInputBorder()),
                        onChanged: (primary) =>
                            dsCreateProvider.dataSet.primary = int.parse(primary),
                      ),
                    ),

                    // Secondary
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _secondary,
                        keyboardType: TextInputType.number,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.looks_two),
                            labelText: "Secondary (*)",
                            border: OutlineInputBorder()),
                        onChanged: (secondary) =>
                            dsCreateProvider.dataSet.secondary = int.parse(secondary),
                      ),
                    ),

                    // Record length
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _recordLength,
                        keyboardType: TextInputType.number,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.format_list_numbered_rtl),
                            labelText: "Record Length (*)",
                            border: OutlineInputBorder()),
                        onChanged: (recl) =>
                            dsCreateProvider.dataSet.recordLength = int.parse(recl),
                      ),
                    ),

                    // Allocation unit
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField<AllocationUnit>(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.format_list_numbered_rtl),
                              labelText: "Allocation Unit (*)",
                              border: OutlineInputBorder()),
                          value: dsCreateProvider.dataSet.allocationUnit == null ? null : AllocationUnit.values.firstWhere((unit) => unit.toString() == dsCreateProvider.dataSet.allocationUnit),
                          hint: Text('Allocation Unit'),
                          onChanged: (AllocationUnit newValue) {
                            setState(() {
                              dsCreateProvider.dataSet.allocationUnit = newValue.toString();
                            });
                          },
                          items: AllocationUnit.values.map((AllocationUnit unit) {
                            return DropdownMenuItem<AllocationUnit>(
                                value: unit,
                                child: Text(unit.toString().split('.')[1]));
                          }).toList()),
                    ),

                                        // Volume serial
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _volumeSerial,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.view_column),
                            labelText: "Volume Serial",
                            border: OutlineInputBorder()),
                        onChanged: (ser) => dsCreateProvider.dataSet.volumeSerial = ser,
                      ),
                    ),

                    // Block size
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _blockSize,
                        keyboardType: TextInputType.number,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.folder_open),
                            labelText: "Block Size",
                            border: OutlineInputBorder()),
                        onChanged: (size) =>
                            dsCreateProvider.dataSet.blockSize = int.parse(size),
                      ),
                    ),

                    // Directory blocks
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _directoryBlocks,
                        keyboardType: TextInputType.number,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.fiber_manual_record),
                            labelText: "Directory Blocks",
                            border: OutlineInputBorder()),
                        onChanged: (blocks) =>
                            dsCreateProvider.dataSet.directoryBlocks = int.parse(blocks),
                      ),
                    ),

                    // Average block
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _averageBlock,
                        keyboardType: TextInputType.number,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.folder),
                            labelText: "Avg Block",
                            border: OutlineInputBorder()),
                        onChanged: (avg) =>
                            dsCreateProvider.dataSet.averageBlock = int.parse(avg),
                      ),
                    ),

                    // Device type
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _deviceType,
                        style: style,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.zoom_out_map),
                            labelText: "Device Type",
                            border: OutlineInputBorder()),
                        onChanged: (type) => dsCreateProvider.dataSet.deviceType = type,
                      ),
                    ),
                    

                    dsCreateProvider.status == ActionStatus.Working
                        ? Center(child: CircularProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30.0),
                              color: Color.fromRGBO(42, 125, 225, 1),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    ResponseStatusMessage response = await dsCreateProvider.createDataSet(
                                      authToken: auth.user.token
                                    );

                                    if (response.error) {
                                      _key.currentState.showSnackBar(SnackBar(
                                        content: Text("${response.status}: ${response.message}"),
                                      ));
                                    } else {
                                      dsCreateProvider.resetDataSet();
                                      _key.currentState.showSnackBar(SnackBar(
                                        content: Text("${response.status}: ${response.message}"),
                                      ));
                                    }
                                  }
                                },
                                child: Text(
                                  "Create",
                                  style: style.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
        );
      }
    )
    );
  }
}
