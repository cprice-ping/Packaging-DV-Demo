provider "davinci" {
  //Must be Identity Data Admin for Environment 
  username = var.admin_user_name
  password = var.admin_user_password
  region   = "NorthAmerica"
  // User should exist in Identities of this environment
  environment_id = var.admin_env_id
}

// This simple read action is used to as a precursor to all other data/resources
// Every other data/resource should have a `depends_on` pointing to this read action
data "davinci_connections" "read_all" {
  // NOTICE: this is NOT resource.pingone_environment. Dependency is on the role assignment, not environment.  
  environment_id = module.environment.environment_id
}

resource "davinci_flow" "initial_flow" {
  flow_json = file("../DaVinci/demo_flow.json")
  deploy    = true
  // NOTICE: this is NOT resource.pingone_environment. Dependency is on the role assignment, not environment.
  environment_id = module.environment.identity_data_admin_role[0].scope_environment_id

  connections {
    connection_id   = "867ed4363b2bc21c860085ad2baa817d"
    connection_name = "Http"
  }

  // This depends_on relieves the client from multiple initial authentication attempts
  depends_on = [
    data.davinci_connections.read_all
  ]
}

resource "davinci_application" "initial_policy" {
  name           = "Sample Application"
  environment_id = module.environment.environment_id
  oauth {
    enabled = true
    values {
      allowed_grants                = ["authorizationCode"]
      allowed_scopes                = ["openid", "profile"]
      enabled                       = true
      enforce_signed_request_openid = false
      redirect_uris                 = ["https://auth.pingone.com/${module.environment.environment_id}/rp/callback/openid_connect"]
    }
  }
  policies {
    name   = "Sample App Flow"
    status = "enabled"
    policy_flows {
      flow_id    = davinci_flow.initial_flow.flow_id
      version_id = -1
      weight     = 100
    }
  }
  saml {
    values {
      enabled                = false
      enforce_signed_request = false
    }
  }
}