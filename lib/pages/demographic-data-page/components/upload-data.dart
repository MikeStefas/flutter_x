import 'package:flutter/material.dart';
import 'package:myapp/pages/demographic-data-page/components/confirm-button.dart';
import 'package:myapp/pages/demographic-data-page/demographic-data-page.dart';
import 'package:myapp/requests/create-demographic-data-request.dart';
import 'package:myapp/requests/update-demographic-data.dart';
import 'package:myapp/global-components/data-field.dart';

class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  final TextEditingController yobController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        const Text(
          "Upload/Update your data:",
          style: TextStyle(color: Colors.lightBlueAccent, fontSize: 22),
        ),
        const SizedBox(height: 10),
        GenderRadio(),
        DataField(dataController: yobController, label: ' Year of Birth'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(child: ConfirmButton(onPressed: handleConfirm)),
      ],
    );
  }

  Column GenderRadio() {
    return Column(
      children: [
        const Text(
          'Gender:',
          style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18),
        ),
        RadioListTile<String>(
          title: const Text(
            'Male',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          value: 'male',
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value;
            });
          },
          activeColor: Colors.lightBlueAccent,
        ),
        RadioListTile<String>(
          title: const Text(
            'Female',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          value: 'female',
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value;
            });
          },
          activeColor: Colors.lightBlueAccent,
        ),
      ],
    );
  }

  handleConfirm() async {
    //data is missing: create request and refresh
    var result = '';
    if (currentYob == 0 && currentGender == ' ') {
      result = await createDemographicDataRequest(
        int.parse(yobController.text),
        selectedGender,
      );
      Navigator.pop(context);
      Navigator.pushNamed(context, '/demographicDatapage');
    } //data is present: patch and refresh
    else {
      result = await updateDemographicDataRequest(
        int.parse(yobController.text),
        selectedGender,
      );
      Navigator.pop(context);
      Navigator.pushNamed(context, '/demographicDatapage');
    }

    if (result == 'success') {
      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.lightBlueAccent,
            title: const Text('Success'),
            content: const Text(
              'Your data has been uploaded successfully! \n Refresh to view changes',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/homepage");
                },
                child: const Text('Refresh'),
              ),
            ],
          );
        },
      );
    } else {
      // Show an error popup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.lightBlueAccent,
          content: Text(result, style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }
}
