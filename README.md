# Startup board composition data (Ewens and Malenko, 2025)

This file contains the board composition data from Ewens and Malenko (2025) "Board Dynamics over the Startup Lifecycle." [Paper available here](https://osf.io/preprints/socarxiv/t96yq_v1).

## Data description and sample creation

Building this database used a combination of Form D filings and VentureSource.  Users of the data should read section 2 ("Data") and the internet appendix from the [paper](https://osf.io/preprints/socarxiv/t96yq_v1).

## Sample code

Please see the [code folder](https://github.com/michaelewens/vc_backed_boards/tree/main/code) for Python and Stata code to recreate the first figures from the original paper.

## Data structure

The file has the following fields":

- `year`: the year of the startup board data
- `numOut`: the number of independent directors (or outsiders)
-  `numExecs`: the number of directors who are executives of the startup
-  `numVCs`: the number of venture capital directors
-  `startupHadFinancing`: a dummy variable equal to 1 if the startup raised capital in this year
-  `financingRoundNumber`: the financing round number (using the sequence of financing years and other information)
-  `cik1,cik2,cik3,cik4`: the "central identification key" or CIK that identifies the firm in the SEC EDGAR data.  Note that some startups have more than one CIK

## Citation

If you use this data, please cite: 

Ewens, Michael, and Nadya Malenko. "Board dynamics over the startup life cycle."  Journal of Finance, 2025.
```@article{ewens_malenko2025,
  title={Board dynamics over the startup life cycle},
  author={Ewens, Michael and Malenko, Nadya},
  year={2025},
  journal={Journal of Finance}
}
```
