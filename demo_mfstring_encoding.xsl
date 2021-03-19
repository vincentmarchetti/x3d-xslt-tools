<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl">

<xsl:import href="mfstring_encoding.xsl"/>

<xsl:output method="xml"
            version="1.0"
            encoding="utf-8" />

<xsl:template match="/">
    <tests>
        <xsl:apply-templates select="*"/>
    </tests>
</xsl:template>

<xsl:template match="mfstring">
    <xsl:variable name="items">

        <xsl:call-template name="decode-mfstring">
            <xsl:with-param name="mfstring" select="./@value"/>
        </xsl:call-template>
    
    </xsl:variable>
     
    <decoding-test>
        <xsl:copy-of select="."/>
        
        <decoded-sfstrings>
        <xsl:for-each select="$items/sfstring">
        <decoded-sfstring><xsl:value-of select="string(.)"/></decoded-sfstring>
        </xsl:for-each>
        </decoded-sfstrings>
        
    </decoding-test>
</xsl:template>

<xsl:template match="sfstrings">
    <encoding-test>
        <xsl:copy-of select="."/>
        <encoded-mfstring>
            <xsl:attribute name="value">
            <xsl:call-template name='encode-mfstring'>
                <xsl:with-param name="sfstrings" select="./sfstring"/>
            </xsl:call-template>
            </xsl:attribute>
        </encoded-mfstring>
    </encoding-test>
</xsl:template>

</xsl:stylesheet>
