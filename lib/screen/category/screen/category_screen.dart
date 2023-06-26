import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerDataTable extends StatefulWidget {
  const ServerDataTable({super.key});

  @override
  ServerDataTableState createState() => ServerDataTableState();
}

class ServerDataTableState extends State<ServerDataTable> {
  List<Map<String, dynamic>> data = [];
  int pageSize = PaginatedDataTable.defaultRowsPerPage;
  int totalRecords = 0;
  String sortColumn = 'id';
  String sortDirection = 'asc';
  String filterColumn = '';
  String filterValue = '';
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    fetchData(0, length: pageSize);
  }

  Future<void> fetchData(int start, {int length = 10}) async {
    try {
      Map<String, dynamic> map = {
        "draw": "1",
        "columns[0][data]": "id",
        "columns[0][searchable]": "true",
        "columns[0][orderable]": "true",
        "columns[0][search][regex]": "false",
        "columns[1][data]": "name",
        "columns[1][searchable]": "true",
        "columns[1][orderable]": "true",
        "columns[1][search][regex]": "false",
        "columns[2][data]": "is_active",
        "columns[2][searchable]": "true",
        "columns[2][orderable]": "true",
        "columns[2][search][regex]": "false",
        "columns[3][data]": "id",
        "columns[3][search][regex]": "false",
        "order[0][column]": "0",
        "order[0][dir]": "asc",
        "start": start.toString(),
        "length": length.toString(),
      };
      var url = Uri.http("192.168.0.163:8000", "/api/brand/dataTable", map);
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        'X-Requested-With': 'XMLHttpRequest',
      });
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        setState(() {
          data = List<Map<String, dynamic>>.from(body['data']);
          totalRecords = body['recordsTotal'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  changePage(int page) async {
    int _length = 0;
    if ((totalRecords - page) < pageSize) {
      _length = (totalRecords - page);
    } else {
      _length = pageSize;
    }
    await fetchData(page, length: _length);
  }

  void onSort(String column, bool ascending) {
    setState(() {
      sortColumn = column;
      sortDirection = ascending ? 'asc' : 'desc';
    });
    // fetchData();
  }

  void onFilter(String column, String value) {
    setState(() {
      filterColumn = column;
      filterValue = value;
    });
    // fetchData();
  }

  void onSearch(String term) {
    setState(() {
      searchTerm = term;
    });
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTableControls(
          onFilter: onFilter,
          onSearch: onSearch,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: PaginatedDataTable(
              dataRowMaxHeight: 35,
              dataRowMinHeight: 20,
              showCheckboxColumn: false,
              showFirstLastButtons: true,
              availableRowsPerPage: const [1, 5, 10, 50],
              rowsPerPage: pageSize,
              primary: true,
              onPageChanged: changePage,
              // onSort: onSort,
              source: ServerDataTableSource(data, totalRecords),
              columns: [
                DataColumn(
                  label: const Text('ID'),
                  onSort: (columnIndex, ascending) => onSort('id', ascending),
                ),
                DataColumn(
                  label: const Text('Name'),
                  onSort: (columnIndex, ascending) => onSort('name', ascending),
                ),
                DataColumn(
                  label: const Text('Status'),
                  onSort: (columnIndex, ascending) =>
                      onSort('is_active', ascending),
                ),
                const DataColumn(
                  label: Text('Action'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DataTableControls extends StatelessWidget {
  final Function(String, String) onFilter;
  final Function(String) onSearch;

  const DataTableControls(
      {super.key, required this.onFilter, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          DropdownButton<String>(
            value: '',
            onChanged: (String? column) {
              onFilter(column!, '');
            },
            items: const [
              DropdownMenuItem<String>(
                value: '',
                child: Text('Filter By'),
              ),
              DropdownMenuItem<String>(
                value: 'id',
                child: Text('ID'),
              ),
              DropdownMenuItem<String>(
                value: 'name',
                child: Text('Name'),
              ),
              DropdownMenuItem<String>(
                value: 'description',
                child: Text('Description'),
              ),
            ],
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextFormField(
              onChanged: (String value) {
                onFilter('filterColumn', value);
              },
              decoration: const InputDecoration(
                labelText: 'Filter Value',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServerDataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final int count;

  ServerDataTableSource(this.data, this.count);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;

    final row = data[index];
    return DataRow(cells: [
      DataCell(Text("${index + 1}")),
      DataCell(Text(row['name'])),
      DataCell(Text(row['is_active'].toString())),
      DataCell(IconButton(onPressed: () {}, icon: const Icon(Icons.edit))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}
