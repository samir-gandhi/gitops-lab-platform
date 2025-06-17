# __generated__ by Terraform from "HTMLFormPD"
resource "pingfederate_idp_adapter" "pingcli__HTMLFormPD" {
  adapter_id = "HTMLFormPD"
  attribute_contract = {
    core_attributes = [
      {
        masked    = false
        name      = "policy.action"
        pseudonym = false
      },
      {
        masked    = false
        name      = "username"
        pseudonym = true
      },
    ]
    extended_attributes = [
      {
        masked    = false
        name      = "entryUUID"
        pseudonym = false
      },
    ]
    mask_ognl_values          = false
    unique_user_key_attribute = null
  }
  attribute_mapping = {
    attribute_contract_fulfillment = {
      entryUUID = {
        source = {
          id   = null
          type = "ADAPTER"
        }
        value = "entryUUID"
      }
      "policy.action" = {
        source = {
          id   = null
          type = "ADAPTER"
        }
        value = "policy.action"
      }
      username = {
        source = {
          id   = null
          type = "ADAPTER"
        }
        value = "username"
      }
    }
    attribute_sources = [
    ]
    issuance_criteria = {
      conditional_criteria = [
      ]
      expression_criteria = null
    }
  }
  authn_ctx_class_ref = null
  configuration = {
    fields = [
      {
        name  = "'Remember My Username' Lifetime"
        value = "30"
      },
      {
        name  = "'This is My Device' Lifetime"
        value = "30"
      },
      {
        name  = "Account Disabled Email Template"
        value = "message-template-account-disabled.html"
      },
      {
        name  = "Account Unlock Email Template"
        value = "message-template-account-unlock-complete.html"
      },
      {
        name  = "Account Unlock Template"
        value = "account-unlock.html"
      },
      {
        name  = "Account Unlock"
        value = "false"
      },
      {
        name  = "Allow Password Changes"
        value = "false"
      },
      {
        name  = "Allow Username Edits During Chaining"
        value = "false"
      },
      {
        name  = "Allowed OTP Character Set"
        value = "23456789BCDFGHJKMNPQRSTVWXZbcdfghjkmnpqrstvwxz"
      },
      {
        name  = "CAPTCHA Provider"
        value = ""
      },
      {
        name  = "CAPTCHA for Authentication"
        value = "false"
      },
      {
        name  = "CAPTCHA for Password Reset"
        value = "false"
      },
      {
        name  = "CAPTCHA for Password change"
        value = "false"
      },
      {
        name  = "CAPTCHA for Username recovery"
        value = "false"
      },
      {
        name  = "Challenge Retries"
        value = "3"
      },
      {
        name  = "Change Password Email Notification"
        value = "false"
      },
      {
        name  = "Change Password Email Template"
        value = "message-template-end-user-password-change.html"
      },
      {
        name  = "Change Password Message Template"
        value = "html.form.message.template.html"
      },
      {
        name  = "Change Password Policy Contract"
        value = ""
      },
      {
        name  = "Change Password Template"
        value = "html.form.change.password.template.html"
      },
      {
        name  = "Enable 'Remember My Username'"
        value = "false"
      },
      {
        name  = "Enable 'This is My Device'"
        value = "false"
      },
      {
        name  = "Enable Username Recovery"
        value = "false"
      },
      {
        name  = "Expiring Password Warning Template"
        value = "html.form.password.expiring.notification.template.html"
      },
      {
        name  = "Fail Authentication on Account Lockout"
        value = "true"
      },
      {
        name  = "Local Identity Profile"
        value = pingfederate_local_identity_profile.pingcli__pingdirectory.profile_id
      },
      {
        name  = "Login Challenge Template"
        value = "html.form.login.challenge.template.html"
      },
      {
        name  = "Login Template"
        value = "html.form.login.template.html"
      },
      {
        name  = "Logout Path"
        value = ""
      },
      {
        name  = "Logout Redirect"
        value = ""
      },
      {
        name  = "Logout Template"
        value = "idp.logout.success.page.template.html"
      },
      {
        name  = "Notification Publisher"
        value = ""
      },
      {
        name  = "OTP Length"
        value = "8"
      },
      {
        name  = "OTP Time to Live"
        value = "10"
      },
      {
        name  = "Password Management System Message Template"
        value = "html.form.message.template.html"
      },
      {
        name  = "Password Management System"
        value = ""
      },
      {
        name  = "Password Reset Code Template"
        value = "forgot-password-resume.html"
      },
      {
        name  = "Password Reset Complete Email Template"
        value = "message-template-forgot-password-complete.html"
      },
      {
        name  = "Password Reset Error Template"
        value = "forgot-password-error.html"
      },
      {
        name  = "Password Reset Failed Email Template"
        value = "message-template-forgot-password-failed.html"
      },
      {
        name  = "Password Reset One-Time Link Email Template"
        value = "message-template-forgot-password-link.html"
      },
      {
        name  = "Password Reset One-Time Password Email Template"
        value = "message-template-forgot-password-code.html"
      },
      {
        name  = "Password Reset Policy Contract"
        value = ""
      },
      {
        name  = "Password Reset Success Template"
        value = "forgot-password-success.html"
      },
      {
        name  = "Password Reset Template"
        value = "forgot-password-change.html"
      },
      {
        name  = "Password Reset Type"
        value = "NONE"
      },
      {
        name  = "Password Reset Username Template"
        value = "forgot-password.html"
      },
      {
        name  = "Password Update Timeout"
        value = "30"
      },
      {
        name  = "PingID Properties"
        value = ""
      },
      {
        name  = "Post-Password Change Re-Authentication Delay"
        value = "0"
      },
      {
        name  = "Require Re-Authentication For Expiring Password Flow"
        value = "false"
      },
      {
        name  = "Require Re-Authentication for Change Password Flow"
        value = "true"
      },
      {
        name  = "Require Re-Authentication for Password Reset Flow"
        value = "true"
      },
      {
        name  = "Require Verified Email"
        value = "false"
      },
      {
        name  = "Revoke Sessions After Password Change Or Reset"
        value = "false"
      },
      {
        name  = "Session Max Timeout"
        value = "480"
      },
      {
        name  = "Session State"
        value = "None"
      },
      {
        name  = "Session Timeout"
        value = "60"
      },
      {
        name  = "Show Password Expiring Warning"
        value = "false"
      },
      {
        name  = "Snooze Interval for Expiring Password Warning"
        value = "24"
      },
      {
        name  = "Threshold for Expiring Password Warning"
        value = "7"
      },
      {
        name  = "Track Authentication Time"
        value = "true"
      },
      {
        name  = "Username Recovery Email Template"
        value = "message-template-username-recovery.html"
      },
      {
        name  = "Username Recovery Info Template"
        value = "username.recovery.info.template.html"
      },
      {
        name  = "Username Recovery Template"
        value = "username.recovery.template.html"
      },
    ]
    sensitive_fields = [
    ]
    tables = [
      {
        name = "Credential Validators"
        rows = [
          {
            default_row = false
            fields = [
              {
                name  = "Password Credential Validator Instance"
                value = pingfederate_password_credential_validator.pingcli__pingdirectory.validator_id
              },
            ]
            sensitive_fields = [
            ]
          },
        ]
      },
    ]
  }
  name       = "HTMLFormPD"
  parent_ref = null
  plugin_descriptor_ref = {
    id = "com.pingidentity.adapters.htmlform.idp.HtmlFormIdpAuthnAdapter"
  }
}