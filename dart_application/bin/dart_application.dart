import 'dart:ffi';
import 'dart:io';
import 'dart:math';

class Otazka {
  String textOtazky;
  String odpoved1;
  String odpoved2;
  String odpoved3;
  int spravnaOdpoved;
  int pocetBodu;

  Otazka(this.textOtazky, this.odpoved1, this.odpoved2, this.odpoved3,
      this.spravnaOdpoved, this.pocetBodu);
}

void main(List<String> arguments) {
  otazky();
}

void otazky() {
  var test = List<Otazka>.generate(10, (index) => Otazka("", "", "", "", 0, 0));

  test[0] =
      Otazka("Základní jednotka informace je?", "Byte", "bit", "znak", 2, 3);
  test[1] = Otazka("1+1", "1", "3", "2", 3, 6);
  test[2] = Otazka("Kolik má týden dní?", "7", "6", "5", 1, 1);
  test[3] = Otazka("5+6", "-1", "11", "12", 2, 1);

  test[4] = Otazka("8-2", "2", "3", "6", 3, 9);
  test[5] = Otazka("7-1", "8", "6", "2", 2, 6);
  test[6] = Otazka("6*2", "22", "12", "3", 2, 5);
  test[7] = Otazka("8/2", "1", "4", "3", 2, 1);
  test[8] = Otazka("7+3", "1", "111", "11", 3, 2);
  test[9] = Otazka("8/4", "1", "2", "3", 2, 4);

  Random random = Random();
  var vybraneOtazky = List<int>.generate(3, (index) => -1);
  int pocetVybranych = 0;

  for (int i = 0; pocetVybranych < 3; i++) {
    int nahodnyIndex = random.nextInt(10);

    if (!vybraneOtazky.contains(nahodnyIndex)) {
      vybraneOtazky[pocetVybranych] = nahodnyIndex;
      pocetVybranych++;
    }
  }

  File file = File('test.txt');
  int soucetBodu = 0;

  try {
    IOSink sink = file.openWrite();
    for (int i = 0; i < 3; i++) {
      int index = vybraneOtazky[i];
      sink.writeln(
          "Otázka ${i + 1}: ${test[index].textOtazky} (${test[index].pocetBodu}b)");
      sink.writeln("a) ${test[index].odpoved1}");
      sink.writeln("b) ${test[index].odpoved2}");
      sink.writeln("c) ${test[index].odpoved3}");

      stdout.writeln(
          "Otázka ${i + 1}: ${test[index].textOtazky} (${test[index].pocetBodu}b)");
      stdout.writeln("a) ${test[index].odpoved1}");
      stdout.writeln("b) ${test[index].odpoved2}");
      stdout.writeln("c) ${test[index].odpoved3}");
      soucetBodu += test[index].pocetBodu;
      var text = stdin
          .readLineSync(); // Načtení textového vstupu      soucetBodu += test[index].pocetBodu;
    }
    sink.writeln("Celkový možný počet bodů: $soucetBodu");
    sink.close();
    print("Soubor 'test.txt' byl vytvořen.");
  } catch (e) {
    print("Nastala chyba při zápisu do souboru: $e");
  }
}
