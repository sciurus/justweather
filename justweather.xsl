<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0">

<xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

<xsl:template match="/">

  <html>
      <head>
          <title>JustWeather</title>
          <meta charset="utf-8" />
      </head>
    <body>

      <table>

        <xsl:for-each select="//yweather:forecast">
          <tr>
            <td class="forecast"><xsl:value-of select="@text" /></td>
          </tr>
          <tr>
            <td class="low">low: <xsl:value-of select="@low" /></td>
            <td class="high">high: <xsl:value-of select="@high" /></td>
          </tr>
          <tr>
            <td class="day"><xsl:value-of select="@day" /></td>
          </tr>
        </xsl:for-each>

      </table>

    </body>
  </html>

</xsl:template>

</xsl:stylesheet>
