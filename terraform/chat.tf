# This bucket stores keys (the Synapse signing key, TLS certificates, ...)
# We mount it with gcsfuse.
resource "google_storage_bucket" "chat-keys" {
  name = "cmc-chat-keys"
  location = "${local.region}"
}
