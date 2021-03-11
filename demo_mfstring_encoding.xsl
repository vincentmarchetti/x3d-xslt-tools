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

<xsl:template match="MFString">
    <xsl:variable name="items">

        <xsl:call-template name="decode-mfstring">
            <xsl:with-param name="mfstring" select="./@value"/>
        </xsl:call-template>
    
    </xsl:variable>
    
    <!-- <xsl:copy-of select="$items"/> -->
    
    <decoding-test>
        <xsl:copy-of select="."/>
        <SFStrings>
            <xsl:for-each select="$items/result/sfstring/text()">
                <SFString><xsl:copy-of select="."/></SFString>
            </xsl:for-each>
        </SFStrings>
    </decoding-test>
</xsl:template>

<xsl:template match="SFStrings">
    <encoding-test>
        <xsl:copy-of select="."/>
        <MFString>
            <xsl:attribute name="value">
            <xsl:call-template name='encode-mfstring'>
                <xsl:with-param name="sfstrings" select="./SFString"/>
            </xsl:call-template>
            </xsl:attribute>
        </MFString>
    </encoding-test>
</xsl:template>

</xsl:stylesheet>
