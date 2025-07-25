<?php 
	include("../db.php");

	$data = array();
	$user_id = $_POST['user_id'];
	$trip_id = $_POST['trip_id'];
	$paid_category = $_POST['paid_category'];	
	$how_much_paid = $_POST['how_much_paid'];
	$when_was_it_paid = $_POST['when_was_it_paid'];



	$sql_query = "INSERT INTO `trip_expenses` ( `user_id`, `trip_id`, `paid_category`, `how_much_paid`, `when_was_it_paid`) VALUES ('$user_id', '$trip_id', '$paid_category', '$how_much_paid', '$when_was_it_paid')";

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