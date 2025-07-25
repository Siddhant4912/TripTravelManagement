<?php 

include('../db.php');
include('../fetch_conn.php');
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$data = array();

$trip_id = isset($_GET['trip_id']) ? $_GET['trip_id'] : null;

if ( !$trip_id) {
    echo json_encode(["error" => "Missing trip_id "]);
    exit();
}

$sql = "SELECT document_files FROM trip_documents WHERE trip_id = '$trip_id' ORDER BY trip_documents.document_id DESC";
$result = mysqli_query($conn, $sql);

$base_url = "$base_path/images/";

if ($result && mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $base_url . $row["document_files"];
    }
} else {
    echo json_encode(["error" => "No documents found"]);
    exit();
}

echo json_encode($data);
?>