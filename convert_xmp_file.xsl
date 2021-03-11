<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
                exclude-result-prefixes="rdf">
                
<xsl:import href="xmp_metadata.xsl"/>
<xsl:output method="xml"
            version="1.0"
            encoding="utf-8"/>

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>


<xsl:template match="rdf:RDF">
    <MetadataSet>
    <xsl:apply-imports/>
    </MetadataSet>
</xsl:template>

<xsl:template match="*">
    <xsl:message><xsl:text>Warning: Applying base file template to </xsl:text>
    <xsl:value-of select="local-name()"/>
    </xsl:message>
</xsl:template>

</xsl:stylesheet>
