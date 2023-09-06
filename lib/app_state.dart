import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/lat_lng.dart';

class FFAppState {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _Selected = prefs.getBool('ff_Selected') ?? _Selected;
    _SelectedM = prefs.getBool('ff_SelectedM') ?? _SelectedM;
    _Offer = prefs.getBool('ff_Offer') ?? _Offer;
    _OfferAmt = prefs.getString('ff_OfferAmt') ?? _OfferAmt;
    _offer2 = prefs.getBool('ff_offer2') ?? _offer2;
    _phoneno = prefs.getString('ff_phoneno') ?? _phoneno;
  }

  late SharedPreferences prefs;

  bool _Selected = false;
  bool get Selected => _Selected;
  set Selected(bool _value) {
    _Selected = _value;
    prefs.setBool('ff_Selected', _value);
  }

  bool _SelectedM = false;
  bool get SelectedM => _SelectedM;
  set SelectedM(bool _value) {
    _SelectedM = _value;
    prefs.setBool('ff_SelectedM', _value);
  }

  bool _Offer = false;
  bool get Offer => _Offer;
  set Offer(bool _value) {
    _Offer = _value;
    prefs.setBool('ff_Offer', _value);
  }

  String _OfferAmt = '';
  String get OfferAmt => _OfferAmt;
  set OfferAmt(String _value) {
    _OfferAmt = _value;
    prefs.setString('ff_OfferAmt', _value);
  }

  bool _offer2 = false;
  bool get offer2 => _offer2;
  set offer2(bool _value) {
    _offer2 = _value;
    prefs.setBool('ff_offer2', _value);
  }

  String _phoneno = '';
  String get phoneno => _phoneno;
  set phoneno(String _value) {
    _phoneno = _value;
    prefs.setString('ff_phoneno', _value);
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}
