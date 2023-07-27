import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import "package:flutter_credit_card/credit_card_model.dart";
import "app_colors.dart";
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrderXpress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: Center(
        child: MyHomePage(title: 'OrderXpress'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? selectedTime;

  final TextEditingController _ordernoCtrl = TextEditingController();
  final TextEditingController _productnoCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _DFeesCtrl = TextEditingController();
  final TextEditingController _DtipCtrl = TextEditingController();
  final TextEditingController _DInstructionCtrl = TextEditingController();
  final TextEditingController _DDiscountCtrl = TextEditingController();
  final TextEditingController _DateCtrl = TextEditingController();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;

  void _onValidate() {
    if (_formKey.currentState!.validate()) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      CoolStep(
        title: 'Basic Information',
        subtitle: 'User Details',
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                labelText: 'Order Number',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Order is required';
                  }
                  return null;
                },
                controller: _ordernoCtrl,
              ),
              _buildTextField(
                labelText: 'Product Number',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Product Number is required';
                  }
                  return null;
                },
                controller: _productnoCtrl,
              ),
              _buildTextField(
                labelText: 'Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                controller: _nameCtrl,
              ),
              _buildTextField(
                labelText: 'Email Address',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email address is required';
                  }
                  return null;
                },
                controller: _emailCtrl,
              ),
              _buildTextField(
                labelText: 'Address',
                icon: const Icon(Icons.map_outlined),
                onIconPressed: () {
                  _showLocationPicker(
                      context); // Show the location picker dialog
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
                controller: _addressCtrl,
              ),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'US',
                onChanged: (phone) {
                  debugPrint(phone.completeNumber);
                },
              ),
              _buildTextField(
                labelText: 'Date',
                icon: const Icon(Icons.calendar_month_outlined),
                onIconPressed: () async {
                  final date = await showDatePickerDialog(
                    context: context,
                    initialDate: DateTime.now(),
                    maxDate: DateTime.now().add(const Duration(days: 365 * 3)),
                    minDate: DateTime.now().subtract(const Duration(days: 1)),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Date is required';
                  }
                  return null;
                },
                controller: TextEditingController(
                    text: selectedDate != null
                        ? "${selectedDate?.year}-${selectedDate?.month.toString().padLeft(2, '0')}-${selectedDate?.day.toString().padLeft(2, '0')}"
                        : ''),
              ),
              _buildTextField(
                labelText: 'Time',
                icon: const Icon(Icons.access_time),
                onIconPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      // Convert the TimeOfDay object to DateTime and set the time to the selectedTime variable
                      selectedTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
                controller: TextEditingController(
                  text: selectedTime != null
                      ? "${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}"
                      : '',
                ), // Pass the formatted time to the TextEditingController
              ),
            ],
          ),
        ),
        validation: () {
          if (!_formKey.currentState!.validate()) {
            return 'Fill form correctly';
          }
          return null;
        },
      ),
      CoolStep(
        title: 'Delievery Information',
        subtitle: '',
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                labelText: 'Delivery Fees',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This is required';
                  }
                  return null;
                },
                controller: _DFeesCtrl,
              ),
              _buildTextField(
                labelText: 'Delivery Tips',
                validator: (value) {
                  return null;
                },
                controller: _DtipCtrl,
              ),
              _buildTextField(
                labelText: 'Discount',
                validator: (value) {
                  return null;
                },
                controller: _DDiscountCtrl,
              ),
              _buildTextField(
                labelText: 'Delivery Instructions',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This is required';
                  }
                  return null;
                },
                controller: _DInstructionCtrl,
              ),
            ],
          ),
        ),
        validation: () {
          if (!_formKey.currentState!.validate()) {
            return 'Fill form correctly';
          }
          return null;
        },
      ),
      CoolStep(
          title: "Details",
          subtitle: "User Details",
          content: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Order No",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 130,
                  ),
                  Text(_ordernoCtrl.text),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                // Add a new Row for the "Name" section
                children: [
                  const Text(
                    "Product No",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 130, // Adjust the width as needed
                  ),
                  Text(_productnoCtrl.text), // Update with the correct Order No
                ],
              ),
              const SizedBox(height: 30),
              Row(
                // Add a new Row for the "Name" section
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 130, // Adjust the width as needed
                  ),
                  Text(_nameCtrl.text), // Update with the correct Order No
                ],
              ),
              const SizedBox(height: 30),
              Row(
                // Add a new Row for the "Name" section
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 130, // Adjust the width as needed
                  ),
                  Text(_emailCtrl.text), // Update with the correct Order No
                ],
              ),
              const SizedBox(height: 30),
              Row(
                // Add a new Row for the "Name" section
                children: [
                  const Text(
                    "Address",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 130, // Adjust the width as needed
                  ),
                  Text(_addressCtrl.text), // Update with the correct Order No
                ],
              ),
            ],
          ),
          validation: () {
            return null;
          }),
      CoolStep(
        title: "Payment Details",
        subtitle: "Credit Card Info",
        content: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            CreditCardWidget(
              glassmorphismConfig: null,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              bankName: 'Axis Bank',
              frontCardBorder:
                  !useGlassMorphism ? Border.all(color: Colors.grey) : null,
              backCardBorder:
                  !useGlassMorphism ? Border.all(color: Colors.grey) : null,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: AppColors.cardBgColor,
              backgroundImage: useBackgroundImage ? 'assets/card_bg.png' : null,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/mastercard.png',
                    height: 48,
                    width: 48,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: _formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    themeColor: Colors.blue,
                    textColor: Colors.black,
                    cardNumberDecoration: InputDecoration(
                      labelText: 'Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                      border: const OutlineInputBorder(),
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: border,
                      enabledBorder: border,
                    ),
                    expiryDateDecoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: border,
                      enabledBorder: border,
                      border: const OutlineInputBorder(),
                      labelText: 'Expired Date',
                      hintText: 'XX/XX',
                    ),
                    cvvCodeDecoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: border,
                      enabledBorder: border,
                      border: const OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: border,
                      enabledBorder: border,
                      border: const OutlineInputBorder(),
                      labelText: 'Card Holder',
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _onValidate,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const Text(
                        'Validate',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'halter',
                          fontSize: 14,
                          package: 'flutter_credit_card',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        validation: () {
          if (!_formKey.currentState!.validate()) {
            return 'Fill form correctly';
          }
          return null;
        },
      ),
    ];

    final stepper = CoolStepper(
      showErrorSnackbar: false,
      onCompleted: () {
        print('Steps completed!');
      },
      steps: steps,
      config: const CoolStepperConfig(
        backText: 'PREV',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )),
      ),
      body: Container(
        child: stepper,
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a Location'),
          content: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: FlutterLocationPicker(
              initZoom: 11,
              minZoomLevel: 5,
              maxZoomLevel: 16,
              trackMyPosition: true,
              searchBarBackgroundColor: Colors.white,
              mapLanguage: 'en',
              onError: (e) => print(e),
              onPicked: (pickedData) {
                // Handle the picked location data here if needed
                _addressCtrl.text = pickedData.address;
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    String? labelText,
    FormFieldValidator<String>? validator,
    TextEditingController? controller,
    VoidCallback?
        onIconPressed, // Add a VoidCallback parameter for the icon press action
    Icon? icon, // Add an optional Icon parameter
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(gapPadding: 10),
          suffixIcon: icon != null
              ? IconButton(
                  icon: icon,
                  onPressed: onIconPressed, // Attach the onPressed callback
                )
              : null,
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }
}
