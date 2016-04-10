#### Ruby Script to encode videos using AWS elastictranscoder

##### Pre-requisites
* Install the ruby sdk using
```gem install 'aws-sdk'```

##### Execution
```ruby aws-elastic-transcoder.rb```

The script does the following operations
- Sets up the AWS config (The keys need to be replaced with your keys as per https://github.com/aws/aws-sdk-ruby)
- Uses available system preset provided by Elastic Transcoder.
- Uploads file specified in /path/to/file to specified s3 bucket
- Creates a pipeline for queing jobs using the Elastic encoder client
- Creates a job
