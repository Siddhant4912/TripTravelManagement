<?php 
include('db.php');
$data = array();
$sql = "SELECT * FROM category";
$result = mysqli_query($conn, $sql);
if (mysqli_num_rows($result) > 0) {
	foreach ($result as $row) {
		$data[] = $row;
	}
}

echo json_encode($data);

?>