#!/usr/local/bin/Rscript

library("jsonlite")
library("githubinstall")
library("FaaSr")

faasr <- commandArgs(TRUE)
faasr_source <- fromJSON(faasr)
actionname <- faasr_source$FunctionList[[faasr_source$FunctionInvoke]]$Actionname

gits <- faasr_source$FunctionGitRepo[[actionname]]
if (length(gits)==0){NULL} else{
for (file in gits){
	command <- paste("git clone --depth=1",file)
	system(command, ignore.stderr=TRUE)
	}
}
	
packages <- faasr_source$FunctionCRANPackage[[actionname]]
if (length(packages)==0){NULL} else{
for (package in packages){
	install.packages(package)
	}
}

ghpackages <- faasr_source$FunctionGitHubPackage[[actionname]]
if (length(ghpackages)==0){NULL} else{
for (ghpackage in ghpackages){
	githubinstall("ghpackage")
	}
}

r_files <- list.files(pattern="\\.R$", recursive=TRUE, full.names=TRUE)
for (rfile in r_files){
    if (rfile != "./faasr_start_invoke_openwhisk_aws-lambda.R" && rfile != "./faasr_start_invoke_github-actions.R") {
	  source(rfile)
	}
}


faasr_start(faasr)

