import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<void> saveIdPromotor(int idProm) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setInt("idPromotor", idProm);
  }

  Future<int> getIdPromotor() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getInt("idPromotor") ?? 0;
  }

  Future<void> saveIdUsuario(int idUser) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setInt("idUsuario", idUser);
  }

  Future<int> getIdUser() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getInt("idUsuario") ?? 0;
  }

  Future<void> saveIdPersonaPromotor(int idPer) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setInt("idPerPromotor", idPer);
  }

  Future<int> getIdPersonaPromotor() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getInt("idPerPromotor") ?? 0;
  }

  //todo SAVE IDENTIFICATION/CI USER
  Future<void> saveUserIdentification(String identification) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("identification", identification);
  }

  Future<String> getUserIdentification() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getString("identification") ?? "";
  }

  Future<void> saveUserPhone(String phone) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("phone", phone);
  }

  Future<String> getUserPhone() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getString("phone") ?? "";
  }

  Future<void> setUserName(String name) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("name", name);
  }

  Future<String> getUserName() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getString("name") ?? "";
  }

  Future<void> setUserLastName(String lastName) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("lastName", lastName);
  }

  Future<String> getUserLastName() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getString("lastName") ?? "";
  }

  Future<void> setUserDate(String date) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("date", date);
  }

  Future<String?> getUserDate() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getString("date") ?? "";
  }

  Future<void> setFullName(String fullName) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("fullName", fullName);
  }

  Future<String> getFullName() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getString("fullName") ?? "";
  }

  Future<void> setUserMail(String? mail) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("mail", mail ?? "");
  }

  Future<String> getUserMail() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getString("mail") ?? "";
  }

  Future<void> savePathPhoto(String? path) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("photo", path ?? "");
  }

  Future<String> getPathPhoto() async {
    final pfrc = await SharedPreferences.getInstance();

    return pfrc.getString("photo") ?? "";
  }

  Future<void> saverVersionPhoto(int version) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setInt("version", version);
  }
}
