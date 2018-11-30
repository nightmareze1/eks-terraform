output "ids" {
  value = ["${aws_subnet.main.*.id}"]
}
