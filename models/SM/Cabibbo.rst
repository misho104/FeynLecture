(******************************************************************)
(*     Restriction file for SM.fr                                 *)
(*                                                                *)
(*     All Yukawa couplings for light fermions (e,m,u,d,s)        *)
(*     are put to zero.                                           *)
(*                                                                *)
(*     Only Cabibbo mixing is taken into account in CKM           *)
(******************************************************************)

M$Restrictions = {yl[i_] :> 0 /; (i === 1) || (i === 2),
            yu[1] -> 0,
            yd[i_] :> 0 /; (i === 1) || (i === 2),
            CKM[3,3] -> 1,
            CKM[i_,3] :> 0 /; (i === 1) || (i ===2),
            CKM[3,i_] :> 0 /; (i === 1) || (i ===2)
}