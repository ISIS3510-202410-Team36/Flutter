import 'package:shared_preferences/shared_preferences.dart';
import 'package:unimarket/globals.dart';

class SharedPreferencesR {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late String _sessionUID;
  late String _edad;
  late String _nombre;
  late String _genero;
  late String _apellido;
  late String _universidad;
  late String _nickname;
  late String _extra;

  Future<String> getSessionUID() async {
    final SharedPreferences prefs = await _prefs;
    String? uid = prefs.getString('Uid');
    if (uid == null) {
      return "0";
    } else {
      return uid;
    }
  }

  Future<String> getNickName() async {
    final SharedPreferences prefs = await _prefs;
    String? nick = prefs.getString('Nick');
    if (nick == null) {
      return "0";
    } else {
      return nick;
    }
  }

  Future<String> getName() async {
    final SharedPreferences prefs = await _prefs;
    String? nick = prefs.getString('Name');
    if (nick == null) {
      return "0";
    } else {
      return nick;
    }
  }

  Future<String> getLast() async {
    final SharedPreferences prefs = await _prefs;
    String? nick = prefs.getString('Last');
    if (nick == null) {
      return "0";
    } else {
      return nick;
    }
  }

  Future<String> getAge() async {
    final SharedPreferences prefs = await _prefs;
    String? nick = prefs.getString('Age');
    if (nick == null) {
      return "0";
    } else {
      return nick;
    }
  }

  Future<String> getGender() async {
    final SharedPreferences prefs = await _prefs;
    String? nick = prefs.getString('Gender');
    if (nick == null) {
      return "0";
    } else {
      return nick;
    }
  }

  Future<String> getUniversity() async {
    final SharedPreferences prefs = await _prefs;
    String? nick = prefs.getString('University');
    if (nick == null) {
      return "0";
    } else {
      return nick;
    }
  }

  Future<String> getExtra() async {
    final SharedPreferences prefs = await _prefs;
    String? nick = prefs.getString('Extra');
    if (nick == null) {
      return "0";
    } else {
      return nick;
    }
  }

  UpdateValues(String edad, String nombre, String genero, String apellido,
      String uni, String nick, String extra) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('Age', edad);
    _edad = edad;
    prefs.setString('Name', nombre);
    _nombre = nombre;
    prefs.setString('Gender', genero);
    _genero = genero;
    prefs.setString('Last', apellido);
    _apellido = apellido;
    prefs.setString('University', uni);
    _universidad = uni;
    prefs.setString('Nick', nick);
    _nickname = nick;
    prefs.setString('Extra', extra);
    _extra = extra;
    prefs.setString('Uid', Globals().getUid());
    _sessionUID = Globals().getUid();
  }
}
