# filepath: /Users/samirgandhi/projects/config-automation/gitops-lab/gitops-lab-platform/02-configuration/aws_permissions.tf

# Create IAM user for Route53 DNS management
resource "aws_iam_user" "pingone_dns_user" {
  name = "pingone-dns-manager-${var.pingone_environment_name}"
  path = "/service-accounts/"
}

# Create access key for the IAM user
resource "aws_iam_access_key" "pingone_dns_key" {
  user = aws_iam_user.pingone_dns_user.name
}

# Create an IAM policy for Route53 permissions
resource "aws_iam_policy" "route53_policy" {
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
        Effect   = "Allow"
        Resource = [
          "arn:aws:route53:::hostedzone/${data.aws_route53_zone.parent_zone.zone_id}",
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

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "pingone_dns_policy_attachment" {
  user       = aws_iam_user.pingone_dns_user.name
  policy_arn = aws_iam_policy.route53_policy.arn
}

# Output IAM credentials for reference
output "pingone_dns_access_key" {
  value     = aws_iam_access_key.pingone_dns_key.id
  sensitive = false
}

output "pingone_dns_secret_key" {
  value     = aws_iam_access_key.pingone_dns_key.secret
  sensitive = true
}