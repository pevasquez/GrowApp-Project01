/*
 * ImageIO - CGImageProperties.h
 * Copyright (c) 2004-2010 Apple Inc. All rights reserved.
 *
 */

#ifndef __CGIMAGEPROPERTIES__
#define __CGIMAGEPROPERTIES__

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CGBase.h>
#include <ImageIO/ImageIOBase.h>

CF_IMPLICIT_BRIDGING_ENABLED

/* Properties that, if returned by CGImageSourceCopyProperties or 
 * CGImageSourceCopyPropertiesAtIndex, contain a dictionary of file-format 
 * or metadata-format specific key-values. */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGIFDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyJFIFDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyRawDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyCIFFDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyMakerCanonDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyMakerNikonDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyMakerMinoltaDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyMakerFujiDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyMakerOlympusDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyMakerPentaxDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImageProperty8BIMDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyDNGDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyOpenEXRDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_NA);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyMakerAppleDictionary  IMAGEIO_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_7_0);


/** Properties which may be returned by "CGImageSourceCopyProperties".  The
 ** values apply to the container in general but not necessarily to any
 ** individual image that it contains. **/

/* The size of the image file in bytes, if known. If present, the value of
 * this key is a CFNumberRef. */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyFileSize  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);


/** Properties which may be returned by "CGImageSourceCopyPropertiesAtIndex".
 ** The values apply to a single image of an image source file. **/

/* The number of pixels in the x- and y-dimensions. The value of these keys 
 * is a CFNumberRef. */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPixelHeight  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPixelWidth  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* The DPI in the x- and y-dimensions, if known. If present, the value of
 * these keys is a CFNumberRef. */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyDPIHeight  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyDPIWidth  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* The number of bits in each color sample of each pixel. The value of this 
 * key is a CFNumberRef. */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyDepth  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* The intended display orientation of the image. If present, the value 
 * of this key is a CFNumberRef with the same value as defined by the 
 * TIFF and Exif specifications.  That is:
 *   1  =  0th row is at the top, and 0th column is on the left.  
 *   2  =  0th row is at the top, and 0th column is on the right.  
 *   3  =  0th row is at the bottom, and 0th column is on the right.  
 *   4  =  0th row is at the bottom, and 0th column is on the left.  
 *   5  =  0th row is on the left, and 0th column is the top.  
 *   6  =  0th row is on the right, and 0th column is the top.  
 *   7  =  0th row is on the right, and 0th column is the bottom.  
 *   8  =  0th row is on the left, and 0th column is the bottom.  
 * If not present, a value of 1 is assumed. */ 
 
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyOrientation  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* The value of this key is kCFBooleanTrue if the image contains floating- 
 * point pixel samples */ 
 
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIsFloat  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* The value of this key is kCFBooleanTrue if the image contains indexed 
 * (a.k.a. paletted) pixel samples */ 
 
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIsIndexed  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* The value of this key is kCFBooleanTrue if the image contains an alpha 
 * (a.k.a. coverage) channel */ 
 
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyHasAlpha  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* The color model of the image such as "RGB", "CMYK", "Gray", or "Lab".
 * The value of this key is CFStringRef. */ 

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyColorModel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* The name of the optional ICC profile embedded in the image, if known.  
 * If present, the value of this key is a CFStringRef. */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyProfileName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);


/* Possible values for kCGImagePropertyColorModel property */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyColorModelRGB  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyColorModelGray  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyColorModelCMYK  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyColorModelLab  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);


/* Possible keys for kCGImagePropertyTIFFDictionary */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFCompression  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFPhotometricInterpretation  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFDocumentName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFImageDescription  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFMake  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFModel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFOrientation  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFXResolution  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFYResolution  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFResolutionUnit  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFSoftware  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFTransferFunction  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFDateTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFArtist  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFHostComputer  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFCopyright  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFWhitePoint  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyTIFFPrimaryChromaticities  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* Possible keys for kCGImagePropertyJFIFDictionary */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyJFIFVersion  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyJFIFXDensity  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyJFIFYDensity  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyJFIFDensityUnit  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyJFIFIsProgressive  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);


