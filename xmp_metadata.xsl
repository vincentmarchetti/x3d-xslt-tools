<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
                xmlns:sgs='http://standards.iso.org/iso/ts/23301/'
                exclude-result-prefixes="rdf sgs">

<xsl:import href="mfstring_encoding.xsl"/>


<xsl:template match="rdf:RDF">
    <xsl:message>In xmp_x3d_metadata matching RDF</xsl:message>
    <xsl:call-template name='xmp-metadata'>
        <xsl:with-param name="descriptions" select="./*"/>
    </xsl:call-template>
</xsl:template>
<!-- 

Example call when the XMP packet is enclosed in a 'sidecar' file.
<xsl:call-template name="xmp-metadata">
    <xsl:with-param name="descriptions" select="document('sidecar.xmp')/rdf:RDF/rdf:Description"/>
</xsl:call-template>}
                
 -->
                
<xsl:template name="xmp-metadata">
    <xsl:param name="descriptions"/>
    <MetadataSet name="XMP" reference="https://www.adobe.com/products/xmp.html">

    <xsl:apply-templates mode='xmp-enc' select='$descriptions/*' />
    </MetadataSet>
</xsl:template>


<!-- 
<xsl:template mode='xmp' match="*">
    <xsl:param name='language-xml' select="./@xml:lang"/>        
    <xsl:apply-templates mode='xmp-enc' select=".">
        <xsl:with-param name='language-xml' select='$language-xml'/>
    </xsl:apply-templates>
</xsl:template>
 -->


<xsl:template mode='xmp-enc' match="*">
    <xsl:param name='language-xml' select="./@xml:lang"/>
    <MetadataString containerField="value">
        <xsl:attribute name="name">
        <xsl:value-of select="local-name()"/>
        </xsl:attribute>

        <xsl:attribute name="reference">
        <xsl:value-of select="namespace-uri()"/>
        </xsl:attribute>

        <xsl:attribute name="value">
        <xsl:call-template name="encode-mfstring">
            <xsl:with-param name="sfstrings" select="./text()"/>
        </xsl:call-template>
        </xsl:attribute>
        
        <xsl:call-template name="language-metadata">
            <xsl:with-param name="language-xml" select="$language-xml"/>
            <xsl:with-param name="containerField" select="'metadata'"/>
        </xsl:call-template>
    </MetadataString>
</xsl:template>

<xsl:template mode='xmp-enc' match="*[rdf:Alt or rdf:Seq or rdf:Bag]">
    <xsl:param name='language-xml' select="./@xml:lang"/>
    <xsl:variable name="container-type" select='local-name(./*)'/>
    <MetadataSet containerField="value">
        <xsl:attribute name="name">
        <xsl:value-of select="local-name()"/>
        </xsl:attribute>

        <xsl:attribute name="reference">
        <xsl:value-of select="namespace-uri()"/>
        </xsl:attribute>
        
        <xsl:choose>
            <xsl:when test="string-length($language-xml)>0">
                <MetadataSet containerField="metadata" name="xmp-metadata">
                    <xsl:call-template name="language-metadata">
                        <xsl:with-param name="language-xml" select="$language-xml"/>
                        <xsl:with-param name="containerField" select="'value'"/>
                    </xsl:call-template>
                    <xsl:call-template name="rdf-container-metadata">
                        <xsl:with-param name="container-type" select="$container-type"/>
                        <xsl:with-param name="containerField" select="'value'"/>
                    </xsl:call-template>
                </MetadataSet>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="rdf-container-metadata">
                    <xsl:with-param name="container-type" select="$container-type"/>
                    <xsl:with-param name="containerField" select="'metadata'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        
        <xsl:apply-templates mode="xmp-enc" select="./*/rdf:li"/>
    </MetadataSet>
</xsl:template>



<xsl:template name="rdf-container-metadata">
    <!-- 
    a string  for example 'Alt','Bag', 'Seq'
    See https://www.w3.org/TR/rdf-schema/#ch_container for RDF container documentation
     -->
    <xsl:param name="container-type"/>
    <xsl:param name="containerField"/>
    
    <MetadataString>
    <xsl:attribute name="containerField"><xsl:value-of select="$containerField"/></xsl:attribute>
    <xsl:attribute name="name">type</xsl:attribute>
    
    <xsl:attribute name="value">
        <xsl:call-template name="encode-mfstring">
            <xsl:with-param name="sfstrings" select="$container-type"/>
        </xsl:call-template>
    </xsl:attribute>
    
    <xsl:attribute name="reference">http://www.w3.org/1999/02/22-rdf-syntax-ns#</xsl:attribute>
    </MetadataString>
    
</xsl:template>

<xsl:template name="language-metadata">
    <xsl:param name="language-xml"/> <!-- should be a node-set of one element, string(.) will be passed to mfstring encoding-->
    <xsl:param name="containerField"/>
    <xsl:if test="string-length(string($language-xml)) > 0">
    <MetadataString>
    <xsl:attribute name="containerField"><xsl:value-of select="$containerField"/></xsl:attribute>
    <xsl:attribute name="name">lang</xsl:attribute>
    <xsl:attribute name="value">
        <xsl:call-template name="encode-mfstring">
            <xsl:with-param name="sfstrings" select="$language-xml"/>
        </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name='reference'>http://www.w3.org/XML/1998/namespace</xsl:attribute>
    </MetadataString>
    </xsl:if>
</xsl:template>


<xsl:template match="MetadataSet[@name='XMP']">
    <rdf:Description>
        <xsl:apply-templates mode="xmp-dec" select="*"/>
    </rdf:Description>
</xsl:template>


<xsl:template mode="xmp-dec" match="MetadataString[@containerField='value']">
    <xsl:variable name="value">
        <xsl:call-template name="decode-mfstring">
            <xsl:with-param name="mfstring" select="./@value"/>
        </xsl:call-template>    
    </xsl:variable>

    <xsl:element name="{./@name}" namespace="{./@reference}">
    <xsl:value-of select="string($value/sfstring)"/>
    </xsl:element>
</xsl:template>

<xsl:template mode="xmp-dec" match="*"/>
</xsl:stylesheet>
