# Archive - Although the following namespace belongs to a `data` type,
# such will still create a new "resource", where the resource is a zip
# file of the source path(s).
data "archive_file" "lambda-function-artifact" {
    type        = "zip"
    source_dir  = join("/", [
        var.sources
    ])
    output_path = join("/", [
        path.module,
        "distribution",
        join(".", [
            lower(replace(var.name, " ", "-")),
            "zip"
        ])
    ])
}

resource "aws_s3_object" "artifacts" {
    bucket = var.artifacts-bucket
    key    = var.name
    source = data.archive_file.lambda-function-artifact.output_path
}

resource "aws_lambda_function" "function" {
    function_name = title(replace(var.name, "_", "-"))
    filename      = data.archive_file.lambda-function-artifact.output_path
    description   = var.description
    memory_size   = 1024
    package_type  = "Zip"
    runtime       = (var.runtime != null) ? var.runtime : "nodejs16.x"
    publish       = (var.publish != null) ? var.publish : true
    role          = aws_iam_role.role.arn
    handler       = var.handler
    timeout       = (var.timeout != null) ? var.timeout : 30

    layers = [ ]

    vpc_config {
        security_group_ids = (var.vpc-configuration != null) ? try(var.vpc-configuration.security-group-identifiers, [ ]) : [ ]
        subnet_ids         = (var.vpc-configuration != null) ? try(var.vpc-configuration.subnet-identifiers, [ ]) : [ ]
    }

    tracing_config {
        mode = "Active"
    }

    environment {
        variables = var.environment-variables
    }
}
