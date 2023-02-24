import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import '../model/list_item.dart';

class DodadiElement extends StatefulWidget {
  final Function addItem;

  DodadiElement(this.addItem);
  @override
  State<StatefulWidget> createState() => _DodadiElementState();
}

class _DodadiElementState extends State<DodadiElement> {
  final _naslovController = TextEditingController();

  late String naslov;
  late String datum;
  late String vreme;

  void _submitData() {
    if (_naslovController.text.isEmpty) {
      return;
    }
    final vnesenPredmet = _naslovController.text;
    final vnesenDatum = dateTime.toString().substring(0, 10);
    final vnesenoVreme = dateTime.toString().substring(10, 16);

    if (vnesenPredmet.isEmpty || vnesenDatum.isEmpty || vnesenoVreme.isEmpty) {
      return;
    }

    final newItem = ListItem(
        id: nanoid(5),
        predmet: vnesenPredmet,
        datum: vnesenDatum,
        vreme: vnesenoVreme);
    widget.addItem(newItem);
    Navigator.of(context).pop();
  }

  DateTime dateTime = DateTime(2022, 11, 24, 10, 15);

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _naslovController,
            decoration: const InputDecoration(
              labelText: "Ime na predmetot: ",
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 30),
            onSubmitted: (_) => _submitData(),
          ),
          SizedBox(height: 30),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 228, 144, 76)),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 20),
                    ),
                  ),
                  onPressed: () async {
                    final date = await pickDate();
                    if (date == null) return;

                    setState(() {
                      dateTime = date;
                    });
                  },
                  child: Text('vnesi datum')),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 228, 144, 76)),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 20),
                    ),
                  ),
                  onPressed: () async {
                    final time = await pickTime();
                    if (time == null) return;

                    final newDateTime = DateTime(dateTime.year, dateTime.month,
                        dateTime.day, time.hour, time.minute);
                    setState(() {
                      dateTime = newDateTime;
                    });
                  },
                  child: Text('vnesi vreme')),
            ],
          ),
          SizedBox(height: 30),
          AdaptiveFlatButton("Dodadi termin", _submitData)
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  AdaptiveFlatButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      onPressed: handler,
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 50),
        ),
        backgroundColor:
            MaterialStateProperty.all(Color.fromARGB(255, 233, 197, 149)),
      ),
    );
  }
}
