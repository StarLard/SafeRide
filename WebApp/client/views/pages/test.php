<?php
    echo " Response From Server Side";
    echo "Username : " . $_REQUEST['username'];
    echo "Password : " . $_REQUEST['password'];

    $connection = new MongoClient("mongodb://<USERNAME>:<PASSWORD>@ds061375.mlab.com:61375/saferide");
    $db = $m->meteor;
    $collection = $db->pending;

    $document = array(
      "name" => "<NAME>",
      "uoid" => "<UOID>",
      "phone" => "<PHONE>",
      "pickup" => "<PICKUP>",
      "dropoff" => "<DROPOFF>",
      "riders" => "<RIDERS>",
      "pickupTime" => "<PICKUPTIME>"
    );

    $collection->insert($document);
?>
