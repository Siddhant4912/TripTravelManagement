<?php 
	include("../db.php");

	$data = array();
	$user_id = $_POST['user_id'];
	$trip_id = $_POST['trip_id'];
	$hotel_name = $_POST['hotel_name'];	
	$checkin_checkout_date = $_POST['checkin_checkout_date'];
	$add_note = $_POST['add_note'];



	$sql_query = "INSERT INTO `accommodation` (`user_id`, `trip_id`, `hotel_name`, `checkin_checkout_date`, `add_note`) VALUES ('$user_id', '$trip_id', '$hotel_name', '$checkin_checkout_date', '$add_note')";	


	

	
	if (mysqli_query($conn, $sql_query)) {
		$data = "data inserted";
	}
	else
	{
		$data = "something went wrong";
	}

	echo json_encode(array("status"=>$data));

 ?>