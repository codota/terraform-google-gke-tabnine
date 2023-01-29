# https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/cmd/nvidia_gpu/device-plugin.yaml
resource "kubernetes_daemonset" "nvidia_gpu_device_plugin_mig" {
  count = var.use_nvidia_mig && !var.exclude_nvidia_driver ? 1 : 0
  metadata {
    name      = "nvidia-driver-installer"
    namespace = "kube-system"

    labels = {
      k8s-app = "nvidia-driver-installer"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "nvidia-driver-installer"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "nvidia-driver-installer"

          name = "nvidia-driver-installer"
        }
      }

      spec {
        volume {
          name = "dev"

          host_path {
            path = "/dev"
          }
        }

        volume {
          name = "vulkan-icd-mount"

          host_path {
            path = "/home/kubernetes/bin/nvidia/vulkan/icd.d"
          }
        }

        volume {
          name = "nvidia-install-dir-host"

          host_path {
            path = "/home/kubernetes/bin/nvidia"
          }
        }

        volume {
          name = "root-mount"

          host_path {
            path = "/"
          }
        }

        volume {
          name = "cos-tools"

          host_path {
            path = "/var/lib/cos-tools"
          }
        }

        volume {
          name = "nvidia-config"

          host_path {
            path = "/etc/nvidia"
          }
        }

        init_container {
          name  = "nvidia-driver-installer"
          image = "cos-nvidia-installer:fixed"

          env {
            name  = "NVIDIA_INSTALL_DIR_HOST"
            value = "/home/kubernetes/bin/nvidia"
          }

          env {
            name  = "NVIDIA_INSTALL_DIR_CONTAINER"
            value = "/usr/local/nvidia"
          }

          env {
            name  = "VULKAN_ICD_DIR_HOST"
            value = "/home/kubernetes/bin/nvidia/vulkan/icd.d"
          }

          env {
            name  = "VULKAN_ICD_DIR_CONTAINER"
            value = "/etc/vulkan/icd.d"
          }

          env {
            name  = "ROOT_MOUNT_DIR"
            value = "/root"
          }

          env {
            name  = "COS_TOOLS_DIR_HOST"
            value = "/var/lib/cos-tools"
          }

          env {
            name  = "COS_TOOLS_DIR_CONTAINER"
            value = "/build/cos-tools"
          }

          resources {
            requests = {
              cpu = "150m"
            }
          }

          volume_mount {
            name       = "nvidia-install-dir-host"
            mount_path = "/usr/local/nvidia"
          }

          volume_mount {
            name       = "vulkan-icd-mount"
            mount_path = "/etc/vulkan/icd.d"
          }

          volume_mount {
            name       = "dev"
            mount_path = "/dev"
          }

          volume_mount {
            name       = "root-mount"
            mount_path = "/root"
          }

          volume_mount {
            name       = "cos-tools"
            mount_path = "/build/cos-tools"
          }

          image_pull_policy = "Never"

          security_context {
            privileged = true
          }
        }

        init_container {
          name  = "partition-gpus"
          image = "gcr.io/gke-release/nvidia-partition-gpu@sha256:c54fd003948fac687c2a93a55ea6e4d47ffbd641278a9191e75e822fe72471c2"

          env {
            name  = "LD_LIBRARY_PATH"
            value = "/usr/local/nvidia/lib64"
          }

          resources {
            requests = {
              cpu = "150m"
            }
          }

          volume_mount {
            name       = "nvidia-install-dir-host"
            mount_path = "/usr/local/nvidia"
          }

          volume_mount {
            name       = "dev"
            mount_path = "/dev"
          }

          volume_mount {
            name       = "nvidia-config"
            mount_path = "/etc/nvidia"
          }

          security_context {
            privileged = true
          }
        }

        container {
          name  = "pause"
          image = "gcr.io/google-containers/pause:2.0"
        }

        host_network = true
        host_pid     = true

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "cloud.google.com/gke-accelerator"
                  operator = "Exists"
                }

                match_expressions {
                  key      = "cloud.google.com/gke-gpu-driver-version"
                  operator = "DoesNotExist"
                }
              }
            }
          }
        }

        toleration {
          operator = "Exists"
        }

        priority_class_name = "system-node-critical"
      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_manifest" "daemonset_kube_system_nvidia_driver_installer" {
  // a hack which can be solved by converting this to kubernetes_daemonset
  count = var.exclude_nvidia_driver || var.use_nvidia_mig ? 0 : 1
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "DaemonSet"
    "metadata" = {
      "labels" = {
        "k8s-app" = "nvidia-driver-installer"
      }
      "name"      = "nvidia-driver-installer"
      "namespace" = "kube-system"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "k8s-app" = "nvidia-driver-installer"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "k8s-app" = "nvidia-driver-installer"
            "name"    = "nvidia-driver-installer"
          }
        }
        "spec" = {
          "affinity" = {
            "nodeAffinity" = {
              "requiredDuringSchedulingIgnoredDuringExecution" = {
                "nodeSelectorTerms" = [
                  {
                    "matchExpressions" = [
                      {
                        "key"      = "cloud.google.com/gke-accelerator"
                        "operator" = "Exists"
                      },
                    ]
                  },
                ]
              }
            }
          }
          "containers" = [
            {
              "image" = "gcr.io/google-containers/pause:2.0"
              "name"  = "pause"
            },
          ]
          "hostNetwork" = true
          "hostPID"     = true
          "initContainers" = [
            {
              "command" = [
                "/cos-gpu-installer",
                "install",
                "--version=latest",
              ]
              "env" = [
                {
                  "name"  = "NVIDIA_INSTALL_DIR_HOST"
                  "value" = "/home/kubernetes/bin/nvidia"
                },
                {
                  "name"  = "NVIDIA_INSTALL_DIR_CONTAINER"
                  "value" = "/usr/local/nvidia"
                },
                {
                  "name"  = "VULKAN_ICD_DIR_HOST"
                  "value" = "/home/kubernetes/bin/nvidia/vulkan/icd.d"
                },
                {
                  "name"  = "VULKAN_ICD_DIR_CONTAINER"
                  "value" = "/etc/vulkan/icd.d"
                },
                {
                  "name"  = "ROOT_MOUNT_DIR"
                  "value" = "/root"
                },
                {
                  "name"  = "COS_TOOLS_DIR_HOST"
                  "value" = "/var/lib/cos-tools"
                },
                {
                  "name"  = "COS_TOOLS_DIR_CONTAINER"
                  "value" = "/build/cos-tools"
                },
              ]
              "image"           = "cos-nvidia-installer:fixed"
              "imagePullPolicy" = "Never"
              "name"            = "nvidia-driver-installer"
              "resources" = {
                "requests" = {
                  "cpu" = "150m"
                }
              }
              "securityContext" = {
                "privileged" = true
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/usr/local/nvidia"
                  "name"      = "nvidia-install-dir-host"
                },
                {
                  "mountPath" = "/etc/vulkan/icd.d"
                  "name"      = "vulkan-icd-mount"
                },
                {
                  "mountPath" = "/dev"
                  "name"      = "dev"
                },
                {
                  "mountPath" = "/root"
                  "name"      = "root-mount"
                },
                {
                  "mountPath" = "/build/cos-tools"
                  "name"      = "cos-tools"
                },
              ]
            },
          ]
          "tolerations" = [
            {
              "operator" = "Exists"
            },
          ]
          "volumes" = [
            {
              "hostPath" = {
                "path" = "/dev"
              }
              "name" = "dev"
            },
            {
              "hostPath" = {
                "path" = "/home/kubernetes/bin/nvidia/vulkan/icd.d"
              }
              "name" = "vulkan-icd-mount"
            },
            {
              "hostPath" = {
                "path" = "/home/kubernetes/bin/nvidia"
              }
              "name" = "nvidia-install-dir-host"
            },
            {
              "hostPath" = {
                "path" = "/"
              }
              "name" = "root-mount"
            },
            {
              "hostPath" = {
                "path" = "/var/lib/cos-tools"
              }
              "name" = "cos-tools"
            },
          ]
        }
      }
      "updateStrategy" = {
        "type" = "RollingUpdate"
      }
    }
  }
}
