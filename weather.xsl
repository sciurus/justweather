<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0"
 xmlns="http://www.w3.org/1999/xhtml">

<xsl:template match="/">

  <html>
    <body>

      <xsl:for-each select="rss/channel">
        <h1>
          <xsl:value-of select="title" />
        </h1>
      </xsl:for-each>

      <p>
        <xsl:value-of select="//yweather:condition/@date" />
        <xsl:value-of select="//yweather:condition/@temp" />
      </p>

      <table>

        <xsl:for-each select="//yweather:forecast">
          <tr>
            <td>forecast</td><td class="day">day: <xsl:value-of select="@day" /></td>
          </tr>
          <tr>
            <td></td><td class="date">date: <xsl:value-of select="@date" /></td>
          </tr>
          <tr>
            <td></td><td class="low">low: <xsl:value-of select="@low" /></td>
          </tr>
          <tr>
            <td></td><td class="high">high: <xsl:value-of select="@high" /></td>
          </tr>
        </xsl:for-each>

      </table>

    </body>
  </html>

</xsl:template>

</xsl:stylesheet>
