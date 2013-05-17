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
      open(1, file="sample.txt")
         read(1,*) fc, xin1, xin2, xin3, iyear, idoy, UT
         write(*,*) fc, xin1, xin2, xin3, iyear, idoy, UT
      close(1)


      call make_lstar1(ntime,kext,options,sysaxes,iyear,idoy,ut, 
     $    xin1,xin2, xin3, maginput, lm,lstar,blocal,bmin,xj,mlt)
      WRITE(6,999) fc, lm, mlt

      stop
 
 997  FORMAT(I7, F2.6, F3.6, F3.6, I4, I3, F2.3) 
 998  FORMAT(I7,' ', F2.6,' ', F3.6,' ', F3.6,' ', I4,' ', I3,' ', F2.3)
 999  FORMAT(I7,' ', F5.2,' ', F5.2)
      end
