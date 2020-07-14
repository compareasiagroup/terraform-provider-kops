module github.com/compareasiagroup/terraform-provider-kops

go 1.13

// kops 1.18.0-beta.2 - 89fba09caae6253c9e4348682c0f36227ee875b2

// https://github.com/kubernetes/kops/blob/v1.18.0-beta.2/go.mod

// Version kubernetes-1.18.0 => tag v0.18.1

replace k8s.io/api => k8s.io/api v0.18.1

replace k8s.io/apimachinery => k8s.io/apimachinery v0.18.1

replace k8s.io/client-go => k8s.io/client-go v0.18.1

replace k8s.io/cloud-provider => k8s.io/cloud-provider v0.18.1

replace k8s.io/kubectl => k8s.io/kubectl v0.18.1

replace k8s.io/apiserver => k8s.io/apiserver v0.18.1

replace k8s.io/apiextensions-apiserver => k8s.io/apiextensions-apiserver v0.18.1

replace k8s.io/kube-scheduler => k8s.io/kube-scheduler v0.18.1

replace k8s.io/kube-proxy => k8s.io/kube-proxy v0.18.1

replace k8s.io/cri-api => k8s.io/cri-api v0.18.1

replace k8s.io/csi-translation-lib => k8s.io/csi-translation-lib v0.18.1

replace k8s.io/legacy-cloud-providers => k8s.io/legacy-cloud-providers v0.18.1

replace k8s.io/component-base => k8s.io/component-base v0.18.1

replace k8s.io/cluster-bootstrap => k8s.io/cluster-bootstrap v0.18.1

replace k8s.io/metrics => k8s.io/metrics v0.18.1

replace k8s.io/sample-apiserver => k8s.io/sample-apiserver v0.18.1

replace k8s.io/kube-aggregator => k8s.io/kube-aggregator v0.18.1

replace k8s.io/kubelet => k8s.io/kubelet v0.18.1

replace k8s.io/cli-runtime => k8s.io/cli-runtime v0.18.1

replace k8s.io/kube-controller-manager => k8s.io/kube-controller-manager v0.18.1

replace k8s.io/code-generator => k8s.io/code-generator v0.18.1

replace github.com/gophercloud/gophercloud => github.com/gophercloud/gophercloud v0.9.0

require (
	github.com/hashicorp/terraform v0.12.28
	k8s.io/apimachinery v0.18.1
	k8s.io/kops v1.18.0-beta.1
)
