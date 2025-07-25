<?php
include('../db.php');

$sql = "SELECT users_blogs.*, user_details.profile_image AS profile_image 
        FROM users_blogs 
        INNER JOIN user_details ON users_blogs.user_id = user_details.user_id ORDER BY users_blogs.blog_id DESC";

$result = mysqli_query($conn, $sql);

if ($result) {
    $blogs = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $blogs[] = $row;
    }
    echo json_encode($blogs);
} else {
    echo json_encode(["error" => "Query failed: " . mysqli_error($conn)]);
}
?>
