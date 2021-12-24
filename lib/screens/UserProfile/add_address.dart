import 'package:flutter/material.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/customer_profile_model.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/app_bar.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';

class AddAddress extends StatefulWidget {
  final CustomerModel customerModel;
  final String? name;
  final String? mobile;
  final String? flat;
  final String? landmark;
  final String? pincode;
  final String? city;
  final String? state;
  final int? creditLimit;
  final int? interest;
  final int? emi;
  final bool isSwitched;

  const AddAddress(
      {Key? key,
      required this.customerModel,
      this.name,
      this.mobile,
      this.flat,
      this.landmark,
      this.pincode,
      this.city,
      this.state,
      this.creditLimit,
      this.interest,
      this.emi,
      required this.isSwitched})
      : super(key: key);
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  bool isSwitched = true;
  String? _nameController, _mobileController;
  int _creditLimitController = 0;
  int _interestController = 0;
  int _emiController = 0;

  void initState() {
    getData();
    super.initState();
  }

@override
void dispose() { 
  _flatController.dispose();
  _landmarkController.dispose();
  _pincodeController.dispose();
  _cityController.dispose();
  _stateController.dispose();
  super.dispose();
}

  getData() async {
    debugPrint("(data1)['address']['flatBuildingHouse']");

    _nameController =
        widget.name ?? widget.customerModel.name.toString();
    _mobileController =
        widget.mobile ?? widget.customerModel.mobileNo.toString();
    _creditLimitController = widget.creditLimit ?? 0;
    _interestController = widget.interest ?? 0;
    _emiController = widget.emi ?? 0;
    _flatController.text = widget.flat.toString();
    _landmarkController.text = widget.landmark.toString();
    _pincodeController.text = widget.pincode.toString();
    _cityController.text = widget.city.toString();
    _stateController.text = widget.state.toString();
    isSwitched = widget.isSwitched;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: NewCustomButton(
          textSize: 18,
          textColor: Colors.white,
          text: 'SAVE',
          onSubmit: () async {
            final Address address = Address(
                flatBuildingHouse: '${_flatController.text}',
                landmark: '${_landmarkController.text}',
                pincode: '${_pincodeController.text}',
                city: '${_cityController.text}',
                state: '${_stateController.text}');
            final Credit credit = Credit(
                creditLimit: widget.creditLimit,
                interest: widget.interest,
                emi: widget.emi);
            final CustomerProfileModel data = CustomerProfileModel(
                uid: widget.customerModel.customerId,
                name: widget.name,
                mobileNo: widget.mobile,
                address: address,
                sendFreeSms: isSwitched,
                credit: credit);
            await repository.customerApi.saveUpdateCustomer(data);
          },
        ),
      ),
      backgroundColor: AppTheme.paleGrey,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
            CustomPaint(
              foregroundPainter: AppBarSmall(),
              size: Size.fromHeight(193),
            ),
            Column(
              children: [
                (MediaQuery.of(context).padding.top).heightBox,
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  dense: true,
                  leading: Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 22,
                      ),
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  title: Align(
                    child: new Text(
                      'Customer Address',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    alignment: Alignment(-1.1, 0),
                  ),
                ),
                // SizedBox(
                //   height: 15,
                // ),
                
              ],
            ),
          ]),
          Flexible(
            child: SingleChildScrollView(
              child: addressFields(),
            ),
          ),
          SizedBox(height:20)
        ],
      ),
    );
  }

  Widget addressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextFeild(
            'assets/icons/building.png',
            'Flat / Building / House',
            'Flat / Building / House',
            _flatController),
        buildTextFeild('assets/icons/loc.png', 'Landmark', 'Landmark',
            _landmarkController),
        buildTextFeild('assets/icons/pincode.png', 'Pincode', 'Pincode',
            _pincodeController),
        buildTextFeild(
            'assets/icons/city.png', 'City', 'City', _cityController),
        buildTextFeild(
            'assets/icons/Vector.png', 'State', 'State', _stateController),
      ],
    );
  }

  Widget buildTextFeild(String imageUrl, String title, String subTitle,
      TextEditingController ctrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        // height: 100,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: AppTheme.coolGrey, width: 0.5)
        ),
        child: ListTile(
          dense: true,
          leading: Image.asset(
            // 'assets/icons/user.png',
            imageUrl,
            height: 30,
          ),
          title: Text(
            // 'User name',
            title,
            style: TextStyle(
                color: AppTheme.brownishGrey,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Container(
            height: 35,
            width: double.infinity,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: TextField(
              controller: ctrl,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: subTitle,
                alignLabelWithHint: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
