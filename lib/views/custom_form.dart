import 'package:flutter/material.dart';
import '../models/submission.dart';
import '../services/form_data_service.dart';
import '../services/local_storage_service.dart';
import '../services/submission_service.dart';
import '../services/connectivity_service.dart';
import 'local_submissions_list.dart';

class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final FormDataService _formDataService = FormDataService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final SubmissionService _submissionService = SubmissionService();

  List<Submission> _localSubmissions = [];

  @override
  void initState() {
    super.initState();
    _loadFormData();
    _loadLocalSubmissions();
    checkConnectivityAndSync();
  }

  Future<void> _loadFormData() async {
    final formData = await _formDataService.loadFormData();
    setState(() {
      _firstNameController.text = formData['first_name'] ?? '';
      _lastNameController.text = formData['last_name'] ?? '';
      _emailController.text = formData['email'] ?? '';
      _messageController.text = formData['message'] ?? '';
    });
  }

  Future<void> _loadLocalSubmissions() async {
    final submissions = await _localStorageService.loadLocalSubmissions();
    setState(() {
      _localSubmissions = submissions;
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userDetails = Submission(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        message: _messageController.text,
      );

      await _localStorageService.addSubmissionToLocalList(userDetails);
      await _submissionService.submitData(userDetails);

      await _formDataService.clearFormData();
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data submitted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: _buildTextField(_firstNameController, 'First name',1)
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: _buildTextField(_lastNameController, 'Last name',1),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                
                _buildTextField(_emailController, 'Email address', isEmail: true,1),
                const SizedBox(height: 10,),

                SizedBox(
                  height: 160,
                  child: _buildTextField(_messageController, 'Message',5)
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 50)
                  ),
                  onPressed: _handleSubmit,
                  child: const Text('SUBMIT', style: TextStyle(color: Colors.white, fontSize: 18),),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('submitted messages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          LocalSubmissionsList(localSubmissions: _localSubmissions),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, int maxLines,{bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      // minLines: 2,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 0.6),
          borderRadius: BorderRadius.circular(4),
        ),
        labelText: null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onChanged: (value) => _formDataService.saveFormData(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        message: _messageController.text,
      ),
    );
  }
}