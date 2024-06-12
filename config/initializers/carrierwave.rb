
CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     'hello',
      aws_secret_access_key: 'builderai',
      region:                'builder-1',
      endpoint:              'https://minio.b117228.dev.eastus.az.svc.builder.cafe',
      path_style: true
  }
  config.fog_directory  = 'sbucket'
  config.fog_public     = true
  config.storage = :fog
end