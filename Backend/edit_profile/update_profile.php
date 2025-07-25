<?php
include("../db.php");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

// Read POST data
$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : null;
$first_name = isset($_POST['first_name']) ? $_POST['first_name'] : null;
$last_name = isset($_POST['last_name']) ? $_POST['last_name'] : null;
$gender = isset($_POST['gender']) ? $_POST['gender'] : null;
$dob = isset($_POST['dob']) ? $_POST['dob'] : null;

if (!$user_id || !$first_name || !$last_name || !$gender || !$dob) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit();
}

// Update user details
$sql = "UPDATE user_details SET 
    first_name = '$first_name', 
    last_name = '$last_name', 
    gender = '$gender', 
    dob = '$dob' 
    WHERE user_id = '$user_id'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "success", "message" => "User Details updated successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Database update failed: " . mysqli_error($conn)]);
}

mysqli_close($conn);
?>
