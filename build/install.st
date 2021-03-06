#!/usr/local/bin/scale

| scaleParentDirectory scaleFile scaleUIFile pharoParentDirectory|

" DEPLOY "
system stdout << 'Deploying scale command';cr.

scaleParentDirectory := '/usr/local/scale' asFileReference.

scaleParentDirectory exists 
ifTrue: [ 
	system stderr << 'There is already an installation. Please uninstall before' 
] ifFalse: [
	scaleParentDirectory ensureCreateDirectory.
	scaleFile := scaleParentDirectory  / 'scale'.
	scaleUIFile := scaleParentDirectory / 'scale-ui'.
	system workingDirectory / '..' / 'scale'  copyTo: scaleFile.
	system workingDirectory / '..' / 'scale-ui'  copyTo: scaleUIFile.
  system workingDirectory / '..' / #build / 'uninstall.st' copyTo: scaleParentDirectory / 'uninstall.st'.
	system stdout << 'Deploying Pharo';cr.

	pharoParentDirectory := '/usr/local/pharo' asFileReference.
	pharoParentDirectory ensureCreateDirectory.
	#( 'pharo' 'pharo-vm' 'pharo-ui')
		do: [ :file | system workingDirectory / file  copyAllTo: pharoParentDirectory / file ].

	#( 'Pharo.image' 'Pharo.changes')
		do: [ :file | system workingDirectory / file  copyAllTo: scaleParentDirectory / file ].

	
	system stdout << 'Giving permissions to run';cr.

	system call: 'chmod +x ', (pharoParentDirectory / 'pharo') fullName.
	system call: 'chmod +x ', (pharoParentDirectory / 'pharo-ui') fullName.
	system call: 'chmod +x ', (pharoParentDirectory / 'pharo-vm/pharo') fullName.
  system call: 'chmod +x ', (scaleParentDirectory / 'uninstall.st') fullName.
	system call: 'chmod +x ', scaleFile fullName.
	system call: 'chmod +x ', scaleUIFile fullName.
	system ln: scaleFile to: '/usr/local/bin/scale' asFileReference.
	system ln: scaleUIFile to: '/usr/local/bin/scale-ui' asFileReference.
	system stdout << 'Done!'.


].
