/**
 * Launch configuration used by autoscaling group
 */
resource "aws_launch_configuration" "ecs" {
  name                 = "${var.project_name}"
  image_id             = "${lookup(var.amis, var.region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.ecs.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
  user_data            = "#!/bin/bash\n/usr/bin/docker pull amazon/amazon-ecs-agent:latest\necho ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} > /etc/ecs/ecs.config\necho ECS_AVAILABLE_LOGGING_DRIVERS='[\"json-file\", \"syslog\", \"fluentd\", \"awslogs\"]' >> /etc/ecs/ecs.config"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

/**
 * Autoscaling group.
 */
resource "aws_autoscaling_group" "ecs" {
  name                 = "${var.project_name}"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier = ["${var.subnet_id}"]
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "BILLING_PROJECT"
    value               = "${var.project_billing_id}"
    propagate_at_launch = true
  }

}

/* ecs service cluster */
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
}

/* create a repository */
resource "aws_ecr_repository" "app_ecr" {
  name = "${var.project_name}-${var.env}"
}

/* create a repository for nginx */
resource "aws_ecr_repository" "app_nginx" {
  name = "${var.project_name}-${var.env}-nginx"
}

/* create a repository for the Picogauge Website */
resource "aws_ecr_repository" "app_website" {
  name = "${var.project_name}-website"
}
