
 IDEAL pre processign steps:

 (preprocessing 1)
 1. load and read bdf
 2. edit channel locations
 3. filter
 4. reference to AVG
 5. edit triggers
 6. extract all epochs
 7. clean noisy epochs

 FROM DATASET CREATED IN STEP 7:
***************************************************************
 (pre processing 2, 3, 4 - optional)
 8. run ICA
 9. clean noisy epochs again (with ic activation scroll)
10. run ICA again and dipfit
11. choose IC to remove
12. reference to mastiods
13. remove  ICs (strict\liberal?)
14. verify no noisy epochs left
***************************************************************

 OR :
***************************************************************
 (pre processing 5)
15. reference to mastoids:  
16. (after step 7) clean epochs exceeding [-100, 100] 
     threshold and noisy epochs according to elc c3, c4. o1, o2
***************************************************************



 CURRENT PRE-PROCESSIGN STEPS:
1-7.   the same
8-11.  the same
15-16. the same. after extracted to dataset according to condition -  
       urevents are IMPORTENT!
17. assign ICA weights and spheres from data set created in step 10, 
    to condition datasets created after step 16. 
18. remove ICs X2 (strict and liberal) from the condition data sets



