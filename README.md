# x3d-xslt-tools
XSLT scripts useful for transformation and manipulation of X3D XML encoding files


## Contents

### mfstring_encoding.xsl
Templates for representing lists of strings as a single X3D-XML encoding of an MFString value; and for
extracting list of strings from an MFString value encoded in XML

java net.sf.saxon.Transform  -s:testdata/mfstring_tests.xml -xsl:demo_mfstring_encoding.xsl


