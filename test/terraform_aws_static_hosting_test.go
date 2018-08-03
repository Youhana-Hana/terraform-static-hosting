package test
import(
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/stretchr/testify/assert"
)

const TEST_DIR = "."

func TestTerraform(t *testing.T) {
	
	test_structure.RunTestStage(t, "deploy", func() {
	
	awsRegion := "us-east-1"
	terraformOptions := &terraform.Options {
	TerraformDir: "../",
	Vars: map[string]interface{}{
	"region": awsRegion,
        },
	EnvVars: map[string]string {
		"AWS_DEFAULT_REGION_ENV_VAR": awsRegion,
		},
	}

	 test_structure.SaveTerraformOptions(t, TEST_DIR, terraformOptions)
	 test_structure.SaveString(t, TEST_DIR, "AWS_REGION", awsRegion)
 	 terraform.InitAndApply(t, terraformOptions);
	})

        defer test_structure.RunTestStage(t, "teardown", func() {
	 terraformOptions := test_structure.LoadTerraformOptions(t, TEST_DIR)
	 terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
	 terraformOptions := test_structure.LoadTerraformOptions(t, TEST_DIR)
	 domainName := terraform.Output(t, terraformOptions, "cloud_front_domain_name")
	 assert.NotNil(t, domainName)
	})

	test_structure.RunTestStage(t, "validate_S3", func() {
	 awsRegion := test_structure.LoadString(t, TEST_DIR, "AWS_REGION")

	 aws.AssertS3BucketExists(t, awsRegion, "com.youhanalabs.dev")
	})

	test_structure.RunTestStage(t, "validate_object", func() {
	 awsRegion := test_structure.LoadString(t, TEST_DIR, "AWS_REGION")
	keyContent := aws.GetS3ObjectContents(t, awsRegion, "com.youhanalabs.dev", "IMG_1176_1.jpg")
	assert.NotNil(t, keyContent)
	})

	test_structure.RunTestStage(t, "get-object", func() {
	 terraformOptions := test_structure.LoadTerraformOptions(t, TEST_DIR)
	 bucket_name := terraform.Output(t, terraformOptions, "s3_bucket_name")
	url := fmt.Sprintf("http://%s/%s", bucket_name, "IMG_1176_1.jpg")
	statusCode, content := http_helper.HttpGet(t, url)
	logger.Logf(t, "url=%s, statusCode=%d", url, statusCode)
	assert.Equal(t, statusCode, 200)
	assert.NotNil(t, content)
	})


}


