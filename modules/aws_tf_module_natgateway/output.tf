output "ids" {
  value = ["${aws_route_table.main.*.id}"]
}
