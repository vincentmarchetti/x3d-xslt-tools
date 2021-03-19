<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xd="http://www.pnp-software.com/XSLTdoc">

<!-- 

Copyright 2021 Vincent Marchetti

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

This code adds documentation elements defined in the open source XSLTDoc project:

 -->

<xd:doc type="stylesheet">
    <xd:short>
    Contains templates to encode and decode lists of strings as X3D MFString value encoded to XML attributes.
    </xd:short>
    
    <xd:detail>
    Reference: <a href="https://www.web3d.org/documents/specifications/19776-1/V3.3/Part01/EncodingOfFields.html#SFString">
    ISO 19771-1:2015 : X3D XML Encoding : MFString Section 5.15</a>
    See https://www.web3d.org/documents/specifications/19776-1/V3.3/Part01/EncodingOfFields.html#SFString
    
    <div>
    two templates below may be used by client script:
    template decode-mfstring is used to create a sequence of string values from a single
    MFString value encoded in an XML attribute. In detail, this template generates an XML fragment
    which may be easily traversed to retrieve each element of the MFString
    </div>
    
    <div>
    template encode-mfstring takes as a parameter a sequence of XSLT nodes. 
    The template returns a text value obtained by taking the string() value of each node
    and encoding that list of strings as a single string which can be the value of the XML attribute
    holding the MFString.
    </div>
    
    Released under MIT License https://opensource.org/licenses/MIT
    See XSLT source for license text
    </xd:detail>
    <xd:author>Vincent Marchetti vmarchetti@kshell.com</xd:author>
    <xd:copyright>2021 Vincent Marchetti</xd:copyright>
</xd:doc>


<!-- 
template decode-mfstring
Takes input parameter mfstring which should be the
XML decoded value of an X3D encoding of MFString
example would be attr-value of '"test1" "test2"' for an MFString
of two elements ['test1', 'test2']
through a recursive sequence of calls to 
recurs-mfstring
gather-sfstring
goto-next-sfstring
handle-sfstring

will generate an XML fragment of a sequence of <sfstring> elements
with inner text of each X3D decoded SFString item from the MFString value
 -->
<xsl:template name="decode-mfstring">
    <xsl:param name="mfstring"/>
    
    <xsl:call-template name="recurs-mfstring">
        <xsl:with-param name="mfstring" select="$mfstring"/>
    </xsl:call-template>
    
</xsl:template>

<xsl:template name="recurs-mfstring">
    <xsl:param name="mfstring"/>
    <xsl:choose>
        <xsl:when test='string-length($mfstring)=0'/>
        
        <xsl:when test="substring($mfstring,1,1)='&quot;'">
            <xsl:call-template name="gather-sfstring">
                <xsl:with-param name="head" select="''"/>
                <xsl:with-param name="tail" select="substring($mfstring,2)"/>
            </xsl:call-template>
        </xsl:when>
        
        <xsl:otherwise> 
            <xsl:message terminate="yes">
            <xsl:text>MFString value must start with quote character</xsl:text>
            <xsl:text> {</xsl:text><xsl:value-of select='$mfstring'/><xsl:text>}</xsl:text>
            </xsl:message>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="gather-sfstring">
    <xsl:param name="head"/>
    <xsl:param name="tail"/>
    <xsl:choose>
        <xsl:when test="string-length($tail)=0">
           <xsl:message terminate="yes">invalid termination of Mfstring valued attribute</xsl:message>
        </xsl:when>
        
        <xsl:when test="substring($tail,1,1)='&quot;'">
            <xsl:call-template name="handle-sfstring">
                <xsl:with-param name="item" select="$head"/>
            </xsl:call-template>
            <xsl:call-template name="goto-next-sfstring">
                <xsl:with-param name="tail" select="substring($tail,2)"/>
            </xsl:call-template>
        </xsl:when>
        
        <xsl:when test="substring($tail,1,2)='\&quot;'">
             <xsl:call-template name="gather-sfstring">
                <xsl:with-param name="head" select="concat($head,'&quot;')"/>
                <xsl:with-param name="tail" select="substring($tail,3)"/>
            </xsl:call-template>
        </xsl:when>
        
        <xsl:when test="substring($tail,1,2)='\\'">
             <xsl:call-template name="gather-sfstring">
                <xsl:with-param name="head" select="concat($head,'\')"/>
                <xsl:with-param name="tail" select="substring($tail,3)"/>
            </xsl:call-template>
        </xsl:when>
        
        <xsl:otherwise>
            <xsl:call-template name="gather-sfstring">
                <xsl:with-param name="head" select="concat($head,substring($tail,1,1))"/>
                <xsl:with-param name="tail" select="substring($tail,2)"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>    
</xsl:template>


<!-- 
wraps the decoded SFstring value in an <sfstring> element
 -->
<xsl:template name="handle-sfstring">
    <xsl:param name="item"/>
    <sfstring><xsl:value-of select="$item"/></sfstring>
</xsl:template>

<xsl:template name="goto-next-sfstring">
    <xsl:param name="tail"/>
        <xsl:choose>
        <xsl:when test="string-length($tail)=0"/>
            
        <xsl:when test="substring($tail,1,1)='&quot;'">
            <xsl:call-template name="recurs-mfstring">
                <xsl:with-param name="mfstring" select="$tail"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="goto-next-sfstring">
                <xsl:with-param name="tail" select="substring($tail,2)"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>    
</xsl:template>

<xsl:template name="encode-mfstring">
    <xsl:param name="sfstrings"/>
    <xsl:for-each select='$sfstrings'>
        <xsl:if test='position() != 1'>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:call-template name="gather-encoded-sfstring">
            <xsl:with-param name="head" select='string(.)'/>
            <xsl:with-param name="tail" select="''"/>
        </xsl:call-template>
    </xsl:for-each>
</xsl:template>


<xsl:template name="gather-encoded-sfstring">
    <xsl:param name="head"/>
    <xsl:param name="tail"/>
    <xsl:choose>
        <xsl:when test="string-length($head)=0">
            <xsl:value-of select="concat('&quot;', $tail, '&quot;')"/>
        </xsl:when>
        
        <xsl:when test="substring($head,1,1)='&quot;'">
            <xsl:call-template  name="gather-encoded-sfstring">
                <xsl:with-param name="head" select="substring($head,2)"/>
                <xsl:with-param name="tail" select="concat($tail,'\&quot;')"/>
            </xsl:call-template>
        </xsl:when>
        
        <xsl:when test="substring($head,1,1)='\'">
            <xsl:call-template  name="gather-encoded-sfstring">
                <xsl:with-param name="head" select="substring($head,2)"/>
                <xsl:with-param name="tail" select="concat($tail,'\\')"/>
            </xsl:call-template>
        </xsl:when>
        
        <xsl:otherwise>
            <xsl:call-template  name="gather-encoded-sfstring">
                <xsl:with-param name="head" select="substring($head,2)"/>
                <xsl:with-param name="tail" select="concat($tail,substring($head,1,1))"/>
            </xsl:call-template>
        </xsl:otherwise>
        
    </xsl:choose>
</xsl:template>
</xsl:stylesheet>

