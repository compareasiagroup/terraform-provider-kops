package kops

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/hashicorp/terraform/helper/schema"
	"github.com/hashicorp/terraform/helper/validation"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/kops/pkg/apis/kops"
	"k8s.io/kops/pkg/client/simple/vfsclientset"

	"k8s.io/apimachinery/pkg/api/errors"
)

type instanceGroupID struct {
	clusterName       string
	instanceGroupName string
}

func (i instanceGroupID) String() string {
	return fmt.Sprintf("%s/%s", i.clusterName, i.instanceGroupName)
}

func parseInstanceGroupID(id string) instanceGroupID {
	split := strings.Split(id, "/")
	if len(split) == 2 {
		return instanceGroupID{
			clusterName:       split[0],
			instanceGroupName: split[1],
		}
	}
	return instanceGroupID{}
}
func getInstanceGroup(d *schema.ResourceData, m interface{}) (*kops.InstanceGroup, error) {
	groupID := parseInstanceGroupID(d.Id())
	clientset := m.(*vfsclientset.VFSClientset)
	ctx := context.TODO()
	cluster, err := clientset.GetCluster(ctx, groupID.clusterName)
	if err != nil {
		return nil, err
	}
	return clientset.InstanceGroupsFor(cluster).Get(ctx, groupID.instanceGroupName, v1.GetOptions{})
}

func resourceInstanceGroup() *schema.Resource {
	return &schema.Resource{
		Create: resourceInstanceGroupCreate,
		Read:   resourceInstanceGroupRead,
		Update: resourceInstanceGroupUpdate,
		Delete: resourceInstanceGroupDelete,
		Exists: resourceInstanceGroupExists,
		Importer: &schema.ResourceImporter{
			State: schema.ImportStatePassthrough,
		},
		Schema: map[string]*schema.Schema{
			"cluster_name": {
				Type:     schema.TypeString,
				Required: true,
				ForceNew: true,
			},
			"content": {
				Type:             schema.TypeString,
				Required:         true,
				ValidateFunc:     validation.ValidateJsonString,
				DiffSuppressFunc: diffJSON,
			},
		},
	}
}

func resourceInstanceGroupCreate(d *schema.ResourceData, m interface{}) error {
	clusterName := d.Get("cluster_name").(string)
	clientset := m.(*vfsclientset.VFSClientset)
	ctx := context.TODO()
	cluster, err := clientset.GetCluster(ctx, clusterName)
	if err != nil {
		return err
	}
	content := d.Get("content").(string)
	ig := &kops.InstanceGroup{}
	err = json.Unmarshal([]byte(content), ig)
	if err != nil {
		return err
	}

	instanceGroup, err := clientset.InstanceGroupsFor(cluster).Create(ctx, ig, v1.CreateOptions{})
	if err != nil {
		return err
	}

	// channel, err := cloudup.ChannelForCluster(cluster)
	// if err != nil {
	// 	return err
	// }

	// fullInstanceGroup, err := cloudup.PopulateInstanceGroupSpec(cluster, instanceGroup, channel)
	// if err != nil {
	// 	return err
	// }

	_, err = clientset.InstanceGroupsFor(cluster).Update(ctx, instanceGroup, v1.UpdateOptions{})
	if err != nil {
		return err
	}

	d.SetId(instanceGroupID{
		clusterName:       clusterName,
		instanceGroupName: instanceGroup.ObjectMeta.Name,
	}.String())

	return resourceInstanceGroupRead(d, m)
}

func resourceInstanceGroupRead(d *schema.ResourceData, m interface{}) error {
	return setInstanceGroupResourceData(d, m)
}

func resourceInstanceGroupUpdate(d *schema.ResourceData, m interface{}) error {
	if ok, _ := resourceInstanceGroupExists(d, m); !ok {
		d.SetId("")
		return nil
	}

	clusterName := d.Get("cluster_name").(string)
	clientset := m.(*vfsclientset.VFSClientset)
	ctx := context.TODO()
	cluster, err := clientset.GetCluster(ctx, clusterName)
	if err != nil {
		return err
	}
	content := d.Get("content").(string)
	ig := &kops.InstanceGroup{}
	err = json.Unmarshal([]byte(content), ig)
	if err != nil {
		return err
	}

	_, err = clientset.InstanceGroupsFor(cluster).Update(ctx, ig, v1.UpdateOptions{})
	if err != nil {
		return err
	}

	return resourceInstanceGroupRead(d, m)
}

func resourceInstanceGroupDelete(d *schema.ResourceData, m interface{}) error {
	groupID := parseInstanceGroupID(d.Id())
	clientset := m.(*vfsclientset.VFSClientset)
	ctx := context.TODO()
	cluster, err := clientset.GetCluster(ctx, groupID.clusterName)
	if err != nil {
		return err
	}
	return clientset.InstanceGroupsFor(cluster).Delete(ctx, groupID.instanceGroupName, v1.DeleteOptions{})
}

func resourceInstanceGroupExists(d *schema.ResourceData, m interface{}) (bool, error) {
	_, err := getInstanceGroup(d, m)
	if err != nil {
		if errors.IsNotFound(err) {
			return false, nil
		}
		return false, err
	}
	return true, nil
}

func setInstanceGroupResourceData(d *schema.ResourceData, m interface{}) error {
	ig, err := getInstanceGroup(d, m)
	if err != nil {
		return err
	}

	igJSON, err := json.Marshal(ig)
	if err != nil {
		return err
	}

	if err := d.Set("content", string(igJSON)); err != nil {
		return err
	}
	return nil
}
