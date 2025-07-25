<?php 
include('../db.php');



    $transportation_id = $_POST["transportation_id"];
// $data = array();
$sql = "DELETE FROM transport_details WHERE `transport_details`.`transportation_id` = '$transportation_id'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => "Transportation Deleted successfully!"]);
} else {
    echo json_encode(["error" => "Failed to Delete Transportation"]);
}

mysqli_close($conn); 
?>