locals {
  name = "mdb-prod-commerce-api"

  # Pinned by digest. Bump by copying the "Image pushed" line from a CI run of maison-douce-bakery/commerce-api.
  image = "452258152479.dkr.ecr.ap-southeast-2.amazonaws.com/mdb/commerce-api@sha256:9b0c5c7d8e119cb025c2537ae7153960bd338bb01962cc53d8f6deffea6590f1"
}
