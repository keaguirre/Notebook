<?php
$dog_fact = get_data(DOG_FACTS_APIURL);
extract($dog_fact); //extract extrae todas las variables de un array asociativo
?>
<h2 class="text-3xl text-center font-bold text-gray-900 md:text-4xl">
    <?php echo $dog_fact["facts"][0]; ?>
</h2>