import 'package:flutter/material.dart';
import 'package:myapp/requests-funcs/createDemographicDataRequest.dart';
import 'package:myapp/requests-funcs/viewDemographicData.dart';
import 'package:myapp/requests-funcs/updateDemographicData.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';
import 'package:myapp/util/data_field.dart';
import 'package:myapp/util/info_box.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var currentYob = 0;
var currentGender = 'Missing';

const storage = FlutterSecureStorage();

//run on commonBottomAppBar button press!

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),

      //BODY
      body: DataPageBody(),

      bottomNavigationBar: CommonBotAppBar(),
      backgroundColor: Colors.black,
    );
  }
}

class DataPageBody extends StatefulWidget {
  const DataPageBody({super.key});

  @override
  State<DataPageBody> createState() => _DataPageBodyState();
}

class _DataPageBodyState extends State<DataPageBody> {
  //the function that brings the data here
  Future<void> loadDemographics() async {
    var res = await viewDemographicDataRequest();
    if (res != null) {
      currentYob = res['yearOfBirth'];
      currentGender = res['gender'];
    }
  }

  @override
  void initState() {
    super.initState();
    () async {
      await loadDemographics();
      setState(() {});
    }();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ShowMyData(yob: currentYob, gender: currentGender),
        UploadData(),
      ],
    );
  }
}

class ShowMyData extends StatelessWidget {
  final int yob;
  final String gender;
  const ShowMyData({super.key, required this.yob, required this.gender});

  @override
  Widget build(BuildContext context) {
    return InfoBox(
      title: 'Your Demographic Data:',
      txt: 'year of birth: $yob \ngender: $gender',
    );
  }
}

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
          "Upload your data:",
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
    //data is missing: create request
    var result = '';
    if (currentYob == 0 && currentGender == 'Missing') {
      result = await createDemographicDataRequest(
        int.parse(yobController.text),
        selectedGender,
      );
    } //data is present: patch
    else {
      result = await updateDemographicDataRequest(
        int.parse(yobController.text),
        selectedGender,
      );
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

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
      ),
      child: const Text('Confirm'),
    );
  }
}
