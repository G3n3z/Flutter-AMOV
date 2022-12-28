import 'Ementa.dart';

class EmentaDia{
  String day;
  Ementa original;
  Ementa? updated;
  String? img;
  bool isUpdated = false;

  EmentaDia(this.original, this.updated, this.isUpdated, this.day);

  factory EmentaDia.fromJson(Map<String, dynamic> json){
    Ementa? updated;
    if (json["update"] != null) {
       updated = Ementa.fromJson(json["update"], true);
    }
    Ementa original = Ementa.fromJson(json["original"], false);
    EmentaDia dia = EmentaDia(original, updated, updated != null, original.day!);
    dia.img = updated != null && updated.img != null ? updated.img : original.img;
    return dia;
  }

}