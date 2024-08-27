<?php
declare(strict_types=1); //para que php sea mas estricto con los tipos de datos
class SuperHero
{
//Propiedades y metodos
    public $name;
    public $powers;
    public $planet;
    public $level;
    public function __construct($name, $powers, $planet)
    {
        $this->name = $name;
        $this->powers = $powers;
        $this->planet = $planet;
    }

    public function attack()
    {
        return "$this->name ataca con sus poderes!";
    }

    public function description()
    {
        return "$this->name es un superheroe que viene de $this->planet y tiene los siguientes poderes: $this->powers";
    }

}

$hero = new SuperHero("superman", "superfuerza y rayos laser", "Krypton");
echo $hero->description();


//Nueva forma de declarar clases -> promoted properties y es desde php 8

class SuperHero2
{
    public function __construct(
        public string $name, //podemos declarar onlyread antes de public para que no se pueda modificar y para esto se debe definir el tipo en la declaracion
        private array $powers, // Tambien podemos definir que los atributos sean privados, protected o publicos
        public string $planet
    )
    {
    }

    public function attack()
    {
        return "$this->name ataca con sus poderes!";
    }

    public function description()
    {
        return "$this->name es un superheroe que viene de $this->planet y tiene los siguientes poderes: $this->powers";
    }

    public function show_all()
    { //recupera todas las propiedades de la clase
        return get_object_vars($this);
    }

    public static function random(){
        $names = ["superman", "batman", "spiderman"];
        $powers = [["superfuerza", "rayos laser", "sentido aracnido"],
                    ["superfuerza", "rayos laser", "sentido aracnido"],
                    ["superfuerza", "rayos laser", "sentido aracnido"],
                    ["superfuerza", "rayos laser", "sentido aracnido"]
        ];
        $planets = ["Krypton", "Gotham", "Tierra"];
        $name = $names[array_rand($names)]; //array_rand devuelve un indice aleatorio de un array
        $power = $powers[array_rand($powers)];
        $planet= $planets[array_rand($planets)];
        //echo "El superheroe elegido es $name, que viene de $planets y tiene los siguientes poderes: . implode(", ", $power)";
        return new self($name, $power, $planet); //generamos un heroe aleatorio con los datos aleatorios generadando una instancia propia de la clase
    }
}

$hero = new SuperHero2("superman", ["superfuerza", "rayos laser"], "Krypton");
echo $hero->description(); //Metodo publico
superhero2::random(); //de esta forma se llama a un metodo estatico