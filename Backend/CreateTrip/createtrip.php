<?php 
	include("../db.php");

	$data = array();
	$user_id = $_POST['user_id'];
	$category_id = $_POST['category_id'];
	$trip_start_from = $_POST['trip_start_from'];
	$trip_to_end = $_POST['trip_to_end'];
	$group_security = $_POST['group_security'];	
	$trip_start_date = $_POST['trip_start_date'];
	$trip_end_date = $_POST['trip_end_date'];
	$trip_status = $_POST['trip_status'];
	$trip_banner = $_POST['trip_banner'];



$sql_query = "INSERT INTO `trip_details` (
    `user_id`, `category_id`, `trip_from`, `trip_to_end`, `group_security`, 
    `trip_start_date`, `trip_end_date`, `trip_banner`, `trip_status`
) VALUES (
    '$user_id', '$category_id', '$trip_start_from', '$trip_to_end', '$group_security', 
    '$trip_start_date', '$trip_end_date', '$trip_banner', 'active'
)";
	// $sql_query = "INSERT INTO `trip_details` ( `user_id`, `categroy_id`, `trip_from`, `trip_to_end`, `group_security`, `trip_start_date`, `trip_end_date`, `trip_status`) 
	// VALUES ('1', '2', 'kedar', 'manali','private', '2024/08/24', '2024/09/20', 'active')";
	// $result = mysqli_query($conn, $sql_query);
	if (mysqli_query($conn, $sql_query)) {
		$data = "data inserted";
	}
	else
	{
		$data = "something went wrong";
	}





	echo json_encode(array("status"=>$data));

 ?>


