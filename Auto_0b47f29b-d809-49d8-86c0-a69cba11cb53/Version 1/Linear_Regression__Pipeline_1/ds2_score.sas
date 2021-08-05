ds2_options sas tkgmac scond=none;
 data SASEP.out;
 #_local _J_;
 #_local _I_;
 #_local _TEMP_;
 #_local _LINP_;
 #_local _BADVAL_;
 dcl double EM_PREDICTION;
 dcl char(17) "VIN";
method run();
dcl char(17) _VIN_;
 dcl double _BETA_46956035_0_[15];
 dcl double _XROW_46956035_0_[15];
 _BETA_46956035_0_:=(7999.99999999998, 0, 0, 72000, 4000.00000000001, 
1.8189894035458E-11, 27000, 0, -2999.99999999998, 0, 20000, 4000.00000000002, 
0, 32000, 0);
set SASEP.in;
_BADVAL_ = 0.0;
_LINP_ = 0.0;
_TEMP_ = 0.0;
_I_ = 0.0;
_J_ = 0.0;
_VIN_ = LEFT(TRIM(put(VIN, $17.)));
do _I_ = 1.0 to 15.0;
_XROW_46956035_0_[_I_] = 0.0;
end;
_XROW_46956035_0_[1.0] = 1.0;
_TEMP_ = 1.0;
select (_VIN_);
when ('12345678901234560') _XROW_46956035_0_[2.0] = _TEMP_;
when ('12345678901234561') _XROW_46956035_0_[3.0] = _TEMP_;
when ('12345678901234562') _XROW_46956035_0_[4.0] = _TEMP_;
when ('12345678901234563') _XROW_46956035_0_[5.0] = _TEMP_;
when ('12345678901234564') _XROW_46956035_0_[6.0] = _TEMP_;
when ('12345678901234565') _XROW_46956035_0_[7.0] = _TEMP_;
when ('12345678901234566') _XROW_46956035_0_[8.0] = _TEMP_;
when ('12345678901234567') _XROW_46956035_0_[9.0] = _TEMP_;
when ('12345678901234568') _XROW_46956035_0_[10.0] = _TEMP_;
when ('12345678901234569') _XROW_46956035_0_[11.0] = _TEMP_;
when ('12345678901234571') _XROW_46956035_0_[12.0] = _TEMP_;
when ('12345678901234572') _XROW_46956035_0_[13.0] = _TEMP_;
when ('12345678901234573') _XROW_46956035_0_[14.0] = _TEMP_;
when ('12345678901234574') _XROW_46956035_0_[15.0] = _TEMP_;
otherwise do ;
_BADVAL_ = 1.0;
goto SKIP_46956035_0;
end;
end;
do _I_ = 1.0 to 15.0;
_LINP_ + _XROW_46956035_0_[_I_] * _BETA_46956035_0_[_I_];
end;
SKIP_46956035_0: if (_BADVAL_ = 0.0) & ^MISSING(_LINP_) then do ;
P_BLUEBOOKPRICE = _LINP_;
end;
 else do ;
_LINP_ = .;
P_BLUEBOOKPRICE = .;
end;
if "P_BLUEBOOKPRICE" = . then "P_BLUEBOOKPRICE" = 22142.857143;
EM_PREDICTION = "P_BLUEBOOKPRICE";
_return: ;
end;
 enddata;
