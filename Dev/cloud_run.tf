module "dev-application-cloud-run" {
  
  # insert the 4 required variables here
  service_name           = var.Application_name
  project_id             = var.project_id
  location               = var.location
  image                  = var.Application_image
  generate_revision_name  = var.generate_revision_name
  traffic_split = var.Application_traffic_split
  service_labels = var.Application_labels
  service_annotations = var.Application_annotations
#   service_account_email = module.application-service-accounts.email
  template_annotations = var.Application_template_annotations
  # encryption_key = var.encryption_key
  container_concurrency = var.Application_container_concurrency
  # timeout_seconds
  ports = var.Application_ports
  env_vars = var.Application_env_vars
  env_secret_vars = []
#   members = ["serviceAccount:${data.terraform_remote_state.service_account.outputs.svc_account_name}"]
}
