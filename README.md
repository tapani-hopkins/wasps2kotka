# wasps2kotka

R package for use at the [Zoological Museum of the University of Turku](https://collections.utu.fi/en/zoological-museum/). Helps database the wasps of the larger collections: 
- wasps collected by Malaise trapping in [Peru 1998-2011](https://doi.org/10.5281/zenodo.3559054)
- wasps collected by Malaise trapping in [Uganda 2014-2015](https://doi.org/10.5281/zenodo.2225643)
- wasps collected by canopy fogging in Ecuador

Takes the text of the wasp labels (Peru and Ecuador) or the sample IDs of the wasps (Uganda). Then extracts data from the labels and creates a csv file for uploading the data to [Kotka](https://wiki.helsinki.fi/display/digit/Manual+for+Kotka). For the Peruvian and Ugandan wasps, data on the Malaise trapping is also included. 

Typically used when faced with the daunting task of digitising thousands of tropical wasps, whose only information is on the labels. With this package, all you need to do is write down the label texts. The computer will do (almost) everything else to get the data to the [Kotka Collection Management System](https://wiki.helsinki.fi/display/digit/Manual+for+Kotka) and [FinBIF](https://laji.fi/en).


## Installation

You can install the development version of wasps2kotka from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tapani-hopkins/wasps2kotka")
```

## Usage

### Short version

``` r
# save labels
example_labels = c( "PERU 1.-15.12.2000, I1/17", "Tiputini 22. Oct 1998 Canopy fogging" )

# load the package
library(wasps2kotka)

# get data from the labels, verify it and create upload
x = get_labeldata(example_labels)
x = verify_labeldata(x)
make_kotkaupload(x)
```

### More detailed usage

Typically, you will have a list of label texts (Peru & Ecuador) or sample IDs (Uganda). Something like this:

> PERU, Dept. of Loreto Iquitos area, Allpahuayo 1.-15.12.2000, white sand Sääksjärvi I.E et al. leg. Malaise trap, APHI, I1/17  
Hylesicida sp. ♂ 1st male Det. Ilari Sääksiärvi 2011  
ZMUT NEOT ICH 208

> ECUADOR, Dept. Orellana, Tiputini, 22. Oct 1998 00°37'55" S, 076°08'39" W, 220-250 m, Canopy fogging T.L. Erwin et al. Lot# 1966  
New gen. / Meniscomorpha sp. 2 ♂Det. Ilari Sääksiärvi 2011  
ZMUT NEOT ICH 209

> cct1- 141022

The job of this package is to go through all of these labels, and detect that:
- label 1 is from sample I1-17 and is a male
- label 2 is a canopy fogged male collected at Tiputini 22 October 1998
- label 3 is an Ugandan wasp from sample CCT1-141022

.. and then pack all of the data (from labels and their associated samples) into a Kotka upload file.

To get this done, simply load the labels to R. You can e.g. save them in Excel, export as csv, then read them in to R with `read.csv`.
``` r
labels = read.csv("/path/to/labelfile.csv", as.is=TRUE)[, 1]
```

Once the labels are in R, all you need to do is get the data from them (`get_labeldata`), optionally verify the label data (`verify_labeldata`), and create the Kotka upload file(`make_kotkaupload`):

``` r
# example labels
labels = c(
"cct1-141022",  
"PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17",  
"ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2"  
)

# load the package
library(wasps2kotka)

# get data from the labels
x = get_labeldata(labels)

# check the extracted data (e.g. that no data is missing, dates look right..)
x = verify_labeldata(x)

# create a Kotka upload file for these wasps
make_kotkaupload(x)
```

This results in a file (kotka_upload.csv) with three sets of columns. In order from left to right:
1. **problems**: One column, where any issues found by `verify_labeldata` will be listed.
2. **label data**: All the data extracted from the labels, such as dates, sex, sample ID etc.
3. **Kotka**: All the data on the wasps in the format expected by Kotka.

Before uploading to Kotka, open the file in e.g. Excel, and check any highlighted problems. You may also need to fill in some fields which the script does not currently handle, e.g. specimen ID, location and species name. 

Then delete the columns for problems and label data (they are clearly marked in the file), and upload to Kotka. 

