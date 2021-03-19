# x3d-xslt-tools
XSLT scripts useful for transformation and manipulation of X3D XML encoding files


## Contents

### mfstring_encoding.xsl
Templates for representing lists of strings as a single X3D-XML encoding of an MFString value; and for
extracting list of strings from an MFString value encoded in XML

### demo_mfstring_encoding.xsl
Script demonstrating use of the mfstring_encoding.xsl templates. This script can be applied to 
an XML file containing <mfstring> and <sfstrings> test cases as shown in this example:


```xml
<?xml version="1.0" encoding="UTF-8" ?>
<testcases>
    <mfstring value="&quot;Tom&quot; &quot;\&quot;Jerry\&quot;&quot; &quot;\\Slashes\\&quot;"/>

    <sfstrings>
        <sfstring>Tom</sfstring>
        <sfstring>"Jerry"</sfstring>
        <sfstring>\Slashes\</sfstring>
    </sfstrings>
</testcases>
```

Result of applying the demo_mfstring_encoding.xsl script will be an XML file; for each <mfstring> element
in the input there will be a decomposition into string values ; and for each <sfstrings> element in the
input there will be the mfstring encoding as an attribute value.

A command line invocation of this script, using the [Saxon XSLT engine](http://saxon.sourceforge.net/) is
[Saxon XSLT engine](http://saxon.sourceforge.net/)
```
java net.sf.saxon.Transform  -s:testdata/mfstring_tests.xml -xsl:demo_mfstring_encoding.xsl
```

### xmp_metadata.xsl
Templates for converting an XMP packet into a X3D MetadataSet node (XML encoding).

### convert_xmp_file.xsl
Demonstration script, imports templates from xmp_metadata.xsl to convert an XMP packet serialized to an XML file, to a
X3D MetadataSet node encoded in XML.

A command line invocation of this script, using the [Saxon XSLT engine](http://saxon.sourceforge.net/) is
[Saxon XSLT engine](http://saxon.sourceforge.net/)

```
java net.sf.saxon.Transform   -s:testdata/sidecar_0001.xmp -xsl:convert_xmp_file.xsl
```
