
resource "google_cloud_run_v2_job" "job" {
  name         = "focus-dev-application"
  project      = "poc-workflow@theta-style-407015.iam.gserviceaccount.com"
  location     = "theta-style-407015"
 

  template {
   
    parallelism = var.parallelism
    task_count  = var.task_count

    template {
        
      service_account = "poc-workflow@theta-style-407015.iam.gserviceaccount.com"
      timeout         = var.timeout

      containers {
        image   = var.image
        command = var.container_command
        args    = var.argument

        resources {
          limits = var.limits
        }

        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.value["name"]
            value = env.value["value"]
          }
        }

       
        dynamic "volume_mounts" {
          for_each = var.volume_mounts
          content {
            name       = volume_mounts.value["name"]
            mount_path = volume_mounts.value["mount_path"]
          }
        }
      }

      dynamic "volumes" {
        for_each = var.volumes
        content {
          name = volumes.value["name"]
          cloud_sql_instance {
            instances = volumes.value.cloud_sql_instance["instances"]
          }
        }
      }

      dynamic "vpc_access" {
        for_each = var.vpc_access
        content {
          connector = vpc_access.value["connector"]
          egress    = vpc_access.value["egress"]
        }
      }
    }
  }
}

data "google_client_config" "default" {}

resource "terracurl_request" "exec" {
  count  = var.exec ? 1 : 0
  name   = "exec-job"
  url    = "https://run.googleapis.com/v2/${google_cloud_run_v2_job.job.id}:run"
  method = "POST"
  headers = {
    Authorization = "Bearer ${data.google_client_config.default.access_token}"
    Content-Type  = "application/json",
  }
  response_codes = [200]
  // no-op destroy
  // we don't use terracurl_request data source as that will result in
  // repeated job runs on every refresh
  destroy_url            = "https://run.googleapis.com/v2/${google_cloud_run_v2_job.job.id}"
  destroy_method         = "GET"
  destroy_response_codes = [200]
  destroy_headers = {
    Authorization = "Bearer ${data.google_client_config.default.access_token}"
    Content-Type  = "application/json",
  }
}
