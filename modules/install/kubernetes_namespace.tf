resource "kubernetes_namespace" "tabnine" {
  metadata {
    name = "tabnine"
    labels = {
      name = "tabnine"
    }
  }
}
