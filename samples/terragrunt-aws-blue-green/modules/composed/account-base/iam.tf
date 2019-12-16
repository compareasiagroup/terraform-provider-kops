# external DNS roles for public zones
resource "aws_iam_role" "externaldns_public_zones" {
  for_each = { for domain, zone in var.public_zones:
    domain => zone
    if length(zone.trusted_accounts) > 0
  }
  name = "externaldns.${each.key}"
  assume_role_policy = data.aws_iam_policy_document.externaldns_public_zones_account_trust[each.key].json
}

data "aws_iam_policy_document" "externaldns_public_zones_account_trust" {
  for_each = { for domain, zone in var.public_zones:
    domain => zone
    if length(zone.trusted_accounts) > 0
  }
  dynamic "statement" {
    for_each = each.value.trusted_accounts
    content {
      sid = "${join("",split("-",title(statement.key)))}AccountTrust"

      principals {
        type = "AWS"
        identifiers = [
          "arn:aws:iam::${statement.value}:root",
        ]
      }

      actions = [
      "sts:AssumeRole",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "externaldns_public_zones" {
  for_each   = { for domain, zone in var.public_zones:
    domain => zone
    if length(zone.trusted_accounts) > 0
  }
  role       = aws_iam_role.externaldns_public_zones[each.key].name
  policy_arn = aws_iam_policy.externaldns_public_zones[each.key].arn
}

resource "aws_iam_policy" "externaldns_public_zones" {
  for_each    = { for domain, zone in var.public_zones:
    domain => zone
    if length(zone.trusted_accounts) > 0
  }
  name        = "externaldns.${each.key}"
  description = "ExternalDNS ${each.key} AWS Integration role"
  policy      = data.aws_iam_policy_document.externaldns_public_zones[each.key].json
}

data "aws_iam_policy_document" "externaldns_public_zones" {
  for_each    = { for domain, zone in var.public_zones:
    domain => zone
    if length(zone.trusted_accounts) > 0
  }
  statement {
    actions = [
      "route53:GetChange",
    ]
    resources = [
      "arn:aws:route53:::change/*",
    ]
  }
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${aws_route53_zone.public_zones[each.key].id}",
    ]
  }
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListHostedZonesByName"
    ]
    resources = [
        "*",
    ]
  }
}
