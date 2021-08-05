   /*---------------------------------------------------------
     Generated SAS Scoring Code
     Date: 01Jul2021:19:09:20
     -------------------------------------------------------*/

   drop _badval_ _linp_ _temp_ _i_ _j_;
   _badval_ = 0;
   _linp_   = 0;
   _temp_   = 0;
   _i_      = 0;
   _j_      = 0;

   array _xrow_46956035_0_{15} _temporary_;
   array _beta_46956035_0_{15} _temporary_ (    7999.99999999998
                          0
                          0
                      72000
           4000.00000000001
        1.8189894035458E-11
                      27000
                          0
          -2999.99999999998
                          0
                      20000
           4000.00000000002
                          0
                      32000
                          0);

   length _VIN_ $17; drop _VIN_;
   _VIN_ = left(trim(put(VIN,$17.)));
   do _i_=1 to 15; _xrow_46956035_0_{_i_} = 0; end;

   _xrow_46956035_0_[1] = 1;

   _temp_ = 1;
   select (_VIN_);
      when ('12345678901234560') _xrow_46956035_0_[2] = _temp_;
      when ('12345678901234561') _xrow_46956035_0_[3] = _temp_;
      when ('12345678901234562') _xrow_46956035_0_[4] = _temp_;
      when ('12345678901234563') _xrow_46956035_0_[5] = _temp_;
      when ('12345678901234564') _xrow_46956035_0_[6] = _temp_;
      when ('12345678901234565') _xrow_46956035_0_[7] = _temp_;
      when ('12345678901234566') _xrow_46956035_0_[8] = _temp_;
      when ('12345678901234567') _xrow_46956035_0_[9] = _temp_;
      when ('12345678901234568') _xrow_46956035_0_[10] = _temp_;
      when ('12345678901234569') _xrow_46956035_0_[11] = _temp_;
      when ('12345678901234571') _xrow_46956035_0_[12] = _temp_;
      when ('12345678901234572') _xrow_46956035_0_[13] = _temp_;
      when ('12345678901234573') _xrow_46956035_0_[14] = _temp_;
      when ('12345678901234574') _xrow_46956035_0_[15] = _temp_;
      otherwise do; _badval_ = 1; goto skip_46956035_0; end;
   end;

   do _i_=1 to 15;
      _linp_ + _xrow_46956035_0_{_i_} * _beta_46956035_0_{_i_};
   end;

   skip_46956035_0:
   label P_BlueBookPrice = 'Predicted: BlueBookPrice';
   if (_badval_ eq 0) and not missing(_linp_) then do;
      P_BlueBookPrice = _linp_;
   end; else do;
      _linp_ = .;
      P_BlueBookPrice = .;
   end;


   *------------------------------------------------------------*;
   * Accounting for missing predicted variable;
   *------------------------------------------------------------*;
   label "P_BlueBookPrice"n ='Predicted: BlueBookPrice';
   if "P_BlueBookPrice"n = . then "P_BlueBookPrice"n =22142.857143;
