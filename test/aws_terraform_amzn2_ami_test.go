package test

import (
	"testing"

	// "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test if Terraform returns a valid Amazon AMI using Terratest.
func TestAwsTerraformAmazonAmi(t *testing.T) {
	t.Parallel()

	expectedAmi := "ami-"
	osVersion := "amzn2-ami-hvm"
	arch := "x86_64"
	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	// awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	// Currently using fixed region due to my SCP restrictions
	awsRegion := "us-east-1"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../modules/ami/amazon",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"os_version": osVersion,
			"arch":       arch,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	actualAmi := terraform.Output(t, terraformOptions, "id")

	// Verify we're getting back the outputs we expect
	assert.Contains(t, actualAmi, expectedAmi)
}
