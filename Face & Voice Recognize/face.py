import cv2
import numpy as np
import face_recognition

picture_of_me = face_recognition.load_image_file("pic/me.jpg")
picture_of_me = cv2.cvtColor(picture_of_me,cv2.COLOR_BGR2RGB)
my_face_encoding = face_recognition.face_encodings(picture_of_me)[0]

unknown_picture = face_recognition.load_image_file("pic/g2.jpg")
unknown_picture =cv2.cvtColor(unknown_picture,cv2.COLOR_BGR2RGB)
unknown_face_encoding = face_recognition.face_encodings(unknown_picture)[0]

results = face_recognition.compare_faces([my_face_encoding], unknown_face_encoding)
face_loc = face_recognition.face_locations(unknown_picture)

for i in range(len(face_loc)):
    cv2.rectangle(unknown_picture,(face_loc[i][3],face_loc[i][0]),(face_loc[i][1],face_loc[i][2]),(255,0,255),2)

cv2.imshow("bb",unknown_picture)

if results[0]:
    print("It's a picture of me!")
else:
    print("It's not a picture of me!")

cv2.waitKey(0)