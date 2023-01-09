import 'package:flutter/material.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/values/constants.dart';

import '../login_controller/login_providers.dart';

class RwButton extends StatelessWidget {
  final String text;

  Function() onPressed;

  bool widthMatchParent;

  double height;

  bool enabled;

  RwButton({super.key,
    required this.text,
    required this.onPressed,
    this.widthMatchParent = false,
    this.height = Constants.btn_min_height,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled? null : Colors.grey,
        shape: RoundedRectangleBorder(
          //to set border radius to button
          borderRadius: BorderRadius.circular(Constants.btn_border_radius),
        ),
        padding: const EdgeInsets.all(Constants.btn_text_padding),
        minimumSize: widthMatchParent ? Size(double.infinity, height) : null,
      ),
      child: RwText(
        text: text,
        textStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white),
      ),
    );
  }
}

class RwRadioGroup extends StatefulWidget {
  List<RwRadioButtonModel> radioButtonModelList;
  final RwOrientation orientation;
  final Function(LoginProvider, int, bool) onChangeSelection;
  RwRadioGroup({super.key, required this.radioButtonModelList, required this.orientation, required this.onChangeSelection});

  List<RwRadioButton> getRadioButtonList(List<RwRadioButtonModel> radioButtonModel) {
    List<RwRadioButton> radioButtonList = [];
    for (var element in radioButtonModel) {
      radioButtonList.add(
        RwRadioButton(
            index: element.index,
            title: element.title,
            isSelected: element.isSelected,
            value: element.value,
            onPressed: onChangeSelection),
      );
    }
    return radioButtonList;
  }

  @override
  State<RwRadioGroup> createState() => _RwRadioGroupState();
}

class _RwRadioGroupState extends State<RwRadioGroup> {
  @override
  Widget build(BuildContext context) {
    widget.getRadioButtonList(widget.radioButtonModelList);
    return Container(
      child: getRadioButtons(widget.orientation),
    );
  }

  Widget getRadioButtons(RwOrientation orientation) {
    if (orientation == RwOrientation.VERTICAL) {
      return Container(
        padding: Constants.base_padding,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.getRadioButtonList(widget.radioButtonModelList),
        ),
      );
    } else {
      return Container(
        padding: Constants.base_padding,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.getRadioButtonList(widget.radioButtonModelList),
        ),
      );
    }
  }
}

class RwRadioButtonModel {
  final String title;
  bool isSelected;
  final LoginProvider value;
  final int index;
  RwRadioButtonModel({
    required this.index,
    required this.title,
    required this.isSelected,
    required this.value,
  });

}

class RwRadioButton extends StatefulWidget {
  final int index;
  final String title;
  bool isSelected;
  final LoginProvider value;
  Function(LoginProvider, int, bool) onPressed;

  RwRadioButton(
      {super.key, required this.index,
      required this.title,
      required this.isSelected,
      required this.value,
      required this.onPressed});

  @override
  State<RwRadioButton> createState() => _RwRadioButtonState();
}

class _RwRadioButtonState extends State<RwRadioButton> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.isSelected;
    return Row(
      children: [
        Center(
            child: Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.green[900],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              widget.onPressed(
                widget.value,
                widget.index,
                widget.isSelected,
              );
              print("index: ${widget.index}");
            },
            icon: Icon(
              Icons.circle,
              size: 20.0,
              color: isSelected ? Colors.teal[600] : Colors.teal[100],
            ),
          ),
        )),
        const SizedBox(
          width: 10.0,
        ),
        RwText(text: widget.title)
      ],
    );
  }
}

class RwRadioButtonController extends ChangeNotifier {
  late String selectedValue;
  late int selectedIndex;
  void setSelection(String selection, int index) {
    selectedValue = selection;
    selectedIndex = index;
    notifyListeners();
  }
}
