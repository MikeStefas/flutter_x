import 'package:flutter/material.dart';
import 'package:myapp/pages/demographicDataPage/showMyData.dart';
import 'package:myapp/pages/demographicDataPage/uploadData.dart';
import 'package:myapp/requests-funcs/viewDemographicData.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var currentYob = 0;
var currentGender = ' ';

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
