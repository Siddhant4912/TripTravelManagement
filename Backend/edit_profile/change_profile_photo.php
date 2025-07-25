<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include("../db.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$upload_dir = "../images/profile_image/";

if (isset($_FILES['file']) && isset($_POST['user_id'])) {
    $user_id = $_POST['user_id'];
    $file_name = time() . "_" . basename($_FILES['file']['name']); // Unique filename
    $target_file = $upload_dir . $file_name;

    // ✅ 1. Fetch the existing profile photo filename
    $query = "SELECT profile_photo FROM user_details WHERE user_id = '$user_id'";
    $result = mysqli_query($conn, $query);
    if ($result) {
        $row = mysqli_fetch_assoc($result);
        $old_file = $row['profile_photo'];

        // ✅ 2. Delete the old file if it exists
        if (!empty($old_file) && file_exists($upload_dir . $old_file)) {
            unlink($upload_dir . $old_file);
        }
    }

    // ✅ 3. Move the new file & update database
    if (move_uploaded_file($_FILES['file']['tmp_name'], $target_file)) {
        $sql_update = "UPDATE user_details SET profile_image = '$file_name' WHERE user_id = '$user_id'";
        if (mysqli_query($conn, $sql_update)) {
            echo json_encode(["status" => "success", "message" => "Profile photo updated", "file_url" => $target_file]);
        } else {
            echo json_encode(["status" => "error", "message" => "Database update failed: " . mysqli_error($conn)]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to upload file"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "No file uploaded or missing user ID"]);
}

mysqli_close($conn);
?>
