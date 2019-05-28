# import the necessary packages
from imutils.video import VideoStream
from pyzbar import pyzbar
import argparse
import datetime
import imutils
import time
import cv2
import requests
import RPi.GPIO as GPIO




ap = argparse.ArgumentParser()
ap.add_argument("-o", "--output", type=str, default="barcodes.csv",
	help="path to output CSV file containing barcodes")
args = vars(ap.parse_args())


vs = VideoStream(usePiCamera=True).start()
time.sleep(0.15)

csv = open(args["output"], "w")
found = set()


while True:
	
	frame = vs.read()
	frame = imutils.resize(frame, width=400)

	
	barcodes = pyzbar.decode(frame)

	
	for barcode in barcodes:
		
		(x, y, w, h) = barcode.rect
		cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 0, 255), 2)

		
		barcodeData = barcode.data.decode("utf-8")
		barcodeType = barcode.type

		text = "{} ({})".format(barcodeData, barcodeType)
		cv2.putText(frame, text, (x, y - 10),
			cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)

		
		print (barcodeData)	

		headers = {'APIKEY':'SmartLockOzanSafaBuket'} 
	
		data = {'DeviceSecret':'ZfNROP0EUki_XFuGKlz7zw', 
				'QRCode': barcodeData}
		  
		try:
			r = requests.post("https://securesmartlock.com/api/device/checkpermission", data = data, headers = headers) 
	 

			if(r.status_code==200):

				GPIO.setmode(GPIO.BOARD)    #Board uzerindeki numaralandirmalari gecerli yaptik


				solenoidPinGreenLamp = 15
				solenoidPinLock = 11  

				#GPIO.output(solenoidPin, GPIO.LOW)
				#print("LOW")
				#time.sleep(0.0001) 
				GPIO.setup(solenoidPinGreenLamp, GPIO.OUT)
				GPIO.setup(solenoidPinLock, GPIO.OUT)
				#to configuation


				#to open lock
				GPIO.output(solenoidPinGreenLamp, GPIO.HIGH)
				GPIO.output(solenoidPinLock, GPIO.HIGH)

				print("High")
				time.sleep(5)

				GPIO.output(solenoidPinGreenLamp, GPIO.LOW)
				GPIO.output(solenoidPinLock, GPIO.LOW)
				#print("LOW")


				GPIO.cleanup() # cleanup all GPIO
			else:
				GPIO.setmode(GPIO.BOARD)    #Board uzerindeki numaralandirmalari gecerli yaptik

				solenoidPinRedLamp = 13  


				time.sleep(0.0001) 
				GPIO.setup(solenoidPinRedLamp, GPIO.OUT)
				#to configuation

				#to open lock
				GPIO.output(solenoidPinRedLamp, GPIO.HIGH)

				#print("LOWWWWW")
				time.sleep(2)
				
				GPIO.output(solenoidPinRedLamp, GPIO.LOW)
				#print("LOW")


				GPIO.cleanup() # cleanup all GPIO
			
			csv.write("{}\n".format(barcodeData))
			csv.flush()
			found.add(barcodeData)
			
		except :    # This is the correct syntax
			print ('Baglanti saglanamadi')
			
			
			

	# show the output frame
	cv2.imshow("Barcode Scanner", frame)
	key = cv2.waitKey(1) & 0xFF
	
	
	
 
	# if the `q` key was pressed, break from the loop
	if key == ord("q"):
		break

csv.close()
cv2.destroyAllWindows()
vs.stop()
