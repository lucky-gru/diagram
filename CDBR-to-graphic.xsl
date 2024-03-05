<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" version="1.0" exclude-result-prefixes="exsl">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:variable name="version" select="'1.116'"/>
	<xsl:variable name="debug" select="'0'"/>
	
	<xsl:variable name="language">
		<xsl:choose>
			<xsl:when test="//DiscourseUnit[@language]">
				<xsl:value-of select="//DiscourseUnit/@language"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>English</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="showGlosses">
		<xsl:choose>
			<xsl:when test="//DiscourseUnit[@showGlosses]">
				<xsl:value-of select="//DiscourseUnit/@showGlosses"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>1</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="showPhraseGlosses">
		<xsl:choose>
			<xsl:when test="//DiscourseUnit[@showPhraseGlosses]">
				<xsl:value-of select="//DiscourseUnit/@showPhraseGlosses"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>0</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="showAlternatives">
		<xsl:choose>
			<xsl:when test="//DiscourseUnit[@hideAlternatives='1']">
				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:when test="//DiscourseUnit[contains(@highlight, 'phrase')]">
				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>1</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="greyColour" select="'#AAAAAA'"></xsl:variable>
	<xsl:variable name="glossColour" select="'#2D9BF0'"></xsl:variable>
	<xsl:variable name="glossWeight" select="'Bold'"></xsl:variable>
	<xsl:variable name="glossSize" select="12"></xsl:variable>
	<xsl:variable name="alternativeColour" select="'#DE57AD'"></xsl:variable>
	<xsl:variable name="alternativesuffix-pronounColour" select="'#F6CEEA'"></xsl:variable>
	<xsl:variable name="revocalisationColour" select="'#652CB3'"></xsl:variable>
	<xsl:variable name="revocalisationsuffix-pronounColour" select="'#A0A5D8'"></xsl:variable>
	<xsl:variable name="emendationColour" select="'#7EB1FF'"></xsl:variable>
	<xsl:variable name="emendationsuffix-pronounColour" select="'#C2CFE1'"></xsl:variable>
	
	<xsl:template match="/">
		<grammaticalDiagram>
			<configuration>
				<diagram direction="rtl" slantangle="60" showoutlines="false"/>
				<line color="Black" width="1"/>
				<word color="black" weight="normal" size="14"/> <!-- family="Times New Roman"  -->
				<gloss color="{$glossColour}" family="work sans" weight="{$glossWeight}" size="{$glossSize}"/> <!-- family="work sans" -->
			</configuration>
			<!-->
			<xsl:if test="$showAlternatives=0">
				<fragment>
					<straight style="noline" wordcolor="{$alternativeColour}" word="(Note: hiding alternatives)"/>
				</fragment>
				
		</xsl:if>
