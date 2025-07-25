<?php 
include('../db.php');



    $expenses_id = $_POST["expenses_id"];
// $data = array();
$sql = "DELETE FROM trip_expenses WHERE `trip_expenses`.`expenses_id` = '$expenses_id'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => "Expense Deleted successfully"]);
} else {
    echo json_encode(["error" => "Failed to Delete expense"]);
}

mysqli_close($conn); 
?>