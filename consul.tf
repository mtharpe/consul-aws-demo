data "template_file" "consul_server" {
  count = "${var.consul_server_count}"

  template = <<EOF
${file("${path.module}/templates/common/provision.sh")}
${file("${path.module}/templates/consul-server.sh")}
EOF

  vars {
    hostname            = "consul-${var.datacenter}-${count.index+1}.node.consul"
    username            = "${var.username}"
    namespace           = "${var.namespace}"
    consul_server_count = "${var.consul_server_count}"
    consul_version      = "${var.consul_version}"
    datacenter          = "${var.datacenter}"
    retry_join_tag      = "${var.retry_join_tag}"
  }
}

resource "aws_instance" "consul_server" {
  count         = "${var.consul_server_count}"
  ami           = "${data.aws_ami.ubuntu-1604.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  iam_instance_profile   = "${aws_iam_instance_profile.consul-retry-join.name}"
  subnet_id              = "${element(var.subnet_ids,  count.index % length(var.subnet_ids))}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

  user_data = "${element(data.template_file.consul_server.*.rendered, count.index)}"

  tags {
    Name   = "consul-${var.datacenter}-${count.index+1}"
    consul = "${var.retry_join_tag}"
  }
}

# Outputs
output "consul_server_ips" {
  value = "${aws_instance.consul_server.*.public_ip}"
}
