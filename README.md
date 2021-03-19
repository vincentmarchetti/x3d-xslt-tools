# x3d-xslt-tools
XSLT scripts useful for transformation and manipulation of X3D XML encoding files


## Contents

### mfstring_encoding.xsl
Templates for representing lists of strings as a single X3D-XML encoding of an MFString value; and for
extracting list of strings from an MFString value encoded in XML

### demo_mfstring_encoding.xsl
```
java net.sf.saxon.Transform  -s:testdata/mfstring_tests.xml -xsl:demo_mfstring_encoding.xsl
```

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

[Saxon XSLT engine](http://saxon.sourceforge.net/)

### xmp_metadata.xsl


### convert_xmp_file.xsl
Demonstration script, imports templates from xmp_metadata.xsl to convert an XMP packet serialized to an XML file, to a
X3D MetadataSet node encoded in XML.


java net.sf.saxon.Transform   -s:testdata/sidecar_0001.xmp -xsl:convert_xmp_file.xsl

java net.sf.saxon.Transform   -s:testdata/metadata_0001.xml -xsl:convert_metadata_node.xsl

