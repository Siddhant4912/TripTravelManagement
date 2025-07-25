<?php 
include('../db.php');



    $accommodation_id = $_POST["accommodation_id"];
$data = array();
$sql = "DELETE FROM accommodation WHERE `accommodation`.`accommodation_id` = '$accommodation_id'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => "Accomodation Deleted successfully"]);
} else {
    echo json_encode(["error" => "Failed to Delete Accommodation"]);
}

mysqli_close($conn); 
?>