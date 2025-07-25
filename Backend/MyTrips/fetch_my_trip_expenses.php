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
$sql = "SELECT expenses_id, paid_category, how_much_paid, when_was_it_paid FROM `trip_expenses` WHERE trip_id = '$trip_id' ORDER BY trip_expenses.expenses_id DESC";
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
