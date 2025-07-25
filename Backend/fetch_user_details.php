<?php 
include('db.php');
$data = array();

$user_id = $_GET['user_id'];
$sql = "SELECT * FROM user_details WHERE user_id = '$user_id'";
$user_details_result = mysqli_query($conn, $sql);

if (mysqli_num_rows($user_details_result) > 0) {
    foreach ($user_details_result as $row) {
        $data = $row;    
    }
}

echo json_encode($data);
?>
