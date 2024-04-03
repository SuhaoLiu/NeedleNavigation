import cv2

# Read grayscale image
test_image = cv2.imread('path/to/test_image.jpg')
gray_image = cv2.imread('path/to/gray_image.jpg', cv2.IMREAD_GRAYSCALE)

# Convert grayscale image to color image
color_image = cv2.cvtColor(gray_image, cv2.COLOR_GRAY2BGR)

# Display the color image
cv2.imshow('Color Image', color_image)
cv2.waitKey(0)
cv2.destroyAllWindows()