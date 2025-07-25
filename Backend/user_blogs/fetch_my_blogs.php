<?php
include('../db.php');

$user_id = $_GET['user_id'];
// $user_id = "1";

// Correctly assigning the SQL query to a variable
$sql = "SELECT users_blogs.*, user_details.profile_image AS profile_image 
        FROM users_blogs 
        INNER JOIN user_details ON users_blogs.user_id = user_details.user_id 
        WHERE users_blogs.user_id = '$user_id'";

$result = mysqli_query($conn, $sql);

if (mysqli_num_rows($result) > 0) {
    $blogs = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $blogs[] = $row;
    }
    echo json_encode($blogs);
} else {
    echo json_encode([]);
}
?>
