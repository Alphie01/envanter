<?php
header('Content-Type: application/json; charset=utf-8');

include './baglan.php';
/* error_reporting(1); */
error_reporting(E_ALL);
error_reporting(-1);
ini_set('error_reporting', E_ALL);
include "vendor/autoload.php";


//TODO getUserMeta;

use IS\PazarYeri\Trendyol\TrendyolClient;
use IS\PazarYeri\Trendyol\Helper\TrendyolException;

use function PHPSTORM_META\type;


use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;


require 'mail/PHPMailer/src/Exception.php';
require 'mail/PHPMailer/src/PHPMailer.php';
require 'mail/PHPMailer/src/SMTP.php';


function MailInfo($name, $code)
{
    return '<!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>E-Posta Başlığı</title>
    </head>
    <body style="font-family: Arial, sans-serif; background-color: #f2f2f2;">
    <table class="body-wrap" style=" box-sizing: border-box; font-size: 14px; width: 100%; background-color: transparent; margin: 0;">
    <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
        <td style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;" valign="top"></td>
        <td class="container" width="600" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto;" valign="top">
            <div class="content" style=" box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 20px;">
                <table class="main" width="100%" cellpadding="0" cellspacing="0" style=" box-sizing: border-box; font-size: 14px; border-radius: 7px; background-color: #fff; color: #495057; margin: 0; box-shadow: 0 0.75rem 1.5rem rgba(18,38,63,.03);" bgcolor="#fff">
                    <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                        <td class="alert alert-warning" style=" box-sizing: border-box; font-size: 16px; vertical-align: top; color: #fff; font-weight: 500; text-align: center; border-radius: 7px 7px 0 0; background-color: #556ee6; margin: 0; padding: 20px;" align="center" bgcolor="#71b6f9" valign="top">
                        Envanterim İş Hayatımı Tercih Ettiğiniz İçin Teşekkürler
                        </td>
                    </tr>
                    <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                        <td class="content-wrap" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 20px;" valign="top">
                            <table width="100%" cellpadding="0" cellspacing="0" style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                        Sevgili ' . $name . ' <br><br>
                                        Envanterim İş Hayatım ailesine hoşgeldiniz. Emailinizi onayladıktan sonra ister kendi işletmenizi oluşturup kendi envanterinizi oluşturabilir, ister daha önceden bulunan işletmenin bünyesine girebilirsiniz.
                                    </td>
                                </tr>
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                        <b>Neden Email Doğrulaması?<b/><br>
                                        En iyi hizmeti alabilmeniz için e-posta adresinizin gerçek olmasına ihtiyacımız var.
                                    </td>
                                </tr>
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                        <p style=" box-sizing: border-box; font-size: 14px; color: #FFF; text-decoration: none; line-height: 2em; font-weight: bold; text-align: center; cursor: pointer; display: inline-block; border-radius: 5px; text-transform: capitalize; background-color: #34c38f; margin: 0; border-color: #34c38f; border-style: solid; border-width: 8px 16px;">' . $code . '</>
                                    </td>
                                </tr>
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                    Envanterim İş Hayatımı Tercih Ettiğiniz İçin Teşekkürler
                                    </td>
                                </tr>
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                        <b> Sevigilerle</b>
                                        <p>Envanterim İş Hayatımı</p>
                                    </td>
                                </tr>
    
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style="text-align: center; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0;" valign="top">
                                        © 2024 Alphie
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    </table>
    </body>
    </html>
    ';
}


function InvitationMail($name, $companyName)
{
    return '<!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>E-Posta Başlığı</title>
    </head>
    <body style="font-family: Arial, sans-serif; background-color: #f2f2f2;">
    <table class="body-wrap" style=" box-sizing: border-box; font-size: 14px; width: 100%; background-color: transparent; margin: 0;">
    <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
        <td style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0;" valign="top"></td>
        <td class="container" width="600" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; display: block !important; max-width: 600px !important; clear: both !important; margin: 0 auto;" valign="top">
            <div class="content" style=" box-sizing: border-box; font-size: 14px; max-width: 600px; display: block; margin: 0 auto; padding: 20px;">
                <table class="main" width="100%" cellpadding="0" cellspacing="0" style=" box-sizing: border-box; font-size: 14px; border-radius: 7px; background-color: #fff; color: #495057; margin: 0; box-shadow: 0 0.75rem 1.5rem rgba(18,38,63,.03);" bgcolor="#fff">
                    <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                        <td class="alert alert-warning" style=" box-sizing: border-box; font-size: 16px; vertical-align: top; color: #fff; font-weight: 500; text-align: center; border-radius: 7px 7px 0 0; background-color: #556ee6; margin: 0; padding: 20px;" align="center" bgcolor="#71b6f9" valign="top">
                        ' . $companyName . ' isimli şirket sizi işletmesine eklemek istiyor!
                        </td>
                    </tr>
                    <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                        <td class="content-wrap" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 20px;" valign="top">
                            <table width="100%" cellpadding="0" cellspacing="0" style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                        Sevgili ' . $name . ' <br><br>
                                        Envanterim İş Hayatım uygulamasında 
                                    </td>
                                </tr>
                                
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                        <p style=" box-sizing: border-box; font-size: 14px; color: #FFF; text-decoration: none; line-height: 2em; font-weight: bold; text-align: center; cursor: pointer; display: inline-block; border-radius: 5px; text-transform: capitalize; background-color: #34c38f; margin: 0; border-color: #34c38f; border-style: solid; border-width: 8px 16px;">Onayla</p>
                                    </td>
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                        <p style=" box-sizing: border-box; font-size: 14px; color: #FFF; text-decoration: none; line-height: 2em; font-weight: bold; text-align: center; cursor: pointer; display: inline-block; border-radius: 5px; text-transform: capitalize; background-color: #FC5050; margin: 0; border-color: #FC5050; border-style: solid; border-width: 8px 16px;">Reddet</p>
                                    </td>
                                </tr>
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                    Envanterim İş Hayatımı Tercih Ettiğiniz İçin Teşekkürler
                                    </td>
                                </tr>
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style=" box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0 0 20px;" valign="top">
                                        <b> Sevigilerle</b>
                                        <p>Envanterim İş Hayatımı</p>
                                    </td>
                                </tr>
    
                                <tr style=" box-sizing: border-box; font-size: 14px; margin: 0;">
                                    <td class="content-block" style="text-align: center; box-sizing: border-box; font-size: 14px; vertical-align: top; margin: 0; padding: 0;" valign="top">
                                        © 2024 Alphie
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    </table>
    </body>
    </html>
    ';
}


$returns = [];


$base_url = 'https://robolink.com.tr';


$error_diffrentPassword = array(
    'id' => 1,
    'error_message' => 'Şifrelerinizi Kontrol Ediniz. Şifreleriniz Birbirinden Farklı Olamaz!'
);

$error_passwordMust = array(
    'id' => 2,
    'error_message' => 'Şifreniz 6 Haneden Düşük Olamaz!'
);

$error_usedMail = array(
    'id' => 3,
    'error_message' => 'E-mail Adresiniz Kullanılmakta!'
);

$error_basarisiz = array(
    'id' => 4,
    'error_message' => 'Kaydınız Başarısız! Lütfen Tekrar Deneyiniz!'
);


$error_duplicated = array(
    'id' => 5,
    'error_message' => 'Daha önceden davet etmişsiniz. Davet ettiğiniz kullanıcı cevaplayacaktır'
);

