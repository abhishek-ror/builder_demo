require 'rails_helper'
RSpec.describe ::BxBlockPosts::Post, type: :model do

  describe '#media_url' do
    let(:post) { described_class.new }
	it 'returns an array of media URLs' do
	  media = [
	    double('ActiveStorage::Attachment', service_url: 'http://example.com/image1.jpg', content_type: 'image/jpeg'),
	    double('ActiveStorage::Attachment', service_url: 'http://example.com/image2.jpg', content_type: 'image/png')
	  ]
	  allow(post).to receive(:media).and_return(media)

	  result = post.media_url

	  expect(result).to be_an(Array)
	  expect(result.size).to eq(2)
	  expect(result[0]['url']).to eq('http://example.com/image1.jpg')
	  expect(result[0]['content_type']).to eq('image/jpeg')
	  expect(result[1]['url']).to eq('http://example.com/image2.jpg')
	  expect(result[1]['content_type']).to eq('image/png')
	end

  end

  describe '#upload_post_images' do
    let(:post) { described_class.new }
	it 'attaches images to the post' do
	  images_params = [
	    { data: 'data:image/jpeg;base64,base64-encoded-data-1', content_type: 'image/jpeg', filename: 'image1.jpg' },
	    { data: 'data:image/png;base64,base64-encoded-data-2', content_type: 'image/png', filename: 'image2.png' }
	  ]

	  post.upload_post_images(images_params)

	  expect(post.images).to be_attached
	  expect(post.images.count).to eq(2)
	  expect(post.images.first.filename.to_s).to eq('image1.jpg')
	  expect(post.images.first.content_type).to eq('image/jpeg')
	  expect(post.images.last.filename.to_s).to eq('image2.png')
	  expect(post.images.last.content_type).to eq('image/png')
	end

	it 'does not attach images if no data provided' do
	  images_params = [
	    { content_type: 'image/jpeg', filename: 'image1.jpg' },
	    { content_type: 'image/png', filename: 'image2.png' }
	  ]

	  post.upload_post_images(images_params)

	  expect(post.images).not_to be_attached
	end

  end

end