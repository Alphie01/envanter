const String trEmailNullError = "Lütfen emailnizi giriniz!";
const String trInvalidEmailError = "Lütfen emailnizi doğru giriniz!";
const String trPassNullError = "Lütfen şifrenizi giriniz";
const String trShortPassError = "Şifreniz çok kısa!";
const String trMatchPassError = "Şifreniz Eşleşmemektedir!";
const String trNamelNullError = "Lütfen isminizi giriniz!";
const String trSurnamelNullError = "Lütfen soyisminizi giriniz!";
const String trGenderNullError = "Lütfen Cinsiyetinizi giriniz!";
const String trPhoneNumberNullError = "Lütfen telefon numaranızı giriniz!";
const String trIvalidPhoneNumberError =
    "Lütfen telefon numaranızı doğru giriniz!";
const String trAddressNullError = "Please Enter your address";
const String trTermsNullError =
    "Lütfen Gizlilik Sözleşmesi, Haklar ve Koşullar Sözleşmesini Okuyun.";

bool isEmailValid(String email) {

  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  return emailRegex.hasMatch(email);
}

String privacyPolicy =
    "Güvenliğiniz bizim için önemli. Bu sebeple bizimle paylaşacağınız kişisel verileriz hassasiyetle korunmaktadır.\n\nBiz, Şirket Adı, veri sorumlusu olarak, bu gizlilik ve kişisel verilerin korunması politikası ile, hangi kişisel verilerinizin hangi amaçla işleneceği, işlenen verilerin kimlerle ve neden paylaşılabileceği, veri işleme yöntemimiz ve hukuki sebeplerimiz ile; işlenen verilerinize ilişkin haklarınızın neler olduğu hususunda sizleri aydınlatmayı amaçlıyoruz.\n\nToplanan Kişisel Verileriniz, Toplanma Yöntemi ve Hukuki Sebebi\n\nIP adresiniz ve kullanıcı aracısı bilgileriniz, sadece analiz yapmak amacıyla ve çerezler (cookies) vb. teknolojiler vasıtasıyla, otomatik veya otomatik olmayan yöntemlerle ve bazen de analitik sağlayıcılar, reklam ağları, arama bilgi sağlayıcıları, teknoloji sağlayıcıları gibi üçüncü taraflardan elde edilerek, kaydedilerek, depolanarak ve güncellenerek, aramızdaki hizmet ve sözleşme ilişkisi çerçevesinde ve süresince, meşru menfaat işleme şartına dayanılarak işlenecektir.\n\nKişisel Verilerinizin İşlenme Amacı\nBizimle paylaştığınız kişisel verileriniz sadece analiz yapmak suretiyle; sunduğumuz hizmetlerin gerekliliklerini en iyi şekilde yerine getirebilmek, bu hizmetlere sizin tarafınızdan ulaşılabilmesini ve maksimum düzeyde faydalanılabilmesini sağlamak, hizmetlerimizi, ihtiyaçlarınız doğrultusunda geliştirebilmek ve sizleri daha geniş kapsamlı hizmet sağlayıcıları ile yasal çerçeveler içerisinde buluşturabilmek ve kanundan doğan zorunlulukların (kişisel verilerin talep halinde adli ve idari makamlarla paylaşılması) yerine getirilebilmesi amacıyla, sözleşme ve hizmet süresince, amacına uygun ve ölçülü bir şekilde işlenecek ve güncellenecektir.\n\nToplanan Kişisel Verilerin Kimlere ve Hangi Amaçlarla Aktarılabileceği\nBizimle paylaştığınız kişisel verileriniz; faaliyetlerimizi yürütmek üzere hizmet aldığımız ve/veya verdiğimiz, sözleşmesel ilişki içerisinde bulunduğumuz, iş birliği yaptığımız, yurt içi ve yurt dışındaki 3. şahıslar ile kurum ve kuruluşlara ve talep halinde adli ve idari makamlara, gerekli teknik ve idari önlemler alınması koşulu ile aktarılabilecektir.\n\nKişisel Verileri İşlenen Kişi Olarak Haklarınız\nKVKK madde 11 uyarınca herkes, veri sorumlusuna başvurarak aşağıdaki haklarını kullanabilir:\nKişisel veri işlenip işlenmediğini öğrenme,\nKişisel verileri işlenmişse buna ilişkin bilgi talep etme,\nKişisel verilerin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme,\nYurt içinde veya yurt dışında kişisel verilerin aktarıldığı üçüncü kişileri bilme,\nKişisel verilerin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme,\nKişisel verilerin silinmesini veya yok edilmesini isteme,\n(e) ve (f) bentleri uyarınca yapılan işlemlerin, kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme,\nİşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kişinin kendisi aleyhine bir sonucun ortaya çıkmasına itiraz etme,\nKişisel verilerin kanuna aykırı olarak işlenmesi sebebiyle zarara uğraması hâlinde zararın giderilmesini talep etme, haklarına sahiptir.\nYukarıda sayılan haklarınızı kullanmak üzere email@site.com üzerinden bizimle iletişime geçebilirsiniz.\n\nİletişim\nSizlere hizmet sunabilmek amaçlı analizler yapabilmek için, sadece gerekli olan kişisel verilerinizin, işbu gizlilik ve kişisel verilerin işlenmesi politikası uyarınca işlenmesini, kabul edip etmemek hususunda tamamen özgürsünüz. Siteyi kullanmaya devam ettiğiniz takdirde kabul etmiş olduğunuz tarafımızca varsayılacak olup, daha ayrıntılı bilgi için bizimle email@site.com e-mail adresi üzerinden iletişime geçmekten lütfen çekinmeyiniz.";
