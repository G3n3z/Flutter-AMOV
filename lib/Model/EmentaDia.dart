import 'Ementa.dart';

class EmentaDia{
  String day;
  Ementa original;
  Ementa? updated;
  String? img;
  bool isUpdated = false;
  Ementa toShow;


  EmentaDia(this.original, this.updated, this.isUpdated, this.day, this.toShow);

  factory EmentaDia.fromJson(Map<String, dynamic> json){
    Ementa? updated;
    Ementa original = Ementa.fromJson(json["original"]);
    if (json["update"] != null) {
      updated = Ementa.fromJsonUpdated(json["update"], original);
    }

    EmentaDia dia = EmentaDia(original, updated, updated != null, original.weekDay.value, updated ?? original);
    dia.img = updated != null && updated.img != null ? updated.img : original.img;
    dia.toShow.img = dia.img;
    return dia;
  }

}