import 'package:flutter/material.dart';
import 'package:travel_app/domain/models/iternary.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_button.dart';
import 'package:travel_app/presentation/pages/login-signup/components/rounded_input_field.dart';
import 'package:travel_app/presentation/pages/login-signup/constants.dart';
import 'package:travel_app/utils/app_colors.dart';
import 'package:travel_app/utils/size_config.dart';


// Screen to post itenary
class ItenaryPostScreen extends StatefulWidget {
  const ItenaryPostScreen({Key? key, required this.date}) : super(key: key);
  final String date;

  @override
  State<ItenaryPostScreen> createState() => _ItenaryPostScreenState();
}

class _ItenaryPostScreenState extends State<ItenaryPostScreen> {
  final List<String> toBring = [];
  late final Itenary itenary;

  @override
  void initState() {
    super.initState();
    itenary = Itenary(widget.date);
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Itenary to Bring"),
        elevation: 3,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "To Bring",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: kPrimaryColor,
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            final item = await addItem();
                            if (item != null) {
                              toBring.add(item);
                              // Adds the item to the toBring list
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                ListView.separated(
                  separatorBuilder: (_, __) => SizedBox(
                    height: 8,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (_, index) => Text(
                    "${(index + 1)}. ${toBring[index]}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  itemCount: toBring.length,
                  shrinkWrap: true,
                  primary: false,
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Text(
                      "Itenary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: kPrimaryColor,
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            final item = await addItenary();
                              // Calls the bottomsheet to get input for itenary

                            if (item != null) {
                              itenary.details.add(item);
                              setState(() {});
                              // Adds the item to the toBring list

                            }
                          },
                          icon: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (itenary.details.isNotEmpty) ...[
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    itenary.date,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ListView.separated(
                    separatorBuilder: (_, __) => SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (_, index) => Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            itenary.details[index].time,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: kPrimaryLightColor,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          itenary.details[index].name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    itemCount: itenary.details.length,
                    shrinkWrap: true,
                    primary: false,
                  ),
                ] else
                  Center(child: Text("No Itenaries added"))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: toBring.isNotEmpty || itenary.details.isNotEmpty
          ? Padding(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: "Save",
                press: () => Navigator.pop(context, [toBring, itenary]),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Future<String?> addItem() async {
    final controller = TextEditingController();
    return await showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add a item to bring",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .002,
              ),
              RoundedInputField(
                hintText: "Your Item",
                onChanged: (value) {},
                controller: controller,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .003,
              ),
              RoundedButton(
                text: "Save",
                press: () async {
                  Navigator.pop(context, controller.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Details?> addItenary() async {
    final timeController = TextEditingController();
    final nameController = TextEditingController();
    return await showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add a itenary detail",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .002,
              ),
              RoundedInputField(
                hintText: "Time",
                onChanged: (value) {},
                controller: timeController,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .002,
              ),
              RoundedInputField(
                hintText: "Title",
                onChanged: (value) {},
                controller: nameController,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * .003,
              ),
              RoundedButton(
                text: "Save",
                press: () async {
                  Navigator.pop(context,
                      Details(timeController.text, nameController.text));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
