import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_inventory_app/db_helper.dart';
import 'package:flutter_inventory_app/models/product_model.dart' as db_elements;
import 'package:multi_image_picker/multi_image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Product Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DBHelper db;
  db_elements.Product product;
  List<db_elements.Image> imageModels;

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();

  List<File> _files = List<File>();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> init() async {
    /// uri can be of android scheme content or file
    /// for iOS PHAsset identifier is supported as well

    List<Asset> assets = await loadAssets();
    List<File> files = [];
    for (Asset asset in assets) {
      final filePath =
      await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      files.add(File(filePath));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _files = files;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _brandController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(
        _files.length,
        (index) {
        File asset = _files[index];
        return Image.file(
          asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<List<Asset>> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      return resultList;
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.


    setState(() {
      images = resultList;
      _error = error;
    });
  }


  var _formKey = GlobalKey<FormState>();

  Widget _shtoFotot(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Center(child: Text('Error: $_error')),
          RaisedButton(
            child: Text("Shto fotot"),
            onPressed: (){
              init();
            },
          ),
          Expanded(
            child: buildGridView(),
          )
        ],
      ),
    );
  }

  Widget _registerItem(BuildContext context) {

    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return Form(
       key: _formKey,
        child: Column(
          children: <Widget>[
            // emri i patikes
            TextFormField(
              controller: _nameController,
              onChanged: (value) {
                updateName();
              },
              decoration: new InputDecoration(
                  labelStyle: TextStyle(
                      color: Colors.black54
                  ),
                  labelText: 'Emri',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.deepOrangeAccent
                      )
                  ),
              ),
              onTap: () => Border(bottom: BorderSide.none),
              validator: (val) => val.isNotEmpty ? null : "Shtyp emrin",
            ),

            // brendi i patikes
            TextFormField(
              controller: _brandController,
              onChanged: (value) {
                updateBrand();
              },
              decoration: new InputDecoration(
                  labelText: 'Brendi',
                  labelStyle: TextStyle(
                      color: Colors.black54
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.deepOrangeAccent
                      )
                  )
              ),
              validator: (val) => val.isNotEmpty ? null : "Shtyp brendin",
            ),

            // ngjyra i patikes
            TextFormField(
              controller: _colorController,
              onChanged: (value) {
                updateColor();
              },
              decoration: new InputDecoration(
                  labelText: 'Ngjyra',
                  labelStyle: TextStyle(
                      color: Colors.black54
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.deepOrangeAccent
                      )
                  )
              ),
              validator: (val) => val.isNotEmpty ? null : "Shtyp ngjyren",
            ),

            // madhesia i patikes
            TextFormField(
              controller: _sizeController,
              onChanged: (value) {
                updateSize();
              },
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  labelText: 'Madhesia',
                  labelStyle: TextStyle(
                      color: Colors.black54
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.deepOrangeAccent
                      )
                  )
              ),
              validator: (val) => val.isNotEmpty ? null : "Shtyp madhesine",
            ),

            // sasia
            TextFormField(
              controller: _qtyController,
              onChanged: (value) {
                updateQty();
              },
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  labelText: 'Sasia',
                  labelStyle: TextStyle(
                      color: Colors.black54
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.deepOrangeAccent
                      )
                  )
              ),
              validator: (val) => val.isNotEmpty ? null : "Shtyp sasine",
            ),
          ],
        )
    );
  }

  Widget _submitButton(BuildContext context) {
    return FlatButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {

            debugPrint("Save button clicked");
            _saveProductWithPictures();

          }

        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.deepOrangeAccent,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          width: 200.0,
          child: Text(
            'Regjistro',
            style: TextStyle(
              color: Colors.white60,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {

    // _nameController.text = product.name;
    // _brandController.text = product.brand;
    // _colorController.text = product.brand;
    // _sizeController.text = product.size as String;
    // _qtyController.text = product.qty as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: _registerItem(context),
          ),
          _shtoFotot(context),
          SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                for ( var i in _files ) Text(i.path.toString())
              ],
            ),
          ),
          _submitButton(context),
        ],
      ),

    );
  }

  void _saveProductWithPictures() async{

    db = DBHelper();
    // var db = await dbHelper.initDb();

    product = db_elements.Product();
    imageModels = List<db_elements.Image>();
    int result;

    await db.insertProduct(product).whenComplete(() => {
      _nameController.clear(),
      _brandController.clear(),
      _colorController.clear(),
      _sizeController.clear(),
      _qtyController.clear()
    });

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
    //save the product

    // end save the product

    //save the product picture/s
    for (var i in _files) imageModels.add(db_elements.Image(path: i.path.toString()));

    for (var image in imageModels) await db.insertImage(image).whenComplete(() => {

      _files.clear()

    });
    //end save the product picture/s

  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  void updateName() {
    product.name = _nameController.text.toString();
  }

  void updateBrand() {
    product.brand = _brandController.text.toString();
  }

  void updateColor() {
    product.color = _brandController.text.toString();
  }

  void updateSize() {
    product.size = int.parse(_sizeController.text.toString());
  }

  void updateQty() {
    product.qty = int.parse(_qtyController.text.toString());
  }
}
