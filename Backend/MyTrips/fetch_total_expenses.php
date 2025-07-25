<?php 
include('../db.php');

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$trip_id = $_GET['trip_id'] ?? '';

if (empty($trip_id)) {
    echo json_encode(["error" => "Trip ID is required"]);
    exit();
}

$total = 0;

$stmt = $conn->prepare("SELECT SUM(how_much_paid) as total_amount FROM trip_expenses WHERE trip_id = ?");
$stmt->bind_param("s", $trip_id);

if ($stmt->execute()) {
    $result = $stmt->get_result();
    if ($row = $result->fetch_assoc()) {
        $total = $row['total_amount'] ?? 0;
    }
    echo json_encode(["total_amount" => (int)$total]);
} else {
    echo json_encode(["error" => "Database query failed"]);
}

$stmt->close();
$conn->close();
?>
