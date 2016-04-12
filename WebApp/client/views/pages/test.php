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

    // Echo back to client
    echo "Your request has been received.";
    echo "You will receive a confirmation text once your request has been processed."
    echo "";
    echo "Please note that SafeRide staff are only able to process requests Sun-Thu: 7pm-12am and Fri-Sat: 7pm-2am.";
    echo "Questions? Call 541-346-7433 ex. 2 during the above hours of operation.";
?>
