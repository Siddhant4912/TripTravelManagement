<?php
include('../db.php');

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $file_name = $_POST['file_name'] ?? '';

    if (!empty($file_name)) {
        $file_path = "../images/" . $file_name;

        // Delete the file from the folder
        if (file_exists($file_path)) {
            unlink($file_path);
        }

        // ✅ Update this line with the correct column name
        $query = "DELETE FROM trip_photos WHERE trip_photo = '$file_name'";
        $result = mysqli_query($conn, $query);

        if ($result) {
            echo json_encode(["status" => "success", "message" => "Image deleted successfully"]);
        } else {
            $error = mysqli_error($conn);
            echo json_encode(["status" => "error", "message" => "Database deletion failed: $error"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid request"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
