# filepath: /Users/samirgandhi/projects/config-automation/gitops-lab/gitops-lab-platform/02-configuration/aws_permissions.tf

# Create IAM user for Route53 DNS management - only for qa and prod
resource "aws_iam_user" "pingone_dns_user" {
  count = local.create_custom_domain ? 1 : 0

  name = "pingone-dns-manager-${var.pingone_environment_name}"
  path = "/service-accounts/"
}

# Create access key for the IAM user - only for qa and prod
resource "aws_iam_access_key" "pingone_dns_key" {
  count = local.create_custom_domain ? 1 : 0

  user = aws_iam_user.pingone_dns_user[0].name
}

# Create an IAM policy for Route53 permissions - only for qa and prod
resource "aws_iam_policy" "route53_policy" {
  count = local.create_custom_domain ? 1 : 0

  name        = "PingOne-Route53-Policy-${var.pingone_environment_name}"
  description = "Policy to allow managing Route53 records for PingOne domains"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:GetChange",
          "route53:ListResourceRecordSets"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:route53:::hostedzone/${data.aws_route53_zone.parent_zone[0].zone_id}",
          "arn:aws:route53:::change/*"
        ]
      },
      {
        Action   = ["route53:ListHostedZonesByName"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the user - only for qa and prod
resource "aws_iam_user_policy_attachment" "pingone_dns_policy_attachment" {
  count = local.create_custom_domain ? 1 : 0

  user       = aws_iam_user.pingone_dns_user[0].name
  policy_arn = aws_iam_policy.route53_policy[0].arn
}

# Output IAM credentials for reference - conditional outputs
output "pingone_dns_access_key" {
  value     = local.create_custom_domain ? aws_iam_access_key.pingone_dns_key[0].id : "N/A - Custom domain not enabled"
  sensitive = false
}

output "pingone_dns_secret_key" {
  value     = local.create_custom_domain ? aws_iam_access_key.pingone_dns_key[0].secret : "N/A - Custom domain not enabled"
  sensitive = true
}