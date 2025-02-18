
----------------------------------
## bidscoin/4.2.1 ##
Contains a collection of tools needed for DICOM to BIDS conversion, as well as MRS spectroscopy and physiological data to BIDS conversion

Tools included:
```
bidscoin: https://bidscoin.readthedocs.io/en/4.2.1
    bidscoin
    bidscoiner
    bidseditor
    bidsmapper
    bidsparticipants
    deface
    dicomsort
    echocombine
    medeface
    physio2tsv
    plotphysio
    rawmapper
    skullstrip
    slicereport
dcm2niix: v1.0.20230411 https://github.com/rordenlab/dcm2niix
spec2nii: v0.7.0: https://github.com/wtclarke/spec2nii
```

Example converting dicom to BIDS: 
```
Getting started:
bidscoin -h

Convert DICOM to BIDS:
bidsmapper inputfolder bidsoutputfolder
bidscoiner inputfolder bidsoutputfolder
```

More documentation can be found here:
https://bidscoin.readthedocs.io/en/4.2.1


Citation:
```
Zwiers MP, Moia S, Oostenveld R. BIDScoin: A User-Friendly Application to Convert Source Data to Brain Imaging Data Structure. Front Neuroinform. 2022 Jan 13;15:770608. doi: 10.3389/fninf.2021.770608. PMID: 35095452; PMCID: PMC8792932.
```

To run container outside of this environment: `ml bidscoin/4.2.1`

----------------------------------
