<?php 
include('../db.php');


    $paid_category = $_POST['paid_category'];   
    $how_much_paid = $_POST['how_much_paid'];
    $when_was_it_paid = $_POST['when_was_it_paid'];
    $expenses_id = $_POST["expenses_id"];
// $data = array();
$sql = "UPDATE trip_expenses SET 
        paid_category = '$paid_category', 
        how_much_paid = '$how_much_paid', 
        when_was_it_paid = '$when_was_it_paid' 
        WHERE expenses_id = '$expenses_id'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => "Expense updated successfully"]);
} else {
    echo json_encode(["error" => "Failed to update expense"]);
}

mysqli_close($conn);

?>