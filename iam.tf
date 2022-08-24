/// Lambda Invocation Permissions -----------------------------------------------------------------

resource "aws_iam_role" "role" {
    name = join("-", [
        title(replace(var.name, "_", "-")),
        "STS"
    ])

    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Action    = "sts:AssumeRole"
                Effect    = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_lambda_permission" "lambda-invocation-permissions" {
    function_name = aws_lambda_function.function.function_name

    # The /*/*/* part allows invocation from any stage, method and resource path
    # within API Gateway REST API.
    source_arn = var.execution-source

    statement_id = "API-Gateway-Invocation"
    action       = "lambda:InvokeFunction"
    principal    = "apigateway.amazonaws.com"
}

/// S3 Read-Only Access
resource "aws_iam_role_policy_attachment" "s3-read-only-access-policy-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

/// Base Lambda Invocation Service-Role Association
resource "aws_iam_role_policy_attachment" "lambda-access-policy-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

/// API-Gateway Cloudwatch IAM Association
resource "aws_iam_role_policy_attachment" "api-gateway-cloudwatch-access-policy-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

/// Lambda VPC Configuration IAM Association
resource "aws_iam_role_policy_attachment" "vpc-access-policy-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

/// Provides AWS Lambda functions permissions to interact with Amazon S3 Object Lambda, grants Lambda permissions to write to CloudWatch Logs
resource "aws_iam_role_policy_attachment" "s3-access-policy-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonS3ObjectLambdaExecutionRolePolicy"
}

/// Provides receive message, delete message, and read attribute access to SQS queues, and write permissions to CloudWatch logs.
resource "aws_iam_role_policy_attachment" "sqs-access-policy-attachment" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}
