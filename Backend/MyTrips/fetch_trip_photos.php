<?php 

include('../db.php');
include('../fetch_conn.php');
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$data = array();

// Change this to dynamically fetch user_id and trip_id if needed

$trip_id = $_GET['trip_id'];
// $trip_id = '1';

$sql = "SELECT trip_photo FROM trip_photos WHERE  trip_id = '$trip_id' ORDER BY trip_photos.trip_photo_id DESC";
$result = mysqli_query($conn, $sql);

$base_url = "$base_path/images/"; // Change this to your actual server path

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        // Append the image filename to the base URL
        $data[] = $base_url . $row["trip_photo"];
    }
}

echo json_encode($data);
?>
