<?php 
include('../db.php');



    $trip_id = $_POST["trip_id"];
// $data = array();
$sql = "DELETE FROM trip_details WHERE `trip_details`.`trip_id` = '$trip_id'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => "Expense Deleted successfully"]);
} else {
    echo json_encode(["error" => "Failed to Delete expense"]);
}

mysqli_close($conn); 
?>