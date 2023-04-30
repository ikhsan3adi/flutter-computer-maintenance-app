import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/utils/helper.dart';

const String addressPath = 'device_maintenance';

const int httpGET = 0;
const int httpPOST = 1;

const String ctxRuangan = 'ruangan';
const String ctxDevice = 'perangkat';
const String ctxPerawatan = 'perawatan';
const String ctxTeknisi = 'teknisi';

const String actSelect = 'select';
const String actCreate = 'create';
const String actDelete = 'delete';
const String actCount = 'count';
const String actLogin = 'login';
const String actSaveQR = 'saveQR';

Future<http.Response> queryData({
  required int httpVerbs,
  required String context,
  required String action,
  Map<String, String>? extraQueryParameters,
  Map<String, dynamic>? body,
}) async {
  // default query parameters
  final Map<String, dynamic> queryParameters = {
    "action": action,
  };

  // add extra query parameters if exists
  extraQueryParameters != null ? queryParameters.addEntries(extraQueryParameters.entries) : null;

  // Uri
  final uri = Uri(
    scheme: 'http',
    host: url,
    path: '$addressPath/$context/',
    queryParameters: queryParameters,
  );

  try {
    // request to API using GET or POST
    switch (httpVerbs) {
      case httpGET:
        return await http.get(uri);
      case httpPOST:
        return await http.post(uri, body: body);
      default:
        return await http.get(uri);
    }
  } catch (e) {
    throw Exception(errorConnection);
  }
}
