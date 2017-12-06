# EFS FS
resource "aws_efs_file_system" "fs" {
  performance_mode = "${var.performance_mode}"

  tags {
    Name = "${var.cluster_name}"
    BILLING_PROJECT = "${var.project_billing_id}"
  }
}

resource "aws_efs_mount_target" "subnet_a" {
  file_system_id = "${aws_efs_file_system.fs.id}"
  subnet_id      = "${element(var.subnets, 0)}"
  security_groups = ["${var.internal_sg_id}"]
}

resource "aws_efs_mount_target" "subnet_b" {
  file_system_id = "${aws_efs_file_system.fs.id}"
  subnet_id      = "${element(var.subnets, 1)}"
  security_groups = ["${var.internal_sg_id}"]
}

resource "aws_efs_mount_target" "subnet_c" {
  file_system_id = "${aws_efs_file_system.fs.id}"
  subnet_id      = "${element(var.subnets, 2)}"
  security_groups = ["${var.internal_sg_id}"]
}

data "template_file" "efs_config" {
  template = "${file("${path.module}/files/efs-config.tmpl")}"

  vars {
    efs_id = "${aws_efs_file_system.fs.id}"
    aws_region = "${var.aws_region}"
  }
}

data "ignition_systemd_unit" "efs" {
  name = "data.mount"
  content = "[Mount]\nWhat=${aws_efs_file_system.fs.id}.efs.${var.aws_region}.amazonaws.com:/\nWhere=/data\nType=nfs\n[Install]\nWantedBy=multi-user.target"
}

output "efs_output" {
  value = "${data.ignition_systemd_unit.efs.id}"
}
