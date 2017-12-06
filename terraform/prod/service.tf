resource "aws_ecs_task_definition" "main" {
  family                = "${var.project_name}-${var.env}"
  container_definitions = "${file("task-definitions/service.json")}"

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  volume {
    name = "${var.project_name}-app"
    host_path = "/data/${var.project_name}-app"
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-${var.env}-api"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  desired_count   = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent = 200

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
}

resource "aws_ecs_task_definition" "app-nginx" {
  family                = "${var.project_name}-${var.env}-nginx"
  container_definitions = "${file("task-definitions/service-nginx.json")}"

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage/nginx"
  }

  volume {
    name = "letsencrypt"
    host_path = "/data/letsencrypt"
  }

  volume {
    name = "${var.project_name}-app"
    host_path = "/data/${var.project_name}-app"
  }

  volume {
    name      = "${var.project_name}-website"
    host_path = "/data/${var.project_name}-website"
  }
}

resource "aws_ecs_service" "app-nginx" {
  name            = "${var.project_name}-${var.env}-nginx"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.app-nginx.arn}"
  desired_count   = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent = 200

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
}

resource "aws_ecs_task_definition" "app-website" {
  family                = "${var.project_name}-${var.env}-website"
  container_definitions = "${file("task-definitions/service-app-website.json")}"

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage/${var.project_name}-website"
  }

  volume {
    name      = "${var.project_name}-website"
    host_path = "/data/${var.project_name}-website"
  }
}

resource "aws_ecs_service" "app-website" {
  name            = "${var.project_name}-${var.env}-website"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.app-website.arn}"
  desired_count   = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent = 200

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
}
