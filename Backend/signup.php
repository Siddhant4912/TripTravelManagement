

<?php 
include('db.php');

$data = array();
$result = array();
$user_name = $_POST['username'];
$email_id = $_POST['email'];
$password = $_POST['password'];





	$sql_ins_query = "INSERT INTO `user_details` (`username`, `first_name`,`last_name`,`email`,`password`,`dob`,`profile_image`) 
	VALUES ( '$user_name','','','$email_id','$password','','')";
	if (mysqli_query($conn, $sql_ins_query)) {
		$user_id = mysqli_insert_id($conn);
		$data = "Login Success";
		$result = array("user_id"=>$user_id, "username"=>$user_name, "email"=>$email_id);
	}
	else{
		$data = "signup failed";
	}


	echo json_encode(array("status"=>$data, "data"=>$result));
?>