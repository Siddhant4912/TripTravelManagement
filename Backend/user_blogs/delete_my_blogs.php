<?php 
include('../db.php');

$blog_id = $_POST["blog_id"];

$sql = "DELETE FROM users_blogs WHERE blog_id = '$blog_id'";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["success" => "Blog deleted successfully"]);
} else {
    echo json_encode(["error" => "Failed to delete blog"]);
}

mysqli_close($conn); 
?>
