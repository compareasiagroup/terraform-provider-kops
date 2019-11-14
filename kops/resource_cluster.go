package kops

import (
	"encoding/json"

	"github.com/hashicorp/terraform/helper/schema"
	"github.com/hashicorp/terraform/helper/validation"
	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/kops/pkg/apis/kops"
	"k8s.io/kops/pkg/client/simple/vfsclientset"
)

func resourceCluster() *schema.Resource {
	return &schema.Resource{
		Create: resourceClusterCreate,
		Read:   resourceClusterRead,
		Update: resourceClusterUpdate,
		Delete: resourceClusterDelete,
		Exists: resourceClusterExists,
		Importer: &schema.ResourceImporter{
			State: schema.ImportStatePassthrough,
		},
		Schema: map[string]*schema.Schema{
			"content": {
				Type:             schema.TypeString,
				Required:         true,
				ValidateFunc:     validation.ValidateJsonString,
				DiffSuppressFunc: diffJSON,
			},
		},
	}
}

func resourceClusterCreate(d *schema.ResourceData, m interface{}) error {
	clientset := m.(*vfsclientset.VFSClientset)
	cluster := &kops.Cluster{}
	content := d.Get("content").(string)
	err := json.Unmarshal([]byte(content), cluster)
	if err != nil {
		return err
	}

	cluster, err = clientset.CreateCluster(cluster)
	if err != nil {
		return err
	}

	cluster, err = clientset.GetCluster(cluster.Name)
	if err != nil {
		return err
	}

	// assetBuilder := assets.NewAssetBuilder(cluster, "")
	// fullCluster, err := cloudup.PopulateClusterSpec(clientset, cluster, assetBuilder)
	// if err != nil {
	// 	return err
	// }
	_, err = clientset.UpdateCluster(cluster, nil)
	if err != nil {
		return err
	}

	d.SetId(cluster.Name)

	return resourceClusterRead(d, m)
}

func resourceClusterRead(d *schema.ResourceData, m interface{}) error {
	return setClusterResourceData(d, m)
}

func resourceClusterUpdate(d *schema.ResourceData, m interface{}) error {
	if ok, _ := resourceClusterExists(d, m); !ok {
		d.SetId("")
		return nil
	}

	clientset := m.(*vfsclientset.VFSClientset)
	cluster := &kops.Cluster{}
	content := d.Get("content").(string)
	err := json.Unmarshal([]byte(content), cluster)

	_, err = clientset.UpdateCluster(cluster, nil)

	if err != nil {
		return err
	}

	return resourceClusterRead(d, m)
}

func resourceClusterDelete(d *schema.ResourceData, m interface{}) error {
	cluster, err := getCluster(d, m)
	if err != nil {
		return err
	}

	clientset := m.(*vfsclientset.VFSClientset)
	return clientset.DeleteCluster(cluster)
}

func resourceClusterExists(d *schema.ResourceData, m interface{}) (bool, error) {
	_, err := getCluster(d, m)
	if err != nil {
		if errors.IsNotFound(err) {
			return false, nil
		}
		return false, err
	}

	return true, nil
}

func getCluster(d *schema.ResourceData, m interface{}) (*kops.Cluster, error) {
	clientset := m.(*vfsclientset.VFSClientset)
	return clientset.GetCluster(d.Id())
}

func setClusterResourceData(d *schema.ResourceData, m interface{}) error {
	// get cluster
	clientset := m.(*vfsclientset.VFSClientset)
	cluster, err := clientset.GetCluster(d.Id())
	if err != nil {
		return err
	}

	clusterJSON, err := json.Marshal(cluster)
	if err != nil {
		return err
	}

	if err := d.Set("content", string(clusterJSON)); err != nil {
		return err
	}
	return nil
}
