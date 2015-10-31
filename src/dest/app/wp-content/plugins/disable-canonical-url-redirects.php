<?php
/*
Plugin Name: Disable Canonical URL Redirects
Plugin URI: http://www.ImagineThought.com/
Description: Disables the "Canonical URL Redirect" feature of WordPress (in versions of Wordpress 2.3 and greater). To use this plugin, simply activate it. Then, disable this if you need to re-enable the "Canonical URL Redirect" feature of WordPress.  
Version: 1.0.11.0228
Author: Geoffrey Griffith
Author URI: http://www.ImagineThought.com/
License: GPL

*/

remove_filter('template_redirect', 'redirect_canonical');

?>