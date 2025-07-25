<?php 
include('db.php');
$data = array();
$user_name = $_POST['username'];
$password = $_POST['password'];
$result = array();
$sql_chk_username = "SELECT * FROM user_details WHERE email = '$user_name'";
$result = mysqli_query($conn, $sql_chk_username);
if (mysqli_num_rows($result) > 0) {
	

	$sql_chk_password = "SELECT user_id, username, email FROM user_details WHERE password = '$password' AND email = '$user_name'";
	$result_chk_password = mysqli_query($conn, $sql_chk_password);
	if (mysqli_num_rows($result_chk_password) > 0) {
		$data = "Login Success";
		foreach ($result_chk_password as $row) {
			$result = $row;
		}
		
	}
	else{
		$data = "password incorrect";
	}
}
else{
	//echo "User not found";
	$data = "User Not Found";
}

echo json_encode(array("status"=>$data, "data"=>$result));

?>