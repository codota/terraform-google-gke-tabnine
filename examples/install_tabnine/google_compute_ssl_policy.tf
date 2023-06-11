resource "google_compute_ssl_policy" "min_tls_v_1_2" {
  name            = "tabnine-min-tls-v-1-2"
  min_tls_version = "TLS_1_2"
  profile         = "MODERN"
}
