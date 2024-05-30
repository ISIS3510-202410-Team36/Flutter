class Globals {
  Globals._internal();
  static final Globals _instance = Globals._internal();
  factory Globals() {
    return _instance;
  }

  static int numberNetworkIsolates = 0;
  static String SessionUserId = "";
  void increaseNetworkIsolate() {
    numberNetworkIsolates++;
  }

  void decreaseNetworkIsolate() {
    numberNetworkIsolates--;
  }

  int getNumberOfNetworkIsolates() {
    return numberNetworkIsolates;
  }

  void setSessionUserId(String uid) {
    SessionUserId = uid;
  }

  String getUid() {
    return SessionUserId;
  }
}