$error_something = array(
    'id' => 404,
    'error_message' => 'Bir şeyler ters gitti! Lütfen sonra tekrar deneyiniz!'
);

$base_shop_permissions = array(
    'user_control' => [
        'shop_can_add_teammates' => false,
        'shop_can_categorise_teammates' => false,
    ],
    'payout' => [
        'shop_can_sell_products' => false,
        'shop_can_bill' => false,
    ],
    'inventory_upgrade' => [
        'shop_inventory_product_limit' => 50,
        'shop_can_categorise' => false,
        'shop_can_initilize_place' => false,
        'shop_can_initilize_low_stok' => false,
        'shop_can_decrease_stock' => false,
        'shop_can_see_product_history' => false,
        'shop_can_init_reminder' => false,
    ],
    'analytics' => [
        'shop_can_see_analytics' => false,
    ],
    'shop_show_ads' => true,
);



function turkishToEnglish($text)
{
    // Türkçe karakterleri İngilizce karakterlere dönüştür
    $text = str_replace(
        array('Ç', 'ç', 'Ğ', 'ğ', 'İ', 'ı', 'Ö', 'ö', 'Ş', 'ş', 'Ü', 'ü'),
        array('C', 'c', 'G', 'g', 'I', 'i', 'O', 'o', 'S', 's', 'U', 'u'),
        $text
    );

    // Boşlukları alt çizgi (_) ile değiştir
    $text = str_replace(' ', '_', $text);

    // Metni küçük harfe dönüştür
    $text = strtolower($text);

    return $text;
}


function sendMail($name, $email, $ret): bool
{



    $mail = new PHPMailer(true);
    try {
        // SMTP ayarlarını belirleyin
        $mail->isSMTP();
        $mail->Host       = 'mail.robolink.com.tr'; // SMTP sunucusu
        $mail->SMTPAuth   = true;
        $mail->Username   = 'welcome@robolink.com.tr'; // E-posta hesabınızın kullanıcı adı
        $mail->Password   = 'N^Xlnxr1OuH*'; // E-posta hesabınızın şifresi
        $mail->SMTPSecure = 'tls';
        $mail->Port       = 587;
        $mail->isHTML(true);
        $mail->CharSet = 'UTF-8';
        // Alıcı, konu ve mesaj içeriğini belirleyin
        $mail->setFrom('welcome@robolink.com.tr', 'Envanterim İş Hayatım');
        $mail->addAddress($email, $name);
        $mail->Subject = 'Envanterim İş Hayatımdan bir bildiriminiz var!';
        $mail->Body = $ret;

        // E-postayı gönderin
        $mail->send();
        return true;
    } catch (Exception $e) {

        return false;
    }
}



/* ********************* */
/* 
TODO User Post REQUESTS 
*/
/* ********************* */

