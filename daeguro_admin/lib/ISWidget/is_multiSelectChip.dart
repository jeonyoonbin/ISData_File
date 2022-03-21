

import 'package:flutter/material.dart';

class ISMultiSelectChip extends StatefulWidget {
  final List<String> itemList;
  final List<String> initItemList;
  final Function(List<String>) onSelectionChanged;

  ISMultiSelectChip({this.itemList, this.initItemList, this.onSelectionChanged});

  @override
  _ISMultiSelectChipState createState() => _ISMultiSelectChipState();
}

class _ISMultiSelectChipState extends State<ISMultiSelectChip>{
  List<String> selectedChoices = List();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((c) {
      setState(() {
        widget.itemList.forEach((element) {
        });

        selectedChoices.clear();
        widget.initItemList.forEach((element) {
          if (_getCompareData(element)){
            selectedChoices.add(element);
          }
        });
      });

    });
  }


  _buildChoiceList(){
    List<Widget> choices = List();

    widget.itemList.forEach((item) {
      choices.add(
          Container(
            padding: const EdgeInsets.all(4.0),
            child: ChoiceChip(
              label: Text(item),
              selected: selectedChoices.contains(item),
              onSelected: (selected) {
                setState(() {
                  //selectedChoices.contains(item) ? selectedChoices.remove(item) : selectedChoices.add(item);

                  widget.onSelectionChanged(selectedChoices);
                });
              },
            ),
        ));
    });

    return choices;
  }

  bool _getCompareData(String item){
    bool temp = false;

    for (final element in widget.itemList){
      if (element == item) {
        temp = true;
        break;
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var result = Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: Wrap(
                children: _buildChoiceList(),
              ),
            ),
            ],
        ),
      ),
    );
    // return Wrap(
    //   children: _buildChoiceList(),
    // );

    return SizedBox(
      width: 460,
      height: 300,
      //height: isDisplayDesktop(context) ? 720 : 1000,
      child: result,
    );
  }

}