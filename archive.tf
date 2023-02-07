data "archive_file" "lambda_instance" {
    type        = "zip"
    source_file = local.lambda_function_file
    output_path = local.lambda_function_archive
}