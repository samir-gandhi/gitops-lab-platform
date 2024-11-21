##############################################
# PingOne Notifications
##############################################

# PingOne Notifications
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/notification_template_content}
# {@link https://docs.pingidentity.com/r/en-us/pingone/pingonemfa_customizing_notifications}

resource "pingone_notification_template_content" "email" {
  environment_id = pingone_environment.target_environment.id
  template_name  = "general"
  locale         = "en"

  email = {
    body    = <<EOT
<div style="display: block; text-align: center; font-family: sans-serif; border: 1px solid #c5c5c5; width: 400px; padding: 50px 30px;">
<img class="align-self-center mb-5" src="$${logoUrl}" alt="$${companyName}" style="$${logoStyle}"/>
     <h1>Success</h1>
     <div style="margin-top: 20px; margin-bottom:25px">
     <p> Please click the link below to confirm your email for Authentication. </p>
     <a href="$${magicLink}" style="font-size: 14pt">Confirmation Link</a>
     </div>
</div>
EOT
    subject = "Magic Link Authentication"

    from = {
      name    = "PingOne"
      address = "noreply@pingidentity.com"
    }
  }
}