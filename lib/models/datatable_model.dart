class DataTableModel {
  int? draw;
  int? recordsFiltered;
  int? recordsTotal;
  List<dynamic>? data;

  DataTableModel({
    this.data,
    this.draw,
    this.recordsFiltered,
    this.recordsTotal,
  });

  DataTableModel.fromJson(Map<String, dynamic> json) {
    draw = json['draw'];
    recordsFiltered = json['recordsFiltered'];
    recordsTotal = json['recordsTotal'];
    data = json['data'];
  }
}
