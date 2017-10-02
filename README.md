# OTU Groupings Workflow Script

## Table of Contents

[What does this workflow do?](#intro)    
[Why is this important?](#importance)       
[Quickstart](#quickstart)    
[Installing OTU_Grouping](#install)    
[OTU_Grouping Usage](#usage)      

## <a name="intro"></a>What does this workflow do?

## <a name="importance"></a>Why is this important?

## <a name="install"></a>Installing OTU_Groupings

Required software
+ QIIME: [download](http://qiime.org/install/index.html)
+ R: [download](https://cran.r-project.org/)
+ R plyr: [documentation](https://cran.r-project.org/web/packages/plyr/index.html)
+ R dplyr: [documentation](https://cran.r-project.org/web/packages/dplyr/index.html) 

## <a name="usage"></a><a name="quickstart"></a>OTU_Grouping Usage

#### Example usage

```
./workflow.sh -b [biom table] -t [threshold]
```

#### Required arguments:

| Option     | Description                                     |
|------------|-------------------------------------------------|
| **-b**   | Path of biom table to operate on           |
| **-t**   | Threshold for otu low abundance filtering |
