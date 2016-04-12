<?php
    $name = $_REQUEST['name'];
    $uoid = $_REQUEST['uoid'];
    $phone = $_REQUEST['phone'];
    $pickup = $_REQUEST['pickup'];
    $dropoff = $_REQUEST['dropoff'];
    $riders = $_REQUEST['riders'];
    $pickupTime = $_REQUEST['pickuptime'];

    $connection = new MongoClient("mongodb://<USERNAME>:<PASSWORD>@ds061375.mlab.com:61375/saferide");
    $db = $m->meteor;
    $collection = $db->pending;

    $document = array(
      "name" => $name,
      "uoid" => $uoid,
      "phone" => $phone,
      "pickup" => $pickup,
      "dropoff" => $dropoff,
      "riders" => $riders,
      "pickupTime" => $pickupTime
    );

    $collection->insert($document);
    echo "Successfully added iOS pending request";
?>
