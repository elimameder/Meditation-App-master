
import 'dart:async';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:ui';
import 'dart:ui' as prefix0;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;


class ImageSelectionScreen extends StatefulWidget {

  @override
  ImageSelectionScreenState createState() => ImageSelectionScreenState();
}

class ImageSelectionScreenState extends State<ImageSelectionScreen> {

 File _imageFile;
  String _status;
  bool _imgLoading;
  bool _isBlurred = false; 
  ImagePicker _imagePicker;
  double t ;
  Timer timer;


List<ListItem> _dropdownItems = [  
    ListItem(1, "5 sec"), 
    ListItem(2, "10 sec"),  
    ListItem(3, "15 sec"),  
    ListItem(4, "20 sec")  
  ];  
  
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;  
  ListItem _itemSelected;  
  
  void initState() {  
    super.initState();  
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);  
    _itemSelected = _dropdownMenuItems[1].value;  
      _status = '';
    _imgLoading = false;
    _imagePicker = ImagePicker();
  }  
  
  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {  
    List<DropdownMenuItem<ListItem>> items = [];  
    for (ListItem listItem in listItems) {  
      items.add(  
        DropdownMenuItem(  
          child: Text(listItem.name),  
          value: listItem,  
        ),  
      );  
    }  
    return items;  
  }  

  


 void _startTimer() {
   timer = Timer.periodic(Duration(seconds: 60), (_) {
      if(mounted) setState(() {
          if (t > 0) {
          t--;
          } if(t<=0) {
            timer.cancel();
          }
        });
      }  
    ,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent[700],
        title: Text('           Welcome to my World!'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _imgLoading
                ? CircularProgressIndicator()
                : null == _imageFile
                    ? Container()
                    : Expanded(
                        child: Image.file(
                          File(_imageFile.path),
                          filterQuality: FilterQuality.high,
                        ),
                      ),
            SizedBox(height: 10),
            Text(_status),
            SizedBox(height: 10),
            _select(),
          ],
        ),
      ),
    );
  }

  _select() {
   
    
    return Container(
      padding: EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
              blurRadius:67,
              spreadRadius: 5,
              color: Colors.blue,
        ),
      ],
        image: DecorationImage(
          image: AssetImage('assets/butterfly.jpg'),
          ),
      ),
      
      

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          
          
           BackdropFilter(
            filter: prefix0.ImageFilter.blur( 
              sigmaX: _isBlurred ? t:0, 
              sigmaY: _isBlurred ? t:0,    
        ),
        

            child: Container(
            )
          ),
           Padding(  
            padding: const EdgeInsets.all(3.0),  
            child: Container(  
              padding: const EdgeInsets.all(1.0),  
              decoration: BoxDecoration(  
                  color: Colors.greenAccent,  
                  border: Border.all()),  
              child: DropdownButtonHideUnderline(  
                child: DropdownButton( 
                    value: _itemSelected,  
                    items: _dropdownMenuItems,  
                    onChanged: (value) {  
                      _startTimer();
                      if(mounted) setState(() {  
                       _itemSelected=value;
     
                      
                      });    
                    }),   
              ),  
            ),  
          ),
          
           Switch(
            
              onChanged: (value) {
              _startTimer();
                if(mounted) setState(() {
              
                 _isBlurred = value;
                 // ignore: unused_element
      if (_itemSelected==_dropdownItems[0]) {
        for (double i = 0; i <= 15; i++) {
               t=i;
                  }} 
     if (_itemSelected==_dropdownItems[1]) {
        for (double i = 0; i <= 30; i++) {
               t=i;
                  }} 
      if (_itemSelected==_dropdownItems[2]) {
        for (double i = 0; i <= 50; i++) {
               t=i;
                  }} 
      if (_itemSelected==_dropdownItems[3]) {
        for (double i = 0; i <= 60; i++) {
               t=i;
                  }} 
            
                }
              );
            },
              value: _isBlurred  
             ),
          
          _button('Camera', ImageSource.camera),
          _button('gallery', ImageSource.gallery),
         
        ],
      ),
    );
  }

  _button(String text, ImageSource imageSource) {
    return TextButton(
      child: Text(text),
      onPressed: () async {
        if(mounted) setState(() {
          _imgLoading = true;
          _imageFile = null;
        });
        File file = await _loadImage(imageSource);
        if (null != file) {
          if(mounted) setState(() {
            _imageFile = file;
            _imgLoading = false;
            _status = 'Loaded';
          });
          return;
        }
        if(mounted) setState(() {
          _imageFile = null;
          _imgLoading = false;
          _status = 'Error';
        });
      },
    );
  }

  Future<File> _loadImage(ImageSource imageSource) async {
    PickedFile file = await _imagePicker.getImage(source: imageSource);
    File mFile;
    if (null != file) {
      Directory directory = await getTemporaryDirectory();
      //mFile = await _saveImageToDisk(file.path, directory);
      Map map = Map();
      map['path'] = file.path;
      map['directory'] = directory;
      mFile = await compute(_saveImageToDisk, map);
    }
    return mFile;
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<void>('t', t));
    properties.add(DoubleProperty('t', t));
    properties.add(DoubleProperty('t', t));
    properties.add(DiagnosticsProperty('t', t));
    properties.add(IterableProperty<ListItem>('_dropdownItems', _dropdownItems));
    properties.add(DiagnosticsProperty('_itemSelected', _itemSelected));
  }
}



Future<File> _saveImageToDisk(Map map) async {
  try {
    String path = map['path'];
    Directory directory = map['directory'];
    File tempFile = File(path);
    Img.Image image = Img.decodeImage(tempFile.readAsBytesSync());
    Img.Image mImage = Img.copyResize(image, width: 512);
    String imgType = path.split('.').last;
    String mPath =
        '${directory.path.toString()}/image_${DateTime.now()}.$imgType';
    File dFile = File(mPath);
    if (imgType == 'jpg' || imgType == 'jpeg') {
      dFile.writeAsBytesSync(Img.encodeJpg(mImage));
    } else {
      dFile.writeAsBytesSync(Img.encodePng(mImage));
      Stack(
                children: <Widget>[
          Image.asset(mPath),
         
        ],
      );
    }
    return dFile;
  } catch (e) {
    return null;
  
  }
}

class ListItem {  
  int value;  
  String name;  
  
  ListItem(this.value, this.name);  
} 