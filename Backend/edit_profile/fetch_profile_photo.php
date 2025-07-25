<?php 

include('../db.php');
include('../fetch_conn.php');
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$data = array();

$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if ( !$user_id) {
    echo json_encode(["error" => "Missing user_id "]);
    exit();
}

$sql = "SELECT profile_image FROM user_details WHERE user_id = '$user_id'";
$result = mysqli_query($conn, $sql);

$base_url = "$base_path/images/profile_image/";

if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    
    $image_file = $row["profile_image"];
    
    // ✅ Handle empty profile images (Return a default image)
    if (empty($image_file)) {
        $response["photo_url"] = $base_url . "default.png"; // Use a default image
    } else {
        $response["photo_url"] = $base_url . $image_file;
    }
} else {
    $response["error"] = "No profile image found";
}

echo json_encode($response);
?>