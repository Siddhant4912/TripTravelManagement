<?php 
include('../db.php');

$data = array();
$sql = "SELECT * FROM trip_details INNER JOIN user_details ON trip_details.user_id = user_details.user_id ORDER BY trip_details.trip_id DESC";
$result = mysqli_query($conn, $sql);
if (mysqli_num_rows($result) > 0) {
	foreach ($result as $row) {
		$data[] = $row;
	}
}

echo json_encode($data);


?>