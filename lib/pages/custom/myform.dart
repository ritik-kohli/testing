import 'package:flutter/material.dart';
import 'package:formtask/Controllers/local_submission_controller.dart';
import 'package:formtask/models/submission.dart';
import 'package:formtask/services/connectivity_service.dart';
import 'package:formtask/services/form_data_service.dart';
import 'package:formtask/services/local_storage_service.dart';
import 'package:formtask/services/submission_service.dart';
import 'package:get/get.dart';
import '../widgets/my_text_feild.dart';


class MyForm extends StatefulWidget {
  const MyForm({super.key});


  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final LocalSubmissionsController controller = Get.put(LocalSubmissionsController());

  final FormDataService _formDataService = FormDataService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final SubmissionService _submissionService = SubmissionService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFormData();
    // _loadLocalSubmissions();
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

  Future<void> _handleSubmit() async {

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      final userDetails = Submission(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        message: _messageController.text,
      );

      await _submissionService.submitData(userDetails);

      await _formDataService.clearFormData();
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _messageController.clear();

      controller.refreshSubmissions();
      
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data submitted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(isLoading) const Center(
            child: CircularProgressIndicator(),
        ),
        Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MyTextFeild(
                              controller: _firstNameController, 
                              hintText:'First name',
                              maxLines:1,
                              validator: (value){
                                if (value == null || value.isEmpty) {return 'Please enter your first name';}
                                return null;
                              },
                              onChanged: (value)=> _formDataService.saveFormData(firstName: _firstNameController.text)
                            )
                          ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: MyTextFeild(
                              controller: _lastNameController, 
                              hintText:'Lirst name',
                              maxLines:1,
                              validator: (value){
                                if (value == null || value.isEmpty) {return 'Please enter your last name';}
                                return null;
                              },
                            onChanged: (value)=> _formDataService.saveFormData(lastName: _lastNameController.text)
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    
                    MyTextFeild(
                      controller: _emailController, 
                      hintText :'Email address',
                      maxLines :1,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onChanged: (value)=> _formDataService.saveFormData(email: _emailController.text)
                    ),
                    const SizedBox(height: 16,),
                
                    SizedBox(
                      height: 160,
                      child: MyTextFeild(
                        controller :_messageController, 
                        hintText :'Message',
                        maxLines :5,
                        validator: (value){
                          if (value == null || value.isEmpty) {return 'Please enter your message';}
                          return null;
                        },
                        onChanged: (value)=> _formDataService.saveFormData(message: _messageController.text)
                      )
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
                      child: const Text('Submit now', style: TextStyle(color: Colors.white, fontSize: 18),),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
