      program printL_MLT
      IMPLICIT NONE


C     
      INTEGER      NTIMELOCAL
      PARAMETER (NTIMELOCAL=1)
c     declare inputs to make _lstar1
      INTEGER*4    kext,options(5)
      INTEGER*4    ntime,sysaxes
      INTEGER*4    iyear(NTIMELOCAL)
      integer*4    idoy(NTIMELOCAL)
      real*8     UT(NTIMELOCAL)
      real*8     xIN1(NTIMELOCAL),xIN2(NTIMELOCAL),xIN3(NTIMELOCAL)
      real*8     maginput(25,NTIMELOCAL)
c     
c     declare locals command line args, frame counter
      INTEGER*4 i, fc
      CHARACTER argv*12 
c     
c     Declare output variables
      REAL*8     BLOCAL(NTIMELOCAL),BMIN(NTIMELOCAL),XJ(NTIMELOCAL)
      REAL*8     MLT(NTIMELOCAL)
      REAL*8     Lm(NTIMELOCAL),Lstar(NTIMELOCAL)

ccccccccccccccccccccccccc_USAGE_ccccccccccccccccccccccccc
      IF (iargc() .lt. 7) then 
      print*, 'Usage: print_l_mlt fc alt lat lon year doy secs'
      print*, '12 chars max per item' 
      print*, 'Input DOUBLES must contain a decimal, INTS must be INTS'
      print*, 'fc is frame counter only used as an echo (INTEGER)'
      print*, 'alt is altitude in km(DOUBLE)'
      print*, 'lat is decimal deg signed latitude (DOUBLE)'
      print*, 'lon is decimal deg EAST longitdue (DOUBLE)'
      print*, 'year is ####(INTEGER)'
      print*, 'doy is day of year 1-366(INTEGER)' 
      print*, 'secs is decimal seconds of the day 0.0-86399.9(DOUBLE)'
      endif
cccccccccccccccccccccccccc_CL_ASSIGNMENT_cccccccc
      CALL GETARG(1,argv)
      READ(argv,997) fc
      CALL GETARG(2,argv)
      READ(argv,998) xin1
      CALL GETARG(3,argv)
      READ(argv,998) xin2
      CALL GETARG(4,argv)
      READ(argv,998) xin3
      CALL GETARG(5,argv)
      READ(argv,997) iyear
      CALL GETARG(6,argv)
      READ(argv,997) idoy
      CALL GETARG(7,argv)
      READ(argv,998) UT

ccccccccccccccccccccccc_DEfault_IRBEM_SETUP_ccccccccccccccc
      ntime=1
      kext=4 !selects T89C as field model (valid for Kp=0 to 9
      options(1)=0 ! this computes Lstar when 1, not when 0
      options(2)=15 ! frequency in days to update IGRF
      options(3)=0 !allows to trade accuracy and computation change on Lstar
      options(4)=0 !decrease this to speed computation time on Lstar
      options(5)=0 !0 selects internal mag field model

      sysaxes=0 !alti lati east longi
      DO i=1,25
         maginput(i,1)=0.0d1
      ENDDO
      maginput(1,1)=2.0d1 !for T89C we need only specify Kp, in this case nominal=2

ccccccccccccccccccccc
      call make_lstar1(ntime,kext,options,sysaxes,iyear,idoy,ut, 
     $    xin1,xin2, xin3, maginput, lm,lstar,blocal,bmin,xj,mlt)
      WRITE(6,999) fc, lm, mlt

      stop
 
 997  FORMAT(I7) 
 998  FORMAT(F10.4)
 999  FORMAT(I7,' ', F5.2,' ', F5.2)
      end
