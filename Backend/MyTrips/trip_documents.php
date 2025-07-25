<?php
include("../db.php");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
$datetime = date('Y-m-d H:i:s');
$upload_dir = "../images/"; // Folder where images will be stored

// Check if a file was uploaded
if (isset($_FILES['file'])) {
    $file_name = basename($_FILES['file']['name']);
        $user_id = $_POST['user_id'];
    $trip_id = $_POST['trip_id'];
    $target_file = $upload_dir . $file_name;

    // Move the uploaded file to the destination folder
    if (move_uploaded_file($_FILES['file']['tmp_name'], $target_file)) {


        $sql_document = "INSERT INTO `trip_documents`(`user_id`, `trip_id`, `document_names`, `document_files`, `date_time`) VALUES ('$user_id','$trip_id','$file_name','$file_name','$datetime')";
        mysqli_query($conn, $sql_document);


        echo json_encode(["status" => "success", "message" => "File uploaded successfully", "file_url" => $target_file]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to upload file"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "No file uploaded"]);
}
?>
