<?php 

include('../db.php');
include('../fetch_conn.php');
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$data = array();

$trip_id = isset($_GET['trip_id']) ? $_GET['trip_id'] : null;

if ( !$trip_id) {
    echo json_encode(["error" => "Missing trip_id "]);
    exit();
}

$sql = "SELECT trip_banner FROM trip_details WHERE trip_id = '$trip_id'";
$result = mysqli_query($conn, $sql);

$base_url = "$base_path/images/trip_banner/";

if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    
    $image_file = $row["trip_banner"];
    
    // ✅ Handle empty profile images (Return a default image)
    if (empty($image_file)) {
        $response["photo_url"] = $base_url . $image_file; // Use a default image
    } else {
        $response["photo_url"] = $base_url . $image_file;
    }
} else {
    $response["error"] = "No profile image found";
}

echo json_encode($response);
?>