-->
			<xsl:apply-templates select="./DiscourseUnit|./Clause|./Fragment"/>
		</grammaticalDiagram>
	</xsl:template>
	<!--
	     
	     Discourse Unit
	     
	     -->
	<xsl:template match="DiscourseUnit">
		<!-- debugging -->
		<xsl:if test="$debug='1'">
			<debug>(00.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		<!-- Participant List -->		
		<xsl:if test="contains(@highlight,'participantgroups')">
			<fragment>
				<straight style="noline" wordcolor="green" word="Participant List"/>
			</fragment>
			
			<fragment>
				<xsl:call-template name="participantList"/>
				
			</fragment>
		</xsl:if>		
		
		
		
		<xsl:if test="@description">
			<fragment>
				<straight style="noline" wordcolor="green">
					<!-->
					     <xsl:choose>
					     <xsl:when test="contains(@description, '@version')">
					     <xsl:attribute name="word">
					     <xsl:value-of select="substring-before(@description, '@version')"/>
					     <xsl:value-of select="$version"/>
					     <xsl:value-of select="substring-after(@description, '@version')"/>
					</xsl:attribute>
					</xsl:when>
					     <xsl:otherwise>
					     <xsl:attribute name="word">
					     <xsl:value-of select="@description"/>
					</xsl:attribute>
					     
					</xsl:otherwise>
					</xsl:choose>
					     -->
					<xsl:attribute name="word">
						<xsl:call-template name="string-replace-all">
							<xsl:with-param name="text"> 
								<xsl:call-template name="string-replace-all">
									<xsl:with-param name="text" select="@description"/>
									<xsl:with-param name="replace" select="'@version'"/>
									<xsl:with-param name="by" select="$version"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="replace" select="'@language'"/>
							<xsl:with-param name="by" select="$language"/>
						</xsl:call-template>
					</xsl:attribute>
					
				</straight>
			</fragment>
		</xsl:if>
		
		
		<xsl:choose>
			<xsl:when test="count(descendant::*[@apposition])=2 and count(descendant::Fragment)=2">
				<!-- need containing fragment -->
				<fragment>
					<xsl:apply-templates select="Fragment[1]"/>
					<break word="=" style="noline" length="40" valign="true" />
					<xsl:apply-templates select="Fragment[2]"/>
				</fragment>
			</xsl:when>
			<xsl:when test="count(descendant::*[@align])=2 and count(descendant::Fragment)=2">
				<!-- need containing fragment -->
				<fragment>
					<xsl:apply-templates select="Fragment[1]"/>
					<break style="noline" length="40" valign="true" />
					<xsl:apply-templates select="Fragment[2]"/>
				</fragment>
			</xsl:when>
			<xsl:when test="@showOnly">
				<xsl:apply-templates select="./*[@description=current()/@showOnly]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="./*[not(@skip='yes') ]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="string-replace-all">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = ''or not($replace)" >
				<!-- Prevent this routine from hanging -->
				<xsl:value-of select="$text" />
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	     
	     Fragments
	     
	     -->
	<xsl:template match="Fragment">
		<!-- debugging -->
		<xsl:if test="$debug='1'">
			<debug>(0.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<!-- Description -->
		<xsl:if test="@description">
			<fragment>
				<straight style="noline" wordcolor="green">
					<xsl:attribute name="word">
						<xsl:value-of select="@description"/>
					</xsl:attribute>
				</straight>
			</fragment>
		</xsl:if>
		<!-- Note (= red text) -->
		<xsl:if test="@note">
			<fragment>
				<straight style="noline" wordcolor="red">
					<xsl:attribute name="word">
						<xsl:value-of select="@note"/>
					</xsl:attribute>
				</straight>
			</fragment>
		</xsl:if>
		<!-- Body -->
		<xsl:choose>
			
			<xsl:when test="$showAlternatives=0 and not(*[not(contains(ancestor-or-self::*/@status,'alternative'))])">
				<xsl:if test="$debug='1'">
					<debug>No fragment because all children are alternatives</debug>
				</xsl:if>
			</xsl:when>
			
			
			
			<!-- Vocatives -->
			<xsl:when test="Vocative">
				<fragment>
					<xsl:apply-templates select="Vocative"/>
				</fragment>
				<xsl:if test="Vocative/following-sibling::*">
					<fragment spacebefore="100">
						<xsl:call-template name="participantGroups"/>
						
						<xsl:choose>
							<xsl:when test="ClauseCluster">
								<xsl:apply-templates select="ClauseCluster"/>
							</xsl:when>
							<xsl:when test="count(Clause)=1">
								<xsl:apply-templates select="Clause"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="buildGroup">
									<xsl:with-param name="root" select="*[not(name()='Vocative')]"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</fragment>
				</xsl:if>
			</xsl:when>
			
			<!-- Apposition -->
			<xsl:when test="Apposition">
				<fragment spacebefore="20">
					<xsl:call-template name="participantGroups"/>
					<xsl:apply-templates select="Apposition/child::*[1]"/>
					<straight style="noline" word="="/>
					<xsl:apply-templates select="Apposition/child::*[2]"/>
				</fragment>
			</xsl:when>
			<!-- Other -->
			<xsl:otherwise>
				<fragment spacebefore="20">
					<xsl:if test="@spacebefore">
						<xsl:attribute name="spacebefore">
							<xsl:value-of select="@spacebefore"/>
						</xsl:attribute>
					</xsl:if>
					
					<!-- phrase-level glosses need to be done HERE -->
					<xsl:if test="ancestor::DiscourseUnit[@phrasePosition='absolute' and contains(@highlight,'phrase')] and $showGlosses='1' and $showPhraseGlosses='1'">
						<!-- trying out Adverbial glosses -->
						<xsl:for-each select="descendant::PrepositionalPhrase[@gloss]|descendant::Adverbial[@gloss]">					
							
							<text family="work sans" color="{$glossColour}" size="{$glossSize}">
								<xsl:if test="$debug='1'"><xsl:attribute name="debug">Fragment-level:<xsl:value-of select="@gloss"/></xsl:attribute></xsl:if>
								<xsl:choose>
									<xsl:when test="@x">
										<xsl:attribute name="offsetX"><xsl:value-of select="@x"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="offsetX">-100</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="ancestor::PrepositionalPhrase[@gloss]/@y">
										<xsl:attribute name="offsetY"><xsl:value-of select="@y"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="offsetY">-10</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:attribute name="text">
									<!-->
									<xsl:call-template name="showGloss"/>-->
									<xsl:value-of select="@gloss"/>

								</xsl:attribute>
								
								
								<!-->
								     <xsl:call-template name="adjustGlossWeight">
								     <xsl:with-param name="gloss" select="@gloss"/>
								</xsl:call-template>
								     <xsl:attribute name="weight"><xsl:value-of select="$glossWeight"/></xsl:attribute>
								     -->
							</text>
							
						</xsl:for-each>
					</xsl:if>
					
					
					
					<xsl:call-template name="participantGroups"/>
					<xsl:call-template name="buildGroup">
						<xsl:with-param name="root" select="."/>
					</xsl:call-template>
				</fragment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	     Helper routines
	     -->
	
	<xsl:template name="glossPositioningHelp">
		<xsl:param name="increment" select="50"/>
		
		<ellipse fillcolor="red" width="10" height="10">
			<xsl:attribute name="offsetX"><xsl:value-of select="$increment"/></xsl:attribute>
			<xsl:attribute name="offsetY"><xsl:value-of select="0"/></xsl:attribute>
		</ellipse>
		
		<ellipse fillcolor="orange" width="10" height="10">
			<xsl:attribute name="offsetX"><xsl:value-of select="$increment - 25"/></xsl:attribute>
			<xsl:attribute name="offsetY"><xsl:value-of select="$increment div 4"/></xsl:attribute>
		</ellipse>
		
		<ellipse fillcolor="yellow" width="10" height="10">
			<xsl:attribute name="offsetX"><xsl:value-of select="$increment - 50"/></xsl:attribute>
			<xsl:attribute name="offsetY"><xsl:value-of select="$increment div 2"/></xsl:attribute>
		</ellipse>
		
		<ellipse fillcolor="green" width="10" height="10">
			<xsl:attribute name="offsetX"><xsl:value-of select="$increment - 75"/></xsl:attribute>
			<xsl:attribute name="offsetY"><xsl:value-of select="$increment div 4 * 3"/></xsl:attribute>
		</ellipse>
		
		<ellipse fillcolor="blue" width="10" height="10">
			<xsl:attribute name="offsetX"><xsl:value-of select="$increment - 100"/></xsl:attribute>
			<xsl:attribute name="offsetY"><xsl:value-of select="$increment"/></xsl:attribute>
		</ellipse>
		
		<ellipse fillcolor="purple" width="10" height="10">
			<xsl:attribute name="offsetX"><xsl:value-of select="0"/></xsl:attribute>
			<xsl:attribute name="offsetY"><xsl:value-of select="$increment"/></xsl:attribute>
		</ellipse>
		
		<!-->
		     <xsl:if test="$increment &lt; 400">
		     
		     <ellipse fillcolor="grey" width="10" height="10">
		     <xsl:attribute name="offsetX"><xsl:value-of select="-1 * $increment"/></xsl:attribute>
		     <xsl:attribute name="offsetY"><xsl:value-of select="$increment"/></xsl:attribute>
		</ellipse>
		     <ellipse fillcolor="pink" width="10" height="10">
		     <xsl:attribute name="offsetX"><xsl:value-of select="-1 * $increment"/></xsl:attribute>
		     <xsl:attribute name="offsetY"><xsl:value-of select="0"/></xsl:attribute>
		</ellipse>
		     <ellipse fillcolor="magenta" width="10" height="10">
		     <xsl:attribute name="offsetX"><xsl:value-of select="-1 * $increment"/></xsl:attribute>
		     <xsl:attribute name="offsetY"><xsl:value-of select="-1 * $increment"/></xsl:attribute>
		</ellipse>
		</xsl:if>
		     -->
		
	</xsl:template>
	<xsl:template name="participantList">
		
		<xsl:if test="//@participant='David'">
			<xsl:call-template name="participantListing">
				<xsl:with-param name="participant" select="'David'"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="//@participant='King'">
			<xsl:call-template name="participantListing">
				<xsl:with-param name="participant" select="'King'"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="//@participant='Israel'">
			<xsl:call-template name="participantListing">
				<xsl:with-param name="participant" select="'Israel'"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="//@participant='People'">
			<xsl:call-template name="participantListing">
				<xsl:with-param name="participant" select="'People'"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="//@participant='YHWH'">
			<xsl:call-template name="participantListing">
				<xsl:with-param name="participant" select="'YHWH'"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="//@participant='Enemies'">
			<xsl:call-template name="participantListing">
				<xsl:with-param name="participant" select="'Enemies'"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="//@participant='Nations'">
			<xsl:call-template name="participantListing">
				<xsl:with-param name="participant" select="'Nations'"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="//@participant='Earth'">
			<xsl:call-template name="participantListing">
				<xsl:with-param name="participant" select="'Earth'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>	
	
	<xsl:template name="participantListing">
		<xsl:param name="participant"/>
		
		<straight word="{$participant}">
			<ellipse height="25" offsety="-9">
				<xsl:attribute name="fillcolor">
					<xsl:call-template name="participantColour">
						<xsl:with-param name="participant" select="$participant"/>
						<xsl:with-param name="colourType" select="'highlight'"/>
					</xsl:call-template>
				</xsl:attribute>
				
				<xsl:attribute name="linecolor">
					<xsl:call-template name="participantColour">
						<xsl:with-param name="participant" select="$participant"/>
						<xsl:with-param name="colourType" select="'fill'"/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:attribute name="linewidth">10</xsl:attribute>
			</ellipse>
		</straight>
	</xsl:template>
	
	<xsl:template name="participantColour">
		<xsl:param name="participant"/>
		<xsl:param name="colourType"/>
		
		<xsl:choose>
			<xsl:when test="$participant='David'">
				<xsl:choose>
					<xsl:when test="$colourType='highlight'">#FEF445</xsl:when>
					<xsl:when test="$colourType='border'">#FEF445</xsl:when>
					<xsl:when test="$colourType='fill'">#fcfbe8</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$participant='King'">
				<xsl:choose>
					<xsl:when test="$colourType='highlight'">#8FD14F</xsl:when>
					<xsl:when test="$colourType='border'">#8FD14F</xsl:when>
					<xsl:when test="$colourType='fill'">#DAEACB</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$participant='People' or $participant='Israel'">
				<xsl:choose>
					<xsl:when test="$colourType='highlight'">#2D9BF0</xsl:when>
					<xsl:when test="$colourType='border'">#2D9BF0</xsl:when>
					<xsl:when test="$colourType='fill'">#D0E3F2</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$participant='YHWH'">
				<xsl:choose>
					<xsl:when test="$colourType='highlight'">#BF78F0</xsl:when>
					<xsl:when test="$colourType='border'">#BF78F0</xsl:when>
					<xsl:when test="$colourType='fill'">#e4d0f2</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$participant='Enemies'">
				<xsl:choose>
					<xsl:when test="$colourType='highlight'">#A8A6A6</xsl:when>
					<xsl:when test="$colourType='border'">#A8A6A6</xsl:when>
					<xsl:when test="$colourType='fill'">#E8E0E0</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$participant='Nations' or $participant='Earth'">
				<xsl:choose>
					<xsl:when test="$colourType='highlight'">#7C6F3E</xsl:when>
					<xsl:when test="$colourType='border'">#7C6F3E</xsl:when>
					<xsl:when test="$colourType='fill'">#E3D9B4</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="participantHighlight">
		<xsl:if test="/DiscourseUnit[contains(@highlight, 'participantgroups')] and @participant">
			
			<ellipse height="25" offsety="-9">
				<xsl:attribute name="fillcolor">
					<xsl:call-template name="participantColour">
						<xsl:with-param name="participant" select="@participant"/>
						<xsl:with-param name="colourType" select="'highlight'"/>
					</xsl:call-template>
				</xsl:attribute>
				
				<xsl:attribute name="linecolor">
					<xsl:call-template name="participantColour">
						<xsl:with-param name="participant" select="@participant"/>
						<xsl:with-param name="colourType" select="'fill'"/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:attribute name="linewidth">10</xsl:attribute>
			</ellipse>
			
		</xsl:if>
		
	</xsl:template>
	<xsl:template name="participantGroups">
		<xsl:if test="/DiscourseUnit[contains(@highlight, 'participantgroups')] and @subjectParticipant">
			<ellipse>
				<xsl:attribute name="fillcolor">
					<xsl:call-template name="participantColour">
						<xsl:with-param name="participant" select="@subjectParticipant"/>
						<xsl:with-param name="colourType" select="'fill'"/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:attribute name="linecolor">
					<xsl:choose>
						<xsl:when test="@predicativeParticipant">
							<xsl:call-template name="participantColour">
								<xsl:with-param name="participant" select="@predicativeParticipant"/>
								<xsl:with-param name="colourType" select="'border'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="participantColour">
								<xsl:with-param name="participant" select="@subjectParticipant"/>
								<xsl:with-param name="colourType" select="'border'"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="linewidth">10</xsl:attribute>
			</ellipse>
		</xsl:if>
		
	</xsl:template>
	
	
	
	
	
	
	<xsl:template match="*[@located]|*/Word[@pos='located']" mode="connectorSetup">
		<xsl:if test="$debug='1'">
			<debug>(601.ConnectorSetup.<xsl:value-of select="@status"/>)</debug>
		</xsl:if>		
		
		<!-- create a connector element with the relevant attributes -->
		<connector style="dash">
			<xsl:call-template name="adjustColours"/>
			
			<xsl:attribute name="name">
				<xsl:if test="ancestor::DiscourseUnit[@chapter]"><xsl:value-of select="ancestor::DiscourseUnit[@chapter]/@chapter"/>.</xsl:if>
				<xsl:if test="ancestor::DiscourseUnit[@verse]"><xsl:value-of select="ancestor::DiscourseUnit[@verse]/@verse"/>.</xsl:if>
				<xsl:value-of select="name(current())"></xsl:value-of>.<xsl:value-of select="count(preceding::*[@located or child::Word[@pos='located']])"/>
			</xsl:attribute>
			
			<xsl:if test="(@located='relative clause head' or Word[@pos='located' and @gloss='relative clause head'])
			        and ancestor::RelativeClause/RelativeParticle/Word">
				<xsl:call-template name="wordAndGloss">
					<xsl:with-param name="node" select="ancestor::RelativeClause/RelativeParticle/*"></xsl:with-param>
				</xsl:call-template>
				
				<xsl:if test="ancestor::RelativeClause[1]/RelativeParticle/Word/@status='elided'">
					<xsl:attribute name="wordcolor"><xsl:value-of select="$greyColour"/></xsl:attribute>
				</xsl:if>
				
				
			</xsl:if>
		</connector>
	</xsl:template>
	<xsl:template match="*[@located]|*/Word[@pos='located']" mode="connectorAttributes">
		<xsl:if test="$debug='1'"><xsl:attribute name='debug'>(602.ConnectorAttributes)</xsl:attribute></xsl:if>		
		<!-- set the relevant attributes -->
		<!-->		
		     <straight>
		     <xsl:attribute name="word">( )</xsl:attribute> -->
		
		<xsl:attribute name="connector">
			<xsl:if test="ancestor::DiscourseUnit[@chapter]"><xsl:value-of select="ancestor::DiscourseUnit[@chapter]/@chapter"/>.</xsl:if>
			<xsl:if test="ancestor::DiscourseUnit[@verse]"><xsl:value-of select="ancestor::DiscourseUnit[@verse]/@verse"/>.</xsl:if>
			<xsl:value-of select="name(current())"></xsl:value-of>.<xsl:value-of select="count(preceding::*[@located or Word/@pos='located'])"/>
		</xsl:attribute>
		<!-->
		     <xsl:call-template name="adjustColours"/>
		</straight> -->
	</xsl:template>	
	
	<xsl:template match="*">
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:if test="$debug='1'">
			<debug>(99: generic:<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and contains(@status,'alternative')">
				<xsl:if test="$debug='1'">
					<debug>(Skipping alternative)</debug>
				</xsl:if>
			</xsl:when>
			<!-- actual word requiring a straight -->
			<xsl:when test="name()='Word'">
				<straight>
					<xsl:apply-templates select="." mode="connectorAttributes"/>
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="child::*">
						<xsl:with-param name="modifiers" select="$modifiers"/>
						<xsl:with-param name="constructChain" select="$constructChain"/>
					</xsl:apply-templates>					
					
					<xsl:if test="@located">
						<xsl:apply-templates select="." mode="connectorAttributes"/>
					</xsl:if>
				</straight>
			</xsl:when>
			<!-- attributes for colours and connectors -->
			<xsl:when test="@located">
				<straight>
					<xsl:attribute name="word">( )</xsl:attribute>
					<xsl:apply-templates select="." mode="connectorAttributes"/>
					<xsl:call-template name="adjustColours"/>
				</straight>
			</xsl:when>
			<xsl:otherwise>
				<!-- net yet a word, so no straight -->
				<xsl:apply-templates select="child::*">
					<xsl:with-param name="modifiers" select="$modifiers"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>					
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="buildGroup">
		<xsl:param name="root"/>
		<xsl:param name="style"/>
		<xsl:param name="childrenInGroup" select="$root/child::*"/>
		<xsl:if test="$debug='1'">
			<debug>(buildGroup.<xsl:value-of select="name()"/>.<xsl:value-of select="count($childrenInGroup)"/><xsl:if test="$style">.<xsl:value-of select="$style"/></xsl:if>.alt:<xsl:value-of select="$showAlternatives"/>)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and not($childrenInGroup[not(contains(ancestor-or-self::*/@status,'alternative'))])">
				<xsl:if test="$debug='1'">
					<debug>No group because all children are alternatives</debug>
				</xsl:if>
			</xsl:when>
			
			
			<xsl:when test="count($childrenInGroup)&gt;1">
				
				<xsl:if test="not(descendant::Clause) and ancestor::DiscourseUnit[contains(concat(',',@highlight,','),',phrasewaws,')]">
					<ellipse parentsize="overall" linecolor="#F2E4FC" fillcolor="#F2E4FC" width="200" linewidth="10"/>
				</xsl:if>
				<group>
					<!-- style -->
					<xsl:call-template name="adjustColoursForMarker"/>
					<xsl:choose>
						<xsl:when test="$style and (child::Clause or child::ClauseCluster)">
							<xsl:attribute name="style">dash <xsl:value-of select="$style"/></xsl:attribute>
							<xsl:attribute name="width">0</xsl:attribute>
						</xsl:when>
						<xsl:when test="$style">
							<xsl:attribute name="style">
								<xsl:value-of select="$style"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="child::Clause or child::ClauseCluster">							
							<xsl:attribute name="style">dash</xsl:attribute>							
							<xsl:attribute name="width">0</xsl:attribute>							
						</xsl:when>
					</xsl:choose>
					
					<xsl:for-each select="$childrenInGroup">
						<xsl:choose>
							<xsl:when test="($showAlternatives=0 and ancestor-or-self::*[contains(@status, 'alternative')])
							          and (name()='Conjunction' or @pos='conjunction')">
								<!-- needs a dummy conjunction because the normal one is an alternative -->
								<conjunction/>
								<xsl:if test="$debug='1'"><debug>Dummy Conjunction for Alternative <xsl:value-of select="name()"/> </debug></xsl:if>
							</xsl:when>
							
							<xsl:when test="contains(@status,'alternative') and not(name()='Clause') and not(name()='Conjunction')">
								<!-- alternatives show up after previous items, not on their own -->
								<xsl:if test="$debug='1'">
									<debug>Skipping Alternative for <xsl:value-of select="name()"/></debug>
								</xsl:if>
							</xsl:when>
							
							<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
								<xsl:if test="$debug='1'">
									<debug>Skipping Alternative for <xsl:value-of select="name()"/></debug>
								</xsl:if>
							</xsl:when>
							
							<xsl:when test="name()='Conjunction' or @pos='conjunction'">
								<xsl:if test="position()=1">
									<xsl:if test="$debug='1'">
										<debug>Segment first first item</debug>
									</xsl:if>
									<segment>
										<xsl:if test="not(descendant::Clause) and ancestor::DiscourseUnit[contains(concat(',',@highlight,','),',phrasewaws,')]">
											<ellipse parentsize="overall" fillcolor="#F2E4FC" width="200" linewidth="2" />
										</xsl:if>
										<straight gloss="..."/>
									</segment>
								</xsl:if>
								<xsl:apply-templates select=".">
									<xsl:with-param name="ellipse" select="count(ancestor::DiscourseUnit[contains(concat(',',@highlight,','),',phrasewaws,')])"/>
								</xsl:apply-templates>
								
							</xsl:when>
							<xsl:when test="name()='PrepositionalPhrase' or name()='Adverbial'">
								<segment>
									<!-- NOW DOING ON A STRAIGHT -->
									<xsl:apply-templates select="." mode="straight"/>
								</segment>
								<xsl:if test="position() &lt; count($childrenInGroup) and 
								        following-sibling::*[not(contains(@status,'alternative')) or $showAlternatives=1] and
								        not(name(following-sibling::*[1])='Conjunction' or following-sibling::*[1]/@pos='conjunction'
								        or name(following::*[1])='Conjunction' or following::*[1]/@pos='conjunction')">
									<!-- needs a dummy conjunction -->
									<conjunction/>
									<xsl:if test="$debug='1'"><debug>Dummy Conjunction for <xsl:value-of select="name()"/></debug></xsl:if>
								</xsl:if>
							</xsl:when>
							<xsl:when test="@pos='adjective' and name($root)='Complement'">
								<segment>
									<xsl:apply-templates select="." mode="straight"/> 
								</segment>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$debug='1'">
									<debug>Default items on a straight</debug>
								</xsl:if>
								<!-- default items on a straight -->
								<segment>
									<xsl:apply-templates select="."/>
									
									<!-- include any ONE alternative immediately after -->
									<xsl:if test="following-sibling::*[1][contains(@status,'alternative') and not(name()='Clause') and not(name()='Conjunction')]">
										<xsl:apply-templates select="following-sibling::*[1]"/>
									</xsl:if>
										
								</segment>
								
								<xsl:if test="$debug='1'">
									<debug>ConjunctionCheck:<xsl:value-of select="name()"/>.position:<xsl:value-of select="position()"/></debug>
								</xsl:if>
								
								
								<!-- just removed from following-sibling:  or $showAlternatives=1 -->
								<xsl:if test="position() &lt; count($childrenInGroup) 
								        and following-sibling::*[$showAlternatives=1 or not(contains(@status,'alternative'))] 
								        and 
								        not(name(following-sibling::*[1])='Conjunction' 
								        or following-sibling::*[1]/@pos='conjunction' 
								        or name(following::*[1])='Conjunction'  
								        or following::*[1]/@pos='conjunction')">
									<!-- needs a dummy conjunction -->
									<conjunction/>
									<xsl:if test="$debug='1'"><debug>Dummy Conjunction for <xsl:value-of select="name()"/></debug></xsl:if>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</group>
			</xsl:when>
			
			<xsl:when test="not(contains(name($childrenInGroup[1]), 'Clause')) and not(name($childrenInGroup[1])='Nominal') and not(name($childrenInGroup[1])='ConstructChain')">
				<xsl:if test="$debug='1'">
					<debug>calling straight mode for child <xsl:value-of select="name($childrenInGroup[1])"/></debug>
				</xsl:if>
				<xsl:apply-templates select="$childrenInGroup[1]" mode="straight"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$childrenInGroup[1]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="CasusPendens|Casuspendens">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		
		<xsl:call-template name="VerticallyAlignedElements">
			<xsl:with-param name="article" select="$article"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
			<xsl:with-param name="constructChain" select="$constructChain"/>
			<xsl:with-param name="connectingText" select="' '"/>
		</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template match="Apposition">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		
		<xsl:call-template name="VerticallyAlignedElements">
			<xsl:with-param name="article" select="$article"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
			<xsl:with-param name="constructChain" select="$constructChain"/>
		</xsl:call-template>
		
	</xsl:template>
	
	
	<xsl:template name="VerticallyAlignedElements">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:param name="connectingText" select="'='"/>
		
		<xsl:if test="$debug='1'">
			<debug>(60.1.<xsl:value-of select="name()"/>.Subject?<xsl:value-of select="generate-id(descendant::Word[1])=generate-id(ancestor::Subject/descendant::Word[1])"/>
				<xsl:if test="$constructChain">.cc:<xsl:value-of select="$constructChain/@word"/></xsl:if>
				<xsl:if test="$showAlternatives=0">.non-alternatives:<xsl:value-of select="count(*[not(contains(@status,'alternative'))])"/></xsl:if>
				<xsl:text>)</xsl:text>
			</debug>
		</xsl:if>
		
		<!-- first word of subject, which means put apposition AFTER -->
		<xsl:choose>
			
			<xsl:when test="$showAlternatives=0 and count(*[not(contains(@status,'alternative'))])=1">
				<xsl:if test="$debug='1'">
					<debug>Apposition no longer needed: just one element</debug>
				</xsl:if>
				
				<xsl:apply-templates select="*[not(contains(@status,'alternative'))]">
					<xsl:with-param name="article" select="$article"/>
					<xsl:with-param name="modifiers" select="$modifiers"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>
				
			</xsl:when>
			
			<xsl:when test="$showAlternatives=0 and count(*[contains(@status,'alternative')])&gt;0 and count(*[not(contains(@status,'alternative'))])=2">
				<xsl:if test="$debug='1'">
					<debug>Apposition still needed: two elements left</debug>
				</xsl:if>
				
				<xsl:for-each select="*[not(contains(@status,'alternative'))][position()=1]">
					<!-- only first element gets construct chain -->
					<xsl:call-template name="displayAppositionalElement">
						<xsl:with-param name="article" select="$article"/>
						<xsl:with-param name="modifiers" select="$modifiers"/>
						<xsl:with-param name="constructChain" select="$constructChain"/>
						<xsl:with-param name="connectingText" select="$connectingText"/>
					</xsl:call-template>	
				</xsl:for-each>
				
				
				<xsl:for-each select="*[not(contains(@status,'alternative'))][position() &gt; 1]">
					<xsl:call-template name="displayAppositionalElement">
						<xsl:with-param name="article" select="$article"/>
						<xsl:with-param name="modifiers" select="$modifiers"/>
						<xsl:with-param name="constructChain" select="$constructChain"/>
						<xsl:with-param name="connectingText" select="$connectingText"/>
					</xsl:call-template>					
				</xsl:for-each>
				
				
				
			</xsl:when>
			
			<xsl:when test="generate-id(descendant::Word[1])=generate-id(ancestor::Subject/descendant::Word[1])">
				<!-- items in apposition to the subject -->
				<xsl:for-each select="*[position()&gt;1]">
					<xsl:call-template name="displayAppositionalElement">
						<!-->
						     <xsl:with-param name="article" select="$article"/>
						     <xsl:with-param name="modifiers" select="$modifiers"/>
						     -->
					</xsl:call-template>					
				</xsl:for-each>
				
				<straight style="noline" word="{$connectingText}">
					<xsl:call-template name="adjustColours"/>
				</straight>
				
				<!-- subject itself last -->
				<xsl:apply-templates select="*[position()=1]">
					<xsl:with-param name="article" select="$article"/>
					<xsl:with-param name="modifiers" select="$modifiers"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>
			</xsl:when>		
			
			<xsl:otherwise>
				<xsl:for-each select="*[position()=1]">
					<!-- only first element gets construct chain -->
					<xsl:call-template name="displayAppositionalElement">
						<xsl:with-param name="article" select="$article"/>
						<xsl:with-param name="modifiers" select="$modifiers"/>
						<xsl:with-param name="constructChain" select="$constructChain"/>
						<xsl:with-param name="connectingText" select="$connectingText"/>
					</xsl:call-template>	
				</xsl:for-each>
				
				
				<xsl:for-each select="*[position() &gt; 1]">
					<xsl:call-template name="displayAppositionalElement">
						<xsl:with-param name="article" select="$article"/>
						<xsl:with-param name="modifiers" select="$modifiers"/>
						<xsl:with-param name="constructChain" select="$constructChain"/>
						<xsl:with-param name="connectingText" select="$connectingText"/>
					</xsl:call-template>					
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		
		
	</xsl:template>
	<xsl:template name="displayAppositionalElement">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:param name="connectingText" select="'='"/>
		
		
		<xsl:if test="$debug='1'">
			<debug>(65.Apposition.<xsl:value-of select="name()"/>.<xsl:value-of select="position()"/> of <xsl:value-of select="count(../*)"/>
				<xsl:if test="generate-id()=generate-id(../*[last()])">.last</xsl:if>
				<xsl:text>)</xsl:text>
			</debug>
		</xsl:if>
		
		<xsl:apply-templates select=".">
			<xsl:with-param name="article" select="$article"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
			<xsl:with-param name="constructChain" select="$constructChain"/>
		</xsl:apply-templates>
		
		
		<xsl:if test="$connectingText and following-sibling::*"> 
			<xsl:choose>
				<xsl:when test="name(.)='Adverbial'">
					<slantdown style="noline">
						<straight style="noline" word="{$connectingText}">
							<xsl:call-template name="adjustColours"/>
						</straight>
					</slantdown>
				</xsl:when>
				<xsl:otherwise>
					<straight style="noline" word="{$connectingText}">
						<xsl:call-template name="adjustColours"/>
					</straight>
				</xsl:otherwise>
			</xsl:choose>					
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Appositive">
		<!-- this surrounds only the appositional elements, NOT the ones in the clause -->
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		
		<xsl:if test="$debug='1'">
			<debug>(99.3.Appositive.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		<straight style="noline" word="=">
			<xsl:call-template name="adjustColours"/>
		</straight>
		
		<xsl:apply-templates select="*">
			<xsl:with-param name="article" select="$article"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
		</xsl:apply-templates>
		
		
	</xsl:template>
	<!--
	     
	     Clauses
	     
	     -->
	<xsl:template match="ClauseCluster">
		<xsl:if test="$debug='1'">
			<debug>(2.1.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="Adverbial|SubordinateClause">
				<!-- need a closed group with shared modifiers -->
				<xsl:call-template name="buildGroup">
					<xsl:with-param name="root" select="."/>
					<xsl:with-param name="childrenInGroup" select="Clause|ClauseCluster|Conjunction"/>
					<xsl:with-param name="style" select="'closed'"/>
				</xsl:call-template>
				<!-- handle any modifiers -->
				<xsl:apply-templates select="Adverbial|SubordinateClause"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- no shared modifiers -->
				<xsl:call-template name="buildGroup">
					<xsl:with-param name="root" select="."/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Nominal/ComplementClause|Nominal/Complementclause">
		<xsl:if test="$debug='1'">
			<debug>(2.55.<xsl:value-of select="name()"/>)
			</debug>
		</xsl:if>
		<pedestal>
			<segment>
				<xsl:apply-templates select="Clause"/>
				</segment>
		</pedestal>
	</xsl:template>
	<xsl:template match="ComplementClause|Complementclause">
		<xsl:if test="$debug='1'">
			<debug>(2.56.<xsl:value-of select="name()"/>)
			</debug>
		</xsl:if>
		<xsl:apply-templates select="Clause"/>
	</xsl:template>
	<!-- coordinating conjunctions -->
	<xsl:template match="Conjunction">
		<xsl:param name="ellipse"/>
		<xsl:if test="$debug='1'">
			<debug>(2.11.<xsl:value-of select="name()"/>)
			</debug>
		</xsl:if>
		<xsl:apply-templates select="Word">
			<xsl:with-param name="ellipse" select="$ellipse"/>
		</xsl:apply-templates>
		
	</xsl:template>
	<!-- grouped conjunctions -->
	<xsl:template match="Conjunction[Conjunction]">
		<xsl:if test="$debug='1'">
			<debug>(2.3.<xsl:value-of select="name()"/>)
			</debug>
		</xsl:if>
		<!-- manually merge all right now -->
		<conjunction>
			<xsl:call-template name="adjustColours"/>
			<xsl:attribute name="word">
				<xsl:for-each select="Conjunction/Word">
					<xsl:value-of select="translate(@word, '֪֢̩̩ˌ̩ ֑֖֛֣֤֥֦֧֢֢֚֭֮֒֓֔֕֗֘֙֜֝֞֟֠֡֨֩֫֬', '')"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</xsl:attribute>
			<xsl:attribute name="gloss">
				<xsl:for-each select="Conjunction/Word">
					<xsl:if test="$showGlosses='1'">
						<xsl:choose>
							<xsl:when test="attribute::*[name()=$language]">
								<xsl:value-of select="attribute::*[name()=$language]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@gloss"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</xsl:attribute>
		</conjunction>
	</xsl:template>
	<!-- Clause -->
	<!-- single clause -->
	
	
	<xsl:template match="Clause">
		
		<xsl:if test="$debug='1'">
			<debug>(2.4.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping alternative clause</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
		
		<!-- immediate connectors -->
		<xsl:apply-templates select="descendant::*[contains(@located, 'infinitive construct')
		                     and generate-id(ancestor::Clause[1])=generate-id(current())]
		                     |descendant::*[Word[@pos='located' and contains(@gloss, 'infinitive construct')] 
		                     and generate-id(ancestor::Clause[1])=generate-id(current())]" 
		                     mode="connectorSetup"/>
		<!-- nested connectors -->
		<xsl:apply-templates select="descendant::RelativeClause/descendant::*[contains(@located, 'relative clause head')
		                     and generate-id(ancestor::Clause[2])=generate-id(current())]
		                     |descendant::*[Word[@pos='located' and contains(@gloss, 'relative clause head')] 
		                     and generate-id(ancestor::Clause[1])=generate-id(current())]" 
		                     mode="connectorSetup"/>
		
		<xsl:call-template name="participantGroups"/>
		
		<xsl:if test="Vocative">
			<xsl:apply-templates select="Vocative"/>
			<straight style="noline" word="  "/>
		</xsl:if>
		<!-- 
		     Subject
		     -->
		<xsl:apply-templates select="Subject"/>
		
		<!-- if this is an embedded clause, include the target here -->
		<xsl:choose>
			<xsl:when test="generate-id(.)=generate-id(ancestor::Object/descendant::RelativeClause/descendant::Clause[1])">
				<!-- NO target for relative clauses -->
			</xsl:when>
			<xsl:when test="generate-id(.)=generate-id(ancestor::Object/descendant::Clause[1]) and not(ancestor::Object/descendant::ClauseCluster)">
				<target/>
			</xsl:when>
		</xsl:choose>
		
		<!-- 
		     separate subject from predicate 
		     -->
		<xsl:choose>
			<!-- double slash to indicate an infinitive -->
			<xsl:when test="Predicate/Word[@pos='verb-infinitive']
			          |Predicate/ConstructChain/Word[@pos='verb-infinitive']
			          |Predicate/Predicate/Word[@pos='verb-infinitive']">
				
				<xsl:if test="$debug='1'">
					<debug>(infinitive marker)</debug>
				</xsl:if>
				
				
				<marker style="double both">
					<xsl:call-template name="adjustColoursForMarker"/>
					<!-- 
					     Subordinate Clauses 
					     -->
					<xsl:if test="SubordinateClause">
						<xsl:apply-templates select="SubordinateClause"/>
					</xsl:if>
				</marker>
			</xsl:when>
			<!-- normal single slash for a finite verb -->
			<xsl:otherwise>
				<xsl:if test="$debug='1'">
					<debug>(normal marker)</debug>
				</xsl:if>
				<marker>
					<xsl:call-template name="adjustColoursForMarker"/>
					
					<!-- 
					     Subordinate Clauses 
					     -->
					<xsl:if test="SubordinateClause">
						<xsl:if test="$debug='1'">
							<debug>(SubordinateClause)</debug>
						</xsl:if>
						<xsl:apply-templates select="SubordinateClause"/>
					</xsl:if>
					
				</marker>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 
		     Predicate 
				     -->
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and Predicate/ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
							<debug>Skipping alternative Predicate</debug>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="Predicate"/>
					</xsl:otherwise>
				</xsl:choose>
				
		<!-- 
		     Complement
		     -->
		<xsl:if test="Complement">
			<marker style="up reverse">
				<xsl:call-template name="adjustColoursForMarker"/>
			</marker>
			<xsl:apply-templates select="Complement"/>
		</xsl:if>
		
		
			</xsl:otherwise>
		</xsl:choose>
		
		
		
	</xsl:template>
	<!-- 
	     Predicate 
	     -->
	<xsl:template match="Predicate">
		<xsl:if test="$debug='1'">
			<debug>(3.Predicate)</debug>
		</xsl:if>
		<!-- 1. verb with adverbials (graphically subordinated)-->
		<xsl:choose>
			<xsl:when test="Word[@pos='conjunction']">
				<!-- compound predicate -->
				
				<xsl:choose>
					<xsl:when test="Object|Complement|Adverbial">
						<!-- closed group to enable shared object or complement or adverbials -->
						<xsl:call-template name="buildGroup">
							<xsl:with-param name="root" select="."/>
							<xsl:with-param name="childrenInGroup" select="Word[starts-with(@pos, 'verb')]|Word[@pos='conjunction']|Word[@pos='copula']"/> 
							<xsl:with-param name="style" select="'closed'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<!-- open group -->
						<xsl:call-template name="buildGroup">
							<xsl:with-param name="root" select="."/>
							<xsl:with-param name="childrenInGroup" select="Word[starts-with(@pos, 'verb')]|Word[@pos='conjunction']|Word[@pos='copula']"/> 
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<!-- adverbials belonging to the compound -->
				<xsl:if test="Adverbial|Word[@pos='adverb']">
					
					<straight > 
						<xsl:apply-templates select="Adverbial|Word[@pos='adverb']"/>
					</straight>
				</xsl:if>
				
			</xsl:when>
			<xsl:when test="count(Word[contains(@pos,'verb') or @pos='copula'])&gt;1">
				<!-- multiple verbs that are NOT compound -->
				
				<!-- when there are multiple verbs, do all but the last, without modifiers -->
				<xsl:for-each select="Word[not(contains(@status,'alternative'))][starts-with(@pos,'verb') or @pos='copula'][position() &lt; last()]">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				<!-- last, with modifiers -->
				<xsl:apply-templates select="Word[not(contains(@status,'alternative'))][starts-with(@pos,'verb') or @pos='copula'][last()]">
					<xsl:with-param name="modifiers" select="Adverbial|Word[@pos='adverb']"/>
				</xsl:apply-templates>
				<!-- now alternatives -->				
				<xsl:if test="$showAlternatives=1">
					<xsl:for-each select="Word[contains(@status,'alternative')][starts-with(@pos,'verb') or @pos='copula']">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:when test="Word[starts-with(@pos,'verb') or @pos='copula']">
				<!-- finite verb -->
				<xsl:apply-templates select="Word[starts-with(@pos,'verb') or @pos='copula']">
					<xsl:with-param name="modifiers" select="Adverbial|Word[@pos='adverb']"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="ConstructChain/Word[@pos='verb-infinitive' or @pos='verb-participle']">
				<!-- infinitives and participles -->
				<xsl:apply-templates select="ConstructChain/Word[1]">
					<xsl:with-param name="constructChain" select="ConstructChain/Word[position()&gt;1]"/>
					<xsl:with-param name="modifiers" select="Adverbial|Word[@pos='adverb']"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- verbless clauses -->
				<straight>
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="Adverbial|Word[@pos='adverb']"/>
				</straight>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="PredicateAfterVerb"/>
	</xsl:template>
	
	<xsl:template name="PredicateAfterVerb">
		<xsl:if test="$debug='1'">
			<debug>(3.10.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		<xsl:if test="/DiscourseUnit[contains(@highlight,'phrase')] and (@gloss or attribute::*[name()=$language]) and $showGlosses='1' and $showPhraseGlosses='1'">
			
			<xsl:call-template name="phraseGloss">
				<xsl:with-param name="offsetX">
					<xsl:choose>
						<xsl:when test="@x">
							<xsl:value-of select="@x"/>
						</xsl:when>
						<xsl:otherwise>-250</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>
				<xsl:with-param name="offsetY">
					<xsl:choose>
						<xsl:when test="@y">
							<xsl:value-of select="@y"/>
						</xsl:when>
						<xsl:otherwise>-50</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>
				
				<xsl:with-param name="debugText">3</xsl:with-param>					
				
				<xsl:with-param name="gloss">
					<xsl:choose>
						<xsl:when test="attribute::*[name()=$language]">
							<xsl:value-of select="attribute::*[name()=$language]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@gloss"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>					
				
			</xsl:call-template>						
			
			
		</xsl:if>
		
		<!-- 2. objects -->
		<xsl:if test="Object">
			<marker style="up">
				<xsl:call-template name="adjustColoursForMarker"/>
			</marker>
			<xsl:apply-templates select="Object"/>
		</xsl:if>
		<xsl:if test="SecondObject">
			<marker style="up">
				<xsl:call-template name="adjustColoursForMarker"/>
			</marker>
			<xsl:apply-templates select="SecondObject"/>
		</xsl:if>
		<!-- 3. complements -->
		<xsl:if test="Complement">
			<marker style="up reverse">
				<xsl:call-template name="adjustColoursForMarker"/>
			</marker>
			<xsl:apply-templates select="Complement"/>
		</xsl:if>
		
	</xsl:template>
	<xsl:template match="Predicate[Predicate]">
		<xsl:if test="$debug='1'">
			<debug>(3b: <xsl:value-of select="name()"/>).<xsl:value-of select="count(Predicate | Conjunction | Word | Adverbial)"/>
			</debug>
		</xsl:if>
		<!-- compound predicate -->
		<xsl:choose>
			<!-- PROBLEM: this flattens the compound predicate to all siblings, raising modifiers to equal siblings -->
			
			<xsl:when test="Object|Complement|Adverbial">
				<xsl:call-template name="buildGroup">
					<xsl:with-param name="root" select="."/>
					<xsl:with-param name="childrenInGroup" select="Predicate|Conjunction|Word[@pos='conjunction']"/> <!--  | Conjunction | Word| Adverbial -->
					<xsl:with-param name="style" select="'closed'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="buildGroup">
					<xsl:with-param name="root" select="."/>
					<xsl:with-param name="childrenInGroup" select="Predicate|Conjunction|Word[@pos='conjunction']"/> <!--> | Conjunction | Word| Adverbial"/> -->
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<!-- adverbials -->
		<xsl:if test="(Adverbial or Word[@pos='adverb'])">
			<straight > 
				<xsl:apply-templates select="Adverbial|Word[@pos='adverb']"/>
			</straight>
		</xsl:if>
		<xsl:call-template name="PredicateAfterVerb"/>
	</xsl:template>
	<!--
	     Noun phrase slots
	     -->
	<xsl:template match="Vocative">
		
		<xsl:if test="$debug='1'">
			<debug>(9.0.2.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		<!-- vocative with null subject -->
		<xsl:apply-templates select="*"/>
		
	</xsl:template>
	<xsl:template match="Subject[Vocative and count(child::*)=1]">
		
		<xsl:if test="$debug='1'">
			<debug>(9.0.1.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		<!-- vocative with null subject -->
		<xsl:apply-templates select="Vocative"/>
		
		<straight style="noline" word="="/>
		<straight style="implied" gloss="( )">
			<xsl:call-template name="adjustColours"/>
		</straight>
		
	</xsl:template>
	<xsl:template match="Subject[ConstructChain]|Object[ConstructChain]|Complement[ConstructChain]">
		<xsl:if test="$debug='1'">
			<debug>(4.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<!-- 
		     construct chain + possible modifiers 
		     -->
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping alternative subject</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="ConstructChain">
					<xsl:with-param name="modifiers" select="Word[@pos='article' or @pos='adjective' or @pos='quantifier']"/>
				</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		
	</xsl:template>
	<!--
	     Article and noun/phrase/etc.
	     -->
	<xsl:template match="*[Article and count(child::*)=2]">
		<xsl:if test="$debug='1'">
			<debug>(9.1: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:apply-templates select="child::*[not(name()='Article')]">
			<xsl:with-param name="modifiers" select="Article"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Apposition[Adjectival and count(child::*)=2]">
		<xsl:if test="$debug='1'">
			<debug>(9.2: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<slantdown>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="buildGroup">
				<xsl:with-param name="root" select="."/>
			</xsl:call-template>
		</slantdown>
	</xsl:template>
	
	<xsl:template match="*[Adjectival and count(child::*)=2]">
		<xsl:if test="$debug='1'">
			<debug>(9.3: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:apply-templates select="child::*[not(name()='Adjectival')]">
			<xsl:with-param name="modifiers" select="Adjectival"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	     Phrases 
	     -->
	<xsl:template name="wordOnStraight">
		<!-- 
		     the basic word (should come FIRST in the stylesheet)
		     -->
		<xsl:param name="base" select="Word[@pos='noun' or @pos='verb-participle']"/>
		<!-- can be overridden -->
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:variable name="localModifiers" select="Word[@pos='adjective' and (not($base/@pos='adjective'))]                 
		              |Word[@pos='quantifier' and not($base/@pos='quantifier')]
		              |Adjectival[not($base/@pos='adjective')]
		              |Word[@pos='adverb' and $base/@pos='adjective']
		              |Adverbial[$base/@pos='adjective' or $base/@pos='verb-participle']
		              |Appositive
		              |Apposition"/>
		<xsl:if test="$debug='1'">
			<debug>(20.1.wordOnStraight.<xsl:value-of select="name($base)"/>.<xsl:value-of select="$base/@pos"/><xsl:if test="$modifiers">.mod.<xsl:value-of select="$modifiers/@gloss"/></xsl:if><xsl:if test="$localModifiers">.local.<xsl:value-of select="count($localModifiers)"/>.<xsl:value-of select="name($localModifiers/..)"/></xsl:if>)</debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$article and $modifiers">
				<xsl:apply-templates select="$base" mode="straight">
					<xsl:with-param name="article" select="$article|Word[@pos='article']"/>
					<xsl:with-param name="modifiers" select="$modifiers|$localModifiers"/>
					<xsl:with-param name="subordinateClause" select="child::*[contains(name(),'Clause')]"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$article">
				<xsl:apply-templates select="$base" mode="straight">
					<xsl:with-param name="article" select="$article|Word[@pos='article']"/>
					<xsl:with-param name="modifiers" select="$localModifiers"/>
					<xsl:with-param name="subordinateClause" select="child::*[contains(name(),'Clause')]"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$modifiers">
				<xsl:apply-templates select="$base" mode="straight">
					<xsl:with-param name="article" select="Word[@pos='article']"/>
					<xsl:with-param name="modifiers" select="$modifiers|$localModifiers"/>
					<xsl:with-param name="subordinateClause" select="child::*[contains(name(),'Clause')]"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$base" mode="straight">
					<xsl:with-param name="article" select="Word[@pos='article']"/>
					<xsl:with-param name="modifiers" select="$localModifiers"/>
					<xsl:with-param name="subordinateClause" select="child::*[contains(name(),'Clause')]"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
		<!-- bare pronoun (if here, everything else will have pulled up empty) -->
		<xsl:apply-templates select="Word[@pos='pronoun']"/>
	</xsl:template>
	
	

	<!-- simplest Word within Nominal -->
	<xsl:template match="Subject[Word]|Object[Word]|Complement[Word]|Nominal[Word and not(Clause)]">
		<!-- |Vocative[Word] -->
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:if test="$debug='1'">
			<debug>(20.01.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:call-template name="wordOnStraight">
			<xsl:with-param name="article" select="$article"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
			<xsl:with-param name="constructChain" select="$constructChain"/>
		</xsl:call-template>
	</xsl:template>
	
	
	<!-- particles and suffix-pronouns need to be put on a straight -->
	<xsl:template match="Subject[Word/@pos='particle' or Word/@pos='suffix-pronoun']                
	              |Object[Word/@pos='particle' or Word/@pos='suffix-pronoun']                
	              |Complement[Word/@pos='particle' or Word/@pos='suffix-pronoun']                
	              |Nominal[Word/@pos='particle' or Word/@pos='suffix-pronoun']                
	              |Vocative[Word/@pos='particle' or Word/@pos='suffix-pronoun']">
		<xsl:apply-templates select="*" mode="straight"/>
	</xsl:template>
	
		
	
	<xsl:template match="Object/Nominal[Word[@pos='adverb']]">
		<!-- adverbial accusative -->
		<xsl:if test="$debug='1'">
			<debug>(20.03.adverbial accusative)</debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				<straight>
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="*">
						<xsl:with-param name="style" select="'dash'"/>
					</xsl:apply-templates>
				</straight>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>	
	
	<!-- adjectives and adjectivals have no special attention... but SOMETIMES require a straight! help! -->
	<xsl:template match="Complement[count(child::*)=1 and Word/@pos='adjective']
	              |Complement[count(child::*)=1 and Word/@pos='quantifier']
	              |Complement[count(child::*)=1 and Adverbial]
	              |Complement[count(child::Adjectival)=2 and count(child::*)=2]
	              |Complement[count(child::Adverbial)=2 and count(child::*)=2]
	              |Complement[count(child::*)=1 and Adjectival]">
		<!-- normal modifier -->
		<xsl:if test="$debug='1'">
			<debug>(20.8.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		<straight>
			<xsl:apply-templates select="*"/>
		</straight>
		
	</xsl:template>
	<xsl:template match="Object[Word/@pos='direct object marker' or Word/@pos='particle']">
		<xsl:if test="$debug='1'">
			<debug>(600.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		<xsl:apply-templates select="*[@pos='direct object marker' or @pos='particle']" mode="straight"/>
		<xsl:apply-templates select="Word[@pos='noun']|Nominal">
			<xsl:with-param name="modifiers" select="Word[@pos='adjective'] | Adjectival"/>
			<xsl:with-param name="article" select="Word[@pos='article']"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	<!--
	     
	     Embedded clauses 
	     
	     -->
	<xsl:template match="Subject[Clause]
	              |Nominal[Clause and not(Word)]
	              |Nominal[ComplementClause]
	              |Complement[Clause]
	              |Object[Clause]
	              |Vocative[Clause]
	              |Object[ComplementClause|Complementclause]">
		<!-- embedded clauses get pedestal/segment -->
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(21.0.<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		
		<xsl:apply-templates select="Complementclause/Conjunction/Word|ComplementClause/Conjunction/Word" mode="straight"/>
		
		<!-- embedded clauses -->
		<xsl:for-each select="Clause|ComplementClause/Clause|Complementclause/Clause|Complementclause/ClauseCluster|ComplementClause/ClauseCluster">
			<pedestal>
				<xsl:call-template name="adjustColoursForMarker"/>
				<segment>
					<!-->
					     <xsl:calltemplate name="connectorsForSegment"/>
					     -->
					<xsl:choose>
						<xsl:when test="$modifiers">
							<xsl:apply-templates select=".">
								<!-- include both modifiers passed in as well as articles and adjectives -->
								<xsl:with-param name="modifiers" select="$modifiers|Word"/>
								<xsl:with-param name="article" select="$article"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select=".">
								<xsl:with-param name="modifiers" select="Word"/>
								<xsl:with-param name="article" select="$article"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</segment>
			</pedestal>
			<!-- TEMPORARY 			<xsl:if test="following-sibling::Clause and not(ancestor::DiscourseUnit[contains(@hide,'alternatives')] and (@alternative or @status='alternative'))">
			     <straight length="150">
			     <xsl:call-template name="adjustColoursForMarker"/>
			</straight>
			</xsl:if>
			     -->
			
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="Nominal[Word/@pos='verb' or Word/@pos='copula']
	              |Adjectival/Nominal[Clause and not(Word)]
	              |Adjectival/Nominal/Nominal[Clause and not(Word)]
	              |ConstructChain/Nominal[Clause and not(Word)]">
		<!-- embedded verbs get segment/pedestal/segment -->
		<xsl:param name="modifiers"/>
		<xsl:param name="article"/>
		<xsl:if test="$debug='1'">
			<debug>(20.2).<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/><xsl:if test="$modifiers">.mod:<xsl:value-of select="$modifiers/descendant::Word/@gloss"/></xsl:if></debug>
		</xsl:if>
		<!-- to clarify: when to include a straight?!? -->
		<!-->		 -->
		<xsl:if test="$article">
			<straight>				
				<xsl:call-template name="adjustColoursForMarker"/>
				
				<xsl:apply-templates select="$article"/>
			</straight>
		</xsl:if>			
		<segment>
			<pedestal>
				<xsl:call-template name="adjustColoursForMarker"/>
				<segment>
					<xsl:apply-templates select="Clause">
						<!-->
						     <xsl:with-param name="modifiers" select="$modifiers"/>
						     -->
					</xsl:apply-templates>
				</segment>
			</pedestal>
		</segment>
		<xsl:if test="$modifiers">
			<straight>				
				<xsl:call-template name="adjustColoursForMarker"/>
				<xsl:apply-templates select="$modifiers"/>
			</straight>
		</xsl:if>			
		<!-->		</straight> -->
	</xsl:template>
	<xsl:template match="Adjectival/Nominal[Clause and Word/@pos='article']
	              |Adjectival/Nominal/Nominal[Clause and Word/@pos='article']
	              |ConstructChain/Nominal[Clause and Word/@pos='article']
	              |Nominal[Clause and Word/@pos='article']
	              |RelativeClause/Clause/Subject[Clause]">
		<!-- embedded verbs get segment/pedestal/segment -->
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(20.3).<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/><xsl:if test="$modifiers">.mod:<xsl:value-of select="$modifiers/descendant::Word/@gloss"/></xsl:if></debug>
		</xsl:if>
		<!-- to clarify: when to include a straight?!? -->
		<!-->		<straight> -->
		<straight>				
			<xsl:call-template name="adjustColoursForMarker"/>
			
			<xsl:apply-templates select="Word[@pos='article']"/>
		</straight>
		
		<segment>
			<pedestal>
				<xsl:call-template name="adjustColoursForMarker"/>
				<segment>
					<xsl:apply-templates select="Clause">
						<!-->
						     <xsl:with-param name="modifiers" select="$modifiers"/>
						     -->
					</xsl:apply-templates>
				</segment>
			</pedestal>
		</segment>
		<xsl:if test="$modifiers">
			<straight>				
				<xsl:call-template name="adjustColoursForMarker"/>
				<xsl:apply-templates select="$modifiers"/>
			</straight>
		</xsl:if>			
		<!-->		</straight> -->
	</xsl:template>
	
	
	<!-- embedded clauses, preceded by conjunction, get pedestal with no prior segment -->
	<xsl:template match="Subject[Conjunction and Clause]|Nominal[Conjunction and Clause]|Complement[Conjunction and Clause]|Object[Conjunction and Clause]|Vocative[Conjunction and Clause]">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(21.4<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		<xsl:apply-templates select="Conjunction" mode="straight"/>
		
		<pedestal>
			<xsl:call-template name="adjustColoursForMarker"/>
			<segment>
				<!-->
				     <xsl:calltemplate name="connectorsForSegment"/>
				     -->
				<xsl:choose>
					<xsl:when test="$modifiers">
						<xsl:apply-templates select="Clause">
							<!-- include both modifiers passed in as well as articles and adjectives -->
							<xsl:with-param name="modifiers" select="$modifiers|Word"/>
							<xsl:with-param name="article" select="$article"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="Clause">
							<xsl:with-param name="modifiers" select="Word"/>
							<xsl:with-param name="article" select="$article"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</segment>
		</pedestal>
	</xsl:template>
	
	<!-- embedded clauses with pedestal **AND** prior segment -->
	<xsl:template match="PrepositionalPhrase/Object[Clause]|PrepositionalPhrase/Object/Nominal[Clause]">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(21.2)<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/></debug>
		</xsl:if>
		<segment>
			<xsl:if test="Word[@pos='article']"> <!-- TEST -->
				<straight>
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="Word[@pos='article']"/>
				</straight>
			</xsl:if>
			<pedestal>				
				<xsl:call-template name="adjustColoursForMarker"/>
				<segment>
					<xsl:apply-templates select="Clause">
						<!-->
						     <xsl:with-param name="modifiers" select="$modifiers"/>-->
					</xsl:apply-templates>
				</segment>
			</pedestal>
		</segment>
	</xsl:template>
	<xsl:template match="ClauseCluster/Adverbial">
		<straight>
			<xsl:call-template name="adjustColours"/> <!-- necessary, with length=0? -->
			<xsl:apply-templates select="*"/>			
		</straight>				
	</xsl:template>
	<!-- embedded clauses with pedestal **WITHOUT** prior segment -->
	<xsl:template match="Adverbial[count(child::PrepositionalPhrase)&gt;1]/PrepositionalPhrase/Object[Clause]">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(21.3)<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/></debug>
		</xsl:if>
		<pedestal>
			<xsl:call-template name="adjustColoursForMarker"/>
			<segment>
				<xsl:apply-templates select="*">
					<xsl:with-param name="modifiers" select="$modifiers"/>
				</xsl:apply-templates>
			</segment>
		</pedestal>
	</xsl:template>
	<xsl:template match="Nominal[Nominal and (Word/@pos='article' or Word/@pos='adjective' or Word/@pos='quantifier' or Adjectival)]                
	              |Object[Nominal and (Word/@pos='article' or Word/@pos='adjective' or Word/@pos='quantifier' or Adjectival)]
	              |Complement[Nominal and (Word/@pos='article' or Word/@pos='adjective' or Word/@pos='quantifier' or Adjectival)]
	              |Subject[Nominal and (Word/@pos='article' or Word/@pos='adjective' or Word/@pos='quantifier' or Adjectival)]                
	              |Nominal[Apposition and Word/@pos='article']">
		<!-- nominal with embedded modifier -->
		<xsl:if test="$debug='1'">
			<debug>(20.3a.<xsl:value-of select="name()"/></debug>
		</xsl:if>
		<!-- nominal + possible modifiers -->
		<xsl:apply-templates select="Nominal|Apposition">				
			<xsl:with-param name="article" select="Word[@pos='article']"/>				
			<xsl:with-param name="modifiers" select="Word[@pos='adjective']|Word[@pos='quantifier']|Adjectival"/>				
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Nominal[ancestor::Clause and Word[@pos='verb-participle'] and (descendant::Word[@pos='adjective'] or Adjectival)]                
	              |Object[Word[@pos='verb-participle'] and (descendant::Word[@pos='adjective'] or Adjectival)]                
	              |Complement[Word[@pos='verb-participle'] and (descendant::Word[@pos='adjective'] or Adjectival)]                
	              |Subject[not(descendant::Word[@pos='noun']) and Word[@pos='verb-participle'] and (descendant::Word[@pos='adjective'] or Adjectival)]">
		<!-- CAUTION: formerly matching descendant::Word[@pos='verb-participle']  -->
		<!-- CAUTION #2: formerly matching descendant::Word[@pos='verb-participle']  -->
		<!-- embedded participle with modifier -->
		<xsl:if test="$debug='1'">
			<debug>(20.3.participle.a.<xsl:value-of select="name()"/></debug>
		</xsl:if>
		<pedestal>
			<xsl:call-template name="adjustColoursForMarker"/>
			<segment>
				<!-- nominal + possible modifiers -->
				<xsl:apply-templates select="Nominal|Object|Complement|Subject">				
					<xsl:with-param name="article" select="Word[@pos='article']"/>				
					<xsl:with-param name="modifiers" select="Word[@pos='adjective']|Word[@pos='quantifier']|Adjectival"/>				
				</xsl:apply-templates>
			</segment>
		</pedestal>
		<!-- TEMPORARY WORKAROUND 
		     <straight length="150"/>-->
		
	</xsl:template>
	<xsl:template match="Complement[Word[@pos='verb-participle'] and (descendant::Word[@pos='adjective'] or Adjectival)] ">
		<!-- CAUTION: formerly matching "Complement[descendant::Word[@pos='verb-participle'] and (descendant::Word[@pos='adjective'] or Adjectival)] " -->
		<!-- embedded participle with modifier -->
		<xsl:if test="$debug='1'">
			<debug>(20.3.participle.c.<xsl:value-of select="name()"/></debug>
		</xsl:if>
		<xsl:call-template name="adjustColoursForMarker"/>
		<!-- nominal + possible modifiers -->
		<xsl:apply-templates select="Word[@pos='verb-participle']">				
			<xsl:with-param name="article" select="Word[@pos='article']"/>				
			<xsl:with-param name="modifiers" select="Word[@pos='adjective']|Word[@pos='quantifier']|Adjectival|Adverbial"/>				
		</xsl:apply-templates>
		
	</xsl:template>
	<xsl:template match="Complement[Apposition]">
		<xsl:if test="$debug='1'">
			<debug>(20.3.99.<xsl:value-of select="name()"/></debug>
		</xsl:if>
		<xsl:apply-templates select="Apposition"/>
	</xsl:template>
	
	<xsl:template match="Nominal[Word[@pos='verb-participle'] and (descendant::Word[@pos='adjective'] or Adjectival)]">
		<!-- CAUTION: formerly matched "Nominal[descendant::Word[@pos='verb-participle'] and (descendant::Word[@pos='adjective'] or Adjectival)]" -->
		<!-- embedded participle with modifier -->
		<xsl:if test="$debug='1'">
			<debug>(20.3.participle.b<xsl:value-of select="name()"/></debug>
		</xsl:if>
		<!-- nominal + possible modifiers -->
		<xsl:apply-templates select="descendant::Word[@pos='verb-participle']">				
			<xsl:with-param name="article" select="Word[@pos='article']"/>				
			<xsl:with-param name="modifiers" select="Word[@pos='adjective']|Word[@pos='quantifier']|Adjectival"/>				
		</xsl:apply-templates>
		
	</xsl:template>
	<xsl:template match="Nominal[Nominal and count(child::*)=1]">
		<!-- nominal with embedded nominal -->
		<xsl:if test="$debug='1'">
			<debug>(20.3b<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<!-- nominal + possible modifiers -->
		<xsl:apply-templates select="Nominal">
			<xsl:with-param name="article" select="Word[@pos='article']"/>
			<xsl:with-param name="modifiers" select="Word[@pos='adjective' or @pos='quantifier']"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="Nominal[(Word/@pos='adjective' or Adjectival) and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle') ]
	              |Object[(Word/@pos='adjective' or Adjectival) and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle')] 
	              |Complement[(Word/@pos='adjective' or Adjectival or Word/@pos='verb-participle') and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle')]
	              |Subject[(Word/@pos='adjective' or Adjectival) and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle') ]
	              |Vocative[(Word/@pos='adjective' or Adjectival) and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle')]">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:param name="subordinateClause"/>
		<!-- 
		     substantival adjective
		     -->
		<xsl:if test="$debug='1'">
			<debug>(20.4.substantival adjective for: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<straight style="implied" word="( )">
			<xsl:call-template name="adjustColours"/>
			
			
			<xsl:apply-templates select="Adjectival|Word[not(@pos='article')]">
				<xsl:with-param name="modifiers" select="Adverbial|Word[@pos='article']"/>
			</xsl:apply-templates>
			
			<xsl:if test="$constructChain">
				<xsl:call-template name="buildConstructChain">
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:call-template>
			</xsl:if>
			<!-->
			     <xsl:apply-templates select="*"/>
			     <xsl:if test="$article">
			     <xsl:apply-templates select="$article" mode="overslant"/>
			</xsl:if>
			     <xsl:if test="$modifiers">
			     <xsl:apply-templates select="$modifiers"/>
			</xsl:if>
			     <xsl:if test="$subordinateClause">
			     <xsl:apply-templates select="$subordinateClause"/>
			</xsl:if> 
			     -->
		</straight>
		<xsl:if test="$debug='1'">
			<debug>(exiting 20.4: <xsl:value-of select="name()"/>)
			</debug>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Nominal[(Word/@pos='quantifier') and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle') ]
	              |Object[(Word/@pos='quantifier') and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle')] 
	              |Complement[(Word/@pos='quantifier') and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle')]
	              |Subject[(Word/@pos='quantifier') and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle') ]
	              |Vocative[(Word/@pos='quantifier') and not (Word/@pos='noun' or Word/@pos='pronoun' or Nominal or Word/@pos='suffix-pronoun' or Word/@pos='verb-participle')]">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:param name="subordinateClause"/>
		<!-- 
		     quantifier as pronoun
		     -->
		<xsl:if test="$debug='1'">
			<debug>(20.9: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:call-template name="wordOnStraight" >
			<xsl:with-param name="base" select="Word[@pos='quantifier']"/>
			<xsl:with-param name="article" select="$article"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
			<xsl:with-param name="constructChain" select="$constructChain"/>
			<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
		</xsl:call-template>
	</xsl:template>	
	
	
	<xsl:template match="Nominal[(Word/@pos='quantifier') and ConstructChain ]
	              |Object[(Word/@pos='quantifier') and ConstructChain ] 
	              |Complement[(Word/@pos='quantifier') and ConstructChain ]
	              |Subject[(Word/@pos='quantifier') and ConstructChain ]
	              |Vocative[(Word/@pos='quantifier') and ConstructChain ]">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:param name="subordinateClause"/>
		<!-- 
		     quantifier as modifying a construct chain
		     -->
		<xsl:if test="$debug='1'">
			<debug>(20.99: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:apply-templates select="ConstructChain">
			<xsl:with-param name="modifiers" select="Word[@pos='quantifier']"/>
			<xsl:with-param name="article" select="$article"/>
		</xsl:apply-templates>
	</xsl:template>	
	<xsl:template match="Complement[Adverbial and count(*)=1]">
		<xsl:if test="$debug='1'">
			<debug>(20.5: <xsl:value-of select="name()"/>)
			</debug>
		</xsl:if>
		<straight>
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="*"/>
		</straight>
	</xsl:template>
	
	<xsl:template match="Particle|Adjectival" mode="straight">
		<xsl:if test="$debug='1'">
			<debug>(70.<xsl:value-of select="name(../..)"/></debug>
		</xsl:if>
		<xsl:apply-templates select="*" mode="straight"/>
	</xsl:template>
	<xsl:template match="Adverbial[not(@word)]" mode="straight">
		<xsl:if test="$debug='1'">
			<debug>(75.<xsl:value-of select="name()"/></debug>
		</xsl:if>
		<xsl:apply-templates select="*" mode="straightNoWrapper"/>
	</xsl:template>
	
	<!-- multiple nominals means a group is needed -->
	<xsl:template match="Subject[count(child::*)&gt;1 and not(Adjectival or Word[@pos='adjective' or Word/@pos='quantifier' or @pos='article'])]
	              |Object[Conjunction]|Complement[Conjunction]|Nominal[Conjunction]|Vocative[Conjunction]">
		<xsl:if test="$debug='1'">
			<debug>(20.7b.<xsl:value-of select="name(../..)"/>/<xsl:value-of select="name(..)"/>/<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="../Predicate">
				<xsl:call-template name="buildGroup">					
					<xsl:with-param name="root" select="."/>					
					<xsl:with-param name="style" select="'closed'"/>					
				</xsl:call-template>				
			</xsl:when>
			<xsl:when test="name(..) = 'Subject' or name(../..)='Subject'">
				<xsl:call-template name="buildGroup">					
					<xsl:with-param name="root" select="."/>					
					<xsl:with-param name="style" select="'closed'"/>					
				</xsl:call-template>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="buildGroup">					
					<xsl:with-param name="root" select="."/>					
				</xsl:call-template>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="Nominal[count(child::Word[@pos='noun'])=2]">
		<!-- just group -->
		<xsl:if test="$debug='1'">
			<debug>(60.2.Grouping: <xsl:value-of select="name()"/>)
			</debug>
		</xsl:if>
		<xsl:call-template name="buildGroup">
			<xsl:with-param name="root" select="."/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="ConstructChain/Nominal[count(child::Word[@pos='noun'])=2 and position()=1]">
		<xsl:param name="constructChain"/>
		<!-- just group -->
		<xsl:if test="$debug='1'">
			<debug>(60.2.Grouping: <xsl:value-of select="name()"/>)
			</debug>
		</xsl:if>
		<xsl:call-template name="buildGroup">
			<xsl:with-param name="root" select="."/>
			<xsl:with-param name="style" select="'closed'"/>
		</xsl:call-template>
		<straight>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="buildConstructChain">
				<xsl:with-param name="constructChain" select="$constructChain"/>
			</xsl:call-template>
		</straight>
		
		
	</xsl:template>
	<!--
	     Construct chain
	     -->
	<xsl:template match="ConstructChain">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(6.1: <xsl:value-of select="name()"/>)<xsl:if test="@x">x=<xsl:value-of select="@x"/></xsl:if></debug>
		</xsl:if>
		
		
		<xsl:if test="/DiscourseUnit[contains(@highlight,'phrase')] and (@gloss or attribute::*[name()=$language]) and $showGlosses='1'">
		<!-- gloss -->	
			<xsl:call-template name="phraseGloss">
				<xsl:with-param name="offsetX">
					<xsl:choose>
						<xsl:when test="@x">
							<xsl:value-of select="@x"/>
						</xsl:when>
						<xsl:otherwise>-100</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>
				<xsl:with-param name="offsetY">
					<xsl:choose>
						<xsl:when test="@y">
							<xsl:value-of select="@y"/>
						</xsl:when>
						<xsl:otherwise>50</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>
				
				<xsl:with-param name="debugText">6.1</xsl:with-param>					
				
				
				<xsl:with-param name="gloss">
					<xsl:choose>
						<xsl:when test="attribute::*[name()=$language]">
							<xsl:value-of select="attribute::*[name()=$language]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@gloss"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>					
			</xsl:call-template>						
		</xsl:if>
		
		<xsl:apply-templates select="child::*[not(@pos='quantifier')][1]">
			<xsl:with-param name="constructChain" select="child::*[not(@pos='quantifier')][position()&gt;1]"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="Adverbial/ConstructChain[Word/@pos='adverb']">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(6.5: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:apply-templates select="child::*[1]" mode="straight">
			<xsl:with-param name="constructChain" select="child::*[position()&gt;1]"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
		</xsl:apply-templates>
	</xsl:template>	<!-- group of construct chains -->
	<xsl:template match="ConstructChain[count(child::ConstructChain)&gt;1]
	              |Object[count(child::ConstructChain)&gt;1]">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(6.1b: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:call-template name="buildGroup">
			<xsl:with-param name="root" select="."/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="Object[count(child::Nominal)&gt;1]">
		<xsl:if test="$debug='1'">
			<debug>(6.10: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:call-template name="buildGroup">
			<xsl:with-param name="root" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="Complement[Word/@pos='noun' and Word/@pos='suffix-pronoun']">
		<xsl:if test="$debug='1'">
			<debug>(6.2: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:apply-templates select="child::*[1]">
			<xsl:with-param name="constructChain" select="child::*[position()&gt;1]"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	     Prepositional phrase
	     -->
	<xsl:template match="PrepositionalPhrase">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(10.1: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
		
		<xsl:apply-templates select="Preposition">
			<xsl:with-param name="object" select="Object"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
				</xsl:apply-templates>
				
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<!-- prepositional phrases needing a straight as a wrapper -->
	<xsl:template match="PrepositionalPhrase" mode="straight">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(10.2a: Prepositional)</debug>
		</xsl:if>
		<straight word="( )" style="implied">
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="Preposition">
				<xsl:with-param name="object" select="Object"/>
				<xsl:with-param name="modifiers" select="$modifiers"/>
			</xsl:apply-templates>
		</straight>
	</xsl:template>
	<xsl:template match="Adverbial/PrepositionalPhrase" mode="straight">
		<!-- same as with no wrapper -->
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(10.5aa: Prepositional.straightNoWrapper)</debug>
		</xsl:if>
		<!-->
		     <straight>
		     <xsl:call-template name="adjustColours"/>
		     -->
		<xsl:apply-templates select="Preposition" mode="straight">
			<xsl:with-param name="object" select="Object"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
		</xsl:apply-templates>
		<!-->		</straight> -->
	</xsl:template>
	<xsl:template match="PrepositionalPhrase" mode="straightNoWrapper">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(10.5a: Prepositional.straightNoWrapper)</debug>
		</xsl:if>
		<!-->
		     <straight>
		     <xsl:call-template name="adjustColours"/>
		     -->
		<xsl:apply-templates select="Preposition" mode="straight">
			<xsl:with-param name="object" select="Object"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
		</xsl:apply-templates>
		<!-->		</straight> -->
	</xsl:template>
	<xsl:template match="Nominal/PrepositionalPhrase                |Fragment/PrepositionalPhrase">
		<xsl:if test="$debug='1'">
			<debug>(10.2b: PrepositionalPhrase)</debug>
		</xsl:if>
		<straight word="( )" style="implied">
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="Preposition">
				<xsl:with-param name="modifiers" select="Object"/>
			</xsl:apply-templates>
		</straight>
	</xsl:template>
	<!-- wrapper for prepositional phrase on line (Complement or Fragment) -->
	<xsl:template match="Complement[PrepositionalPhrase]">
		<xsl:if test="$debug='1'">
			<debug>(10.3: Prepositional)</debug>
		</xsl:if>
		<straight>
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="*"/>		
		</straight>
		
	</xsl:template>
	<!--
	     <xsl:template match="Complement/PrepositionalPhrase">
	     <xsl:if test="$debug='1'">
	     <debug>(10.4: Prepositional)</debug>
	</xsl:if>
	     <xsl:apply-templates select="Preposition" mode="complement"/>
	     <xsl:apply-templates select="Object"/>
	</xsl:template> -->
	<!-- phrase containing preposition of prepositional phrase -->
	<xsl:template match="Phrase[Preposition and not(name(..)='Fragment')]">
		<xsl:if test="$debug='1'">
			<debug>(10.5: Prepositional)</debug>
		</xsl:if>
		<xsl:apply-templates select="Preposition">
			<xsl:with-param name="modifiers" select="Object"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	     Preposition itself
	     -->
	<xsl:template match="Preposition">
		<xsl:param name="object"/>
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(10.6a: Preposition:<xsl:value-of select="../Object/*/@gloss"/>)</debug>
		</xsl:if>
		<xsl:apply-templates select="*">
			<xsl:with-param name="object" select="$object"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
			<xsl:with-param name="ellipse" select="ancestor::DiscourseUnit[contains(concat(',', @highlight, ','), ',prepositionalphrases,')]/@highlight"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="Preposition" mode="complement">
		<xsl:param name="object"/>
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(10.6b: Preposition:<xsl:value-of select="../Object/*/@gloss"/>)	</debug>
		</xsl:if>
		<xsl:apply-templates select="*" mode="straight">
			<xsl:with-param name="object" select="$object"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Preposition" mode="straight">
		<xsl:param name="object"/>
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(10.6c: Preposition.straight:<xsl:value-of select="count($object)"/>)	</debug>
		</xsl:if>
		<xsl:apply-templates select="*" mode="straight">
			<xsl:with-param name="object" select="$object"/>
			<xsl:with-param name="modifiers" select="$modifiers"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	     Adverbial and Adjectival
	     -->
	<xsl:template match="Adverbial[not(name(..)='ClauseCluster')]|Adjectival|Word[@pos='adverb']">
		<xsl:if test="$debug='1'">
			<debug>(40.0: Adverbial or Adjectival)</debug>
		</xsl:if>
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template match="Adverbial[PrepositionalPhrase]">
		<xsl:if test="$debug='1'">
			<debug>(40.07: Adverbial containing Prepositional phrase)</debug>
		</xsl:if>
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template match="ClauseCluster/Adverbial">
		<xsl:if test="$debug='1'">
			<debug>(40.08: Adverbial or Adjectival)</debug>
		</xsl:if>
		<straight>
			<xsl:if test="@drop">
				<xsl:attribute name="length">25</xsl:attribute>
				<!-- slantdown will also need a height of the @drop value -->
			</xsl:if>
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="*"/>
		</straight>
	</xsl:template>
	<xsl:template match="Adverbial[(Adverbial or count(child::*)&gt;1) and descendant::Word/@pos='verb-participle']                
	              |Adjectival[count(child::*)&gt;1 and descendant::Word/@pos='verb-participle']">
		<!-- group modifiers -->
		<xsl:if test="$debug='1'">
			<debug>(40.8: Adverbial/Adjectival)</debug>
		</xsl:if>
		<slantdown>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="buildGroup">
				<xsl:with-param name="root" select="."/>
			</xsl:call-template>
		</slantdown>
	</xsl:template>
	<xsl:template match="Adverbial[PrepositionalPhrase and count(child::*)&gt;1]                
	              |Adjectival[PrepositionalPhrase and count(child::*)&gt;1]">
		<xsl:if test="$debug='1'">
			<debug>(40.9a: Adverbial/Adjectival)
			</debug>
		</xsl:if>
		<slantdown>
			
			<xsl:call-template name="adjustColours"/>
			
			
			<xsl:if test="descendant::*[@located] or descendant::*[@pos='located']">
				<!-- hard-coded right now! -->
				<xsl:attribute name="height">250</xsl:attribute>
			</xsl:if>
			
			
			
			<xsl:call-template name="buildGroup">
				<xsl:with-param name="root" select="."/>
			</xsl:call-template>
		</slantdown>
	</xsl:template>
	<xsl:template match="Adverbial[Adverbial or count(child::*)&gt;1]                
	              |Adjectival[Adjectival or count(child::*)&gt;1]">
		<!-- group of multiple modifiers -->
		<xsl:if test="$debug='1'">
			<debug>(40.100: Adverbial/Adjectival)</debug>
		</xsl:if>
		<slantdown>
			<xsl:if test="@drop">
				<xsl:attribute name="height"><xsl:value-of select="@drop"/></xsl:attribute>
				<!-- slantdown will also need a height of the @drop value -->
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="@word">
					<xsl:call-template name="adjustColours"/>
					<xsl:call-template name="wordAndGloss"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="adjustColours">
						<xsl:with-param name="noWordColor">1</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:call-template name="buildGroup">
				<xsl:with-param name="root" select="."/>
			</xsl:call-template>
		</slantdown>
	</xsl:template>
	<xsl:template match="Adverbialx[Adverbial or count(child::*)&gt;1]                
	              |Adjectivalx[Adjectival or count(child::*)&gt;1]">
		<!-- multiple slanting modifiers -->
		<xsl:if test="$debug='1'">
			<debug>(40.1: Adverbial/Adjectival)</debug>
		</xsl:if>
		<multislant>
			<xsl:call-template name="adjustColours">
				<xsl:with-param name="noWordColor">1</xsl:with-param>
			</xsl:call-template>
			
			<xsl:apply-templates select="*"/>
		</multislant>
	</xsl:template>
	
	<xsl:template match="Adjectival[Word and Adverbial]
	              |Adjectival[Word/@pos='article' and Word/@pos='adjective']">
		<!-- overslant needed -->
		<xsl:if test="$debug='1'">
			<debug>(40.4a: Adverbial/Adjectival)</debug>
		</xsl:if>
		<xsl:apply-templates select="Word[not(@pos='article')]">
			<xsl:with-param name="modifiers" select="Adverbial|Word[@pos='article']"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Adverbial[Word and (Adverbial or PrepositionalPhrase)]
	              |Adverbial[PrepositionalPhrase and Adverbial]
	              |Adjectival[PrepositionalPhrase and Adverbial]">
		<!-- overslant needed -->
		<xsl:if test="$debug='1'">
			<debug>(40.4b: Adverbial needing overslant)</debug>
		</xsl:if>
		<xsl:apply-templates select="*[1]"> <!-- Word[not(@pos='article')] -->
			<xsl:with-param name="modifiers" select="*[2]"/> <!-- Adverbial|Word[@pos='article'] -->
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Complement/Adjectival[Word and Adverbial]">
		<!-- NO overslant needed, because this is going on a straight -->
		<xsl:if test="$debug='1'">
			<debug>(40.4.Complement: Adverbial/Adjectival)</debug>
		</xsl:if>
		<xsl:apply-templates select="Word" mode="straight">
			<xsl:with-param name="modifiers" select="Adverbial"/>
		</xsl:apply-templates>
	</xsl:template>	
	<xsl:template match="Adjectival[Word/@pos='verb-participle' and count(child::*)&gt;1 and not(Word[@pos='adjective' or @pos='quantifier' or @pos='article'])]">
		<!-- multiple adjectival participles that belong on a straight -->
		<xsl:if test="$debug='1'">
			<debug>(40.3: Adverbial/Adjectival)</debug>
		</xsl:if>
		<slantdown>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="buildGroup">
				<xsl:with-param name="root" select="."/>
			</xsl:call-template>
		</slantdown>
	</xsl:template>
	
	<xsl:template match="Adjectival[Conjunction]">
		<!-- compound adjectival -->
		<xsl:if test="$debug='1'">
			<debug>(40.3compound: Adverbial/Adjectival)</debug>
		</xsl:if>
		<slantdown>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="buildGroup">
				<xsl:with-param name="root" select="."/>
			</xsl:call-template>
		</slantdown>
	</xsl:template>	
	
	<xsl:template match="Adjectival[Word[@pos='verb-participle'] and Word[@pos='article']]">
		<!-- substantival adjectival participles -->
		<xsl:if test="$debug='1'">
			<debug>(40.33: Adverbial/Adjectival)</debug>
		</xsl:if>
		<slantdown style="round">
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="Word[@pos='verb-participle']">
				<xsl:with-param name="modifiers" select="Word[@pos='article']"/>
			</xsl:apply-templates>
		</slantdown>
	</xsl:template>	
	<xsl:template match="Adverbial[Adverbial or count(child::*)&gt;1]                |Adjectival[Adjectival or count(child::*)&gt;1]" mode="straight">
		<!-- needing to be on a straight -->
		<xsl:if test="$debug='1'">
			<debug>(40.2: Adverbial/Adjectival-straight-overslant)</debug>
		</xsl:if>
		<straight>
			<xsl:call-template name="adjustColours"/>
			<!-- NOT a multislant, but rather an OVERslant! -->
			<xsl:apply-templates select="Word">
				<xsl:with-param name="modifiers" select="Adverbial"/>
			</xsl:apply-templates>
		</straight>
	</xsl:template>
	<xsl:template match="Adjectival[Word/@pos='verb-participle' and count(*)=1]|Adverbial[Word/@pos='verb-participle' and count(*)= 1]">
		<xsl:if test="$debug='1'">
			<debug>(40.22: Adverbial/Adjectival-slantdown-participle)</debug>
		</xsl:if>
		<!-- participle is on a straight -->
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				<slantdown style="round">
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="Word"/>
				</slantdown>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Adjectival[Word/@pos='verb-participle' and Adverbial]">
		<xsl:if test="$debug='1'">
			<debug>(40.23: Adverbial/Adjectival-slantdown-with-modifier)</debug>
		</xsl:if>
		<!-- participle is on a straight, with the adverbial as a modifier -->
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				
				<slantdown style="round">
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="Word">
						<xsl:with-param name="modifiers" select="Adverbial"/>
					</xsl:apply-templates>
				</slantdown>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Adjectival[Clause]|Adverbial[Clause]">
		<!-- embedded clause as adjectival -->
		<xsl:if test="$debug='1'">
			<debug>(40.01a)</debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				
				<slantdown style="dash">
					<xsl:call-template name="adjustColours"/>
					<segment>
						<pedestal>
							<xsl:call-template name="adjustColoursForMarker"/>
							<segment>
								<xsl:apply-templates select="*"/>
							</segment>
						</pedestal>
					</segment>
				</slantdown>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Adjectival[Clause/Predicate/Word[@pos='verb-infinitive']]
	              |Adverbial[Clause/Predicate/Word[@pos='verb-infinitive']]">
		<!-- embedded clause as adjectival -->
		<xsl:if test="$debug='1'">
			<debug>(40.01aa)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				<slantdown>
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="*"/>
				</slantdown>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	<xsl:template match="Adverbial[Word/@pos='noun' or Word/@pos='verb' or Word/@pos='copula' or Word/@pos='verb-infinitive']
	              |Adverbial[Nominal]|Adjectival[Nominal]
	              |Adverbial[ConstructChain]|Adjectival[ConstructChain]">
		<!-- adverbial accusative -->
		<xsl:if test="$debug='1'">
			<debug>(40.02a)</debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				
				<!-- phrase-level glosses -->
				<xsl:if test="@gloss and ancestor::DiscourseUnit[contains(@highlight,'phrase') and not(@phrasePosition='absolute')] and $showGlosses='1'">
					
					
					<xsl:call-template name="phraseGloss">
						<xsl:with-param name="offsetX">
							<xsl:choose>
								<xsl:when test="@x">
									<xsl:value-of select="@x"/>
								</xsl:when>
								<xsl:otherwise>-100</xsl:otherwise>
							</xsl:choose>
							
						</xsl:with-param>
						<xsl:with-param name="offsetY">
							<xsl:choose>
								<xsl:when test="@y">
									<xsl:value-of select="@y"/>
								</xsl:when>
								<xsl:otherwise>-10</xsl:otherwise>
							</xsl:choose>
							
						</xsl:with-param>
						
						<xsl:with-param name="gloss">
							<xsl:choose>
								<xsl:when test="attribute::*[name()=$language]">
									<xsl:value-of select="attribute::*[name()=$language]"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@gloss"/>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:with-param>					
						
					</xsl:call-template>			
					
					
					
				</xsl:if>
				     
				
				<slantdown style="dash">
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="*"/>
				</slantdown>
				
				
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<xsl:template match="Adjectival[Nominal/Word/@pos='verb-participle']">
		<!-- participial adjectival -->
		<xsl:if test="$debug='1'">
			<debug>(40.05.participial.adjective)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				<slantdown style="round">
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="*"/>
				</slantdown>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Adverbial[ConstructChain/Word[@pos='adverb']]|Adjectival[ConstructChain/Word[@pos='adjective' or @pos='quantifier']]">
		<!-- adverbial or adjectival beginning a construct chain -->
		<xsl:if test="$debug='1'">
			<debug>(40.02c)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				<slantdown>
					<xsl:call-template name="adjustColours"/>
					<xsl:apply-templates select="*"/>
				</slantdown>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Adverbial[Word/@pos='noun']" mode="straight">
		<xsl:if test="$debug='1'">
			<debug>(40.01b)
			</debug>
		</xsl:if>
		<straight>
			<xsl:call-template name="adjustColours"/>
			<slantdown style="dash">
				<xsl:call-template name="adjustColours"/>
				<xsl:apply-templates select="*"/>
			</slantdown>
		</straight>
	</xsl:template>
	<xsl:template match="Adjectival[Clause]" mode="straight">
		<xsl:if test="$debug='1'">
			<debug>(40.02b)
			</debug>
		</xsl:if>
		<straight>
			<xsl:call-template name="adjustColours"/>
			<slantdown>
				<xsl:call-template name="adjustColours"/>
				<segment>
					<pedestal>
						<xsl:call-template name="adjustColoursForMarker"/>
						<segment>
							<xsl:apply-templates select="*"/>
						</segment>
					</pedestal>
				</segment>
			</slantdown>
		</straight>
	</xsl:template>
	<!--
	     Words
	     -->
	<xsl:template match="Word">
		<!-- default (on a straight) -->
		<xsl:param name="modifiers"/>
		<xsl:param name="article"/>
		<xsl:param name="subordinateClause"/>
		<xsl:param name="constructChain"/>
		<xsl:if test="$debug='1'">
			<debug>(100.0: <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		<xsl:call-template name="straightWithAllModifiers">
			<xsl:with-param name="modifiers" select="$modifiers"/>
			<xsl:with-param name="article" select="$article"/>
			<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
			<xsl:with-param name="constructChain" select="$constructChain"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="Word" mode="down">
		<!-- straight down -->
		<xsl:param name="style"/>
		<xsl:param name="subordinateClause"/>
		<xsl:if test="$debug='1'">
			<debug>(100.0: <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		<down>
			<xsl:call-template name="adjustColours"/>
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*[@status='elided'] and $style">
					<!-- group elision plus any passed in style -->
					<xsl:attribute name="style"><xsl:value-of select="$style"/> implied</xsl:attribute>
				</xsl:when>
				<xsl:when test="ancestor-or-self::*[@status='elided']">
					<!-- group elision on its own-->
					<xsl:attribute name="style">implied</xsl:attribute>
				</xsl:when>
				<xsl:when test="$style">
					<xsl:attribute name="style">
						<xsl:value-of select="$style"/>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:call-template name="wordAndGloss"/>
			<xsl:if test="$subordinateClause">
				<!-- XSLT 1.0 RESULTS TREE FRAGMENT 
				     <xsl:apply-templates select="$subordinateClause"/> -->
				
				<xsl:apply-templates select="exsl:node-set($subordinateClause)"/>
			</xsl:if>
		</down>
	</xsl:template>
	
	<!-- explicitly on a straight -->
	<xsl:template match="Word" mode="straight">
		<xsl:param name="modifiers"/>
		<xsl:param name="article"/>
		<xsl:param name="subordinateClause"/>
		<xsl:param name="constructChain"/>
		<xsl:if test="$debug='1'">
			<debug>(100.05:Straight mode:<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping alternative word on straight</debug>
				</xsl:if>
				
				<xsl:if test="$showAlternatives=0 and not($modifiers/ancestor-or-self::*[contains(@status,'alternative')])">
					<xsl:if test="$debug='1'">
						<debug>Still showing a non-alternative modifier</debug>
					</xsl:if>
					
					<xsl:call-template name="straightWithModifiersOnly">
						<xsl:with-param name="modifiers" select="$modifiers"/>
						<xsl:with-param name="article" select="$article"/>
						<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
						<xsl:with-param name="constructChain" select="$constructChain"/>
					</xsl:call-template>
				</xsl:if>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="straightWithAllModifiers">
					<xsl:with-param name="modifiers" select="$modifiers"/>
					<xsl:with-param name="article" select="$article"/>
					<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="buildConstructChain">
		<!-- construct chains (enabling recursive ones) -->
		<xsl:param name="constructChain"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="atEnd" select="true"/>
		<xsl:if test="$debug='1'">
			<debug>(900.buildConstructChain.<xsl:value-of select="count($constructChain)"/>.<xsl:value-of select="@gloss"/><xsl:if test="$modifiers">.modifiers:<xsl:value-of select="$modifiers"/></xsl:if>.atEnd:<xsl:value-of select="$atEnd"/>)</debug>
		</xsl:if>
		
		<!-- now done right after the straight>
		<xsl:if test="ancestor::DiscourseUnit[contains(concat(',', @highlight, ','), ',boundphrases,')]/@highlight">
			<ellipse parentsize="Overall" fillcolor="#FFFDDA" linewidth="2"/> 
		</xsl:if>
		-->
		
		<down>
			<xsl:if test="$constructChain[1]/@height">
				<xsl:attribute name="height"><xsl:value-of select="$constructChain[1]/@height"/></xsl:attribute>
			</xsl:if>
			
			<xsl:choose>
			<!-- at (beginning or) middle -->
			<xsl:when test="count($constructChain)&gt;1">
					<xsl:if test="$debug='1'">
						<xsl:attribute name="debug900phase">middle</xsl:attribute>
						<xsl:attribute name="debug900this">
							<xsl:value-of select="name($constructChain[1])"/>.<xsl:value-of select="$constructChain[1]/@word"/>
						</xsl:attribute>
						<xsl:attribute name="debug900next">
							<xsl:value-of select="name($constructChain[2])"/>.<xsl:value-of select="$constructChain[2]/@word"/>
						</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="$atEnd and not(@nested or @nested='no')">					
						<xsl:attribute name="style">atEnd</xsl:attribute>
					</xsl:if>
					
					<xsl:call-template name="adjustColours"/>
					
					<xsl:if test="$modifiers">
						<xsl:apply-templates select="$modifiers"/>
					</xsl:if>
					
					<xsl:apply-templates select="$constructChain[1]">
						<xsl:with-param name="constructChain" select="$constructChain[position()&gt;1]"/>
					</xsl:apply-templates>
					
			</xsl:when>
			<xsl:otherwise>
					<xsl:if test="$debug='1'">
						<xsl:attribute name="debug900phase">last</xsl:attribute>
					</xsl:if>
					<xsl:if test="$atEnd and not($constructChain[1]/@nested='no')">					
						<xsl:attribute name="style">atEnd</xsl:attribute>
					</xsl:if>
					
					<xsl:call-template name="adjustColours"/>
					
					<xsl:if test="$modifiers">
						<xsl:apply-templates select="$modifiers"/>
					</xsl:if>
					
					<xsl:apply-templates select="$constructChain[1]"/>
			</xsl:otherwise>
			</xsl:choose>
		</down>
		
		<xsl:if test="$debug='1'">
			<debug>(900.buildConstructChain.finished.<xsl:value-of select="count($constructChain)"/>.<xsl:value-of select="@gloss"/><xsl:if test="$modifiers">.modifiers:<xsl:value-of select="$modifiers"/></xsl:if>)</debug>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="straightWithAllModifiers">
		<!-- helper routine for all straights -->
		<xsl:param name="modifiers"/>
		<xsl:param name="article"/>
		<xsl:param name="subordinateClause"/>
		<xsl:param name="constructChain"/>
		
		
		<xsl:if test="$debug='1'">
			<debug>(100.99.straightWithAllModifiers.<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>.<xsl:value-of select="@word"/>
				<xsl:if test="$modifiers">.mod:<xsl:value-of select="name($modifiers[1])"/></xsl:if>
				<xsl:if test="$constructChain">.cc:<xsl:value-of select="name($constructChain[1])"/></xsl:if>
				<xsl:if test="$subordinateClause">.sc:<xsl:value-of select="name($subordinateClause[1])"/></xsl:if>)</debug>
		</xsl:if>
		
		
		<straight>
		
			<xsl:call-template name="bareWordWithAllModifiers">
				<xsl:with-param name="modifiers" select="$modifiers"/>
				<xsl:with-param name="article" select="$article"/>
				<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
				<xsl:with-param name="constructChain" select="$constructChain"/>
				
			</xsl:call-template>
			
			<xsl:if test="$constructChain and not($constructChain[1][contains(@status,'alternative')])">
				<!-- simple construct chain belongs within this straight -->
				<xsl:call-template name="buildConstructChain">
					<xsl:with-param name="modifiers" select="following-sibling::Word[not(@pos='quantifier' or @pos='suffix-pronoun' or @pos='noun')]"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
					<xsl:with-param name="atEnd" select="'true'"/> <!-- >not($article or $modifiers or $subordinateClause)"/>-->
				</xsl:call-template>
			</xsl:if>
			
		</straight>
		
		<!-- alternatives interrupting a construct chain -->
		<xsl:if test="$constructChain and $constructChain[1][contains(@status,'alternative')]">				
			<xsl:if test="$debug='1'">
				<debug>constructChain:<xsl:value-of select="$constructChain[1]/@status"></xsl:value-of></debug>
			</xsl:if>
			
			<xsl:for-each select="$constructChain[1]">
				<straight>
					
					<xsl:call-template name="bareWordWithAllModifiers"/>
					
					<xsl:call-template name="adjustColours"/>
					
					<!-- handle continuing construct chain, if any -->
					<xsl:if test="count(following-sibling::*) &gt; 0">
							<xsl:call-template name="buildConstructChain">
								<xsl:with-param name="modifiers" select="following-sibling::Word[not(@pos='quantifier' or @pos='suffix-pronoun' or @pos='noun')]"/>
								<xsl:with-param name="constructChain" select="./following-sibling::*"/>
								<xsl:with-param name="atEnd" select="'true'"/> <!-- >not($article or $modifiers or $subordinateClause)"/>-->
							</xsl:call-template>
					</xsl:if>
					
					
				</straight>
				
			</xsl:for-each>
		</xsl:if>
			
		
		
		<!-- Elements OUTSIDE the straight -->
		
		<xsl:if test="$subordinateClause">					
			<xsl:for-each select="$subordinateClause[$showAlternatives=1 or not(contains(@status,'alternative'))]">		
				<straight>
					<xsl:if test="$debug='1'">
						<xsl:attribute name="debugModifier"><xsl:value-of select="name(..)"/>/<xsl:value-of select="name()"/></xsl:attribute>
					</xsl:if>
					
					<!-- get parent context for colours -->
					<xsl:for-each select="..">
						<xsl:call-template name="adjustColours"/>
					</xsl:for-each>
					
					<xsl:if test="@drop">
						<xsl:attribute name="length">element</xsl:attribute>
					</xsl:if>
					
					<xsl:apply-templates select="."/>					
				</straight>
			</xsl:for-each>
			
			
		</xsl:if>
		
		<!-- last of all, appositives -->
		<xsl:if test="$modifiers">
			<xsl:apply-templates select="$modifiers[name()='Appositive']"/>
		</xsl:if>
		
			
	</xsl:template>
	
	<xsl:template name="bareWordWithAllModifiers">
		<!-- helper routine for all straights -->
		<xsl:param name="modifiers"/>
		<xsl:param name="article"/>
		<xsl:param name="subordinateClause"/>
		<xsl:param name="constructChain"/>
		
		<!-->
		<straight>
-->
			
			<!-- hard-coded width/length -->
			<xsl:if test="@width">
				<xsl:attribute name="length"><xsl:value-of select="@width"/></xsl:attribute>
			</xsl:if>
			
			<!-- colours and connectors and styles -->
			<xsl:call-template name="adjustColours"/>
			
			<!-- connector -->
			<xsl:if test="@located or Word[@pos='located']">
				<xsl:apply-templates select="." mode="connectorAttributes"/>
			</xsl:if>
			
			<!-- infinitive suffix-pronoun connectors -->
			<xsl:if test="preceding-sibling::Word[1]/@pos='verb-infinitive'">
				<!-- connects to the subject position -->				
				<xsl:apply-templates select="ancestor::Clause[1]/Subject[@located='after infinitive construct']
				                     |ancestor::Clause[1]/Subject/Word[@pos='located' and gloss='after infinitive construct']" mode="connectorAttributes"/>				
				<!-- connects to object (of clause or of prepositional phrase) position -->
				<xsl:apply-templates select="ancestor::Clause[1]/descendant::Object[@located='after infinitive construct']
				                     |ancestor::Clause[1]/Object/Word[@pos='located' and gloss='after infinitive construct']" mode="connectorAttributes"/>
				
				<xsl:if test="$debug='1'"><xsl:attribute name="linecolor">red</xsl:attribute></xsl:if>
			</xsl:if>
			
			<!-- object of a relative clause -->
			<xsl:if test="ancestor::Object[@located] or ancestor::Object/Word/@pos='located'">
				<!-- connecting to object -->
				<xsl:apply-templates select="ancestor::Object[@located]|ancestor::Object[Word/@pos='located']" mode="connectorAttributes"/>
				<xsl:if test="$debug='1'"><xsl:attribute name="linecolor">orange</xsl:attribute></xsl:if>
			</xsl:if>
			
			<!-- relative clause head -->			
			<xsl:if test="../RelativeClause/descendant::*[@located='relative clause head'] or ../RelativeClause/descendant::*/Word[@pos='located' and @gloss='relative clause head']">
				<xsl:apply-templates select="../RelativeClause/descendant::*[@located='relative clause head']
				                     |../RelativeClause/descendant::*/Word[@pos='located' and @gloss='relative clause head']" mode="connectorAttributes"/>
				<xsl:if test="$debug='1'"><xsl:attribute name="linecolor">purple</xsl:attribute></xsl:if>
			</xsl:if>
			<xsl:if test="preceding-sibling::Word[1]/@pos='verb-participle'">
				<!-- participle suffix-pronoun as object -->			
				<xsl:apply-templates select="ancestor::Clause/descendant::Object[@located='after participle']
				                     |ancestor::Clause/descendant::Object[Word/@pos='located' and @gloss='after participle']" mode="connectorAttributes"/>
				<xsl:if test="$debug='1'"><xsl:attribute name="linecolor">pink</xsl:attribute></xsl:if>
			</xsl:if>
			<!-->
			     <xsl:if test="../RelativeClause/descendant::Word[@located='relative clause head']">
			     <xsl:attribute name="connector">601</xsl:attribute>
			     <xsl:if test="$debug='1'"><xsl:attribute name="linecolor">green</xsl:attribute></xsl:if>
			</xsl:if>
			     -->
			
			<xsl:if test="@pos='verb-participle' and not(name(..)='Adjectival' or (name(..)='Nominal' and name(../..)='Adjectival'))">
				<xsl:attribute name="style">round</xsl:attribute>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*[@status='elided'] or starts-with(@word,'(') or starts-with(@gloss,'(')">
					<!-- group elision plus any passed in style -->
					<xsl:attribute name="style">implied</xsl:attribute>
				</xsl:when>
				<xsl:when test="ancestor-or-self::*[@status='elided']">
					<!-- group elision on its own-->
					<xsl:attribute name="style">implied</xsl:attribute>
				</xsl:when>
				<xsl:when test="starts-with(@word,'(') or starts-with(@gloss,'(')">
					<xsl:attribute name="style">implied</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			
			<xsl:if test="@pos='verb-participle' and (starts-with(@word,'(') or starts-with(@gloss,'(') or ancestor-or-self::*[@status='elided'])">
				<xsl:attribute name="style">round implied</xsl:attribute>
			</xsl:if>
			
			<!-- vertical alignment -->
			<xsl:if test="@apposition or @align">
				<xsl:attribute name="valign">true</xsl:attribute>
			</xsl:if>
			
			
			<!-- word and gloss -->
			<xsl:call-template name="wordAndGloss"/>
			
			<!-- participant ellipses -->
			<xsl:call-template name="participantHighlight"/>
			
			<!-- now putting construct chain earlier... will this cause style=AtEnd problems?? 
			     <xsl:if test="$constructChain">
			     <xsl:call-template name="buildConstructChain">
			     <xsl:with-param name="modifiers" select="following-sibling::Word[not(@pos='quantifier' or @pos='suffix-pronoun' or @pos='noun')]"/>
			     <xsl:with-param name="constructChain" select="$constructChain"/>
			     <xsl:with-param name="atEnd" select="not($article or $modifiers or $subordinateClause)"/>
			</xsl:call-template>
			</xsl:if>
			     -->
			
			
			<!-- handle KOL 		
			     <xsl:if test="preceding-sibling::Word[@pos='quantifier']">
			     <xsl:apply-templates select="preceding-sibling::Word[@pos='quantifier']"/>
			</xsl:if>
			     -->	
			
			<!-- ellipse for construct chain must be done HERE -->			
			<xsl:if test="$constructChain">
				<xsl:if test="ancestor::DiscourseUnit[contains(concat(',', @highlight, ','), ',boundphrases,')]/@highlight">
					<ellipse parentsize="Overall" fillcolor="#FFFDDA" linewidth="2"/> 
				</xsl:if>
			</xsl:if>			
			

			<xsl:if test="$article">					
				<xsl:apply-templates select="$article"/>					
			</xsl:if>				
			
			
			<!-- modifiers -->	
			
			<xsl:if test="$modifiers">
				<xsl:for-each select="$modifiers[not(name()='Appositive')][$showAlternatives=1 or not(contains(@status,'alternative'))]">		
					
<!-->					<straight>
						<xsl:if test="$debug='1'">
							<xsl:attribute name="debugModifier"><xsl:value-of select="name(..)"/>/<xsl:value-of select="name()"/></xsl:attribute>
						</xsl:if>
	
					
						<!- - get parent context for colours - ->
						<xsl:for-each select="..">
							<xsl:call-template name="adjustColours"/>
						</xsl:for-each>
						
						<xsl:if test="@drop">
							<xsl:attribute name="length">element</xsl:attribute>
						</xsl:if>
					-->						
					<xsl:apply-templates select="."/>					
<!-->
				</straight>
-->
				</xsl:for-each>
			</xsl:if>
			
	
		<!-->
		</straight>
		     -->
		
	</xsl:template>
	
	
	
	<xsl:template name="straightWithModifiersOnly">
		<!-- helper routine for all straights -->
		<xsl:param name="modifiers"/>
		<xsl:param name="article"/>
		<xsl:param name="subordinateClause"/>
		<xsl:param name="constructChain"/>
		
		<xsl:if test="$debug='1'">
			<debug>(100.102.<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>.<xsl:value-of select="@word"/>
				<xsl:if test="$modifiers">.mod:<xsl:value-of select="name($modifiers[1])"/></xsl:if>
				<xsl:if test="$constructChain">.cc:<xsl:value-of select="name($constructChain[1])"/></xsl:if>
				<xsl:if test="$subordinateClause">.sc:<xsl:value-of select="name($subordinateClause[1])"/></xsl:if>)</debug>
		</xsl:if>
		<straight>
			<!-- hard-coded width/length -->
			<xsl:if test="@width">
				<xsl:attribute name="length"><xsl:value-of select="@width"/></xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$article or $modifiers or $subordinateClause">
				
				<!-- modifiers -->				
				<xsl:if test="$article">					
					<xsl:apply-templates select="$article"/>					
				</xsl:if>				
				<xsl:if test="$modifiers">					
					<xsl:apply-templates select="$modifiers[not(name()='Appositive')]"/>					
				</xsl:if>				
				
				<xsl:if test="$subordinateClause">					
					<xsl:apply-templates select="$subordinateClause"/>					
				</xsl:if><!-->				
				</straight>		-->	
			</xsl:if>
			
			<!-- need to figure out WHEN the construct chain should come !! -->
			<xsl:if test="$constructChain">
				<xsl:call-template name="buildConstructChain">
					<xsl:with-param name="modifiers" select="following-sibling::Word[not(@pos='quantifier' or @pos='suffix-pronoun' or @pos='noun')]"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
					<xsl:with-param name="atEnd" select="'true'"/> <!-- >not($article or $modifiers or $subordinateClause)"/>-->
				</xsl:call-template>
			</xsl:if> 
			
		</straight>
		
		<!-- last of all, appositives -->
		<xsl:if test="$modifiers">
			<xsl:apply-templates select="$modifiers[name()='Appositive']"/>
		</xsl:if>
		
		
	</xsl:template>
	
	
	<xsl:template match="Word[@pos='noun' or @pos='pronoun' or @pos='verb' or @pos='copula' 
	              or @pos='verb-participle' or @pos='interjection' or @pos='suffix-pronoun']
	              |Complement/Word[@pos='adjective']|Participle/Word[@pos='verb' or @pos='copula']">
		<!-- needing help to get on a straight -->
		<xsl:param name="modifiers"/>
		<xsl:param name="article"/>
		<xsl:param name="constructChain"/>
		<xsl:param name="subordinateClause"/>
		
		<xsl:if test="$debug='1'">
			<debug>(100.2.<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>
				<xsl:if test="$modifiers">.mod:<xsl:value-of select="name($modifiers[1])"/></xsl:if>
				<xsl:if test="$constructChain">.cc:<xsl:value-of select="name($constructChain[1])"/></xsl:if>
				<xsl:if test="$subordinateClause">.sc:<xsl:value-of select="name($subordinateClause[1])"/></xsl:if>
				<xsl:text>showAlternatives:</xsl:text><xsl:value-of select="$showAlternatives"/>
				<xsl:text>)</xsl:text>
			</debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
				
				<xsl:if test="$showAlternatives=0 and not($modifiers/ancestor-or-self::*[contains(@status,'alternative')])">
					<xsl:if test="$debug='1'">
						<debug>Still showing a non-alternative modifier</debug>
					</xsl:if>
					
					<xsl:call-template name="straightWithModifiersOnly">
						<xsl:with-param name="modifiers" select="$modifiers"/>
						<xsl:with-param name="article" select="$article"/>
						<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
						<xsl:with-param name="constructChain" select="$constructChain"/>
					</xsl:call-template>
				</xsl:if>
				
			</xsl:when>
			
			<xsl:otherwise>
			
				<xsl:call-template name="straightWithAllModifiers">
					
					<xsl:with-param name="modifiers" select="$modifiers"/>
					<xsl:with-param name="article" select="$article"/>
					<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:call-template>
			
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="Word[@pos='article' or @pos='adverb' or @pos='particle' or @pos='adjective' or @pos='quantifier']">
		<xsl:param name="modifiers"/>
		<xsl:param name="style"/>
		<!-- slantdown -->
		<xsl:if test="$debug='1'">
			<debug>(100.3 <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/><xsl:if test="$modifiers">.mod:<xsl:value-of select="name($modifiers)"/></xsl:if>)</debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping alternative word</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				<slantdown>
					<xsl:if test="$style">
						<xsl:attribute name="style">
							<xsl:value-of select="$style"/>
						</xsl:attribute>
					</xsl:if>
					
					<xsl:call-template name="adjustColours"/>
					<xsl:call-template name="wordAndGloss"/>
					
					
					<xsl:if test="@pos='article' and ancestor::DiscourseUnit[contains(concat(',',@highlight,','),',articles,')]">
						<ellipse parentsize="overall" fillcolor="#A0A5D8" linewidth="2"/>
					</xsl:if>
					<xsl:if test="@pos='quantifier' and ancestor::DiscourseUnit[contains(concat(',',@highlight,','),',articles,')]">
						<ellipse parentsize="overall" fillcolor="#88E6E9" linewidth="2"/>
					</xsl:if>
					
					<xsl:if test="$modifiers">
						<!-- overslant needed -->
						<!-- XSLT 1.0 RESULTS TREE FRAGMENT 
						     <xsl:apply-templates select="exsl:node-set($modifiers)" mode="overslant"/>-->
						<xsl:apply-templates select="$modifiers" mode="overslant"/>
					</xsl:if>
				</slantdown>
				
			</xsl:otherwise>
		</xsl:choose>
		
		
	</xsl:template>
	
	<xsl:template match="*" mode="overslant">
		<xsl:if test="$debug='1'">
			<debug>(100.999.overslant <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		
		<overslant>			
			<xsl:call-template name="adjustColours"/>			
			
			<xsl:apply-templates select="*"/>
			
			
		</overslant>			
		
		
	</xsl:template>
	<xsl:template match="Adverbial[Word/@pos='noun']" mode="overslant">
		<xsl:param name="modifiers"/>
		<!-- overslant -->
		<xsl:if test="$debug='1'">
			<debug>(100.3.2.overslant <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		<overslant style="dash">
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="*" />
		</overslant>
		
	</xsl:template>
	<xsl:template match="Word[@pos='article' or @pos='adverb' or @pos='particle' or @pos='adjective' or Word/@pos='quantifier' ]" mode="overslant">
		<xsl:param name="modifiers"/>
		<!-- slantdown -->
		<xsl:if test="$debug='1'">
			<debug>(100.3.3.overslant <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		<overslant>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="wordAndGloss"/>
			<xsl:if test="$modifiers">
				<!-- overslant needed -->
				<!-- XSLT 1.0 RESULTS TREE FRAGMENT -->
				
				<xsl:apply-templates select="exsl:node-set($modifiers)" mode="overslant"/>
			</xsl:if>
			
			
			<!-- ellipses not covered when this is an overslant -->
			<xsl:if test="@pos='article' and ancestor::DiscourseUnit[contains(concat(',',@highlight,','),',articles,')]">
				<ellipse parentsize="overall" fillcolor="#A0A5D8" linewidth="2"/>
			</xsl:if>
			
			
		</overslant>
	</xsl:template>
	<xsl:template match="Adverbial[PrepositionalPhrase]" mode="overslant">
		<xsl:if test="$debug='1'">
			<debug>(100.3.4.overslant <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)</debug>
		</xsl:if>
		<!-- need the CONTEXT of the prepositional phrases for adjustColours to work properly -->
		<xsl:for-each select="PrepositionalPhrase">
			
			<overslant>		
				<xsl:for-each select="Preposition/Word">
					<xsl:call-template name="adjustColours"/>			
					
					<xsl:call-template name="wordAndGloss"> 
						<xsl:with-param name="node" select="."/>
					</xsl:call-template>
				</xsl:for-each>
				
				<xsl:apply-templates select="Object"/>
				
			</overslant>			
		</xsl:for-each>
		
	</xsl:template>
	
	
	
	<xsl:template match="Word[@pos='preposition']" mode="straight">
		<!-- straight (preposition) -->
		<xsl:param name="object"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="ellipse"/>
		<xsl:if test="$debug='1'">
			<debug>(100.4.straight)<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/><xsl:if test="$modifiers"><xsl:value-of select="name($modifiers)"/></xsl:if></debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$showAlternatives=0 and ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:if test="$debug='1'">
					<debug>Skipping Alternatives</debug>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				
				<straight>
					
					<xsl:call-template name="adjustColours"/>
					<xsl:call-template name="wordAndGloss"/>
					
					<xsl:if test="contains($ellipse,'prepositionalphrases')">
						<ellipse parentsize="overall" fillcolor="#E9F6DC" linewidth="2"/> <!-- FFFDDA for bound phrases -->
					</xsl:if>
					
				</straight>
		
				<!-- the object will actually be NEXT to the preposition, on the line -->
				<xsl:if test="$object">
					<xsl:apply-templates select="$object"/>
				</xsl:if>
		
		<!-- phrase-level glosses -->
		<xsl:if test="ancestor::PrepositionalPhrase[1][@gloss] and ancestor::DiscourseUnit[contains(@highlight,'phrase') and not(@phrasePosition='absolute')] and $showGlosses='1'">
			
			
			<xsl:call-template name="phraseGloss">
				<xsl:with-param name="offsetX">
					<xsl:choose>
						<xsl:when test="ancestor::PrepositionalPhrase[@gloss]/@x">
							<xsl:value-of select="ancestor::PrepositionalPhrase[@gloss]/@x"/>
						</xsl:when>
						<xsl:otherwise>-100</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>
				<xsl:with-param name="offsetY">
					<xsl:choose>
						<xsl:when test="ancestor::PrepositionalPhrase[@gloss]/@y">
							<xsl:value-of select="ancestor::PrepositionalPhrase[@gloss]/@y"/>
						</xsl:when>
						<xsl:otherwise>-10</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>
				
				<xsl:with-param name="debugText">100.4.straight</xsl:with-param>					
				
				
				<xsl:with-param name="gloss">
					<xsl:choose>
						<xsl:when test="ancestor::PrepositionalPhrase/attribute::*[name()=$language]">
							<xsl:value-of select="ancestor::PrepositionalPhrase/attribute::*[name()=$language]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="ancestor::PrepositionalPhrase/@gloss"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param>					
				
			</xsl:call-template>			
			
			
			
		</xsl:if>
		
		<!-- modifiers -->			
		<xsl:if test="$modifiers">
			
			<xsl:apply-templates select="$modifiers"/>
		</xsl:if>
		
			</xsl:otherwise>
		</xsl:choose>
		
		
	</xsl:template>
	<xsl:template match="Word[@pos='preposition']">
		<!-- slantdown (preposition) -->
		<xsl:param name="object"/>
		<xsl:param name="modifiers"/>
		<xsl:param name="ellipse"/>
		<xsl:if test="$debug='1'">
			<debug>(100.4)<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/><xsl:if test="$modifiers"><xsl:value-of select="name($modifiers)"/></xsl:if></debug>
		</xsl:if>
		
		<slantdown>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="wordAndGloss"/>
			<xsl:if test="ancestor::PrepositionalPhrase[1]/../@drop">
				<xsl:attribute name="height"><xsl:value-of select="ancestor::PrepositionalPhrase[1]/../@drop"/></xsl:attribute>
			</xsl:if>
			
			
			<!-- if overslant is needed, it needs to be BEFORE the preposition and BEFORE any ellipse
			     <xsl:if test="name($modifiers)='Adverbial' and $modifiers[PrepositionalPhrase]">
			     <xsl:apply-templates select="$modifiers"/>
			</xsl:if>-->
			<!-- modifiers -->			
			<xsl:if test="$modifiers">
				
				<xsl:apply-templates select="$modifiers" mode="overslant"/>
			</xsl:if>
			
			<xsl:if test="contains($ellipse,'prepositionalphrases')">
				<ellipse parentsize="overall" fillcolor="#E9F6DC" linewidth="2"/> <!-- FFFDDA for bound phrases -->
			</xsl:if>
			
			<xsl:if test="$object">
				<xsl:apply-templates select="$object"/>
			</xsl:if>
			
			<!-- phrase-level glosses -->
			<xsl:if test="ancestor::PrepositionalPhrase[1][@gloss] and ancestor::DiscourseUnit[contains(@highlight,'phrase') and not(@phrasePosition='absolute')] and $showGlosses='1'">
				<!-->
				     <straight style="noline">
				     <xsl:call-template name="wordAndGloss">
				     <xsl:with-param name="node" select="ancestor::PrepositionalPhrase[@gloss]"/>
				</xsl:call-template>
				</straight>-->
				
				<xsl:call-template name="phraseGloss">
					<xsl:with-param name="offsetX">
						<xsl:choose>
							<xsl:when test="ancestor::PrepositionalPhrase[@gloss]/@x">
								<xsl:value-of select="ancestor::PrepositionalPhrase[@gloss]/@x"/>
							</xsl:when>
							<xsl:otherwise>-100</xsl:otherwise>
						</xsl:choose>
						
					</xsl:with-param>
					<xsl:with-param name="offsetY">
						<xsl:choose>
							<xsl:when test="ancestor::PrepositionalPhrase[@gloss]/@y">
								<xsl:value-of select="ancestor::PrepositionalPhrase[@gloss]/@y"/>
							</xsl:when>
							<xsl:otherwise>-10</xsl:otherwise>
						</xsl:choose>
						
					</xsl:with-param>
					
					<xsl:with-param name="debugText">100.4</xsl:with-param>					
					
					
					<xsl:with-param name="gloss">
						<xsl:choose>
							<xsl:when test="ancestor::PrepositionalPhrase/attribute::*[name()=$language]">
									<xsl:value-of select="ancestor::PrepositionalPhrase/attribute::*[name()=$language]"/>
							</xsl:when>
							<xsl:otherwise>
									<xsl:value-of select="ancestor::PrepositionalPhrase/@gloss"/>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:with-param>					
					
				</xsl:call-template>				
				
			</xsl:if>
			
			
			
		</slantdown>
	</xsl:template>
	<xsl:template name="phraseGloss">
		<xsl:param name="offsetX"/>
		<xsl:param name="offsetY"/>
		<xsl:param name="gloss"/>
		<xsl:param name="onlyLine" select="1"/>
		<xsl:param name="subsequent" select="0"/>
		<xsl:param name="noMoreBold" select="0"/>
		<xsl:param name="debugText"/>
		
		<xsl:if test="$debug='1'">
			<debug>77.<xsl:value-of select="name(..)"/>/<xsl:value-of select="name()"/>
				<xsl:text>gloss:</xsl:text><xsl:value-of select="$gloss"/>
				<xsl:if test="ancestor::ConstructChain[@gloss]">
					<xsl:text>.parent:</xsl:text>
					<xsl:value-of select="name(ancestor::ConstructChain[@gloss])"/>
				</xsl:if>
				<xsl:text>.onlyLine:</xsl:text><xsl:value-of select="$onlyLine"/>
				<xsl:text>.subsequent:</xsl:text><xsl:value-of select="$subsequent"/>
				<xsl:choose>
					<xsl:when test="ancestor::Predicate[@gloss]">
						<xsl:text>.parent:</xsl:text>
						<xsl:value-of select="name(ancestor::Predicate[@gloss])"/>
					</xsl:when>
					<!-- Prepositions need to check above the current phrase -->
					<xsl:when test="name(..)='Preposition' and ../../ancestor::PrepositionalPhrase[@gloss]">
						<xsl:text>.parent:</xsl:text>
						<xsl:value-of select="name(../ancestor::PrepositionalPhrase[@gloss])"/>
					</xsl:when>
					
					<xsl:when test="not(name(..) = 'Preposition') and ancestor::PrepositionalPhrase[@gloss]">
						<xsl:text>.parent:</xsl:text>
						<xsl:value-of select="name(ancestor::PrepositionalPhrase[@gloss])"/>
					</xsl:when>
				</xsl:choose>
			</debug>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$showPhraseGlosses=0">
				<!-- ignore -->
			</xsl:when>
			<xsl:when test="ancestor::DiscourseUnit[contains(@highlight,'phrase')] and ancestor::*[contains(@status,'alternative')]">
				<!-- ignore -->
			</xsl:when>
			
			<xsl:when test="contains($gloss, '&gt; &gt;') or contains($gloss, '&gt;&gt;')">
				<!-- must split into multiple lines -->
				
				<!-- this line -->
				<text family="work sans" size="{$glossSize}">
					<xsl:if test="$debug='1'"><xsl:attribute name="debug"><xsl:value-of select="$debugText"/></xsl:attribute></xsl:if>
					
					<xsl:call-template name="phraseGlossColour"/>
					
					<xsl:attribute name="offsetX">
						<xsl:value-of select="$offsetX"/>
					</xsl:attribute>
					
					<xsl:attribute name="offsetY">
						<xsl:value-of select="$offsetY"/>
					</xsl:attribute>
					
					<xsl:attribute name="text">
						<xsl:choose>
							<xsl:when test="contains($gloss, '* &gt; &gt;')">
								<xsl:value-of select="concat(substring-after(substring-before($gloss, '* &gt; &gt;'),'*'), ' &gt; &gt;')"/>
							</xsl:when>
							<xsl:when test="contains($gloss, '&gt; &gt;')">
								<xsl:value-of select="concat(substring-before($gloss, '&gt; &gt;'), ' &gt; &gt;')"/>
							</xsl:when>
							<xsl:when test="contains($gloss, '* &gt;&gt;')">
								<xsl:value-of select="concat(substring-after(substring-before($gloss, '* &gt;&gt;'),'*'), ' &gt;&gt;')"/>
							</xsl:when>
							<xsl:when test="contains($gloss, '&gt;&gt;')">
								<xsl:value-of select="concat(substring-before($gloss, '&gt;&gt;'), ' &gt;&gt;')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					
					<xsl:attribute name="weight">
						<xsl:choose>
							<!-- later element is bold -->
							<xsl:when test="contains($gloss, '&gt; &gt; *')">Normal</xsl:when>
							<!-- this element is marked as bold -->
							<xsl:when test="starts-with($gloss, '*')">Bold</xsl:when>
							<!-- fallback -->
							<xsl:otherwise>Normal</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</text>
				
				<!-- additional lines -->
				<xsl:call-template name="phraseGloss">
					<xsl:with-param name="offsetX"><xsl:value-of select="$offsetX"/></xsl:with-param>
					<xsl:with-param name="offsetY"><xsl:value-of select="$offsetY+13"/></xsl:with-param>
					<xsl:with-param name="gloss">
						<xsl:choose>
							<xsl:when test="contains($gloss, '&gt; &gt;')">
								<xsl:value-of select="substring-after($gloss, '&gt; &gt; ')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after($gloss, '&gt;&gt; ')"/>
							</xsl:otherwise>

						</xsl:choose>
						</xsl:with-param>
					
					<xsl:with-param name="debugText"><xsl:value-of select="concat($debugText, '.')"/></xsl:with-param>
					
					<xsl:with-param name="onlyLine">0</xsl:with-param>
					<xsl:with-param name="subsequent">
						<xsl:choose>
							<xsl:when test="contains(substring-after($gloss, '&gt; &gt;'), '&gt; &gt;')">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="noMoreBold">
						<xsl:choose>
							<!-- later element is bold -->
							<xsl:when test="contains($gloss, '&gt; &gt; *')">0</xsl:when>
							<!-- this element is marked as bold -->
							<xsl:when test="starts-with($gloss, '*')">1</xsl:when>
							<!-- fallback -->
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
				
			</xsl:when>
			<xsl:otherwise>
				<text family="work sans" size="{$glossSize}">
					<xsl:if test="$debug='1'"><xsl:attribute name="debug"><xsl:value-of select="$debugText"/></xsl:attribute></xsl:if>
					
					<xsl:call-template name="phraseGlossColour"/>
					
					<xsl:attribute name="weight">
						<xsl:choose>
							<xsl:when test="$noMoreBold='1'">Normal</xsl:when>
							<xsl:when test="$onlyLine='1' or $subsequent='1'">Bold</xsl:when>
							<xsl:when test="$noMoreBold='0' or $subsequent='0'">Bold</xsl:when>
							<xsl:otherwise>Normal</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<xsl:attribute name="offsetX">
						<xsl:value-of select="$offsetX"/>
					</xsl:attribute>
					
					<xsl:attribute name="offsetY">
						<xsl:value-of select="$offsetY"/>
					</xsl:attribute>
					
					<xsl:attribute name="text">
						<xsl:value-of select="$gloss"/>
					</xsl:attribute>
					
				</text>
				
			</xsl:otherwise>
		</xsl:choose>		
		
		
		
		
	</xsl:template>

	<xsl:template name="phraseGlossColour">
		
		
			<xsl:attribute name="color">
				<xsl:choose>
					<xsl:when test="ancestor::SubordinateClause[not(descendant-or-self::*[@gloss])]">
						<!-- within a subordinate clause, so don't need to look any further -->
						<xsl:value-of select="$glossColour"/>
					</xsl:when>
					<xsl:when test="count(ancestor::RelativeClause/descendant-or-self::*[not(name()='Word')and @gloss])=1">
						<!-- within a relative clause, so don't need to look any further -->
						<xsl:value-of select="$glossColour"/>
					</xsl:when>
					<!-- higher-level construct chain with a gloss -->
					<xsl:when test="ancestor::ConstructChain[@gloss]">
						<!-- grey out -->
						<xsl:value-of select="$greyColour"/>
					</xsl:when>
					<xsl:when test="ancestor::Predicate[@gloss]">
						<!-- grey out -->
						<xsl:value-of select="$greyColour"/>
					</xsl:when>
					<xsl:when test="not(name(..)='Preposition') and ancestor::PrepositionalPhrase[@gloss]">
						<!-- grey out -->
						<xsl:value-of select="$greyColour"/>
					</xsl:when>
					<xsl:when test="name(..)='Preposition' and ../../ancestor::PrepositionalPhrase[@gloss]">
						<!-- grey out -->
						<xsl:value-of select="$greyColour"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$glossColour"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
		
	</xsl:template>
	
	
	<xsl:template match="Adverbial/Adverbial/PrepositionalPhrase/Preposition/Word[@pos='preposition']">
		<!-- overslant (preposition) -->
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(100.50)<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/></debug>
		</xsl:if>
		<overslant>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="wordAndGloss"/>
			<xsl:if test="$modifiers">
				<xsl:apply-templates select="$modifiers"/>
			</xsl:if>
		</overslant>
	</xsl:template>
	<xsl:template match="Adverbial[Word/@pos='noun']/Adverbial/PrepositionalPhrase/Preposition/Word[@pos='preposition']">
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(100.55)<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/></debug>
		</xsl:if>
		<slantdown>
			<xsl:call-template name="adjustColours"/>
			<xsl:call-template name="wordAndGloss"/>
			<xsl:if test="$modifiers">
				<xsl:apply-templates select="$modifiers"/>
			</xsl:if>
		</slantdown>
	</xsl:template>	
	
	
	<!-->
	     <xsl:template match="Adverbial[count(child::PrepositionalPhrase)&gt;1]/PrepositionalPhrase/Preposition/Word[@pos='preposition']">
	     <!- - slantdown already supplied by group - ->
	     <xsl:param name="modifiers"/>
	     <xsl:if test="$debug='1'">
	     <debug>(100.4b)<xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/></debug>
	</xsl:if>
	     <straight>
	     <xsl:call-template name="adjustColours"/>
	     <xsl:call-template name="wordAndGloss"/>
	</straight>
	     <!- - note that modifiers need to go OUTSIDE the straight - ->
	     <xsl:if test="$modifiers">
	     <xsl:apply-templates select="$modifiers"/>
	</xsl:if>
	</xsl:template>
	     -->
	
	<xsl:template match="Word[@pos='conjunction' and not(name(../..)='SubordinateClause')]">
		<!-- conjunction -->
		<xsl:param name="modifiers"/>
		<xsl:param name="ellipse"/>
		<xsl:if test="$debug='1'">
			<debug>(100.5: <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>.ellipse:<xsl:value-of select="$ellipse"/>)
			</debug>
		</xsl:if>
		<conjunction>
			<xsl:call-template name="adjustColours"/>
			
			<xsl:choose>
				<xsl:when test="name(../..)='Complementclause'">
					<xsl:call-template name="wordAndGloss">
						<xsl:with-param name="overrideName" select="'particle'"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="wordAndGloss"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:if test="$ellipse">
				<ellipse parentsize="overall" fillcolor="#F2E4FC" linewidth="2"/>
			</xsl:if>
			
			<xsl:if test="$modifiers">
				<xsl:apply-templates select="$modifiers"/>
			</xsl:if>
		</conjunction>
	</xsl:template>
	<xsl:template match="Complement[(Word/@pos='adjective' or Word/@pos='quantifier') and not (Word/@pos='noun')]">
		<xsl:if test="$debug='1'">
			<debug>(PA.100.6: <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)
			</debug>
		</xsl:if>
		<!-- 
		     predicate adjective: marker replaces the slantdown
		     -->
		<xsl:call-template name="wordOnStraight">
			<xsl:with-param name="base" select="Word[@pos='adjective' or Word/@pos='quantifier']"/>
		</xsl:call-template>
	</xsl:template>
	<!-- conjunction within nominal means a group is needed -->
	<xsl:template match="Subject[Conjunction or Word[@pos='conjunction']]|Object[Conjunction or Word[@pos='conjunction']]
	              |Complement[Conjunction or Word[@pos='conjunction']]|Nominal[Conjunction or Word[@pos='conjunction']]
	              |Vocative[Conjunction or Word[@pos='conjunction']]">
		<xsl:param name="article"/>
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(Compound.20.7a.<xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="ancestor-or-self::Subject">
				<xsl:call-template name="buildGroup">
					<xsl:with-param name="root" select="."/>
					<xsl:with-param name="style" select="'close'"/> <!-- should be "close noopen" but that loses conjunctions now -->
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$modifiers">
				<xsl:call-template name="buildGroup">
					<xsl:with-param name="root" select="."/>
					<xsl:with-param name="style" select="'close'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="buildGroup">
					<xsl:with-param name="root" select="."/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$modifiers">
			<straight>
				<xsl:apply-templates select="adjustColours"/>
				<xsl:apply-templates select="$modifiers"/>
			</straight>
		</xsl:if>
	</xsl:template>
	<xsl:template match="RelativeParticle/Word|SubordinateClause/Conjunction/Word"> <!-- [@pos='particle'] -->
		<xsl:param name="subordinateClause"/>
		<xsl:if test="$debug='1'">
			<debug>(100.7: <xsl:value-of select="name()"/>.<xsl:value-of select="@pos"/>)<xsl:if test="$subordinateClause">
					<xsl:value-of select="name($subordinateClause/*[1])"/>
				</xsl:if></debug>
		</xsl:if>
		<xsl:choose>
			<!-- looking for an element with attribute @located within THIS clause -->
			<xsl:when test="../following-sibling::*[contains(name(),'Clause')]/descendant::*[not(contains(name(),'Clause'))]/child::*[@located or @pos='located']">
				<down hidden="true">
					<xsl:if test="$subordinateClause">
						<!-->						<segment> -->
						<xsl:apply-templates select="$subordinateClause"/>
						<!-->						</segment> -->
					</xsl:if>
				</down>
			</xsl:when>
			<xsl:otherwise>
				<down style="dash">
					<xsl:call-template name="adjustColours">
						<xsl:with-param name="style" select="'dash'"/>
					</xsl:call-template>
					<xsl:call-template name="wordAndGloss"/>
					<xsl:if test="$subordinateClause">
						<!-->						<segment> -->
						<xsl:apply-templates select="$subordinateClause"/>
						<!-->						</segment> -->
					</xsl:if>
					
				</down>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	     Helper routines
	     -->
	<xsl:template name="adjustColoursForPronouns">
		<xsl:param name="baseColour"/>
		<xsl:param name="suffixColour"/>
		<xsl:param name="emendedSuffixColour"/>
		<xsl:param name="defaultColour" select="concat($baseColour, '$', $suffixColour)"/>
		<xsl:param name="emendationColour" select="concat($baseColour, '$', $emendedSuffixColour)"/>
		
		<!-- multiple colours for suffix-pronouns or elision -->
		<xsl:if test="following-sibling::Word[1]/@pos='suffix-pronoun'
		        or (name(..)='Preposition' and ../../Object/Word[@pos='suffix-pronoun'])
		        or (name(..)='Nominal' and ../../Word[@pos='suffix-pronoun'])
		        or following-sibling::Apposition/Word[1]/@pos='suffix-pronoun'
		        or ((@pos='verb' or @pos='copula') and following-sibling::Object/Word[1]/@pos='suffix-pronoun')
		        or starts-with(@word,'(')">
			
			<xsl:choose>
				<xsl:when test="following-sibling::Word[1][@pos='suffix-pronoun']/@emendation or 
				          following-sibling::Word[1]/ancestor-or-self::*[contains(@status,'emendation')]">
					<xsl:attribute name="wordcolor">
						<xsl:value-of select="$baseColour"/>
						<xsl:text>$</xsl:text>
						<xsl:value-of select="$emendedSuffixColour"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="wordcolor">
						<xsl:value-of select="$baseColour"/>
						<xsl:text>$</xsl:text>
						<xsl:value-of select="$suffixColour"/>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
		
		
		
		<xsl:choose>
			<xsl:when test="1">
				<!-- short-circuit this whole choose -->
			</xsl:when>			
			<xsl:when test="@pos='suffix-pronoun'">
				<!-- suffixes don't need suffixes on top of them -->
			</xsl:when>
			
			<xsl:when test="following::Word[1][@pos='suffix-pronoun'][contains(@status,'emendation')]">
				<!-- TEMPORARY>
				     <xsl:attribute name="wordcolor">
				     <xsl:call-template name="includeSuffix">
				     <xsl:with-param name="base" select="."/>
				     <xsl:with-param name="pronoun" select="following::Word[1]"/>
				     <xsl:with-param name="textElement" select="$emendationColour"/>
				</xsl:call-template>
				</xsl:attribute>			
				     -->
			</xsl:when>
			<xsl:when test="following::Word[1]/@pos='suffix-pronoun'">
				
				<!-- TEMPORARY>
				     <xsl:attribute name="wordcolor">
				     
				     <xsl:call-template name="includeSuffix">
				     <xsl:with-param name="base" select="."/>
				     <xsl:with-param name="pronoun" select="following::Word[1]"/>
				     <xsl:with-param name="textElement" select="$defaultColour"/>
				</xsl:call-template>
				</xsl:attribute>
				     -->
				
			</xsl:when>
			
			<!-- a noun needing a suffix may be embedded within a nominal -->			
			<xsl:when test="name(..)='xNominal' and ../../descendant::Word[@pos='suffix-pronoun'][contains(@status,'emendation')]">
				<xsl:attribute name="wordcolor">
					<xsl:call-template name="includeSuffix">
						<xsl:with-param name="base" select=".."/>
						<xsl:with-param name="pronoun" select="../following::Word[@pos='suffix-pronoun']"/>
						<xsl:with-param name="textElement" select="$emendationColour"/>
					</xsl:call-template>
				</xsl:attribute>
				
				
			</xsl:when>
			
			<xsl:when test="name(..)='xNominal' and ../../descendant::Word[@pos='suffix-pronoun']">
				
				<xsl:attribute name="wordcolor">
					<xsl:call-template name="includeSuffix">
						<xsl:with-param name="base" select=".."/>
						<xsl:with-param name="pronoun" select="../following::Word[@pos='suffix-pronoun']"/>
						<xsl:with-param name="textElement" select="$defaultColour"/>
					</xsl:call-template>
				</xsl:attribute>
				
				
			</xsl:when>
			
			
		</xsl:choose>		
		
		
	</xsl:template>
	<xsl:template name="adjustColoursForArticles">
		<xsl:param name="baseColour"/>
		<xsl:param name="suffixColour"/>
		
		<xsl:if test="(preceding::Word[1]/@pos='article' and not(preceding::Word[1]/@status='elided') 
		        and not(contains(preceding::Word[1]/@word,'('))) or @prefix">
			
			<xsl:attribute name="wordcolor">
				<xsl:value-of select="$suffixColour"/>
				<xsl:text>$</xsl:text>
				<xsl:value-of select="$baseColour"/>
			</xsl:attribute>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="adjustColours">
		<xsl:param name="style"/>
		<xsl:param name="noWordColor" select="0"/>
		
		
		<!-- hard-coded height -->
		<xsl:if test="@height">
			<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
		</xsl:if>
		
		<!-- hard-coded halign -->
		<xsl:if test="@halign">
			<xsl:attribute name="halign"><xsl:value-of select="@halign"/></xsl:attribute>
		</xsl:if>
		
		<!-- adjust line colour for alternatives and elision -->
		<xsl:choose>
			
			
			<!-- elided alternatives -->
			<xsl:when test="(ancestor::Fragment[starts-with(@description,'Alternative')]
			          or ancestor-or-self::*[@alternative] or ancestor-or-self::*[contains(@status,'alternative')])
			          and ancestor-or-self::*[@status='elided']">
				<xsl:attribute name="linecolor"><xsl:value-of select="$alternativeColour"/></xsl:attribute>
				<xsl:attribute name="wordcolor"><xsl:value-of select="$alternativesuffix-pronounColour"/></xsl:attribute>
				<xsl:attribute name="glosscolor"><xsl:value-of select="$alternativesuffix-pronounColour"/></xsl:attribute>
				<xsl:attribute name="style">implied <xsl:if test="$style"> <xsl:value-of select="$style"/></xsl:if></xsl:attribute>
			</xsl:when>
			
			<!-- non-elided alternatives -->
			<xsl:when test="ancestor::Fragment[starts-with(@description,'Alternative')]
			          |ancestor-or-self::*[@alternative] or ancestor-or-self::*[contains(@status,'alternative')]">
				<xsl:attribute name="linecolor"><xsl:value-of select="$alternativeColour"/></xsl:attribute>
				<xsl:if test="$noWordColor='0'">
					<xsl:attribute name="wordcolor"><xsl:value-of select="$alternativeColour"/></xsl:attribute>
					<xsl:attribute name="glosscolor"><xsl:value-of select="$alternativeColour"/></xsl:attribute>

					<xsl:call-template name="adjustColoursForPronouns">
						<xsl:with-param name="baseColour" select="$alternativeColour"/>
						<xsl:with-param name="suffixColour" select="$alternativesuffix-pronounColour"/>
						<xsl:with-param name="emendedSuffixColour" select="$emendationsuffix-pronounColour"/>
					</xsl:call-template>
					
					<xsl:call-template name="adjustColoursForArticles">
						<xsl:with-param name="baseColour" select="$alternativeColour"/>
						<xsl:with-param name="suffixColour" select="$alternativesuffix-pronounColour"/>
					</xsl:call-template>
					
					
					<!-- revocalisation within an alternative -->				
					<xsl:if test="@revocalisation or contains(@status,'revocalisation') or @revocalization or contains(@status,'revocalization')">
						<xsl:attribute name="wordcolor">
							<xsl:value-of select="$revocalisationColour"/>
						</xsl:attribute>
						
						<xsl:call-template name="adjustColoursForPronouns">
							<xsl:with-param name="baseColour" select="$revocalisationColour"/>
							<xsl:with-param name="suffixColour" select="$revocalisationsuffix-pronounColour"/>
							<xsl:with-param name="emendedSuffixColour" select="$emendationsuffix-pronounColour"/>
						</xsl:call-template>
						
						
						<xsl:call-template name="adjustColoursForArticles">
							<xsl:with-param name="baseColour" select="$revocalisationColour"/>
							<xsl:with-param name="suffixColour" select="$revocalisationsuffix-pronounColour"/>
						</xsl:call-template>
						
					</xsl:if>
					
					<!-- emendation within an alternative -->				
					<xsl:if test="@emendation or contains(@status,'emendation')">
						<xsl:attribute name="wordcolor">
							<xsl:value-of select="$emendationColour"/>
						</xsl:attribute>
						

						<xsl:call-template name="adjustColoursForPronouns">
							<xsl:with-param name="baseColour" select="$emendationColour"/>
							<xsl:with-param name="suffixColour" select="$emendationsuffix-pronounColour"/>
							<xsl:with-param name="emendedSuffixColour" select="$emendationsuffix-pronounColour"/>
						</xsl:call-template>
						
						
						<xsl:call-template name="adjustColoursForArticles">
							<xsl:with-param name="baseColour" select="$emendationColour"/>
							<xsl:with-param name="suffixColour" select="$emendationsuffix-pronounColour"/>
						</xsl:call-template>
						
					</xsl:if>
					
				</xsl:if>
				
			</xsl:when>
			
			<!-- officially elided have grey lines and grey colours -->
			<xsl:when test="ancestor-or-self::*[@status='elided']">
				<xsl:attribute name="linecolor"><xsl:value-of select="$greyColour"/></xsl:attribute>
				<xsl:attribute name="style">implied <xsl:if test="$style"> <xsl:value-of select="$style"/></xsl:if></xsl:attribute>
			</xsl:when>
			
			<!-- emendation NOT within an alternative -->
			<xsl:when test="ancestor::Fragment[starts-with(@description,'Emendation')] or ancestor-or-self::*[@emendation] or ancestor-or-self::*[contains(@status,'emendation')]">
				<!-->
				<xsl:attribute name="linecolor"><xsl:value-of select="$emendationColour"/></xsl:attribute>
-->
				<xsl:attribute name="wordcolor"><xsl:value-of select="$emendationColour"/></xsl:attribute>
				
				<xsl:call-template name="adjustColoursForPronouns">
					<xsl:with-param name="baseColour" select="$emendationColour"/>
					<xsl:with-param name="suffixColour" select="$emendationsuffix-pronounColour"/>
					<xsl:with-param name="emendedSuffixColour" select="$emendationsuffix-pronounColour"/>
				</xsl:call-template>
				
				<xsl:call-template name="adjustColoursForArticles">
					<xsl:with-param name="baseColour" select="$emendationColour"/>
					<xsl:with-param name="suffixColour" select="$emendationsuffix-pronounColour"/>
				</xsl:call-template>
				
			</xsl:when>
			
			<!-- revocalisation NOT within an alternative -->
			<xsl:when test="ancestor::Fragment[starts-with(@description,'Revocalisation')] or ancestor-or-self::*[@revocalisation] or ancestor-or-self::*[@status='revocalisation'] or ancestor-or-self::*[@revocalization] or ancestor-or-self::*[@status='revocalization']">
<!-->				
				     <xsl:attribute name="linecolor"><xsl:value-of select="$revocalisationColour"/></xsl:attribute>
				     -->
				<xsl:attribute name="wordcolor"><xsl:value-of select="$revocalisationColour"/></xsl:attribute>
				
				<xsl:call-template name="adjustColoursForPronouns">
					<xsl:with-param name="baseColour" select="$revocalisationColour"/>
					<xsl:with-param name="suffixColour" select="$revocalisationsuffix-pronounColour"/>
					<xsl:with-param name="emendedSuffixColour" select="$emendationsuffix-pronounColour"/>
				</xsl:call-template>
				
				<xsl:call-template name="adjustColoursForArticles">
					<xsl:with-param name="baseColour" select="$revocalisationColour"/>
					<xsl:with-param name="suffixColour" select="$revocalisationsuffix-pronounColour"/>
				</xsl:call-template>
			</xsl:when>
			
			
			<xsl:otherwise>
				<!-->
				     <xsl:if test="$debug='1'"><xsl:attribute name="debugColour"><xsl:value-of select="name(..)"/>/<xsl:value-of select="name(.)"/></xsl:attribute></xsl:if>
				     -->
				
				<xsl:call-template name="adjustColoursForPronouns">
					<xsl:with-param name="baseColour" select="black"/>
					<xsl:with-param name="suffixColour" select="$greyColour"/>
					<xsl:with-param name="emendedSuffixColour" select="$emendationsuffix-pronounColour"/>
				</xsl:call-template>
				
				
				<xsl:call-template name="adjustColoursForArticles">
					<xsl:with-param name="baseColour" select="'black'"/>
					<xsl:with-param name="suffixColour" select="$greyColour"/>
				</xsl:call-template>
				
				
			</xsl:otherwise>
		</xsl:choose>
		
		
		<xsl:if test="/DiscourseUnit[contains(@highlight,'phrase')]">
			<xsl:if test="$debug='1'">
				<xsl:attribute name="debugParentGlosses">
					<xsl:value-of select="count(ancestor::*[@gloss and (name()='PrepositionalPhrase' or name()='ConstructChain' or name()='Predicate')])"/>
				</xsl:attribute>
			</xsl:if>
			
			<xsl:choose>
				<!-->
				
				<xsl:when test="ancestor::RelativeClause[1]/descendant::*[current()/ancestor::*[@gloss][1]]">
					<!- -  found an intervening gloss - ->
					<xsl:attribute name="glosscolor"><xsl:value-of select="$greyColour"/></xsl:attribute>
					
				</xsl:when>
				-->
				
				<xsl:when test="count(ancestor::RelativeClause[not(descendant-or-self::*[not(name()='Word')][@gloss])])">
					<!-- Relative clauses can block phrase-level glosses -->
					<xsl:if test="$debug='1'">
						<xsl:attribute name="debugRelativeClauseBlocked">1</xsl:attribute>
					</xsl:if>
				</xsl:when>
				
				<xsl:when test="ancestor::SubordinateClause[not(descendant-or-self::*[not(name()='Word')][@gloss])]">
					<!-- Subordinate clauses can block phrase-level glosses -->
					<xsl:if test="$debug='1'">
						<xsl:attribute name="debugSubordinateClauseBlocked">1</xsl:attribute>
					</xsl:if>
				</xsl:when>
				
				<!-- phrase-level gloss means descendants are all in grey -->
				<xsl:when test="ancestor::PrepositionalPhrase[@gloss] or ancestor::ConstructChain[@gloss] or ancestor::Predicate[@gloss]">
					<xsl:attribute name="glosscolor"><xsl:value-of select="$greyColour"/></xsl:attribute>
				</xsl:when>
				<!-- quantifiers as part of construct chains -->
				<xsl:when test="@pos='quantifier' and following-sibling::ConstructChain[@gloss]">
					<xsl:attribute name="glosscolor"><xsl:value-of select="$greyColour"/></xsl:attribute>
				</xsl:when>
				
				<!-- at the phrase level, grey out all non-preferred -->			
				<xsl:when test="ancestor::*[contains(@status,'emendation') or contains(@status,'alternative')]">
					<!-- gloss in light grey -->
					<xsl:attribute name="glosscolor"><xsl:value-of select="'white'"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		
		
		</xsl:if>
		
		
		<xsl:choose>
			<xsl:when test="attribute::*[name()=$language]">
				<xsl:call-template name="adjustGlossWeight">
					<xsl:with-param name="gloss" select="attribute::*[name()=$language]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="adjustGlossWeight"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<!-->		
		     <xsl:if test="contains(@gloss, '>>')">
		     <xsl:choose>
		     <xsl:when test="contains(@gloss, '* >>')">
		     <xsl:attribute name="glossweight">Bold$Normal</xsl:attribute>
		     
		</xsl:when>
		     <xsl:otherwise>
		     <xsl:attribute name="glossweight">Normal$Bold</xsl:attribute>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:if>
		     -->
		
		<!-- for languages with case endings -->
		<xsl:choose>
			<xsl:when test="@case = 'Nominative'">
				<xsl:attribute name="wordcolor">red</xsl:attribute>
			</xsl:when>
			<xsl:when test="@case = 'Genitive'">
				<xsl:attribute name="wordcolor">orange</xsl:attribute>
			</xsl:when>
			<xsl:when test="@case = 'Dative'">
				<xsl:attribute name="wordcolor">green</xsl:attribute>
			</xsl:when>
			<xsl:when test="@case = 'Accusative'">
				<xsl:attribute name="wordcolor">blue</xsl:attribute>
			</xsl:when>
			<xsl:when test="@case = 'Ablative'">
				<xsl:attribute name="wordcolor">purple</xsl:attribute>
			</xsl:when>
			
		</xsl:choose>
		
		<xsl:if test="@SDBH">
			<xsl:attribute name="glosscolor">red</xsl:attribute>
		</xsl:if>
		
		
	</xsl:template>
	<xsl:template name="adjustGlossWeight">
		<xsl:param name="gloss" select="@gloss"/>
		
		<!-->
		<xsl:if test="$debug='1'">
			<xsl:attribute name="adjustGlossWeight"><xsl:value-of select="$gloss"/></xsl:attribute>
		</xsl:if>
		-->

		<xsl:choose>
			
			<xsl:when test="contains($gloss, '>>')">
				<xsl:choose>
					<xsl:when test="contains($gloss, '* >>')">
						<xsl:attribute name="glossweight">Bold$Normal</xsl:attribute>
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="glossweight">Normal$Bold</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($gloss, '&amp;gt;&amp;gt;')">
				<xsl:choose>
					<xsl:when test="contains($gloss, '* &amp;gt;&amp;gt;')">
						<xsl:attribute name="glossweight">Bold$Normal</xsl:attribute>
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="glossweight">Normal$Bold</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="adjustColoursForMarker">
		<xsl:param name="style"/>
		<!-- adjust line colour BUT NOT WORD/GLOSS COLOUR for alternatives and elision -->
		<xsl:choose>
			<xsl:when test="ancestor::Fragment[starts-with(@description,'Alternative')]|ancestor-or-self::*[@alternative] or ancestor-or-self::*[@status='alternative']">
				<xsl:attribute name="linecolor"><xsl:value-of select="$alternativeColour"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="ancestor::Fragment[starts-with(@description,'Emendation')]|ancestor-or-self::*[@emendation] or ancestor-or-self::*[contains(@status,'emendation')]">
				<xsl:attribute name="linecolor"><xsl:value-of select="$emendationColour"/></xsl:attribute>
			</xsl:when>			
			<xsl:when test="ancestor-or-self::*[@status='elided']">
				<xsl:attribute name="linecolor"><xsl:value-of select="$greyColour"/></xsl:attribute>
				<!-->
				     NOTE: <pedestal> doesn't permit style... will this mess up markers?
				     <xsl:attribute name="style">implied<xsl:if test="$style"> <xsl:value-of select="$style"/></xsl:if></xsl:attribute>
				     -->
			</xsl:when>
			<!-->
			     <xsl:when test="starts-with(@gloss,'(')">
			     <xsl:attribute name="style">implied<xsl:if test="$style"> <xsl:value-of select="$style"/></xsl:if></xsl:attribute>
			</xsl:when> -->
		</xsl:choose>
	</xsl:template>
	<!-->
	     <xsl:template name="localModifiers">
	     <xsl:param name="basePOS" select="'noun'"/>
	     
	     <xsl:choose>
	     <xsl:when test="$basePOS = 'noun'">
	</xsl:when>
	     <xsl:when test="$basePOS= 'adjective'"></xsl:when>
	</xsl:choose>
	     
	     <xsl:variable name="localModifiers" select="Word[@pos='adjective' and (not($base/@pos='adjective'))]                 
	     |Adjectival[not($base/@pos='adjective')]
	     |Word[@pos='adverb' and $base/@pos='adjective']
	     |Adverbial[$base/@pos='adjective' or $base/@pos='verb-participle']
	     |Appositive"/>
	     
	     
	</xsl:template>-->
	<xsl:template name="stripAccents">
		<xsl:param name="node" select="."/>
		<!-->
		     <xsl:value-of select="translate($node/@word, '֪֢̩ˌ̩ ֑֖֛֣֤֥֦֧֢֢֚֭֮֒֓֔֕֗֘֙֜֝֞֟֠֡֨֩֫֬', '')"/>-->
		
		<xsl:value-of select="$node/@word"/>
		
	</xsl:template>
	
	<xsl:template name="wordAndGloss">
		<xsl:param name="node" select="."/>
		<xsl:param name="overrideName" select="name($node)"/>
		
		<xsl:if test="$debug='1'">
			<xsl:attribute name="debug">600:<xsl:value-of select="$overrideName"/>
				<xsl:if test="$node/following-sibling::Word[1]/@pos='suffix-pronoun'">
					<xsl:text>.</xsl:text>
					<xsl:value-of select="$node/following-sibling::Word/@word"/>
				</xsl:if>
				<xsl:text>.Gloss:</xsl:text>
				<xsl:value-of select="$node/@gloss"/>
			</xsl:attribute>
		</xsl:if>
		
		<xsl:attribute name="word">
			<!-- ensure opening parenthesis for elided words -->
			<xsl:if test="$node/ancestor-or-self::*[@status='elided'] and not(starts-with($node/@word,'('))">(</xsl:if>
			
			<!-- article -->			
			<xsl:if test="$node/preceding::Word[1]/@pos='article' and not($node/preceding::Word[1]/@status='elided')">
				<xsl:value-of select="translate($node/preceding::Word[1]/@word, '֪֢̩()ˌ̩ ֑֖֛֣֤֥֦֧֢֢֚֭֮֒֓֔֕֗֘֙֜֝֞֟֠֡֨֩֫֬', '')"/>
				<xsl:text>$</xsl:text>
			</xsl:if>
			
			<!-- other prefixes -->
			<xsl:if test="$node/@prefix">
				<xsl:value-of select="$node/@prefix"/>
				<xsl:text>$</xsl:text>
			</xsl:if>
			
			<!-- word itself -->			
			<xsl:call-template name="stripAccents">
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			
			<!-- suffix-pronouns -->
			
			<!--			<xsl:if test="not(@pos='preposition')">  when a bug is fixed, we'll include prepositions as well -->
			<xsl:choose>
				
				<xsl:when test="@pos='suffix-pronoun'">
					<!-- suffixes don't need suffixes -->
				</xsl:when>
				
				
				<xsl:when test="$node/following::Word[1]/@pos='suffix-pronoun'">
					<!-- old way -->
					<xsl:text>$</xsl:text>
					<xsl:call-template name="stripAccents">
						<xsl:with-param name="node" select="$node/following::Word[@pos='suffix-pronoun']"/>
					</xsl:call-template>
				</xsl:when>
				
				
				
				<xsl:when test="$node/following::xWord[1]/@pos='suffix-pronoun'">
					
					<xsl:call-template name="includeSuffix">
						<xsl:with-param name="base" select="$node"/>
						<xsl:with-param name="pronoun" select="$node/following::Word[1]"/>
						<xsl:with-param name="index" select="count($node/following::Word[1]/preceding::Word[@pos='suffix-pronoun'])"/>
						<xsl:with-param name="textElement" select="concat('$', $node/following::Word[1]/@word)"/>
						
					</xsl:call-template>
					
				</xsl:when>
				<xsl:when test="name(..)='xNominal'">
					<!-- a noun needing a suffix may be embedded within a nominal -->
					<xsl:call-template name="includeSuffix">
						<xsl:with-param name="base" select="$node/.."/>
						<xsl:with-param name="pronoun" select="$node/../following::Word[@pos='suffix-pronoun']"/>
						<xsl:with-param name="index" select="count($node/following::Word[1]/preceding::Word[@pos='suffix-pronoun'])"/>
						<xsl:with-param name="textElement" select="concat('$', $node/../following::Word[@pos='suffix-pronoun']/@word)"/>
					</xsl:call-template>
				</xsl:when>
				
				
			</xsl:choose>
			<!--></xsl:if> -->
			
			<!-- ensure closing parenthesis for elided words -->
			<xsl:if test="$node/ancestor-or-self::*[@status='elided'] and not(starts-with($node/@word,'('))">)</xsl:if>
		</xsl:attribute>
		
		
		<!-->		<xsl:if test="not($node/ancestor-or-self::*[@status='elided'])"> -->
		<xsl:if test="$showGlosses='1'">
			
			<xsl:choose>
				<xsl:when test="$node/attribute::*[name()=$language]">
					<xsl:call-template name="showGloss">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="gloss" select="$node/attribute::*[name()=$language]"/>
					</xsl:call-template>
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="showGloss">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="gloss" select="$node/@gloss"/>
					</xsl:call-template>
					
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
		<!-->		</xsl:if> -->
	</xsl:template>
	
	
	<xsl:template name="includeSuffix">
		<xsl:param name="base"/>
		<xsl:param name="pronoun"/>
		<xsl:param name="ancestors" select="
		           $base/ancestor::*
		           [count(. | $pronoun/ancestor::*) 
		           = 
		           count($pronoun/ancestor::*)
		           ]
		           "/>
		<xsl:param name="ancestor" select="$ancestors[last()]"/>
		<xsl:param name="textElement"/>
		
		
		<!-- ensure no intervening clauses -->
		<xsl:if test="count(
		        $ancestor/descendant::Clause
		        [count(. | $pronoun/preceding::Clause)
		        =
		        count($pronoun/preceding::Clause)]
		        )=0">
			
			
			<!-- ensure no intervening Adjectivals -->
			<xsl:if test="count(
			        $ancestor/descendant::Adjectival
			        [count(. | $base/ancestor::Adjectival)
			        =
			        count($base/ancestor::Adjectival)]
			        )=0">
				
				<!-- ensure no intervening words -->
				<xsl:if test="count(
				        $base/following::Word
				        [count(. | $pronoun/preceding::Word)
				        =
				        count($pronoun/preceding::Word)]
				        )=0">
					
					<!-- ensure common ancestor is a viable one for a suffix -->
					<xsl:if test="name($ancestor)='ConstructChain' 
					        or name($ancestor)='PrepositionalPhrase'
					        or name($ancestor)='Predicate'">
						
						<xsl:value-of select="$textElement"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		
		
	</xsl:template>		
	
	<xsl:template name="showGloss">
		<xsl:param name="node" select="."/>
		<xsl:param name="gloss" select="@gloss"/>
		
		<xsl:choose>			
			<xsl:when test="@SDBH">
				<xsl:attribute name="gloss">
					<xsl:choose>
						<xsl:when test="$node/attribute::*[name()=$language]">
							<xsl:value-of select="$node/attribute::*[name()=$language]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$gloss"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>$v. </xsl:text>
					<xsl:value-of select="@SDBH"/>
				</xsl:attribute> 
			</xsl:when>
			
			<xsl:when test="contains($gloss, '* >>')"> 
				<xsl:attribute name="gloss">
					<xsl:value-of select="substring-before($gloss,'* >>')"/> <!-- HELP -->
					<xsl:text> $>> </xsl:text>
					<xsl:value-of select="substring-after($gloss,'>>')"/>
				</xsl:attribute> 
			</xsl:when>
			
			<xsl:when test="contains($gloss, '>>')"> 
				<xsl:attribute name="gloss">
					<xsl:value-of select="substring-before($gloss,'>>')"/> <!-- HELP -->
					<xsl:text> >>$ </xsl:text>
					<xsl:value-of select="substring-after($gloss,'>>')"/>
				</xsl:attribute> 
			</xsl:when>
			
			<xsl:when test="contains($gloss, '&gt;&gt;')"> 
				<xsl:attribute name="gloss">
					<xsl:value-of select="substring-before($gloss,'&gt;&gt;')"/> <!-- HELP -->
					<xsl:text> &gt;&gt;$ </xsl:text>
					<xsl:value-of select="substring-after($gloss,'&gt;&gt;')"/>
				</xsl:attribute> 
			</xsl:when>
			
			<xsl:otherwise>
				
				<xsl:attribute name="gloss">
					<xsl:value-of select="$gloss"/>
				</xsl:attribute>
				
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<!--
	     Relative and subordinate clauses 
	     -->
	<xsl:template match="RelativeParticle">
		<!-- relative particle itself -->
		<xsl:param name="subordinateClause"/>
		<xsl:if test="$debug='1'">
			<debug>(305: <xsl:value-of select="name()"/>)<xsl:value-of select="name(Clause/*[1])"/></debug>
		</xsl:if>
		<xsl:apply-templates select="*">
			<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="SubordinateClause/Conjunction">
		<!-- subordinating particle itself -->
		<xsl:param name="subordinateClause"/>
		<xsl:if test="$debug='1'">
			<debug>(306: <xsl:value-of select="name()"/>)<xsl:value-of select="name(Clause/*[1])"/></debug>
		</xsl:if>
		<xsl:apply-templates select="*">
			<xsl:with-param name="subordinateClause" select="$subordinateClause"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Nominal[RelativeClause]|Complement[RelativeClause]|Object[RelativeClause]|Subject[RelativeClause]|Vocative[RelativeClause]">
		<!-- headed relative clause -->
		<xsl:param name="modifiers"/>
		<xsl:param name="constructChain"/>
		<xsl:if test="$debug='1'">
			<debug>(300.1: <xsl:value-of select="name()"/>)</debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$modifiers">
				<xsl:apply-templates select="Word[@pos='noun']|Nominal|Word[@pos='verb-participle']">
					<xsl:with-param name="modifiers" select="$modifiers|Word[@pos='adjective' or @pos='quantifier']|Adjectival"/>
					<xsl:with-param name="article" select="Word[@pos='article']"/>
					<xsl:with-param name="subordinateClause" select="RelativeClause"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- not sure this should really be limited to nouns... or nominal? -->
				<xsl:apply-templates select="Word[@pos='noun']|Nominal|Word[@pos='verb-participle']">
					<xsl:with-param name="article" select="Word[@pos='article']"/>
					<xsl:with-param name="modifiers" select="Word[@pos='adjective' or @pos='quantifier']|Adjectival"/>
					<xsl:with-param name="subordinateClause" select="RelativeClause"/>
					<xsl:with-param name="constructChain" select="$constructChain"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Complement[not(Adjectival or Word/@pos='adjective' or Word/@pos='quantifier' or Word/@pos='verb-participle') and Adverbial]">
		<xsl:if test="$debug='1'">
			<debug>(300.20: <xsl:value-of select="name()"/>)
				<xsl:value-of select="name(Clause/*[1])"/>
			</debug>
		</xsl:if>
		<straight style="implied" word="( )">
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="*"/>
		</straight>
	</xsl:template>
	<xsl:template match="Complement[RelativeClause and not(Word or Nominal)]
	              |Subject[RelativeClause and not(Word or Nominal)]
	              |Nominal[RelativeClause and not(Word or Nominal) and not(name(..)='Adjectival')]
	              |Object[RelativeClause and not(Word or Nominal)]">
		<!-- headless relative clause -->
		<xsl:if test="$debug='1'">
			<debug>(300.2: <xsl:value-of select="name()"/>)
				<xsl:value-of select="name(Clause/*[1])"/>
			</debug>
		</xsl:if>
		<straight style="implied" word="( )">
			<xsl:call-template name="adjustColours"/>
			<xsl:apply-templates select="*"/>
		</straight>
	</xsl:template>
	<xsl:template match="RelativeClause|SubordinateClause">
		<!-- relative or subordinate clause itself -->
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(300.4: <xsl:value-of select="name()"/>)<xsl:value-of select="name(Clause/*[1])"/></debug>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="RelativeParticle|Conjunction">
				<xsl:apply-templates select="RelativeParticle|Conjunction">
					<xsl:with-param name="subordinateClause" select="*[name()='Clause' or name()='ClauseCluster']"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- always do this?? -->
				<down hidden="true">
					<xsl:apply-templates select="*[name()='Clause' or name()='ClauseCluster']"/>
				</down>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ClauseCluster/RelativeClause|ClauseCluster/SubordinateClause">
		<!-- relative or subordinate clause modifying multiple clauses in a cluster -->
		<xsl:param name="modifiers"/>
		<xsl:if test="$debug='1'">
			<debug>(300.5: <xsl:value-of select="name()"/>)<xsl:value-of select="name(Clause/*[1])"/></debug>
		</xsl:if>
		<straight>
			<xsl:call-template name="adjustColours"/>
			<xsl:choose>
				<xsl:when test="RelativeParticle|Conjunction">
					<xsl:apply-templates select="RelativeParticle|Conjunction">
						<xsl:with-param name="subordinateClause" select="*[name()='Clause' or name()='ClauseCluster']"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*[name()='Clause' or name()='ClauseCluster']"/>
				</xsl:otherwise>
			</xsl:choose>
		</straight>
	</xsl:template>
</xsl:stylesheet>
