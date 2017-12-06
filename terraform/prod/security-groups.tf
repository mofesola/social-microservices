/**
 * Provides internal access to container ports
 */
resource "aws_security_group" "ecs" {
  name = "${var.project_name}-ecs-sg"
  description = "Container Instance Allowed Ports"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.project_name}-ecs-${var.env}"
  }
}

resource "aws_security_group" "internal" {
  name = "${var.project_name}-internal-sg"
  description = "${var.project_name} internal SG"

  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "allow_all_out_from_ecs" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.internal.id}"
}
