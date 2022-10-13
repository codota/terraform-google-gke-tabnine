resource "kubernetes_manifest" "daemonset_kube_system_nvidia_driver_installer" {
  // a hack which can be solved by converting this to kubernetes_daemonset
  count = var.exclude_nvidia_driver ? 0 : 1
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
