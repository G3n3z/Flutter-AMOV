import 'Field.dart';

class Ementa{

  Field weekDay;
  String? img;
  Field soup;
  Field fish;
  Field meat;
  Field vegetarian;
  Field desert;


  Ementa.all(this.img, this.weekDay, this.soup, this.fish, this.meat,
      this.vegetarian, this.desert);

  factory Ementa.fromJson(Map<String, dynamic> json){
    Ementa ementa = Ementa.all(
      json["img"],
      Field(json["weekDay"], false),
      Field(json["soup"], false),
      Field(json["fish"], false),
      Field(json["meat"], false),
      Field(json["vegetarian"], false),
      Field(json["desert"], false)
    );
    return ementa;
  }

  factory Ementa.fromJsonUpdated(Map<String, dynamic> json, Ementa original){
    Ementa ementa = Ementa.all(
        json["img"],
        Field(json["weekDay"], false),
        Field(json["soup"], json["soup"] != original.soup.value),
        Field(json["fish"], json["fish"] != original.fish.value),
        Field(json["meat"], json["meat"] != original.meat.value),
        Field(json["vegetarian"], json["vegetarian"] != original.vegetarian.value),
        Field(json["desert"], json["desert"] != original.desert.value)
    );
    if(ementa.soup.updated || ementa.fish.updated || ementa.meat.updated
        || ementa.vegetarian.updated || ementa.desert.updated){
      ementa.weekDay.updated = true;
    }
    return ementa;
  }


}