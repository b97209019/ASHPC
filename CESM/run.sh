#! /bin/sh

cd ~/my_cesm_sandbox/cime/config/cesm/machines/
# overwrite config_machines.xml config_batch.xml config_compilers.xml
cd ~/my_cesm_sandbox/cime/script/

./create_newcase --case ~/cases/b.e20.B1850.f19_g17.test \
                  --compset B1850 --res f19_g17 \
                  --machine ashpc-intel

function chstop(){
  ./xmlchange STOP_N=10
}

function chntasks(){
  ./xmlchange NTASKS_CPL=24,ROOTPE_CPL=0
  ./xmlchange NTASKS_ATM=288,ROOTPE_ATM=24
  ./xmlchange NTASKS_LND=48,ROOTPE_LND=312
  ./xmlchange NTASKS_ROF=12,ROOTPE_ROF=360
  ./xmlchange NTASKS_ICE=72,ROOTPE_ICE=372
  ./xmlchange NTASKS_WAV=12,ROOTPE_WAV=444
  ./xmlchange NTASKS_OCN=552,ROOTPE_OCN=456
}

function chnthrds(){
  ./xmlchange NTHRDS_ATM=1,NTHRDS_OCN=1,NTHRDS_ICE=1,NTHRDS_LND=1,NTHRDS_CPL=1
}


cd ~/cases/b.e20.B1850.f19_g17.test
#chstop
#chntasks

spack load /izbheyj /3sufxvw /jeji6ry /uvl7swr /hkdp3av /yggcrws intel-oneapi-compilers-classic@2021.10.0
export NETCDF=/opt/spack/local/netcdf-combined-intel2021.10.0
export PNETCDF_PATH=/opt/spack/opt/spack/linux-icelake/parallel-netcdf-1.14.1-jeji6ryoewe5h3stu66j36k5bjjk7ubx/
export HDF5_PATH=/opt/spack/opt/spack/linux-icelake/hdf5-1.14.6-3sufxvwdgsp3fm6znchdkqgclwlukbeu/
export NETCDF_classic=1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${NETCDF}/lib:${HDF5_PATH}/lib:${PNETCDF_PATH}/lib

./case.setup --reset
./preview_run
#exit
./case.build
./case.submit
