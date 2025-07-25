<?php 
include('../db.php');

$start_from = $_POST['start_from'];   
$destination = $_POST['destination'];
$travel_date = $_POST['travel_date'];
$transportation_category = $_POST["transportation_category"];
$transportation_id = $_POST["transportation_id"];

$sql = "UPDATE transport_details SET 
        start_from = '$start_from', 
        destination = '$destination', 
        travel_date = '$travel_date', 
        transportation_category = '$transportation_category' 
        WHERE transportation_id = '$transportation_id'";

// Log error if query fails
if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "Transportation updated successfully"]);
} else {
    echo json_encode([
        "status" => "Failed to update transportation", 
        "error" => mysqli_error($conn)  // 👈 this is what we need to see
    ]);
}

mysqli_close($conn);
?>