/* Possible keys for kCGImagePropertyExifDictionary */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifExposureTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifExposureProgram  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSpectralSensitivity  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifISOSpeedRatings  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifOECF  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSensitivityType  IMAGEIO_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifStandardOutputSensitivity  IMAGEIO_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifRecommendedExposureIndex  IMAGEIO_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifISOSpeed  IMAGEIO_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifISOSpeedLatitudeyyy  IMAGEIO_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifISOSpeedLatitudezzz  IMAGEIO_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifVersion  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifDateTimeOriginal  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifDateTimeDigitized  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifComponentsConfiguration  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifCompressedBitsPerPixel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifShutterSpeedValue  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifApertureValue  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifBrightnessValue  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifExposureBiasValue  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifMaxApertureValue  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSubjectDistance  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifMeteringMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifLightSource  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFlash  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFocalLength  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSubjectArea  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifMakerNote  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifUserComment  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSubsecTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSubsecTimeOrginal  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSubsecTimeDigitized  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFlashPixVersion  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifColorSpace  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifPixelXDimension  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifPixelYDimension  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifRelatedSoundFile  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFlashEnergy  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSpatialFrequencyResponse  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFocalPlaneXResolution  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFocalPlaneYResolution  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFocalPlaneResolutionUnit  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSubjectLocation  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifExposureIndex  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSensingMethod  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFileSource  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSceneType  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifCFAPattern  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifCustomRendered  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifExposureMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifWhiteBalance  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifDigitalZoomRatio  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifFocalLenIn35mmFilm  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSceneCaptureType  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifGainControl  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifContrast  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSaturation  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSharpness  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifDeviceSettingDescription  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifSubjectDistRange  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifImageUniqueID  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifCameraOwnerName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifBodySerialNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifLensSpecification  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifLensMake  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifLensModel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifLensSerialNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifGamma  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

/* Possible keys for kCGImagePropertyExifAuxDictionary */
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxLensInfo    IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxLensModel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxSerialNumber    IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxLensID  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxLensSerialNumber    IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxImageNumber IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxFlashCompensation   IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxOwnerName   IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyExifAuxFirmware    IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);

/* Possible keys for kCGImagePropertyGIFDictionary */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGIFLoopCount  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGIFDelayTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGIFImageColorMap  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGIFHasGlobalColorMap  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGIFUnclampedDelayTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_4_0);

/* Possible keys for kCGImagePropertyPNGDictionary */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGGamma  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGInterlaceType  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGXPixelsPerMeter  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGYPixelsPerMeter  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGsRGBIntent  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGChromaticities  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGAuthor  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGCopyright  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGCreationTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGDescription  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGModificationTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGSoftware  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyPNGTitle  IMAGEIO_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyAPNGLoopCount  IMAGEIO_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyAPNGDelayTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyAPNGUnclampedDelayTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);

/* Possible keys for kCGImagePropertyGPSDictionary */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSVersion  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSLatitudeRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSLatitude  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSLongitudeRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSLongitude  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSAltitudeRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSAltitude  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSTimeStamp  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSSatellites  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSStatus  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSMeasureMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDOP  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSSpeedRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSSpeed  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSTrackRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSTrack  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSImgDirectionRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSImgDirection  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSMapDatum  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDestLatitudeRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDestLatitude  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDestLongitudeRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDestLongitude  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDestBearingRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDestBearing  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDestDistanceRef  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDestDistance  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSProcessingMethod  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSAreaInformation  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDateStamp  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSDifferental  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyGPSHPositioningError  IMAGEIO_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);

/* Possible keys for kCGImagePropertyIPTCDictionary */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCObjectTypeReference  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCObjectAttributeReference  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCObjectName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCEditStatus  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCEditorialUpdate  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCUrgency  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCSubjectReference  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCCategory  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCSupplementalCategory  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCFixtureIdentifier  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCKeywords  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContentLocationCode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContentLocationName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCReleaseDate  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCReleaseTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCExpirationDate  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCExpirationTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCSpecialInstructions  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCActionAdvised  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCReferenceService  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCReferenceDate  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCReferenceNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCDateCreated  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCTimeCreated  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCDigitalCreationDate  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCDigitalCreationTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCOriginatingProgram  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCProgramVersion  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCObjectCycle  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCByline  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCBylineTitle  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCCity  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCSubLocation  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCProvinceState  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCCountryPrimaryLocationCode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCCountryPrimaryLocationName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCOriginalTransmissionReference  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCHeadline  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCCredit  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCSource  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCCopyrightNotice  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContact  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCCaptionAbstract  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCWriterEditor  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCImageType  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCImageOrientation  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCLanguageIdentifier  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCStarRating  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCCreatorContactInfo  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);  // IPTC Core
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCRightsUsageTerms  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);    // IPTC Core
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCScene  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);               // IPTC Core

