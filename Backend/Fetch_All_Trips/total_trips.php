<?php
include('../db.php');
$category = $_GET['category'] ?? null;

if ($category === null) {
    echo json_encode(['error' => 'No category ID provided']);
    exit;
}

$query = "SELECT COUNT(*) as total_trips FROM trip_details WHERE category_id = ?";
$stmt = $conn->prepare($query);

if (!$stmt) {
    echo json_encode(['error' => 'Query preparation failed', 'details' => $conn->error]);
    exit;
}

$stmt->bind_param("i", $category); // "i" for integer
$stmt->execute();
$result = $stmt->get_result()->fetch_assoc();

echo json_encode(['total_trips' => $result['total_trips']]);
?>
 