# wasps2kotka

R package for use at the [Zoological Museum of the University of Turku](https://collections.utu.fi/en/zoological-museum/). Helps database the wasps of the larger collections: 
- wasps collected by Malaise trapping in [Peru 1998-2011](https://doi.org/10.5281/zenodo.3559054)
- wasps collected by Malaise trapping in [Uganda 2014-2015](https://doi.org/10.5281/zenodo.2225643)
- wasps collected by canopy fogging in Ecuador
- wasps collected in Skanssi, Finland, in 2024

Takes the text of wasp labels, or the sample IDs of the wasps. Extracts data from the labels, and collects data on the sample. Then creates a csv file for uploading the data to [Kotka](https://wiki.helsinki.fi/display/digit/Manual+for+Kotka). 

Typically used when faced with the daunting task of digitising thousands of tropical wasps, whose only information is on the labels. With this package, all you need to do is write down the label texts. The computer will do (almost) everything else to get the data to the [Kotka Collection Management System](https://wiki.helsinki.fi/display/digit/Manual+for+Kotka) and [FinBIF](https://laji.fi/en).

Also used to quickly upload the data of recently pinned Ugandan wasps to the database. All that is needed are the sample IDs of each wasp, the computer does everything else.


## Installation

You can install the development version of wasps2kotka from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tapani-hopkins/wasps2kotka")
```

## Usage

### Short version

``` r
# load the package
library(wasps2kotka)

# save example labels
x = data.frame(label=c( "PERU 1.-15.12.2000, I1/17", "Tiputini 22. Oct 1998 Canopy fogging" ))

# get data from the labels, verify it and create upload
make_upload(x)
```

### More detailed usage

Typically, you will have a list of label texts (Peru & Ecuador) or sample identifiers (Uganda). Something like this:

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
labels = read.csv("/path/to/labelfile.csv", as.is=TRUE)
```

Easiest is to name the column that has labels "label". This column name is recognised automatically by the script. You can also give additional data in the following columns:
- `box` Added to the equivalent column in Kotka, "MYDocumentLocation".
- `date_begin` Start date in format "04.12.1998".
- `date_end` End date in format "04.12.1998".
- `sample` Sample identifier. If the labels give a different sample to this, this is the sample whose data will be added to Kotka.
- `sex` One of "F", "M" or "U". If the sex given by labels contradicts this, this is the one which will be added to Kotka.

``` r
# load the package
library(wasps2kotka)

# example labels
labels = c(
"cct1-141022",  
"PERU, Allpahuayo 1.-15.12.2000, Sääksjärvi I.E I1/17 Occia sp. 1. ♀ ",  
"ECUADOR, Tiputini, 22. Oct 1998, Canopy fogging Lot# 1966 Meniscomorpha sp. 2"  
)

# example data on sex (wasp 1 is female)
sex = c("F", NA, NA)

# save labels and other data as data frame
x = data.frame(label=labels, sex=sex)

# create a Kotka upload file for these wasps
make_upload(x)
```

This results in a file (kotka_upload.csv) with all the data on the wasps in the format expected by Kotka. 

Before uploading to Kotka, open the file in e.g. Excel, and fill in any fields which are still missing. E.g. specimen ID and species name will typically need filling in. 

Then save and and upload the file to Kotka. 

