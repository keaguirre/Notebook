<?php
declare (strict_types=1);
function get_data(string $url) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $result = curl_exec($ch);
    curl_close($ch);
    return json_decode($result, true);
}

function render_template (string $template, array $data = []) { //Se le pasa un array con los datos que pueda necesitar para renderizar
    //Con esto ya puedo acceder desde el template que seleccione a las variables que estan en el array asociativo $data
    require "templates/$template.php";
    //Ejecuta un warning debido a que el require se ejecuta dentro de una funcion y no reconoce los scope globales
}
?>
