############### DATA ###############
data "azuread_client_config" "current" {}

############### RESOURCES ###############
resource "azuread_application" "sp-covid" {
  display_name = "BigDataCovid19-Arturo"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "sp-covid" {
  application_id               = azuread_application.sp-covid.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  feature_tags {
    enterprise = true
    gallery    = true
  }
}


resource "azuread_service_principal_password" "sp-covid" {
  end_date             = "2299-12-30T23:00:00Z"                        # Forever
  service_principal_id = azuread_service_principal.sp-covid.id
}

############### OUTPUTS ###############
output "client_secret" {
  value = azuread_service_principal_password.sp-covid.value
  sensitive = false # Note that you might not want to print this in out in the console all the time
}
output "service_principal"{
  value = azuread_service_principal.sp-covid #obtain application-id
}