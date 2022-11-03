resource "google_compute_ssl_policy" "min_tls_v_1_2" {
  name            = format("%s-min-tls-v-1-2", var.prefix)
  min_tls_version = "TLS_1_2"
  profile         = "MODERN"
}
