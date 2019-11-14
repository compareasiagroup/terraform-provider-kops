package kops

import (
	"encoding/json"
	"reflect"

	"github.com/hashicorp/terraform/helper/schema"
)

func diffJSON(k, old, new string, d *schema.ResourceData) bool {
	var o interface{}
	var n interface{}
	var err error

	err = json.Unmarshal([]byte(old), &o)
	if err != nil {
		return false
	}
	err = json.Unmarshal([]byte(new), &n)
	if err != nil {
		return false
	}

	// deleteCreationTimeStamp(&o)
	// deleteCreationTimeStamp(&n)

	return reflect.DeepEqual(o, n)
}

// func deleteCreationTimeStamp(s *map[string]interface{}) {
// 	metadata := (*s)["metadata"].(map[string]interface{})
// 	metadata["creationTimestamp"] = nil
// 	(*s)["metadata"] = metadata
// }
