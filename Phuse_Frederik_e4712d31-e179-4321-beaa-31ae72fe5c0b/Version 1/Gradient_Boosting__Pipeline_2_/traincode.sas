*------------------------------------------------------------*;
* Macro Variables for input, output data and files;
  %let dm_datalib       =;                 /* Libref associated with the CAS training table */
  %let dm_output_lib    = &dm_datalib;     /* Libref associated with the output CAS tables */
  %let dm_data_caslib   =;                 /* CASLIB associated with the training table */
  %let dm_output_caslib = &dm_data_caslib; /* CASLIB associated with the output tables */
  %let dm_inputTable=;  /* Input Table */
  %let dm_memName=_input_DNGOB3MOZDU4DFX9F9860I81W;
  %let dm_memNameNLit='_input_DNGOB3MOZDU4DFX9F9860I81W'n;
  %let dm_lib     = WORK;
  %let dm_folder  = %sysfunc(pathname(work));
*------------------------------------------------------------*;
*------------------------------------------------------------*;
  * Preparing the training data for modeling;
*------------------------------------------------------------*;
data &dm_datalib.._input_DNGOB3MOZDU4DFX9F9860I81W/ SESSREF=&_SESSREF_;
   set &dm_trainlib..'DM_DGEC7WKD8F1QYK6B0ZLKQVP8T'n;
drop 
'elapsed_s'n
'ID'n
'ID_NOTE'n
'NOTE'n
;
run;
*------------------------------------------------------------*;
  * Training for gradboost;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
  * Initializing Variable Macros;
*------------------------------------------------------------*;
%macro dm_unary_input;
%mend dm_unary_input;
%global dm_num_unary_input;
%let dm_num_unary_input = 0;
%macro dm_interval_input;
'x_axis_deg_s'n 'x_axis_g'n 'y_axis_deg_s'n 'y_axis_g'n 'z_axis_deg_s'n
'z_axis_g'n
%mend dm_interval_input;
%global dm_num_interval_input;
%let dm_num_interval_input = 6 ;
%macro dm_binary_input;
'Eyes'n 'Support'n
%mend dm_binary_input;
%global dm_num_binary_input;
%let dm_num_binary_input = 2 ;
%macro dm_nominal_input;
%mend dm_nominal_input;
%global dm_num_nominal_input;
%let dm_num_nominal_input = 0;
%macro dm_ordinal_input;
%mend dm_ordinal_input;
%global dm_num_ordinal_input;
%let dm_num_ordinal_input = 0;
%macro dm_class_input;
'Eyes'n 'Support'n
%mend dm_class_input;
%global dm_num_class_input;
%let dm_num_class_input = 2 ;
%macro dm_segment;
%mend dm_segment;
%global dm_num_segment;
%let dm_num_segment = 0;
%macro dm_id;
%mend dm_id;
%global dm_num_id;
%let dm_num_id = 0;
%macro dm_text;
%mend dm_text;
%global dm_num_text;
%let dm_num_text = 0;
%macro dm_strat_vars;
'TARGET'n
%mend dm_strat_vars;
%global dm_num_strat_vars;
%let dm_num_strat_vars = 1 ;
*------------------------------------------------------------*;
  * Initializing Macro Variables *;
*------------------------------------------------------------*;
  %let dm_data_outfit = &dm_lib..outfit;
  %let dm_file_scorecode = &dm_folder/scorecode.sas;
  %let dm_caslibOption =;
  data _null_;
     if index(symget('dm_data_caslib'), '(') or index(symget('dm_data_caslib'), ')' ) or (symget('dm_data_caslib')=' ') then do;
        call symput('dm_caslibOption', ' ');
     end;
     else do;
        call symput('dm_caslibOption', 'caslib="'!!ktrim(symget('dm_data_caslib'))!!'"');
     end;
  run;


*------------------------------------------------------------*;
  * Component Code;
*------------------------------------------------------------*;
proc gradboost data=&dm_datalib..&dm_memnameNlit(&dm_caslibOption)
     earlystop(tolerance=0 stagnation=5 minimum=NO metric=MCR)
     binmethod=QUANTILE
     maxbranch=2
     nomsearch(maxcategories=128)
     assignmissing=USEINSEARCH minuseinsearch=1
     ntrees=100 learningrate=0.1 samplingrate=0.5 lasso=0 ridge=1 maxdepth=4 numBin=50 minleafsize=5
     seed=12345
     printtarget
  ;
  partition rolevar='_PartInd_'n (TRAIN='1' VALIDATE='0' TEST='2');
  target 'TARGET'n / level=nominal;
  input %dm_interval_input / level=interval;
  input %dm_binary_input %dm_nominal_input %dm_ordinal_input %dm_unary_input  / level=nominal;
  ods output
     VariableImportance   = &dm_lib..varimportance
     Fitstatistics        = &dm_data_outfit
     PredProbName = &dm_lib..PredProbName
     PredIntoName = &dm_lib..PredIntoName
  ;
  savestate rstore=&dm_output_lib.._DNGOB3MOZDU4DFX9F9860I81W_ast;
run;
