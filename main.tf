data "external" "kontena" {
  program = ["ruby", "${path.module}/grid.rb"]

  query {
    depends_id   = "${var.depends_id}"
    name         = "${var.name}"
    organization = "${var.organization}"
  }
}
