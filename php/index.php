<?php
// require 'video1.php';
// require_once 'video1.php'; revisa si ya se ha incluido el archivo, si es asi no lo vuelve a incluir
// require_once 'archivo_que_no_existe.php'; si el archivo no existe, no se ejecuta el script, se ejecuta un warning y luego un fatal error
// include 'video1.php'; si el archivo no existe, se ejecuta el script y ejecuta un warning solamente
// include_once 'video1.php'; revisa si ya se ha incluido el archivo, si es asi no lo vuelve a incluir
//Video2------------------------------------------------
require_once 'consts.php';
require_once 'functions.php';
?>

<?php render_template('head')?>
<?php render_template('dog_facts') ;?>
<?php render_template('dog_photos') ;?>