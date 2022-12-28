class EmentaDia{

  String? day;
  String? img;
  String? weekDay;
  String? soup;
  String? fish;
  String? meat;
  String? vegetarian;
  String? desert;
  bool? update;

  EmentaDia();

  EmentaDia.all(this.day, this.img, this.weekDay, this.soup, this.fish, this.meat,
      this.vegetarian, this.desert, this.update);

  factory EmentaDia.fromJson(Map<String, dynamic> json, bool flag){
    EmentaDia ementa = EmentaDia();
    ementa.day = json["weekDay"];
    ementa.img = json["img"];
    ementa.weekDay = json["weekDay"];
    ementa.soup = json["soup"];
    ementa.fish = json["fish"];
    ementa.meat = json["meat"];
    ementa.vegetarian = json["vegetarian"];
    ementa.desert = json["desert"];
    ementa.update = flag;
    return ementa;
  }


}