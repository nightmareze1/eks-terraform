output "id" {
  value = "${aws_instance.main.*.id}"
}

