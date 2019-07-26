# ess-css-extra

Folder containing all accessory files and folders necessary to compile and deploy ESS version of CS-Studio.

## ess_css_comp_repo

This repository contains the _Composite P2 Repository_ files as described in [Control System Studio Guide](http://cs-studio.sourceforge.net/docbook/ch04.html#idp157632), needed to manually build the product using Maven.

## home/dot-profile

This file contains the environment variables to be set and included into the ~/.profile file.

## maven

This folder contains various files to be used by Maven during the build.

## gitlab

This folder contains the `CSStudio.gitlab-ci.yml` template used by GitLab to run the various pipelines.

In each GitLab project, you should include this template in your `.gitlab-ci.yml` file and override the desired variables.

Here is the list of default variables:

```
variables:
  MAVEN_IMAGE: registry.esss.lu.se/ics-docker/maven:openjdk-8
  MAVEN_OPTS: -Xmx2048m -Xms1024M -Xss128M -XX:-UseGCOverheadLimit
  MVNOPT: "-q -B -P ess-css-settings,platform-default,csstudio-composite-repo-enable,eclipse-sites -Dmaven.repo.local=${CI_PROJECT_DIR}/css-maven-repo/.m2 -Dcsstudio.composite.repo=${CI_PROJECT_DIR}/ess-css-extra/ess_css_comp_repo"
  REPO_BRANCH: master
  CSSTUDIO_REPO_BASE_URL: https://github.com/ESSICS
  DISPLAY_BUILDER_REPO: https://github.com/ESSICS/org.csstudio.display.builder
  DISPLAY_BUILDER_REPO_BRANCH: master
  RELEASE_TO_ARTIFACTORY: "true"
  ARTIFACTORY_FOLDER: CSSGitlab/development
```

## jenkins

This folder contains the file used by Jenkins to run the various pipelines.

css-pipeline is the jenkinsfile that builds and tests the CS-Studio -community, ess -development and -production

css-devenv-integration-pipeline is the jenkinsfile that creates a virtual machine and launches the lates cs-studio production version. It needs the testcs.json file to specify how the virtual machine should be created. The folder scripts contains the scripts that will be ran on the virtual machine specified by testcs.json.        

### Step by step creation of a pipeline

1.	Have Jenkins 2.x with pipeline and version control plugins installed.
2.	Press “New Item” [top left].
3.	Choose name and the item type “Pipeline”.
4.	In the menu furthest down called “pipeline” change the definition to “Pipeline script from SCM”.
5.	Paste the url to the repo containing the Jenkinsfile and the path to it from within the repo (this repo).

### Config for the pipelines

For reusability, the script is reliant on parameters from the user. These parameters are to be inputted through configuring jenkins and require the plug in "environment injector".
The option **Prepare an environment for the run** then gets available for the user. Variables can then be defined in the textfield **Properties Content**.

The css-devenv-integration-pipeline is intended to be ran after the production version has been built by css-pipeline. In order to make a pipeline start after another you need to make the second pipeline listen to the previous job as nan upstream. Do this by adding the configuration property "Build after other projects are built" under "Build Triggers", there you can set any type of project as upstream.  

### Default environments used at ESS

#### CS-Studio Community Edition

```
csstudioRepo=https://github.com/ControlSystemStudio
displayBuilderRepo=https://github.com/kasemir/org.csstudio.display.builder
diirtRepo=https://github.com/diirt/diirt
repoBranch=master
buildFolder=css-ce
email=test@replace.se
useArtifactory=false

```

#### ESS CS-Studio development

```
csstudioRepo=https://github.com/ESSICS
displayBuilderRepo=https://github.com/ESSICS/org.csstudio.display.builder
diirtRepo=https://github.com/ESSICS/diirt
repoBranch=master
buildFolder=ess-css-development
email=test@replace.se
useArtifactory=true
artifactoryServerID=<replace>
artifactoryFolder=development

```

#### ESS CS-Studio production

```
csstudioRepo=https://github.com/ESSICS
displayBuilderRepo=https://github.com/ESSICS/org.csstudio.display.builder
diirtRepo=https://github.com/ESSICS/diirt
repoBranch=production
buildFolder=ess-css-production
email=test@replace.se
useArtifactory=true
artifactoryServerID=<replace>
artifactoryFolder=production

```

### Adding slack integration

1. Download slack notification plugin for jenkins.
2. Go to the slack url <teamname>.slack.com/apps/ and find jenkins integration.
3. Press "add configuration" for the channel you want to add the integration to.
4. Copy and add the Team domain, token and channel name for the pipeline script.

Currently Slack is not used to notify user's abount the pipeline.

#### Example

```
slackSend message: "Build Started", token: 'AKrq2kTrwtrFjepxe6OFC5Lu', channel: "<theChannel>", teamDomain: "teamName"
```

### Jenkinsfile syntax references

[Supported steps (predefined methods) for the jenkins file](https://jenkins.io/doc/pipeline/steps/)

[Syntax reference, includes almost everything needed](https://jenkins.io/doc/book/pipeline/syntax/)

### Useful tips

* Use triple ' (''') for a literal string.
* Substitution (using $variable) requires explicit string sign ("").
* The "steps" are ran on the slave, other is ran on the master.
* Variables declared in the "environment"-block are accessible from the slave as exported variables.
