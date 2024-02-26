class Company {
  final String companyName;
  final String? companySurname, companyShortName, companyTags;
  final int? companyType, vkNumber, tcKimlik, mersisNo;
  final VergiDairesi? vergiDairesi;
  final Iletisim? iletisim;
  final List<Adres>? adres;
  final CariTuru cariTuru;

  Company({
    required this.companyName,
    this.vergiDairesi,
    this.mersisNo,
    this.companySurname,
    this.companyShortName,
    this.companyTags,
    required this.companyType,
    required this.vkNumber,
    required this.tcKimlik,
    required this.iletisim,
    required this.adres,
    this.cariTuru = CariTuru.sahis,
  });

  static CariTuru _setCariTuru(String value) =>
      value == "tuzel" ? CariTuru.tuzel : CariTuru.sahis;

  /* static Company createCompany(){} */
  
}

enum CariTuru { sahis, tuzel }

class Iletisim {
  final String? telefon, eposta, webadresi, faksNo;

  Iletisim({
    this.telefon,
    this.eposta,
    this.webadresi,
    this.faksNo,
  });
}

class Adres {
  final String? adres, il, ilce, postaKodu;

  Adres({
    this.adres,
    this.il,
    this.ilce,
    this.postaKodu,
  });
}

class VergiDairesi {
  final int? vergidairesiId, vergidairesiIl_id, vergidairesiSay_kodu;
  final String vergidairesiIlce, vergidairesiName;

  VergiDairesi({
    this.vergidairesiId,
    this.vergidairesiIl_id,
    this.vergidairesiSay_kodu,
    required this.vergidairesiIlce,
    required this.vergidairesiName,
  });
}
