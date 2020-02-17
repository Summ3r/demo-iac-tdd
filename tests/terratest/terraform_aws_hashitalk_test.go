package test

import (
	"fmt"
	httpHelper "github.com/gruntwork-io/terratest/modules/http-helper"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsSimpleWebArch(t *testing.T) {
	t.Parallel()

	// where are my tf files
	terraformOptions := &terraform.Options{
		TerraformDir: "../../templates",
	}

	// always destroy after test is complete
	defer terraform.Destroy(t, terraformOptions)

	// create resources via tf
	terraform.InitAndApply(t, terraformOptions)

	// validate
	elbDnsName := terraform.Output(t, terraformOptions, "elb_dns_name")
	url := fmt.Sprintf("http://%s:80", elbDnsName)
	httpHelper.HttpGetWithRetry(t, url, nil, 200, "Hello, HashiTalks", 30, 5*time.Second)
}

//func getListFromTerraformOutput(t *testing.T, terraformOptions *terraform.Options, key string) []string {
//	instanceIds := terraform.OutputList(t, terraformOptions, key)
//	instanceIds[0] = strings.ReplaceAll(instanceIds[0], "[", "")
//	instanceIds[0] = strings.ReplaceAll(instanceIds[0], "]", "")
//	return strings.Split(instanceIds[0], " ")
//}

//instanceIps := getListFromTerraformOutput(t, terraformOptions, "elb_dns_name")
//assert.Equal(t, expectedNumberOfInstances, len(instanceIps))
//for _, ip := range instanceIps {
//url := fmt.Sprintf("http://%s:80", ip)
//http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, HashiTalks", 30, 5*time.Second)
//}
