<?php 
$app = "wordpress";
$appname = "WordPress";
$appversion = "4.4";
$appsite = "https://wordpress.org/";
$apphelp = "https://wordpress.org/support/";

$applogs = array("/tmp/DroboApps/".$app."/log.txt",
                 "/tmp/DroboApps/".$app."/access.log",
                 "/tmp/DroboApps/".$app."/error.log",
                 "/tmp/DroboApps/".$app."/install.log",
                 "/tmp/DroboApps/".$app."/update.log");

$appprotos = array("http");
$appports = array("8030");
$droboip = $_SERVER['SERVER_ADDR'];
$apppage = $appprotos[0]."://".$droboip.":".$appports[0]."/";
if ($publicip != "") {
  $publicurl = $appprotos[0]."://".$publicip.":".$appports[0]."/";
} else {
  $publicurl = $appprotos[0]."://public.ip.address.here:".$appports[0]."/";
}
$portscansite = "http://mxtoolbox.com/SuperTool.aspx?action=scan%3a".$publicip."&run=toolpage";
?>
