output "module" {
    value = aws_lambda_function.function
}

output "invocation-lambda-permission" {
    value = aws_lambda_permission.lambda-invocation-permissions
}

output "artifact" {
    value = {
        bucket = aws_s3_object.artifacts.bucket
        source = aws_s3_object.artifacts.source
        key = aws_s3_object.artifacts.key
    }
}

output "artifact-bucket" {
    value = aws_s3_object.artifacts.bucket
}

output "artifact-bucket-source" {
    value = aws_s3_object.artifacts.source
}

output "artifact-bucket-object-key" {
    value = aws_s3_object.artifacts.key
}

output "function-name" {
    value = aws_lambda_function.function.function_name
}