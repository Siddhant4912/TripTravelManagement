<?php 
include('../db.php');

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$trip_id = $_GET['trip_id'];

if (empty($trip_id)) {
    echo json_encode(["error" => "Trip ID is required"]);
    exit();
}


// $trip_id = $_POST['trip_id'];
$data = array(); 
$sql = "SELECT accommodation_id , hotel_name, checkin_checkout_date, add_note FROM `accommodation` WHERE trip_id = '$trip_id' ORDER BY accommodation.accommodation_id DESC";
$result = mysqli_query($conn, $sql);

if (!$result) {
    echo json_encode(["error" => "Database query failed"]);
    exit();
}

while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode($data);
?>
