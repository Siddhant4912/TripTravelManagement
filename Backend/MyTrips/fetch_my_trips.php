

<?php 

include('../db.php');
$data = array();
$user_id = $_POST['user_id'];
$sql = "SELECT * FROM trip_details WHERE user_id = '$user_id' ORDER BY trip_details.trip_id DESC ";
$result = mysqli_query($conn, $sql);
if (mysqli_num_rows($result) > 0) {
	foreach ($result as $row) {
		$data[] = $row;
	}
}

echo json_encode($data);


?>