#!/bin/bash
#

START=$(date +%s)

# cd ..

# To start fresh, clean your local repository
# If you have accidentally invoked
#   mvn install
# or want to assert that you start over fresh,
# delete the Maven repository:
# rm -rf $HOME/.m2/repository
# rm -rf $HOME/.m2/repository/p2/bundle/osgi/org.csstudio.*
# rm -rf $HOME/.m2/repository/p2/bundle/osgi/org.diirt.*
rm -f ?_*.log
#
# To reduce maven verbosity
# MAVEN_OPTS = $MAVEN_OPTS -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
# MVNOPT="-P !cs-studio-sites,!eclipse-sites -B -DlocalArtifacts=ignore"
MVNOPT="-X -B -P ess-css-settings,platform-default,csstudio-composite-repo-enable,eclipse-sites"

echo ""
echo "===="
echo "==== BUILDING maven-osgi-bundles"
echo "===="
(cd maven-osgi-bundles; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings-no-tests.xml clean verify) | tee 0_maven-osgi-bundles.log
cd ..

echo ""
echo "===="
echo "==== BUILDING cs-studio-thirdparty"
echo "===="
(cd cs-studio-thirdparty; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings-no-tests.xml clean verify) | tee 1_cs-studio-thirdparty.log
cd ..

echo ""
echo "===="
echo "==== BUILDING diirt"
echo "===="
(cd diirt; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings-no-tests.xml clean verify) | tee 2_diirt.log
cd ..

echo ""
echo "===="
echo "==== BUILDING cs-studio/core"
echo "===="
(cd cs-studio/core; time mvn $MVNOPT --settings ../../ess-css-extra/maven/settings-no-tests.xml clean verify) | tee 3_cs-studio-core.log

echo ""
echo "===="
echo "==== BUILDING cs-studio/applications"
echo "===="
(cd cs-studio/applications; time mvn $MVNOPT --settings ../../ess-css-extra/maven/settings-no-tests.xml clean verify) | tee 4_cs-studio-applications.log
cd ..
echo ""
echo "===="
echo "==== BUILDING org.csstudio.display.builder"
echo "===="
(cd org.csstudio.display.builder; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings-no-tests.xml -Dcss_repo=file:/home/jenkins/workspace/css-ce/ess-css-extra/ess_css_comp_repo clean verify) | tee 5_org.csstudio.display.builder.log
cd ..
echo ""
echo "===="
echo "==== BUILDING org.csstudio.product"
echo "===="
pwd >> 6_org.csstudio.product.log
(cd org.csstudio.product; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings-no-tests.xml clean verify) | tee 6_org.csstudio.product.log
cd ..
echo ""
echo "===="
echo "==== BUILDING org.csstudio.ess.product"
echo "===="
pwd >> 7_org.csstudio.ess.product.log
(cd org.csstudio.ess.product; time mvn $MVNOPT --settings ../ess-css-extra/maven/settings-no-tests.xml clean verify) | tee 7_org.csstudio.ess.product.log

cd ..
echo ""
tail ?_*.log
echo ""

# Displaying execution time
DUR=$(echo "$(date +%s) - $START" | bc)
MDUR=`expr $DUR / 60`; \
SDUR=`expr $DUR - 60 \* $MDUR`; \
echo "===="
echo "==== Building took $MDUR minutes and $SDUR seconds."
echo "===="
