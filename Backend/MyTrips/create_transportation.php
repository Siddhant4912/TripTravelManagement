<?php 
	include("../db.php");

	$data = array();

		$trip_id = $_POST['trip_id'];
		
	$user_id = $_POST['user_id'];
	$start_from = $_POST['start_from'];
	$destination = $_POST['destination'];	
	$travel_date = $_POST['travel_date'];
	$transportation_category = $_POST['transport_category'];



	$sql_query = "INSERT INTO `transport_details` (`trip_id`, `user_id`, `start_from`, `destination`, `travel_date`, `transportation_category`) VALUES ('$trip_id', '$user_id', '$start_from', '$destination', '$travel_date', '$transportation_category')";


	// $sql_query = "INSERT INTO `trip_expenses` ( `user_id`, `trip_id`, `paid_category`, `how_much_paid`, `when_was_it_paid`) VALUES ('1', '2', 'restuarant', '200', '2024-08-24')";
	
	if (mysqli_query($conn, $sql_query)) {
		$data = "data inserted";
	}
	else
	{
		$data = "something went wrong";
	}

	echo json_encode(array("status"=>$data));

 ?>