/* Possible keys for kCGImagePropertyIPTCCreatorContactInfo dictionary (part of IPTC Core - above) */

IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContactInfoCity  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContactInfoCountry  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContactInfoAddress  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContactInfoPostalCode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContactInfoStateProvince  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContactInfoEmails  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContactInfoPhones  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef kCGImagePropertyIPTCContactInfoWebURLs  IMAGEIO_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0);

/* Possible keys for kCGImageProperty8BIMDictionary */

IMAGEIO_EXTERN const CFStringRef  kCGImageProperty8BIMLayerNames  IMAGEIO_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImageProperty8BIMVersion     IMAGEIO_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);

/* Possible keys for kCGImagePropertyDNGDictionary */

IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyDNGVersion  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyDNGBackwardVersion  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyDNGUniqueCameraModel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyDNGLocalizedCameraModel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyDNGCameraSerialNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyDNGLensInfo  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);


/* Possible keys for kCGImagePropertyCIFFDictionary */

IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFDescription  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFFirmware  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFOwnerName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFImageName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFImageFileName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFReleaseMethod  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFReleaseTiming  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFRecordID  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFSelfTimingTime  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFCameraSerialNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFImageSerialNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFContinuousDrive  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFFocusMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFMeteringMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFShootingMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFLensModel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFLensMaxMM  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFLensMinMM  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFWhiteBalanceIndex  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFFlashExposureComp  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyCIFFMeasuredEV  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);


/* Possible keys for kCGImagePropertyMakerNikonDictionary */

IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonISOSetting  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonColorMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonQuality  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonWhiteBalanceMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonSharpenMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonFocusMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonFlashSetting  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonISOSelection  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonFlashExposureComp  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonImageAdjustment  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonLensAdapter  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef     kCGImagePropertyMakerNikonLensType  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonLensInfo  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonFocusDistance  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonDigitalZoom  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonShootingMode  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonCameraSerialNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerNikonShutterCount  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);

/* Possible keys for kCGImagePropertyMakerCanonDictionary */

IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerCanonOwnerName  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerCanonCameraSerialNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerCanonImageSerialNumber  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerCanonFlashExposureComp  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerCanonContinuousDrive  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerCanonLensModel  IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerCanonFirmware    IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);
IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyMakerCanonAspectRatioInfo IMAGEIO_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_4_0);

/* Possible keys for kCGImagePropertyOpenEXRDictionary */

IMAGEIO_EXTERN const CFStringRef  kCGImagePropertyOpenEXRAspectRatio  IMAGEIO_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_NA);


/* Possible int values for kCGImagePropertyTIFFOrientation */
enum CGImagePropertyOrientation {
    kCGImagePropertyOrientationUp = 1,        // 0th row at top,    0th column on left   - default orientation
    kCGImagePropertyOrientationUpMirrored,    // 0th row at top,    0th column on right  - horizontal flip
    kCGImagePropertyOrientationDown,          // 0th row at bottom, 0th column on right  - 180 deg rotation
    kCGImagePropertyOrientationDownMirrored,  // 0th row at bottom, 0th column on left   - vertical flip
    kCGImagePropertyOrientationLeftMirrored,  // 0th row on left,   0th column at top
    kCGImagePropertyOrientationRight,         // 0th row on right,  0th column at top    - 90 deg CW
    kCGImagePropertyOrientationRightMirrored, // 0th row on right,  0th column on bottom
    kCGImagePropertyOrientationLeft           // 0th row on left,   0th column at bottom - 90 deg CCW
};
typedef enum CGImagePropertyOrientation CGImagePropertyOrientation;

CF_IMPLICIT_BRIDGING_DISABLED

#endif  /* __CGIMAGEPROPERTIES__ */