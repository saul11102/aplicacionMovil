import 'package:productos_app/controllers/Connection.dart';
import 'package:productos_app/models/ResponseGeneric.dart';
import 'package:productos_app/models/Session.dart';

class Service{
  final Connection _con = Connection();
  String getMedia() {
    return Connection.URL_MEDIA;
  }
  Future<Session> session(Map<dynamic, dynamic> map)  async {
    ResponseGeneric rg = await _con.post("session", map,'');
    Session s = Session();
    s.add(rg);
    if(rg.code == '200') {
      s.token = s.datos["token"];
      s.user = s.datos["user"];
    } 
    return s;
  }

  Future<Session> listar_sucursal()  async {
    ResponseGeneric rg = await _con.get("sucursal");
    Session s = Session();
    s.add(rg);
    print(s.toString());
    return s;
  }

  Future<Session> listar_productos()  async {
    ResponseGeneric rg = await _con.get("producto");
    Session s = Session();
    s.add(rg);
    print(s.toString());
    return s;
  }
}