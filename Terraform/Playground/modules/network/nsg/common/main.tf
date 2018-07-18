locals {
  ports {
    HTTP  = 80
    HTTPS = 443
    RDP   = 3389
  }

  allow_http_rule {
    name   = "HTTP"
    source = "*"
    port   = "${local.ports["HTTP"]}"
  }

  allow_https_rule {
    name   = "HTTPS"
    source = "*"
    port   = "${local.ports["HTTPS"]}"
  }

  allow_rdp_rule {
    name   = "RDP"
    source = "*"
    port   = "${local.ports["RDP"]}"
  }
}
