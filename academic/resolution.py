import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
from scipy.signal import find_peaks
from skimage import io, color

# Define the Gaussian function for curve fitting
def gaussian(x, a, x0, sigma):
    return a * np.exp( - (x - x0)**2 / (2 * sigma**2) )

# Function to calculate line pairs per millimeter (lp/mm) based on group and element numbers
def lp_mm(group, element):
    lp_per_mm = 2 ** (group + (element -1)/6)
    return lp_per_mm

# Main function to process the image and calculate resolution and magnification
def process_image(filename, group, element, orientation):
    # Read the image
    img = io.imread(filename)
    
    # Convert to grayscale if the image is in RGB
    if len(img.shape) == 3:
        img_gray = color.rgb2gray(img)
    else:
        img_gray = img
    
    # Convert to double precision (float64)
    img_double = img_gray.astype(np.float64)
    
    # Display the grayscale image
    plt.figure()
    plt.imshow(img_double, cmap='gray')
    plt.title('Grayscale Image')
    plt.axis('off')
    plt.show()
    
    # Calculate lp/mm and line width
    lp_per_mm = lp_mm(group, element)
    line_width_mm = 1 / (2 * lp_per_mm)
    print(f'Group {group}, Element {element}, lp/mm: {lp_per_mm:.2f}, line width: {line_width_mm*1e3:.2f} µm')
    
    # Extract the intensity profile
    if orientation == 'horizontal':
        profile = np.mean(img_double, axis=1)
    elif orientation == 'vertical':
        profile = np.mean(img_double, axis=0)
    else:
        raise ValueError('Orientation must be "horizontal" or "vertical"')
    
    x_val = np.arange(len(profile))
    
    # Plot the intensity profile
    plt.figure()
    plt.plot(x_val, profile)
    plt.title('Intensity Profile')
    plt.xlabel('Pixel Position')
    plt.ylabel('Intensity')
    plt.show()
    
    # Compute the derivative of the intensity profile
    profile_d = np.diff(profile) / np.diff(x_val)
    x_val_d = (x_val[:-1] + x_val[1:]) / 2
    
    # Plot the derivative
    plt.figure()
    plt.plot(x_val_d, profile_d)
    plt.title('Derivative of Intensity Profile')
    plt.xlabel('Pixel Position')
    plt.ylabel('Derivative of Intensity')
    plt.show()
    
    # Fit the derivative to a Gaussian
    initial_guess = [np.max(profile_d), x_val_d[np.argmax(profile_d)], np.std(x_val_d)]
    popt, pcov = curve_fit(gaussian, x_val_d, profile_d, p0=initial_guess)
    a_fit, x0_fit, sigma_fit = popt
    
    # Plot the Gaussian fit
    plt.figure()
    plt.plot(x_val_d, profile_d, label='Data')
    plt.plot(x_val_d, gaussian(x_val_d, *popt), 'r--', label='Gaussian Fit')
    plt.title('Derivative with Gaussian Fit')
    plt.xlabel('Pixel Position')
    plt.ylabel('Derivative of Intensity')
    plt.legend()
    plt.show()
    
    # Extract sigma and calculate FWHM
    sigma = sigma_fit
    FWHM = 2 * np.sqrt(2 * np.log(2)) * sigma
    print(f'Sigma: {sigma:.2f} pixels')
    print(f'FWHM: {FWHM:.2f} pixels')
    
    # Estimate resolution 
    resolution = FWHM  # in pixels
    print(f'Estimated Resolution: {resolution:.2f} pixels')
    
    # Estimate magnification
    # Find peaks in the derivative profile (edges of the lines)
    peaks, _ = find_peaks(profile_d)
    if len(peaks) > 1:
        # Calculate distances between peaks
        peak_distances = np.diff(peaks)
        avg_peak_distance = np.mean(peak_distances)
        print(f'Average distance between peaks: {avg_peak_distance:.2f} pixels')
        
        # Each line pair consists of a dark and light line; so line pair width in pixels
        line_pair_width_pixels = avg_peak_distance
        
        # Calculate effective pixel size
        effective_pixel_size_mm = (1 / lp_per_mm) / line_pair_width_pixels
        print(f'Effective Pixel Size: {effective_pixel_size_mm*1e3:.4f} µm')
        
        # Assuming known camera pixel size 
        camera_pixel_size_um = 1.12  
        magnification = camera_pixel_size_um / (effective_pixel_size_mm * 1e3)
        print(f'Estimated Magnification: {magnification:.2f}x')
    else:
        print('Could not find multiple peaks to estimate magnification.')
    
    return


filename = 'pic1(g4,e2 hor).jpg' 
group = 4  
element = 2  
orientation = 'horizontal' 

process_image(filename, group, element, orientation)
