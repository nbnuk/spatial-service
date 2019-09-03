curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/nurc?recurse=true
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/cite?recurse=true
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/it.geosolutions.html?recurse=true
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/sde?recurse=true
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/sf?recurse=true
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/tiger?recurse=true
curl -v -u admin:geoserver -XDELETE http://localhost:8080/geoserver/rest/workspaces/topp?recurse=true
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<workspace><name>ALA</name></workspace>" http://localhost:8080/geoserver/rest/workspaces

#create LayersDB store
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<dataStore><name>LayersDB</name><connectionParameters><host>localhost</host><port>5432</port><database>layersdb</database><schema>public</schema><user>postgres</user><passwd>postgres</passwd><dbtype>postgis</dbtype></connectionParameters></dataStore>" http://localhost:8080/geoserver/rest/workspaces/ALA/datastores

#create styles
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<style><name>distributions_style</name><filename>distributions_style.sld</filename></style>" http://localhost:8080/geoserver/rest/styles
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<style><name>envelope_style</name><filename>envelope_style.sld</filename></style>" http://localhost:8080/geoserver/rest/styles
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<style><name>alastyles</name><filename>alastyles.sld</filename></style>" http://localhost:8080/geoserver/rest/styles
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<style><name>points_style</name><filename>points_style.sld</filename></style>" http://localhost:8080/geoserver/rest/styles

#upload styles
wget -O /tmp/distributions_style.sld https://github.com/AtlasOfLivingAustralia/spatial-database/raw/master/distributions_style.sld
wget -O /tmp/envelope_style.sld https://github.com/AtlasOfLivingAustralia/spatial-database/raw/master/envelope_style.sld
wget -O /tmp/alastyles.sld https://github.com/AtlasOfLivingAustralia/spatial-database/raw/master/alastyles.sld
wget -O /tmp/points_style.sld https://github.com/AtlasOfLivingAustralia/spatial-database/raw/master/points_style.sld
curl -v -u admin:geoserver -XPUT -H "Content-type: application/vnd.ogc.sld+xml" -d @/tmp/distributions_style.sld http://localhost:8080/geoserver/rest/styles/distributions_style
curl -v -u admin:geoserver -XPUT -H "Content-type: application/vnd.ogc.sld+xml" -d @/tmp/envelope_style.sld http://localhost:8080/geoserver/rest/styles/envelope_style
curl -v -u admin:geoserver -XPUT -H "Content-type: application/vnd.ogc.sld+xml" -d @/tmp/alastyles.sld http://localhost:8080/geoserver/rest/styles/alastyles
curl -v -u admin:geoserver -XPUT -H "Content-type: application/vnd.ogc.sld+xml" -d @/tmp/points_style.sld http://localhost:8080/geoserver/rest/styles/points_style

#create layer
curl -u admin:geoserver -XPOST -H 'Content-type: text/xml' -T geoserver.objects.xml  http://localhost:8080/geoserver/rest/workspaces/ALA/datastores/LayersDB/featuretypes
curl -u admin:geoserver -XPOST -H 'Content-type: text/xml' -T geoserver.distributions.xml  http://localhost:8080/geoserver/rest/workspaces/ALA/datastores/LayersDB/featuretypes
curl -u admin:geoserver -XPOST -H 'Content-type: text/xml' -T geoserver.points.xml  http://localhost:8080/geoserver/rest/workspaces/ALA/datastores/LayersDB/featuretypes

#assign styles to layers

curl -u admin:geoserver -XPUT -H 'Content-type: text/xml' -d '<layer><defaultStyle><name>distributions_style</name><workspace>ALA</workspace></defaultStyle></layer>' http://localhost:8080/geoserver/rest/layers/ALA:Objects
curl -u admin:geoserver -XPUT -H 'Content-type: text/xml' -d '<layer><defaultStyle><name>distributions_style</name><workspace>ALA</workspace></defaultStyle></layer>' http://localhost:8080/geoserver/rest/layers/ALA:Distributions
curl -u admin:geoserver -XPUT -H 'Content-type: text/xml' -d '<layer><defaultStyle><name>points_style</name><workspace>ALA</workspace></defaultStyle></layer>' http://localhost:8080/geoserver/rest/layers/ALA:Points

#additional actions

#upload icon
wget -O /tmp/marker.png https://github.com/AtlasOfLivingAustralia/spatial-database/raw/master/marker.png
curl -u admin:geoserver -XPUT -H 'Content-type: image/png' -d @/tmp/marker.png http://localhost:8080/geoserver/rest/resource/styles/marker.png
