<?php

namespace classes;

class dogFact
{
    public function __construct(
        private string  $fact,
    ) {}

    public static function get_fact_obj()
    {
        $dog_fact = get_data(DOG_FACTS_APIURL)["facts"][0] ?? "No se pudo obtener el dato";
        //return get_data(DOG_FACTS_APIURL)["facts"][0]->fact;
        return new self ($dog_fact);
    }
}