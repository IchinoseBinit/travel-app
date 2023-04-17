class Itenary {
  late String date;
  late final List<Details> details;

  Itenary(this.date) {
    details = [];
  }

  Itenary.fromJson(Map obj) {
    date = obj["date"];
    details = List.from(obj["details"]).map((e) => Details.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["date"] = date;
    map["details"] = details.map((e) => e.toJson()).toList();
    return map;
  }
}

class Details {
  late final String time;
  late final String name;

  Details(this.time, this.name);

  Details.fromJson(Map obj) {
    time = obj["time"].toString();
    name = obj["name"].toString();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["time"] = time;
    map["name"] = name;
    return map;
  }
}
