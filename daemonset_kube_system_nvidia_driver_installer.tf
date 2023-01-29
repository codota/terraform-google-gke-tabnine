# https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/cmd/nvidia_gpu/device-plugin.yaml
resource "kubernetes_daemonset" "nvidia_gpu_device_plugin_mig" {
  count = var.use_nvidia_mig ? 1 : 0
  metadata {
    name      = "nvidia-gpu-device-plugin-mig"
    namespace = "kube-system"

    labels = {
      "addonmanager.kubernetes.io/mode" = "EnsureExists"
      k8s-app = "nvidia-gpu-device-plugin-mig"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "nvidia-gpu-device-plugin-mig"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "nvidia-gpu-device-plugin-mig"
        }
      }

      spec {
        volume {
          name = "device-plugin"

          host_path {
            path = "/var/lib/kubelet/device-plugins"
          }
        }

        volume {
          name = "dev"

          host_path {
            path = "/dev"
          }
        }

        volume {
          name = "nvidia"

          host_path {
            path = "/home/kubernetes/bin/nvidia"
          }
        }

        volume {
          name = "pod-resources"

          host_path {
            path = "/var/lib/kubelet/pod-resources"
          }
        }

        volume {
          name = "proc"

          host_path {
            path = "/proc"
          }
        }

        volume {
          name = "nvidia-config"

          host_path {
            path = "/etc/nvidia"
          }
        }

        container {
          name    = "nvidia-gpu-device-plugin-mig"
          image   = "gcr.io/gke-release/nvidia-gpu-device-plugin-mig@sha256:5881b00412e4fbd0715741eba696ddf040a92a1680773d8937189181b4313c3f"
          command = ["/usr/bin/nvidia-gpu-device-plugin-mig", "-logtostderr", "--enable-container-gpu-metrics"]

          port {
            name           = "metrics"
            container_port = 2112
          }

          env {
            name = "NODE_NAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name  = "LD_LIBRARY_PATH"
            value = "/usr/local/nvidia/lib64"
          }

          resources {
            limits = {
              cpu = "50m"

              memory = "20Mi"
            }

            requests = {
              cpu = "50m"

              memory = "20Mi"
            }
          }

          volume_mount {
            name       = "device-plugin"
            mount_path = "/device-plugin"
          }

          volume_mount {
            name       = "dev"
            mount_path = "/dev"
          }

          volume_mount {
            name       = "nvidia"
            mount_path = "/usr/local/nvidia"
          }

          volume_mount {
            name       = "pod-resources"
            mount_path = "/var/lib/kubelet/pod-resources"
          }

          volume_mount {
            name       = "proc"
            mount_path = "/proc"
          }

          volume_mount {
            name       = "nvidia-config"
            mount_path = "/etc/nvidia"
          }

          security_context {
            privileged = true
          }
        }

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "cloud.google.com/gke-accelerator"
                  operator = "Exists"
                }
              }
            }
          }
        }

        toleration {
          operator = "Exists"
          effect   = "NoExecute"
        }

        toleration {
          operator = "Exists"
          effect   = "NoSchedule"
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
  count = var.exclude_nvidia_driver && !var.use_nvidia_mig ? 0 : 1
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
