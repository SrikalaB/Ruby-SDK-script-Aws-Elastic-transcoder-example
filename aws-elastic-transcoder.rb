require 'aws-sdk' # Using the aws-sdk

# The AWS_ACCESS_KEY_ID and the AWS_SECRET_ACCESS_KEY have to be set as specified here https://github.com/aws/aws-sdk-ruby
Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(YOUR_ACCESS_KEY_ID, YOUR_SECRET_ACCESS_KEY)
})

PRESET_ID = '1351620000001-100070' # ID for the sytem web preset

filename = 'input_video_file.mp4'

##### Upload the input video file to a s3 bucket:

# Get an instance of the S3 interface
s3 = Aws::S3::Resource.new(region:'ap-northeast-1')

# Upload the file into a pre-existing s3 bucket. 
obj = s3.bucket('transcoder-source-input').object(filename) #s3.bucket('bucket-name').object('key')
obj.upload_file('/path/to/file') #/path/to/source/file

# Create a transcoder client
elastictranscoder = Aws::ElasticTranscoder::Client.new(region: 'ap-northeast-1')

# Create a pipeline with the following code below or using the AWS console GUI(http://docs.aws.amazon.com/elastictranscoder/latest/developerguide/creating-pipelines.html)
pipeline_options = {}
pipeline_options[:name] = 'default-pipeline'
pipeline_options[:input_bucket] = 'transcoder-source-input'
pipeline_options[:output_bucket] = 'transcoder-dest-output'
pipeline_options[:role] = iam_role_identifier # Eg: 'arn:aws:iam::444888444994:role/Elastic_Transcoder_Default_Role'

pipeline = elastictranscoder.create_pipeline(pipeline_options)

PIPELINE_ID =  pipeline[:pipeline][:id]

# Create a job
job_options = {}
job_options[:pipeline_id] = PIPELINE_ID
job_options[:input] = {
	key: filename
}
job_options[:output] = {
	key: 'transcoded' + filename,
	preset_id: PRESET_ID,
	thumbnail_pattern: "{count}-#{filename}"
}
job = elastictranscoder.create_job(job_options)
