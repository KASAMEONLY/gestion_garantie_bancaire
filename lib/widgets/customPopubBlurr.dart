import 'dart:ui';
import 'package:flutter/material.dart';


class BlurryDialog extends StatelessWidget {

  String title;
  String content;
  VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack);
  TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(
          title: new Text(title,style: textStyle,),
          content: new Text(content, style: textStyle,),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                continueCallBack();
              },
            ),
            new FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}

/*_showDialog(BuildContext context)
{

  VoidCallback continueCallBack = () => {
 Navigator.of(context).pop(),
    // code on continue comes here

  };
  BlurryDialog  alert = BlurryDialog("Abort","Are you sure you want to abort this operation?",continueCallBack);


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
 showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annuler"),
      onPressed:  () {},
    );
    Widget continueButton = TextButton(
      child: Text("Valider"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Choisir Banque"),
      //content: Text("Would you like to continue learning how to use Flutter alerts?"),

      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }*/