# https://www.terraform.io/docs/configuration/locals.html

locals {
  region_lower         = "${lower(var.region)}"
  resource_name_prefix = "${var.resource_name_prefix}-${local.region_lower}"

  common_tags = "${merge(
        var.common_tags,
        map(
            "Environment", "Test"
        )
    )}"
}

# "${local.common_tags}"

