import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeCameraControllerFuture;
      final image = await _cameraController.takePicture();
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _accessContacts() async {
    // Request permission to access contacts
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();
    if (permissionStatus == PermissionStatus.granted) {
      // Access contacts
      Iterable<Contact> contacts = await ContactsService.getContacts();
      // Do something with contacts
    } else {
      // Handle denied permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              _buildProfilePicture(),
              SizedBox(height: 20),
              _buildProfileInfo(),
              SizedBox(height: 20),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
          ),
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              : Placeholder(
                  fallbackWidth: 200,
                  fallbackHeight: 200,
                ),
        ),
        if (_image != null)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: _removeImage,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Text(
          'John Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'john.doe@example.com',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '123 Main Street, City, Country',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: Text('Choose from Gallery'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _takePicture(),
          child: Text('Take Picture'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _accessContacts(),
          child: Text('Access Contacts'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
