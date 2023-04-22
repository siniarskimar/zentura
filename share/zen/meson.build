filenames = [
	'test_image.jpg',
	'test_image_grayscale.png'
]

foreach file : filenames
	fs.copyfile(file, file, install: true, install_dir: 'share/zen')
endforeach
