! RUN: %S/test_errors.sh %s %t %f18 -fopenmp
! XFAIL: *

! OpenMP Version 4.5
! 2.7.3 single Construct
! Symbol present on multiple clauses

program omp_single
  integer i
  i = 10

  !$omp single private(i)
  print *, "omp single", i
  !ERROR: Symbol āiā present on multiple clauses
  !$omp end single copyprivate(i)

end program omp_single
