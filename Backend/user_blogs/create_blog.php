<?php
header("Content-Type: application/json");
include("../db.php");

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'] ?? null;
    $username = $_POST['username'] ?? null;
    $blog_title = $_POST['blog_title'] ?? null;
    $short_description = $_POST['short_description'] ?? null;
    $blog_content = $_POST['blog_content'] ?? null;
    $status = 'public';

    // Validate required fields
    if (!$user_id || !$username || !$blog_title || !$short_description || !$blog_content) {
        $response["success"] = false;
        $response["message"] = "All fields are required!";
        echo json_encode($response);
        exit;
    }

    // SQL query
    $sql_query = "INSERT INTO `users_blogs` (`user_id`, `username`, `blog_title`, `short_description`, `blog_content`, `status`) 
                  VALUES ('$user_id', '$username', '$blog_title', '$short_description', '$blog_content', '$status')";

    if (mysqli_query($conn, $sql_query)) {
        $response["success"] = true;
        $response["message"] = "Blog added successfully!";
    } else {
        $response["success"] = false;
        $response["message"] = "Database error: " . mysqli_error($conn);
    }
} else {
    $response["success"] = false;
    $response["message"] = "Invalid request method!";
}

echo json_encode($response);
?>
