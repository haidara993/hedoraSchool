class User {
  int? id;
  String? email;
  String? photoUrl;
  String? division;
  int? divisionId;
  String? standard;
  int? standardId;
  String? enrollNo;
  String? displayName;
  String? dob;
  String? guardianName;
  String? bloodGroup;
  String? phoneNumber;
  String? jwt;
  bool? isVerified;

  User({
    this.id,
    this.email,
    this.photoUrl,
    this.division,
    this.divisionId,
    this.standard,
    this.standardId,
    this.displayName,
    this.dob,
    this.phoneNumber,
    this.guardianName,
    this.bloodGroup,
    this.enrollNo,
    this.isVerified,
    this.jwt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      photoUrl: json["photoUrl"],
      email: json["email"],
      division: json["division"],
      divisionId: json["divisionId"],
      enrollNo: json["enrollNo"],
      displayName: json["displayName"],
      standard: json["standard"],
      standardId: json["standardId"],
      dob: json["dob"],
      guardianName: json["guardianName"],
      bloodGroup: json["bloodGroup"],
      phoneNumber: json["phoneNumber"],
      isVerified: json["isVerified"],
      jwt: json["jwt"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["photoUrl"] = this.photoUrl;
    data["email"] = this.email;
    data["division"] = this.division;
    data["divisionId"] = this.divisionId;
    data["enrollNo"] = this.enrollNo;
    data["displayName"] = this.displayName;
    data["standard"] = this.standard;
    data["standardId"] = this.standardId;
    data["dob"] = this.dob;
    data["guardianName"] = this.guardianName;
    data["bloodGroup"] = this.bloodGroup;
    data["phoneNumber"] = this.phoneNumber;
    data["isVerified"] = this.isVerified;
    return data;
  }
}

class AuthUserDetails {
  late String? accessToken;
  late int? expiresIn;
  late User? userDetails;

  AuthUserDetails._({this.accessToken, this.expiresIn, this.userDetails});

  factory AuthUserDetails.fromJson(Map<String, dynamic> json) {
    // print("<<<<<<<<<<< user deatils"+json["userDetails"]);
    // ignore: unnecessary_new
    return new AuthUserDetails._(
        accessToken: json["accessToken"],
        expiresIn: json["expires_in"],
        userDetails: User.fromJson(json["userDetails"]));
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'expiresIn': expiresIn,
        'userDetails': userDetails
      };
}
