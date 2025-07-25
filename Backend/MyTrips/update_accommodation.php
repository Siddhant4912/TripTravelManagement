<?php 
include('../db.php');


    $hotel_name = $_POST['hotel_name'];   
    $checkin_checkout_date = $_POST['checkin_checkout_date'];
    $add_note = $_POST['add_note'];
    $accommodation_id = $_POST["accommodation_id"];
// $data = array();
$sql = "UPDATE accommodation SET 
        hotel_name = '$hotel_name', 
        checkin_checkout_date = '$checkin_checkout_date', 
        add_note = '$add_note' 
        WHERE accommodation_id = '$accommodation_id'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => "Accommodation updated successfully"]);
} else {
    echo json_encode(["error" => "Failed to update Accommodation"]);
}

mysqli_close($conn);

?>