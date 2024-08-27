<?php
$imageData = base64_encode(file_get_contents(DOG_IMAGE_APIURL)); //las constantes van sin el $ para invocarlas
?>

<center>
    <div class="md:5/12 lg:w-1/2">
    <?php echo '<img class="rounded-3xl" src="data:image/jpeg;base64,'.$imageData.'"'?> alt="image" loading="lazy"/>
    <!-- <img class="rounded-3xl" src="<?php //echo DOG_IMAGE_APIURL; ?>" alt="image" loading="lazy"/> Manera facil-->
    </div>
</center>