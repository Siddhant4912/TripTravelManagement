<?php 
include('../db.php');

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$trip_id = $_GET['trip_id'];

if (empty($trip_id)) {
    echo json_encode(["error" => "Trip ID is required"]);
    exit();
}

$data = array(); 
$sql = "SELECT transportation_id, start_from, destination, travel_date, transportation_category 
FROM transport_details 
WHERE trip_id = '$trip_id' ORDER BY transport_details.transportation_id DESC";

$result = mysqli_query($conn, $sql);

if (!$result) {
    echo json_encode(["error" => "Database query failed"]);
    exit();
}

while ($row = mysqli_fetch_assoc($result)) {
    $data[] = array(
        "transportation_id" => $row['transportation_id'],
        "start_from" => $row['start_from'],
        "destination" => $row['destination'],
        "travel_date" => $row['travel_date'],
        "category" => $row['transportation_category']
    );
}

echo json_encode($data);
?>
