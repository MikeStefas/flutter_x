import 'package:flutter/material.dart';
import 'package:myapp/pages/signuppage.dart';
import 'package:myapp/util/common_app_bar.dart';
import 'package:myapp/util/common_bot_app_bar.dart';
import 'package:myapp/util/data_field.dart';
import 'package:myapp/util/info_box.dart';

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

class DataPageBody extends StatelessWidget {
  const DataPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [ShowMyData(), UploadData()]);
  }
}

class ShowMyData extends StatefulWidget {
  const ShowMyData({super.key});

  @override
  State<ShowMyData> createState() => _ShowMyDataState();
}

class _ShowMyDataState extends State<ShowMyData> {
  @override
  Widget build(BuildContext context) {
    return const InfoBox(
      title: 'Your Personal Data:',
      txt: 'will be filled hihih',
    );
  }
}

class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  TextEditingController genderController = TextEditingController();
  TextEditingController yobController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        DataField(dataController: genderController, label: 'Gender'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        DataField(dataController: yobController, label: 'Year of Birth'),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ConfirmButton(onPressed: () {}),
      ],
    );
  }
}
