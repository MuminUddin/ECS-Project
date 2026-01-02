output "acm_validation_certificate" {
    description = "acm validation certificate arn"
    value = aws_acm_certificate_validation.acm_validation.certificate_arn
}