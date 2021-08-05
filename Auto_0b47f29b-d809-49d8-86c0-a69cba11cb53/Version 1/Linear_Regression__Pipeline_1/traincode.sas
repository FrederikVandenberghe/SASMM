*------------------------------------------------------------*;
* Macro Variables for input, output data and files;
  %let dm_datalib       =;                 /* Libref associated with the CAS training table */
  %let dm_output_lib    = &dm_datalib;     /* Libref associated with the output CAS tables */
  %let dm_data_caslib   =;                 /* CASLIB associated with the training table */
  %let dm_output_caslib = &dm_data_caslib; /* CASLIB associated with the output tables */
  %let dm_memName= ;    /* Training Table name */
  %let dm_memnameNlit = %sysfunc(nliteral(&dm_memname));
  %let dm_lib     = WORK;
  %let dm_folder  = %sysfunc(pathname(work));
*------------------------------------------------------------*;
*------------------------------------------------------------*;
  * Training for linearreg;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
  * Initializing Variable Macros;
*------------------------------------------------------------*;
%macro dm_unary_input;
%mend dm_unary_input;
%global dm_num_unary_input;
%let dm_num_unary_input = 0;
%macro dm_interval_input;
'CurrentBid'n 'Miles'n 'OriginalInvoice'n 'OriginalMSRP'n
%mend dm_interval_input;
%global dm_num_interval_input;
%let dm_num_interval_input = 4 ;
%macro dm_binary_input;
%mend dm_binary_input;
%global dm_num_binary_input;
%let dm_num_binary_input = 0;
%macro dm_nominal_input;
'Make'n 'Model'n 'state'n 'VIN'n 'Year'n
%mend dm_nominal_input;
%global dm_num_nominal_input;
%let dm_num_nominal_input = 5 ;
%macro dm_ordinal_input;
%mend dm_ordinal_input;
%global dm_num_ordinal_input;
%let dm_num_ordinal_input = 0;
%macro dm_class_input;
'Make'n 'Model'n 'state'n 'VIN'n 'Year'n
%mend dm_class_input;
%global dm_num_class_input;
%let dm_num_class_input = 5 ;
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
%mend dm_strat_vars;
%global dm_num_strat_vars;
%let dm_num_strat_vars = 0;
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
proc regselect data=&dm_datalib..&dm_memnameNlit;
  partition rolevar='_PartInd_'n (TRAIN='1' VALIDATE='0' TEST='2');
  class
     %dm_class_input
     /
     param=GLM
  ;
  model 'BlueBookPrice'n=
     %dm_interval_input
     %dm_class_input
     / VIF 
     ;
  selection method=STEPWISE( select=SBC stop=SBC slEntry=0.05 slStay=0.05 Hierarchy=NONE choose=SBC );
  ods output ModelInfo = &dm_lib..PredNameTable
     SelectionSummary = &dm_lib..Selection(drop=Control)
     ParameterEstimates   = &dm_lib..ParamEstsA
     FitStatistics        = &dm_lib..OutFit
  ;
  code file="&dm_file_scorecode." labelid=46956035;
run;