if (isset($_POST['kullanici_register'])) {

    print_r($_POSt);
    $random_mail_key = random_int(1000, 9999);
    $kullanici_yetki = 0;
    $token = bin2hex(random_bytes(16));
    $kullanici_passwordone = trim($_POST['kullanici_password']);

    $kullanicisor = $db->prepare("select * from kullanici where kullanici_mail=:mail");
    $kullanicisor->execute(array(
        'mail' => $_POST['kullanici_mail']
    ));
    $say = $kullanicisor->rowCount();
    if ($say == 0) {
        $password = md5($kullanici_passwordone);

        $postArray = array(
            'kullanici_mail' => $_POST['kullanici_mail'],
            'kullanici_secretToken' => $token
        );




        $kullanicikaydet = $db->prepare("INSERT INTO kullanici SET
						kullanici_adsoyad=:kullanici_adsoyad,
						kullanici_mail=:kullanici_mail,
						kullanici_password=:kullanici_password,
						kullanici_gsm=:kullanici_gsm,
						kullanici_gender=:kullanici_gender,
						kullanici_adres=:kullanici_adres,
						kullanici_ad=:kullanici_ad,
						kullanici_mail_key=:kullanici_mail_key,
						kullanici_secretToken=:kullanici_secretToken,
						kullanici_yetki=:kullanici_yetki
						");
        $insert = $kullanicikaydet->execute(array(
            'kullanici_adsoyad' => $_POST['kullanici_adsoyad'],
            'kullanici_mail' => $_POST['kullanici_mail'],
            'kullanici_password' => $password,
            'kullanici_gender' => $_POST['kullanici_gender'],
            'kullanici_adres' => $_POST['kullanici_adres'],
            'kullanici_gsm' => $_POST['kullanici_gsm'],
            'kullanici_ad' => $_POST['kullanici_ad'],
            'kullanici_mail_key' => $random_mail_key,
            'kullanici_secretToken' => $token,
            'kullanici_yetki' => $kullanici_yetki
        ));
        if ($insert) {
            $bool = sendMail($_POST['kullanici_adsoyad'], $_POST['kullanici_mail'], MailInfo($name, $code));
            if ($bool) {
                $success = array(
                    'id' => 0,
                    'result' => $postArray
                );
                print_r(json_encode($success));
            } else {

                print_r(json_encode($error_something));
            }
        } else {
            print_r(json_encode($error_basarisiz));
        }
    } else {
        print_r(json_encode($error_usedMail));
    }
}

if (isset($_POST['resend_mail_key'])) {

    $kullanici_mail = $_POST['kullanici_mail'];

    $kullanicisor = $db->prepare("SELECT * FROM kullanici where kullanici_mail=:mail and kullanici_secretToken=:kullanici_secretToken ");
    $kullanicisor->execute(array(
        'mail' => $kullanici_mail,
        'kullanici_secretToken' => $_POST['kullanici_secretToken']
    ));

    $say = $kullanicisor->rowCount();
    $kullanicicek = $kullanicisor->fetch(PDO::FETCH_ASSOC);

    if ($kullanicicek) {
        $bool = sendMail($kullanicicek['kullanici_adsoyad'], $_POST['kullanici_mail'], MailInfo($name, $code));
        if ($bool) {
            $success = array(
                'id' => 0,
            );
            print_r(json_encode($success));
        } else {
            print_r(json_encode($error_something));
        }
    } else {

        print_r(json_encode($error_basarisiz));
    }
}



if (isset($_POST['check_mail_key'])) {

    $kullanici_mail = $_POST['kullanici_mail'];

    $kullanicisor = $db->prepare("SELECT * FROM kullanici where kullanici_mail=:mail and kullanici_secretToken=:kullanici_secretToken and kullanici_mail_key=:kullanici_mail_key");
    $kullanicisor->execute(array(
        'mail' => $kullanici_mail,
        'kullanici_secretToken' => $_POST['kullanici_secretToken'],
        'kullanici_mail_key' => $_POST['mail_key']
    ));

    $say = $kullanicisor->rowCount();
    $kullanicicek = $kullanicisor->fetch(PDO::FETCH_ASSOC);

    if ($kullanicicek) {

        $kaydet = $db->prepare("UPDATE kullanici SET
        kullanici_durum=:kullanici_durum
        WHERE kullanici_id=:kullanici_id");
        $update = $kaydet->execute(array(
            'kullanici_durum' => '1',
            'kullanici_id' => $kullanicicek['kullanici_id']
        ));

        if ($update) {
            $returns = array(
                'id' => 0,
                'kullanici' => $kullanicicek
            );
            print_r(json_encode($returns));
        } else {
            print_r(json_encode($error_basarisiz));
        }
    } else {

        print_r(json_encode($error_basarisiz));
    }
}





if (isset($_POST['fetchUserByMail'])) {

    $kullanici_mail = $_POST['kullanici_mail'];
    $kullanici_password = md5($_POST['kullanici_password']);

    $kullanicisor = $db->prepare("SELECT * FROM kullanici where kullanici_mail=:mail and kullanici_password=:password");
    $kullanicisor->execute(array(
        'mail' => $kullanici_mail,
        'password' => $kullanici_password
    ));

    $say = $kullanicisor->rowCount();
    $kullanicicek = $kullanicisor->fetch(PDO::FETCH_ASSOC);

    if ($kullanicicek) {

        $workingAreas = array();
        $invitedAreas = array();


        $workerSor = $db->prepare("SELECT * FROM shop_workers where shop_workers_workerId=:shop_workers_workerId and worker_isApproved=1");
        $workerSor->execute(array(

            'shop_workers_workerId' => $kullanicicek['kullanici_id']
        ));
        while ($workerCek = $workerSor->fetch(PDO::FETCH_ASSOC)) {

            $platformsor = $db->prepare("SELECT shop_id, shop_owner_Id, shop_type, shop_name, shop_image,shop_token, shop_permissions FROM shop where shop_id=:shop_id");
            $platformsor->execute(array(

                'shop_id' => $workerCek['shop_id']
            ));
            $platformcek = $platformsor->fetch(PDO::FETCH_ASSOC);
            $platformcek['shop_permissionLevel'] = $workerCek['shop_workers_permissonLevel'];

            array_push($workingAreas, $platformcek);
        }




        $worker_invite_Sor = $db->prepare("SELECT * FROM shop_workers where shop_workers_workerId=:shop_workers_workerId and worker_isApproved=2");
        $worker_invite_Sor->execute(array(

            'shop_workers_workerId' => $kullanicicek['kullanici_id']
        ));
        while ($worker_invite_Cek = $worker_invite_Sor->fetch(PDO::FETCH_ASSOC)) {

            $platformsor = $db->prepare("SELECT shop_id, shop_type, shop_name, shop_image,shop_token, shop_permissions FROM shop where shop_id=:shop_id");
            $platformsor->execute(array(

                'shop_id' => $worker_invite_Cek['shop_id']
            ));
            $platformcek = $platformsor->fetch(PDO::FETCH_ASSOC);
            $platformcek['shop_permissionLevel'] = $worker_invite_Cek['shop_workers_permissonLevel'];

            array_push($invitedAreas, $platformcek);
        }

        $returns = array(
            'id' => 0,
            'kullanici' => $kullanicicek,
            'shop' => $workingAreas,
            'invitedShops' => $invitedAreas
        );


        print_r(json_encode($returns));
    } else {

        print_r(json_encode($error_basarisiz));
    }
}


if (isset($_POST['fetchUserByToken'])) {


    $kullanicisor = $db->prepare("SELECT * FROM kullanici where kullanici_secretToken=:kullanici_secretToken");
    $kullanicisor->execute(array(

        'kullanici_secretToken' => $_POST['userToken']
    ));

    $say = $kullanicisor->rowCount();
    $kullanicicek = $kullanicisor->fetch(PDO::FETCH_ASSOC);


    if ($kullanicicek) {

        $workingAreas = array();
        $invitedAreas = array();


        $workerSor = $db->prepare("SELECT * FROM shop_workers where shop_workers_workerId=:shop_workers_workerId and worker_isApproved=1");
        $workerSor->execute(array(

            'shop_workers_workerId' => $kullanicicek['kullanici_id']
        ));
        while ($workerCek = $workerSor->fetch(PDO::FETCH_ASSOC)) {

            $platformsor = $db->prepare("SELECT shop_id, shop_owner_Id, shop_type, shop_name, shop_image,shop_token, shop_permissions FROM shop where shop_id=:shop_id");
            $platformsor->execute(array(

                'shop_id' => $workerCek['shop_id']
            ));
            $platformcek = $platformsor->fetch(PDO::FETCH_ASSOC);
            $platformcek['shop_permissionLevel'] = $workerCek['shop_workers_permissonLevel'];

            array_push($workingAreas, $platformcek);
        }




        $worker_invite_Sor = $db->prepare("SELECT * FROM shop_workers where shop_workers_workerId=:shop_workers_workerId and worker_isApproved=2");
        $worker_invite_Sor->execute(array(

            'shop_workers_workerId' => $kullanicicek['kullanici_id']
        ));
        while ($worker_invite_Cek = $worker_invite_Sor->fetch(PDO::FETCH_ASSOC)) {

            $platformsor = $db->prepare("SELECT shop_id, shop_type, shop_name, shop_image,shop_token, shop_permissions FROM shop where shop_id=:shop_id");
            $platformsor->execute(array(

                'shop_id' => $worker_invite_Cek['shop_id']
            ));
            $platformcek = $platformsor->fetch(PDO::FETCH_ASSOC);
            $platformcek['shop_permissionLevel'] = $worker_invite_Cek['shop_workers_permissonLevel'];

            array_push($invitedAreas, $platformcek);
        }

        $returns = array(
            'id' => 0,
            'kullanici' => $kullanicicek,
            'shop' => $workingAreas,
            'invitedShops' => $invitedAreas
        );


        print_r(json_encode($returns));
    } else {

        print_r(json_encode($error_basarisiz));
    }
}


if (isset($_POST['initShopByToken'])) {
    $initShop = $db->prepare("SELECT shop_id, shop_products, shop_categories, shop_notifications, shop_sells FROM shop where shop_token=:shop_token");
    $initShop->execute(array(
        'shop_token' => $_POST['shop_token']
    ));
    $initShopCek = $initShop->fetch(PDO::FETCH_ASSOC);

    $workerInfos = array();
    $waitingWorkerInfos = array();



    $workerSor = $db->prepare("SELECT * FROM shop_workers where shop_id=:shop_id and not shop_workers_workerId=:shop_workers_workerId ORDER BY shop_workers_permissonLevel DESC");
    $workerSor->execute(array(
        'shop_id' => $initShopCek['shop_id'],
        'shop_workers_workerId' => $_POST['user_id']
    ));
    while ($workerCek = $workerSor->fetch(PDO::FETCH_ASSOC)) {

        $platformsor = $db->prepare("SELECT kullanici_id, kullanici_ad, kullanici_adsoyad, kullanici_mail, kullanici_resim FROM kullanici where kullanici_id=:kullanici_id");
        $platformsor->execute(array(

            'kullanici_id' => $workerCek['shop_workers_workerId']
        ));
        $platformcek = $platformsor->fetch(PDO::FETCH_ASSOC);
        $platformcek['shop_workers_permissonLevel'] = $workerCek['shop_workers_permissonLevel'];


        if ($workerCek['worker_isApproved'] == 1) {
            array_push($workerInfos, $platformcek);
        } else if ($workerCek['worker_isApproved'] == 0) {
            array_push($waitingWorkerInfos, $platformcek);
        }
    }




    if ($initShopCek) {
        $returns = array(
            'id' => 0,
            'products' => json_decode($initShopCek['shop_products']),
            'categories' => json_decode($initShopCek['shop_categories']),
            'workers' => $workerInfos,
            'waitingApprove' => $waitingWorkerInfos,
            'notification' => json_decode($initShopCek['shop_notifications']),
            'shop_sells' => json_decode($initShopCek['shop_sells'])
        );
        print_r(json_encode($returns));
    } else {

        print_r(json_encode($error_basarisiz));
    }
}




if (isset($_POST['answerInvitation'])) {


    $kaydet = $db->prepare("UPDATE shop_workers SET worker_isApproved=:worker_isApproved
            WHERE shop_id=:shop_id and shop_workers_workerId=:shop_workers_workerId");
    $update = $kaydet->execute(array(
        'shop_workers_workerId' => $_POST['answeredUser_id'],
        'worker_isApproved' => $_POST['answer'],
        'shop_id' => $_POST['shop_id']
    ));

    if ($update) {
        $returns = array(
            'id' => 0,
        );
        print_r(json_encode($returns));
    } else {
        # code...
        print_r(json_encode($error_basarisiz));
    }
}

if (isset($_POST['leaveCompany'])) {


    $kaydet = $db->prepare("UPDATE shop_workers SET worker_isApproved=:worker_isApproved
            WHERE shop_id=:shop_id and shop_workers_workerId=:shop_workers_workerId");
    $update = $kaydet->execute(array(
        'shop_workers_workerId' => $_POST['answeredUser_id'],
        'worker_isApproved' => $_POST['answer'],
        'shop_id' => $_POST['shop_id']
    ));

    if ($update) {
        $returns = array(
            'id' => 0,
        );
        print_r(json_encode($returns));
    } else {
        # code...
        print_r(json_encode($error_basarisiz));
    }
}

if (isset($_POST['sendInvitation'])) {


    $initShop = $db->prepare("SELECT shop_name FROM shop where shop_id=:shop_id");
    $initShop->execute(array(
        'shop_id' => $_POST['shop_id']
    ));
    $initShopCek = $initShop->fetch(PDO::FETCH_ASSOC);


    $kullanicisor = $db->prepare("SELECT * FROM kullanici where kullanici_id=:kullanici_id");
    $kullanicisor->execute(array(
        'kullanici_id' => $_POST['user_id']
    ));
    $kullanicicek = $kullanicisor->fetch(PDO::FETCH_ASSOC);

    $workersor = $db->prepare("SELECT * FROM shop_workers where shop_workers_workerId=:shop_workers_workerId and shop_id=:shop_id");
    $workersor->execute(array(
        'shop_id' => $_POST['shop_id'],
        'shop_workers_workerId' => $_POST['answeredUser_id']
    ));
    $say = $workersor->rowCount();
    $workercek = $workersor->fetch(PDO::FETCH_ASSOC);


    if ($say == 0) {
        $kaydet = $db->prepare("INSERT INTO shop_workers SET
        worker_whoApproved=:worker_whoApproved, worker_isApproved=:worker_isApproved
        , shop_id=:shop_id, shop_workers_workerId=:shop_workers_workerId");
        $update = $kaydet->execute(array(
            'worker_whoApproved' => $_POST['user_id'],
            'shop_workers_workerId' => $_POST['answeredUser_id'],
            'worker_isApproved' => $_POST['answer'],
            'shop_id' => $_POST['shop_id']
        ));

        if ($update) {
            $ret = InvitationMail($kullanicicek['kullanici_adsoyad'], $initShopCek['shop_name']);
            $bool = sendMail($kullanicicek['kullanici_adsoyad'], $kullanicicek['kullanici_mail'], $ret);
            if ($bool) {
                $success = array(
                    'id' => 0,
                );
                print_r(json_encode($success));
            } else {
                print_r(json_encode($error_something));
            }
        } else {
            # code...
            print_r(json_encode($error_basarisiz));
        }
    } else {
        print_r(json_encode($error_duplicated));
    }
}

if (isset($_POST['answerWaitingWorker'])) {


    $kaydet = $db->prepare("UPDATE shop_workers SET
            worker_whoApproved=:worker_whoApproved, worker_isApproved=:worker_isApproved
            WHERE shop_id=:shop_id and shop_workers_workerId=:shop_workers_workerId");
    $update = $kaydet->execute(array(
        'shop_workers_workerId' => $_POST['answeredUser_id'],
        'worker_whoApproved' => $_POST['user_id'],
        'worker_isApproved' => $_POST['answer'],
        'shop_id' => $_POST['shop_id']
    ));

    if ($update) {
        $returns = array(
            'id' => 0,
        );
        print_r(json_encode($returns));
    } else {
        # code...
        print_r(json_encode($error_basarisiz));
    }
}

if (isset($_POST['getInfoWhoWorker'])) {

    $workerSor = $db->prepare("SELECT * FROM shop_workers where shop_id=:shop_id and shop_workers_workerId=:shop_workers_workerId");
    $workerSor->execute(array(

        'shop_workers_workerId' => $_POST['user_id'],
        'shop_id' => $_POST['shop_token']
    ));
    $say = $workerSor->rowCount();
    $workerCek = $workerSor->fetch(PDO::FETCH_ASSOC);

    if ($say > 0) {
        $kullanicisor = $db->prepare("SELECT kullanici_gsm, kullanici_adres, kullanici_il, kullanici_ilce FROM kullanici where kullanici_id=:kullanici_id");
        $kullanicisor->execute(array(

            'kullanici_id' => $_POST['user_id']
        ));

        $kullanicicek = $kullanicisor->fetch(PDO::FETCH_ASSOC);
        $returns = array(
            'id' => 0,
            'user_moreInfo' => $kullanicicek
        );
        print_r(json_encode($returns));
    } else {
        print_r(json_encode($error_basarisiz));
    }
}

if (isset($_POST['getUserByMails'])) {

    $keywords = $_POST['kullanici_mail'];
    $userByMailSor = $db->prepare("
        SELECT k.kullanici_id, k.kullanici_ad, k.kullanici_adsoyad, k.kullanici_mail, k.kullanici_resim 
        FROM kullanici k 
        LEFT JOIN shop_workers sw ON k.kullanici_id = sw.shop_workers_workerId AND sw.shop_id = :shop_id
        WHERE k.kullanici_mail LIKE :keywords AND sw.shop_workers_workerId IS NULL
        ORDER BY k.kullanici_id 
        LIMIT 6
    ");
    $userByMailSor->execute(array(':keywords' => "%$keywords%", ':shop_id' => $_POST['shop_id']));
    $say = $userByMailSor->rowCount();
    $userByMailCek = $userByMailSor->fetchAll(PDO::FETCH_ASSOC);

    if ($say > 0) {
        $returns = array(
            'id' => 0,
            'UserByMails' => $userByMailCek
        );
        print_r(json_encode($returns));
    } else {
        print_r(json_encode($error_basarisiz));
    }
}



/* 

shop_privacy == 0 ? gizli
shop_privacy == 1 ? gizli değil Herkese Açık!
createNewShop
*/


/* *********************  */
/* 
TODO Shop 
*/
/* ********************* */
// creating 

if (isset($_POST['createNewShop'])) {



    $kaydet = $db->prepare("INSERT INTO shop SET
						shop_owner_Id=:shop_owner_Id,
						shop_name=:shop_name,
						shop_permissions=:shop_permissions,
						shop_image=:shop_image,
						shop_userName=:shop_userName,
						shop_type=:shop_type,
						shop_privacy=:shop_privacy,
						shop_adres=:shop_adres,
						shop_gsm=:shop_gsm,
						shop_eposta=:shop_eposta
						");
    $insert = $kaydet->execute(array(
        'shop_owner_Id' => $_POST['user_id'],
        'shop_permissions' => json_encode($base_shop_permissions),
        'shop_name' => $_POST['shop_name'],
        'shop_image' => $base_url . '/assets/user-avatar.png',
        'shop_userName' => turkishToEnglish($_POST['shop_name']),
        'shop_type' => 0,
        'shop_privacy' => $_POST['shop_privacy'],
        'shop_adres' => $_POST['shop_adres'],
        'shop_gsm' => $_POST['shop_gsm'],
        'shop_eposta' => $_POST['shop_eposta']
    ));


    if ($insert) {
        $fetchExistedShopsor = $db->prepare("SELECT * FROM shop where 
        shop_owner_Id=:shop_owner_Id and
        shop_name=:shop_name ");
        $fetchExistedShopsor->execute(array(
            'shop_owner_Id' => $_POST['user_id'],
            'shop_name' => $_POST['shop_name']
        ));

        $say = $fetchExistedShopsor->rowCount();
        $fetchExistedShopCek = $fetchExistedShopsor->fetch(PDO::FETCH_ASSOC);


        $id = $fetchExistedShopCek['shop_id'];

        $token = "000$id-" . random_int(100000000, 999999999);
        $fetchExistedShopCek['shop_token'] = $token;

        $kaydet = $db->prepare("UPDATE shop SET
        shop_accessCode=:shop_accessCode, shop_apiKey=:shop_apiKey, shop_token=:shop_token
        WHERE shop_id=:shop_id");
        $update = $kaydet->execute(array(
            'shop_accessCode' => "000$id-" . random_int(100000000, 999999999),
            'shop_apiKey' => "000$id-" . random_int(100000000, 999999999),
            'shop_token' => $token,
            'shop_id' => $id
        ));

        if ($update) {

            $kaydet = $db->prepare("INSERT INTO shop_workers SET
						shop_workers_workerId=:shop_workers_workerId,
						shop_workers_permissonLevel=:shop_workers_permissonLevel,
						shop_id=:shop_id,
						worker_isApproved=:worker_isApproved
						");
            $insert = $kaydet->execute(array(
                'shop_workers_workerId' => $_POST['user_id'],
                'shop_workers_permissonLevel' => 5,
                'shop_id' => $id,
                'worker_isApproved' => 1
            ));

            $returns = array(
                'id' => 0,
                'shop' => $fetchExistedShopCek
            );
            print_r(json_encode($returns));
        } else {
            print_r(json_encode($error_basarisiz));
        }
    } else {

        print_r(json_encode($error_basarisiz));
    }
}

// Joining 

if (isset($_POST['shop_getAccessCode'])) {

    $fetchExistedShopsor = $db->prepare("SELECT shop_accessCode FROM shop where shop_token=:shop_token");
    $fetchExistedShopsor->execute(array(

        'shop_token' => $_POST['shop_token']
    ));

    $say = $fetchExistedShopsor->rowCount();
    $fetchExistedShopCek = $fetchExistedShopsor->fetch(PDO::FETCH_ASSOC);


    if ($fetchExistedShopCek) {
        $returns = array(
            'id' => 0,
            'shop_accessCode' => $fetchExistedShopCek['shop_accessCode']
        );
        print_r(json_encode($returns));
    } else {

        print_r(json_encode($error_basarisiz));
    }
}


if (isset($_POST['fetchExistedShop'])) {

    $fetchExistedShopsor = $db->prepare("SELECT shop_id, shop_name, shop_image, shop_desc, shop_type, shop_privacy, shop_permissions FROM shop where shop_accessCode=:shop_accessCode");
    $fetchExistedShopsor->execute(array(

        'shop_accessCode' => $_POST['shop_accessCode']
    ));

    $say = $fetchExistedShopsor->rowCount();
    $fetchExistedShopCek = $fetchExistedShopsor->fetch(PDO::FETCH_ASSOC);


    if ($fetchExistedShopCek) {
        $returns = array(
            'id' => 0,
            'shop' => $fetchExistedShopCek
        );
        print_r(json_encode($returns));
    } else {

        print_r(json_encode($error_basarisiz));
    }
}



if (isset($_POST['joinExistedShop'])) {

    $fetchExistedShopsor = $db->prepare("SELECT * FROM shop where shop_id=:shop_id");
    $fetchExistedShopsor->execute(array(

        'shop_id' => $_POST['shop_id']
    ));

    $say = $fetchExistedShopsor->rowCount();
    $fetchExistedShopCek = $fetchExistedShopsor->fetch(PDO::FETCH_ASSOC);


    if ($fetchExistedShopCek) {
        $fetchExistedShopWorkersor = $db->prepare("SELECT * FROM shop_workers where shop_workers_workerId=:shop_workers_workerId and shop_id=:shop_id");
        $fetchExistedShopWorkersor->execute(array(

            'shop_id' => $_POST['shop_id'],
            'shop_workers_workerId' => $_POST['user_id']
        ));

        $row_say = $fetchExistedShopWorkersor->rowCount();
        $fetchExistedShopWorkerCek = $fetchExistedShopWorkersor->fetch(PDO::FETCH_ASSOC);
        if ($row_say == 0) {
            if ($fetchExistedShopCek['shop_privacy'] == 1) {
                $count = 1;
            } else {
                $count = 0;
            }

            $kaydet = $db->prepare("INSERT INTO shop_workers SET
                            shop_workers_workerId=:shop_workers_workerId,
                            shop_workers_permissonLevel=:shop_workers_permissonLevel,
                            shop_id=:shop_id,
                            worker_isApproved=:worker_isApproved
                            ");
            $insert = $kaydet->execute(array(
                'shop_workers_workerId' => $_POST['user_id'],
                'shop_workers_permissonLevel' => 0,
                'shop_id' => $_POST['shop_id'],
                'worker_isApproved' => $count
            ));
            if ($insert) {
                if ($fetchExistedShopCek['shop_privacy'] == 1) {
                    $returns = array('id' => 0, 'token' => $fetchExistedShopCek['shop_token']);
                    print_r(json_encode($returns));
                } else {
                    $returns = array('id' => 0, 'exeption' => 'İşletmedeki yetkili kişilere giriş bilgileriniz gönderilmiştir. Onaylandığınız zaman email üzerinden mail ile bilgilendiriliceksiniz.');
                    print_r(json_encode($returns));
                }
            } else {
                # code...
                print_r(json_encode($error_basarisiz));
            }
        } else {
            $returns = array('id' => 0, 'exeption' => 'İşletmeye daha önceden kayıt için başvurmuş bulunmaktasınız. İşletmedeki yetkili kişilere giriş bilgileriniz gönderilmiştir. Onaylandığınız zaman email üzerinden mail ile bilgilendiriliceksiniz.');
            print_r(json_encode($returns));
        }
    } else {

        print_r(json_encode($error_basarisiz));
    }
}

if (isset($_POST['shop_changeUserPermission'])) {

    $kaydet = $db->prepare("UPDATE shop_workers SET
        shop_workers_permissonLevel=:shop_workers_permissonLevel
        WHERE shop_id=:shop_id and shop_workers_workerId=:shop_workers_workerId");
    $update = $kaydet->execute(array(

        'shop_id' => $_POST['shop_id'],
        'shop_workers_workerId' => $_POST['changed_userId'],
        'shop_workers_permissonLevel' => $_POST['permissionLevel']
    ));

    if ($update) {
        $returns = array(
            'id' => 0,
        );
        print_r(json_encode($returns));
    } else {
        print_r(json_encode($error_basarisiz));
    }
}

if (isset($_POST['shop_buyPackage'])) {

    $permissions = array();

    $shopCatagoriesSor = $db->prepare("SELECT shop_id, shop_permissions FROM shop where shop_token=:shop_token");
    $shopCatagoriesSor->execute(array(
        'shop_token' => $_POST['shop_token']
    ));
    $shopCatagoriesCek = $shopCatagoriesSor->fetch(PDO::FETCH_ASSOC);

    if ($shopCatagoriesCek) {
        $permissions = json_decode($shopCatagoriesCek['shop_permissions'], true); // true parametresi ile dizi olarak decode et

        if ($permissions != null) {

            $bought = explode(',', $_POST['packages']);

            foreach ($bought as $element) {

                switch ($element) {
                    case 'user_control':
                        $permissions['user_control']['shop_can_add_teammates'] = true;
                        $permissions['user_control']['shop_can_categorise_teammates'] = true;
                        $permissions['user_control']['refreshDate'] = $_POST['refreshDate'];
                        break;

                    case 'payout':
                        $permissions['payout']['shop_can_sell_products'] = true;
                        $permissions['payout']['shop_can_bill'] = true;
                        $permissions['payout']['refreshDate'] = $_POST['refreshDate'];
                        break;
                    case 'inventory_upgrade':
                        $permissions['inventory_upgrade']['shop_inventory_product_limit'] = -1;
                        $permissions['inventory_upgrade']['shop_can_categorise'] = true;
                        $permissions['inventory_upgrade']['shop_can_decrease_stock'] = true;
                        $permissions['inventory_upgrade']['shop_can_init_reminder'] = true;
                        $permissions['inventory_upgrade']['shop_can_initilize_place'] = true;
                        $permissions['inventory_upgrade']['shop_can_initilize_low_stok'] = true;
                        $permissions['inventory_upgrade']['shop_can_see_product_history'] = true;
                        $permissions['inventory_upgrade']['refreshDate'] = $_POST['refreshDate'];
                        break;
                    case 'analytics':
                        $permissions['analytics']['shop_can_see_analytics'] = true;
                        $permissions['analytics']['refreshDate'] = $_POST['refreshDate'];
                        break;
                    default:
                        # code...
                        break;
                }
            }
            $permissions['shop_show_ads'] = false;

            $kaydet = $db->prepare("UPDATE shop SET
            shop_permissions=:shop_permissions
            WHERE shop_id=:shop_id");
            $update = $kaydet->execute(array(
                'shop_permissions' => json_encode($permissions),
                'shop_id' => $shopCatagoriesCek['shop_id']
            ));

            if ($update) {
                $returns = array(
                    'id' => 0,
                    'bought' => $permissions
                );
                print_r(json_encode($returns));
            } else {
                # code...
                print_r(json_encode($error_basarisiz));
            }
        } else {
            print_r(json_encode($error_basarisiz));
        }
    } else {
        // Veritabanından gelen bir sonuç yoksa
        print_r(json_encode($error_basarisiz));
    }
}


/* if (isset($_POST['shop_buyPackage'])) {

    

    $permissions = array();

    $shopCatagoriesSor = $db->prepare("SELECT shop_id, shop_permissions FROM shop where shop_token=:shop_token");
    $shopCatagoriesSor->execute(array(
        'shop_token' => $_POST['shop_token']
    ));
    $shopCatagoriesCek = $shopCatagoriesSor->fetch(PDO::FETCH_ASSOC);

    $permissions = json_decode($shopCatagoriesCek['shop_permissions']);

        $bought = explode(',', $_POST['packages']);

    foreach ($bought as $element) {
        switch ($element) {
            case 1:
                $anan['user_control']['shop_can_add_teammates'] = true;
                $anan['user_control']['shop_can_categorise_teammates'] = true;
                break;

            case 2:
                $anan['payout']['shop_can_sell_products'] = true;
                $anan['payout']['shop_can_bill'] = true;
                break;
            case 3:
                $anan['inventory_upgrade']['shop_inventory_product_limit'] = -1;
                $anan['inventory_upgrade']['shop_can_categorise'] = true;
                $anan['inventory_upgrade']['shop_can_decrease_stock'] = true;
                $anan['inventory_upgrade']['shop_can_init_reminder'] = true;
                $anan['inventory_upgrade']['shop_can_initilize_place'] = true;
                $anan['inventory_upgrade']['shop_can_initilize_low_stok'] = true;
                $anan['inventory_upgrade']['shop_can_see_product_history'] = true;
                break;
            case 4:
                $anan['analytics']['shop_can_see_analytics'] = true;
                break;
            default:
                # code...
                break;
        }
    }

    


    if (true) {
        $returns = array(
            'id' => 0,

            'bought' => $permissions
        );
        print_r(json_encode($returns));
    } else {
        print_r(json_encode($error_basarisiz));
    }
}

 */


/* *********************  */
/* 
TODO Tables 
*/
/* ********************* */



if (isset($_POST['fetchShopTables'])) {

    $shop_workingAreas = $db->prepare("SELECT * FROM shop_workingAreas where shop_workingAreas_shopToken=:shop_workingAreas_shopToken");
    $shop_workingAreas->execute(array(

        'shop_workingAreas_shopToken' => $_POST['shop_token']
    ));

    $say = $shop_workingAreas->rowCount();
    $shop_workingAreasCek = $shop_workingAreas->fetchAll(PDO::FETCH_ASSOC);


    if ($shop_workingAreasCek) {

        $returns = array(
            'id' => 0,
            'tables' => $shop_workingAreasCek
        );
        print_r(json_encode($returns));
    } else {

        print_r(json_encode($error_basarisiz));
    }
}

/* ********************* */
/* 
TODO ADDİTİONS 
*/
/* ********************* */

if (isset($_POST['createNewAddition'])) {

    $shop_additions_confirmationNumber = bin2hex(random_bytes(16));
    $shop_additions_workingAreaTable = $_POST['shop_id'] . '-' . $_POST['shop_workingAreas_id'];
    /*  $newAddition = array();
    $shop_additions_content = json_encode($newAddition); */

    $shop_additions_content = file_get_contents('addition.json');
    $shop_additions_specialGuest = $_POST['shop_additions_specialGuest'] ?? -1;
    $shop_additions_openerUser = $_POST['shop_additions_openerUser'];

    $kaydet = $db->prepare("INSERT INTO shop_additions SET
						shop_additions_confirmationNumber=:shop_additions_confirmationNumber,
						shop_additions_workingAreaTable=:shop_additions_workingAreaTable,
						shop_additions_content=:shop_additions_content,
						shop_additions_specialGuest=:shop_additions_specialGuest,
						shop_additions_openerUser=:shop_additions_openerUser
						");
    $insert = $kaydet->execute(array(
        'shop_additions_confirmationNumber' => $shop_additions_confirmationNumber,
        'shop_additions_workingAreaTable' => $shop_additions_workingAreaTable,
        'shop_additions_content' => $shop_additions_content,
        'shop_additions_specialGuest' => $shop_additions_specialGuest,
        'shop_additions_openerUser' => $shop_additions_openerUser
    ));


    if ($insert) {

        $kaydet = $db->prepare("UPDATE shop_workingAreas SET
        shop_workingAreas_status=:shop_workingAreas_status
        WHERE shop_workingAreas_shopToken=:shop_id and shop_workingAreas_id=:shop_workingAreas_id");
        $update = $kaydet->execute(array(
            'shop_workingAreas_status' => 1,
            'shop_id' => $_POST['shop_id'],
            'shop_workingAreas_id' => $_POST['shop_workingAreas_id']
        ));

        if ($update) {
            $returns = array(
                'id' => 0,
                'table' => $shop_additions_confirmationNumber,
            );
            print_r(json_encode($returns));
        } else {
            print_r(json_encode($error_basarisiz));
        }
    } else {

        print_r(json_encode($error_basarisiz));
    }
}


if (isset($_POST['additionByTable'])) {
    $workerSor = $db->prepare("SELECT shop_additions_confirmationNumber, shop_additions_content, shop_addition_timestamp, shop_additions_specialGuest, shop_additions_openerUser FROM shop_additions where shop_additions_workingAreaTable=:shop_additions_workingAreaTable and shop_additions_isPayed=:shop_additions_isPayed ORDER BY shop_additions_id DESC");
    $workerSor->execute(array(
        'shop_additions_workingAreaTable' => $_POST['shop_additions_workingAreaTable'],
        'shop_additions_isPayed' => $_POST['shop_additions_isPayed']
    ));
    $workerCek = $workerSor->fetch(PDO::FETCH_ASSOC);
    if ($workerCek) {
        # code...
        $returns = array(
            'id' => 0,
            'addition' => [
                'shop_additions_confirmationNumber' => $workerCek['shop_additions_confirmationNumber'],
                'shop_additions_content' => json_decode($workerCek['shop_additions_content']),
                'shop_addition_timestamp' => $workerCek['shop_addition_timestamp'],
                'shop_additions_specialGuest' => $workerCek['shop_additions_specialGuest'],
                'shop_additions_openerUser' => $workerCek['shop_additions_openerUser']
            ]
        );
        print_r(json_encode($returns));
    } else {

        print_r(json_encode($error_basarisiz));
    }
}

/* ********************* */
/* 
TODO CATEGORİES 

*/
/* ********************* */


if (isset($_POST['addNewCategorywithToken'])) {

    $shopCatagoriesSor = $db->prepare("SELECT shop_id, shop_categories, shop_token FROM shop where shop_token=:shop_token");
    $shopCatagoriesSor->execute(array(
        'shop_token' => $_POST['shop_token']
    ));
    $shopCatagoriesCek = $shopCatagoriesSor->fetch(PDO::FETCH_ASSOC);

    $anan = json_decode($shopCatagoriesCek['shop_categories']);

    array_push($anan, json_decode($_POST['categories']));


    $kaydet = $db->prepare("UPDATE shop SET
        shop_categories=:shop_categories
        WHERE shop_id=:shop_id");
    $update = $kaydet->execute(array(

        'shop_id' => $shopCatagoriesCek['shop_id'],
        'shop_categories' => json_encode($anan)
    ));

    if ($update) {
        $returns = array(
            'id' => 0,
            'table' => $anan,
        );
        print_r(json_encode($returns));
    } else {
        print_r(json_encode($error_basarisiz));
    }
}

if (isset($_POST['deleteCategorywithToken'])) {

    $shopCatagoriesSor = $db->prepare("SELECT shop_id, shop_categories, shop_token, shop_products FROM shop where shop_token=:shop_token");
    $shopCatagoriesSor->execute(array(
        'shop_token' => $_POST['shop_token']
    ));
    $shopCatagoriesCek = $shopCatagoriesSor->fetch(PDO::FETCH_ASSOC);

    $shop_products = json_decode($shopCatagoriesCek['shop_products'], true);
    $anan = json_decode($shopCatagoriesCek['shop_categories'], true);
    if (isset($_POST['categories'])) {
        $arrayOfCategory = array();
        $arrayOfCategory = json_decode($_POST['categories'], true);


        foreach ($shop_products as $key => $item) {
            if ($item['categories']['name'] == $arrayOfCategory['name'] && $item['categories']['menuTypeId'] == $arrayOfCategory['menuTypeId']) {
                unset($shop_products[$key]['categories']);
            }
        }


        foreach ($anan as $key => $item) {
            if ($item['name'] == $arrayOfCategory['name'] && $item['menuTypeId'] == $arrayOfCategory['menuTypeId']) {
                unset($anan[$key]);
                break;
            }
        }
    }
    $anan = array_values($anan);
    $pressed = json_encode($anan);

    $kaydet = $db->prepare("UPDATE shop SET
        shop_categories=:shop_categories, shop_products=:shop_products
        WHERE shop_id=:shop_id");
    $update = $kaydet->execute(array(

        'shop_id' => $shopCatagoriesCek['shop_id'],
        'shop_categories' => $pressed,
        'shop_products' => json_encode($shop_products)
    ));

    if ($update) {
        $returns = array(
            'id' => 0,
            'shop_categories' => json_encode($anan)
        );
        print_r(json_encode($returns));
    } else {
        print_r(json_encode($error_basarisiz));
    }
}


/* ********************* */
/* 

TODO PRODUCTS 

    ⁡⁣⁣⁢Update
    Delete
    ⁡⁣⁣⁢Fetch⁡

    
*/
/* ********************* */



if (isset($_POST['createProduct'])) {

    $workerSor = $db->prepare("SELECT shop_id, shop_products FROM shop where shop_token=:shop_token ORDER BY shop_id DESC");
    $workerSor->execute(array(
        'shop_token' => $_POST['shop_token']
    ));
    $workerCek = $workerSor->fetch(PDO::FETCH_ASSOC);
    $products = json_decode($workerCek['shop_products']);

    $imgArrays = array();


    if ($_FILES['images'] != null) {
        $uploads_dir = './products/';
        $error = 0;
        for ($i = 0; $i < count($_FILES['images']['name']); $i++) {
            @$tmp_name = $_FILES['images']["tmp_name"][$i];
            @$name = $_FILES['images']["name"][$i];

            $benzersizsayi1 = rand(20000, 32000);

            $benzersizad = "{$_POST['shop_token']}-" . $benzersizsayi1;
            $refimgyol = $base_url . substr($uploads_dir, 1) . $benzersizad . $name;
            @move_uploaded_file($tmp_name, "$uploads_dir/$benzersizad$name");
            array_push($imgArrays, $refimgyol);
        }
    }

    $json = $_POST['product'];


    $json['images'] = $imgArrays;
    $json['user'] = $_POST['user'];

    array_push($products, $json);

    /*  print_r(json_encode($json)); */



    $kaydet = $db->prepare("UPDATE shop SET
        shop_products=:shop_products
        WHERE shop_id=:shop_id");
    $update = $kaydet->execute(array(

        'shop_id' => $workerCek['shop_id'],
        'shop_products' => json_encode($products)
    ));

    if ($update) {
        $returns = array(
            'id' => 0,
            'product' => json_encode($json),
        );
        print_r(json_encode($returns));
    } else {
        print_r(json_encode($error_basarisiz));
    }
}





if (isset($_POST['createNewProduct'])) {

    $workerSor = $db->prepare("SELECT shop_id, shop_products FROM shop where shop_token=:shop_token ORDER BY shop_id DESC");
    $workerSor->execute(array(
        'shop_token' => $_POST['shop_token']
    ));
    $workerCek = $workerSor->fetch(PDO::FETCH_ASSOC);
    $products = json_decode($workerCek['shop_products']);

    $imgArrays = array();


    if ($_FILES['images'] != null) {
        $uploads_dir = './products/';
        $error = 0;
        for ($i = 0; $i < count($_FILES['images']['name']); $i++) {
            @$tmp_name = $_FILES['images']["tmp_name"][$i];
            @$name = $_FILES['images']["name"][$i];

            $benzersizsayi1 = rand(20000, 32000);

            $benzersizad = "{$_POST['shop_token']}-" . $benzersizsayi1;
            $refimgyol = $base_url . substr($uploads_dir, 1) . $benzersizad . $name;
            @move_uploaded_file($tmp_name, "$uploads_dir/$benzersizad$name");
            array_push($imgArrays, $refimgyol);
        }
    }

    $json = $_POST['product_meta'];


    $json['images'] = $imgArrays;

    array_push($products, $json);

    /*  print_r(json_encode($products)); */



    $kaydet = $db->prepare("UPDATE shop SET
        shop_products=:shop_products
        WHERE shop_token=:shop_token");
    $update = $kaydet->execute(array(

        'shop_token' => $_POST['shop_token'],
        'shop_products' => json_encode($products)
    ));

    if ($update) {
        $returns = array(
            'id' => 0,
            'message' => 'Yeni Ürün Kaydınız Tamamlanmıştır.',
        );
        print_r(json_encode($returns));
    } else {
        print_r(json_encode($error_basarisiz));
    }
}


if (isset($_POST['fetchProductList'])) {

    $workerSor = $db->prepare("SELECT shop_id, shop_products FROM shop where shop_token=:shop_token ORDER BY shop_id DESC");
    $workerSor->execute(array(
        'shop_token' => $_POST['shop_token']
    ));
    $workerCek = $workerSor->fetch(PDO::FETCH_ASSOC);

    $returns = [
        'id' => 0,
        'products' => json_decode($workerCek['shop_products'])
    ];

    print_r(json_encode($returns));
}


/* if ($_GET['fetchPlatforms'] == "ok") {
    $platformsor = $db->prepare("SELECT * FROM platforms where platform_isAvaliable=:platform_isAvaliable");
    $platformsor->execute(array(

        'platform_isAvaliable' => 1
    ));
    $platformcek = $platformsor->fetchAll(PDO::FETCH_ASSOC);

    print_r(json_encode($platformcek));
} */


/* 
if ($_GET['getUsersProducts'] == "ok") {

  $trendyol = new TrendyolClient();
  $trendyol->setSupplierId(597415);
  $trendyol->setUsername("6O8h2aIzszfEXJPGiwNv");
  $trendyol->setPassword("ddL2HZnx9Kq64ejai3fS");

  $returns = $trendyol->product->filterProducts(
    getBrandArrayQuery($_GET)
  );
  print_r(json_encode($returns));
}


if ($_GET['getBrandsList'] == "ok") {

  $trendyol = new TrendyolClient();
  $trendyol->setSupplierId(597415);
  $trendyol->setUsername("6O8h2aIzszfEXJPGiwNv");
  $trendyol->setPassword("ddL2HZnx9Kq64ejai3fS");

  $returns = $trendyol->brand->getBrandByName($_GET['brandName']);
  print_r(json_encode($returns));
}


if ($_GET['getOrderList'] == "ok") {

  $trendyol = new TrendyolClient();
  $trendyol->setSupplierId(597415);
  $trendyol->setUsername("6O8h2aIzszfEXJPGiwNv");
  $trendyol->setPassword("ddL2HZnx9Kq64ejai3fS");

  $returns = $trendyol->order->orderList(
    getOrderArrayQuery($_GET)
  );
  print_r(json_encode($returns));
}

if ($_GET['getCategoryAttributes'] == "ok") {

  $trendyol = new TrendyolClient();
  $trendyol->setSupplierId(597415);
  $trendyol->setUsername("6O8h2aIzszfEXJPGiwNv");
  $trendyol->setPassword("ddL2HZnx9Kq64ejai3fS");

  $returns = $trendyol->category->getCategoryAttributes($_GET['categoryId']);
  print_r(json_encode($returns));
}

if (isset($_POST['showPOST'])) {
  print_r(json_encode($_POST));
}





if (isset($_POST['createNewProduct'])) {
  print_r(json_encode($_POST['json_array']));
}


function setTrendyolApi($id, $db): TrendyolClient
{

  $platformsor = $db->prepare("SELECT * FROM kullanici_platformKeys where kullanici_platformTokens_userId=:kullanici_platformTokens_userId and kullanici_platformTokens_platformId=:kullanici_platformTokens_platformId");
  $platformsor->execute(array(

    'kullanici_platformTokens_userId' => $id,
    'kullanici_platformTokens_platformId' => 2
  ));
  $platformcek = $platformsor->fetch(PDO::FETCH_ASSOC);

  $trendyol = new TrendyolClient();
  $trendyol->setSupplierId($platformcek['kullanici_platformTokens_supplierId']);
  $trendyol->setUsername($platformcek['kullanici_platformTokens_supplierId']);
  $trendyol->setPassword("ddL2HZnx9Kq64ejai3fS");


  return $trendyol;
}
 */


function getBrandArrayQuery($get)
{
    $parameters = array();

    if (isset($get['approved'])) {
        $parameters['approved'] = $get['approved'];
    }

    if (isset($get['barcode'])) {
        $parameters['barcode'] = $get['barcode'];
    }

    if (isset($get['startDate'])) {
        $parameters['startDate'] = $get['startDate'];
    }

    if (isset($get['endDate'])) {
        $parameters['endDate'] = $get['endDate'];
    }

    if (isset($get['page'])) {
        $parameters['page'] = $get['page'];
    }

    if (isset($get['dateQueryType'])) {
        $parameters['dateQueryType'] = $get['dateQueryType'];
    }

    if (isset($get['size'])) {
        $parameters['size'] = $get['size'];
    }

    return $parameters;
}

function getOrderArrayQuery($get)
{
    $parameters = array();

    if (isset($get['startDate'])) {
        $parameters['startDate'] = $get['startDate'];
    }

    if (isset($_GET['endDate'])) {
        $parameters['endDate'] = $get['endDate'];
    }

    if (isset($get['page'])) {
        $parameters['page'] = $get['page'];
    }

    if (isset($_GET['size'])) {
        $parameters['size'] = $get['size'];
    }

    if (isset($get['orderNumber'])) {
        $parameters['orderNumber'] = $get['orderNumber'];
    }

    if (isset($get['status'])) {
        $parameters['status'] = $get['status'];
    }

    if (isset($get['orderByField'])) {
        $parameters['orderByField'] = $get['orderByField'];
    }

    if (isset($get['orderByDirection'])) {
        $parameters['orderByDirection'] = $get['orderByDirection'];
    }

    if (isset($get['shipmentPackagesId'])) {
        $parameters['shipmentPackagesId'] = $get['shipmentPackagesId'];
    }
    return $parameters;
}
