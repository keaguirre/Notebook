# PHP CheatSheet
```shell 
sudo apt-get install php-curl #para que no lance errores con curl en php en debian
```
para que no lance errores con curl en php en debian
```php 
php -S localhost:8000  #para levantar el local server
```
# Main
```php
define('CONSTANTE_GLOBAL', 'valor'); //Constante global fija
const CONSTANTE_LOCAL = 'value'; //No funcionan en tiempo de ejecucion, no puedes tener constantes dentro de un bucle PARA QUE SEAN DINAMICAS, para esos usos hay variables

if ($age >= 18) {
    echo "Eres mayor de edad";
} else if ($age >= 13) { //el else if funciona tanto junto como separado, pero solo permite junto cuanto se ocupa a modo plantilla
    echo "Eres un adolescente";
} else {
    echo "Eres menor de edad";
}

$isOld = true;

//sintaxis if a modo plantillas
<?php if ($isOld): ?>
    <h2> Eres viejo, lo siento</h2>
<?php elseif ($isDev): ?> //en esta sintaxis para insertar code, solo permite que el elseif sea solamente junto
    <h2> No eres viejo, pero eres dev. </h2>
<?php else: ?>
    <h2> Eres joven, feticidades </h2>
<?php endif; ?>
<?php
$age = 18;
$name = "pope";
$outputAge = match (true){
    $age > 2 => "$name, eres un bebé",
    $age > 10 => "$name, eres un niño",
    $age > 18 => "$name, eres un adolescente",
    $age === 18 => "$name, eres un adulto joven",
    $age > 40 => "$name, eres un adulto viejo",
    default => "$name, Eres un anciano"
}
//Arrays
$bestLanguages = [ "PHP", "JavaScript ", "Python"];
$bestLanguages[] = "Java"; //Asignar un valor de esta manera se inserta al final del array
$bestLanguages[] = "TypeScript" ;
?>
//For Each
<ul>
    <?php> foreach ($bestLanguages as $key => $language): ?> //$key es el indice y $language es el iterador
        <li><?= $key . " " . $language ?></li> //Texto concatenado: <?= para indicar que habra interpretacion de variables, . para concatenar
    <?php endforeach; ?>
</ul>
<?php
//Arrays como diccionarios o submap, estos son arrays asociativos
$person = [
    "name" => "Kevin",
    "age" => "26",
    "isOld" => true,
    "languages" => ["PHP", "JS", "Python"],
]
//Asignacion
$person["name"] = "pope";
$person["languages"][] = "Java";

$result = file_get_contents(API_URL); //si solo quieres hacer un get de una api
?>

// Estructura base de una funcion
<?php
function get_data($url){
    $result = file_get_contents($url);
    $data = json_decode($result, true);
    return $data;
}
```
> [!IMPORTANT]
> los tipos en php son opcionales y se deben activar para definir los tipos estrictos es con 
> declare (strict_types=1); // y habilita el tipado solo en este archivo y debe setearse arriba al inicio del archivo

```php
function get_data(string $url): string{ //se puede definir el tipo del dato de retorno con :tipo_dato 
    $result = file_get_contents($url);
    $data = json_decode($result, true);
    return $data;
}
$data = get_data(321312) //esta 'cadena' de numeros la convierte en un string "321312" si no esta el tipado fuerte activado
?>

```
- Las variables tienen scope global y local
- las variables globales no son accesibles en el scope de una funcion a menos que se pase emediante parametros o a menos que se especifique usando:
```php
global $global_var;
```

### Fusion de arrays
```php
array_merge($array1, $array2); //para unir dos arrays
array_merge($data, ["new_key" => "new_value"]); //para agregar un nuevo valor a un array
array_merge($data, ["new_key" => $new_value]); //para agregar un nuevo valor a un array
```
- Pasar solo un dato del array data:
```php
["title" => $data["title"]]
```
- En este caso, ```php ["title" => $data["title"]]``` está creando un nuevo array con una única entrada. La clave de esta entrada es "title", y el valor es $data["title"].

- ```implode()``` une los elementos de un array en un string implode("separador como por ej ,", $array)
- ```join()``` es un alias de implode()
- ```var_dump($hero->show_all());``` var_dump() es una función de depuración que se utiliza para imprimir información detallada sobre una variable.
- get_object_vars() es una función que se utiliza para obtener las propiedades públicas de un objeto dado como un array asociativo.
- En resumen, ```var_dump()``` es una herramienta de depuración más general que puede manejar todo tipo de variables y proporciona información detallada sobre el tipo de datos, mientras que ```get_object_vars()``` es una función específica para objetos que devuelve las propiedades públicas de un objeto como un array asociativo.
