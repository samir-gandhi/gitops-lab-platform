# Custom Domain Testing Guide

This document provides a guide for testing the custom domain functionality implemented in this GitOps Lab project.

## Overview

The custom domain implementation automatically creates subdomains for the "qa" and "prod" environments and secures them with Let's Encrypt certificates. It integrates with AWS Route53 for DNS management. Custom domains are NOT created for feature branches or development environments to avoid hitting Let's Encrypt rate limits.

## Prerequisites

Before testing, ensure you have:

1. A domain registered in AWS Route53
2. AWS credentials configured with appropriate Route53 permissions
3. Updated the following variables:
   - `parent_domain` in `02-configuration/vars.tf` to your registered domain
   - `email_address` to a valid email for Let's Encrypt notifications

## Testing Workflow

### 1. Initial Deployment with Custom Domain

```bash
# Deploy a qa or prod branch to enable custom domain
./scripts/local_feature_deploy.sh -b qa

# Check logs for the domain being created
grep -A 3 "Custom domain creation" terraform.log

# You should see "ENABLED" for qa or prod, and "DISABLED" for other environments
```

### 2. Verify DNS Records

After deployment, verify the DNS records are created in Route53:

```bash
# Use AWS CLI to check the records (replace with your hosted zone ID)
aws route53 list-resource-record-sets --hosted-zone-id <your-zone-id> --query "ResourceRecordSets[?Name=='*.<your-domain>.']"
```

You should see CNAME records for both PingOne verification and the domain pointing to PingOne's service.

### 3. Verify Certificate Creation

The initial deployment uses Let's Encrypt's staging environment which produces untrusted certificates:

```bash
# Check the certificate details
curl -vI https://<environment-name>.<your-domain>
```

You'll see a warning about an untrusted certificate - this is expected in staging mode.

### 4. Moving to Production

When ready for production use:

1. Update the ACME provider in `02-configuration/providers.tf`:
   ```terraform
   provider "acme" {
     # Production URL (uncomment when ready):
     server_url = "https://acme-v02.api.letsencrypt.org/directory"
     
     # Staging URL (comment out):
     # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
   }
   ```

2. Re-deploy to update the certificates:
   ```bash
   ./scripts/local_feature_deploy.sh -b <your-branch-name>
   ```

### 5. Re-enabling Email Domain Functionality

Once custom domain is verified working, re-enable the email domain functionality:

1. Uncomment the email domain resources in `02-configuration/custom_domain.tf`
2. Uncomment the DNS record resources for email domain verification
3. The conditional logic (`count = local.create_custom_domain ? 1 : 0`) ensures these will only be created for qa and prod environments
4. Deploy the changes to apply the email domain configuration

## Troubleshooting

### Environment Not Getting Custom Domain

If your environment isn't getting a custom domain:

1. Verify the environment name is exactly "qa" or "prod" (case sensitive)
2. Check the Terraform logs to confirm the custom domain creation is "ENABLED"
3. Run `terraform state list` to see if the custom domain resources are being created

### DNS Verification Issues

If the PingOne domain verification fails:

1. Check if DNS records were created in Route53
2. Verify the CNAME record matches the validation record from PingOne
3. Check for permissions issues with the AWS IAM user

### Certificate Generation Issues

If ACME certificate generation fails:

1. Ensure your email address is valid
2. Check for Let's Encrypt rate limits (especially when using production)
3. Verify DNS propagation for the validation records

## Outputs

After successful deployment, you can view these outputs for reference:

- `custom_domain_url`: The full HTTPS URL for your custom domain
- `custom_domain_certificate_expiration`: When the certificate will expire
- `custom_domain_status`: Verification status of the custom domain
