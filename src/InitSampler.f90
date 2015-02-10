!> This allows for a simple C interface... 


module InitSampler

    ! ~~~~~~~ Loaded Modules ~~~~~~~



    use priors_module
    use settings_module,          only: program_settings,initialise_settings,STR_LENGTH
    use random_module,            only: initialise_random
    use nested_sampling_module,   only: NestedSampling
#ifdef MPI
    use mpi_module
#endif


    contains

subroutine DoSamplingFromC(Lfunc, nDims, nDerived, Nlive, Nchords, PArray, Froot, context)

    ! ~~~~~~~ Local Variable Declaration ~~~~~~~
    implicit none


    !Lfunc is the likelihood to be evaluated by PolyChord
    !nDims is number of dimensions
    !nDerived is number of derived parameters
    !Nlive is number of live points
    !Nchords is number of chords to use in sampling
    !PArray is the (2*Ndims) array containing priors, this has only been tested using uniform priors in polychord
    !Froot is the file root
    !context is a pointer to a c struct
    


    
    !Input parameters for initialisation
    integer nDims, nDerived, Nlive, Nchords, context
    double precision PArray(2*nDims)
    character(STR_LENGTH) :: Froot
    
    
    

    double precision, dimension(5) :: output_info

    type(program_settings)    :: settings  ! The program settings 
    type(prior), dimension(1) :: priors    ! The details of the priors

    ! Temporary variables for initialising loglikelihoods
    double precision :: loglike

    double precision, allocatable, dimension(:) :: theta
    double precision, allocatable, dimension(:) :: phi

    double precision, allocatable, dimension(:) :: minimums 
    double precision, allocatable, dimension(:) :: maximums
    integer, allocatable, dimension(:) :: hypercube_indices
    integer, allocatable, dimension(:) :: physical_indices
    integer :: i





    !Had to change interface to likelihood to include the size of the arrays theta and phi, otherwise it seg faulted in C, alternatives welcome.
    interface
        function Lfunc(nDims, theta, nDerived, phi, context)
            integer,          intent(in)                 :: nDims
            integer,          intent(in)                 :: nDerived
            double precision, intent(in), dimension(nDims) ::theta
            double precision, intent(out),  dimension(nDerived) :: phi
            integer,          intent(in)                 :: context
            double precision :: Lfunc
        end function
    end interface



   !print *, "in init", Ndims, NDerived, Nchords

    ! ======= (1) Initialisation =======
    ! We need to initialise:
    ! a) mpi threads
    ! b) random number generator
    ! c) model
    ! d) program settings


    ! ------- (1a) Initialise MPI threads -------------------
#ifdef MPI
    call MPI_INIT(mpierror)
#endif

    !print *, "called mpi init"
    ! ------- (1b) Initialise random number generator -------
    ! Initialise the random number generator with the system time
    ! (Provide an argument to this if you want to set a specific seed
    ! leave argumentless if you want to use the system time)
    call initialise_random()

    !print *, "init randomed"
    ! ------- (1c) Initialise the model -------
    ! (i) Choose the loglikelihood
    !       Possible example likelihoods:
    !       - gaussian_loglikelihood
    !       - gaussian_shell
    !       - rosenbrock_loglikelihood
    !       - himmelblau_loglikelihood
    !       - rastrigin_loglikelihood
    !       - eggbox_loglikelihood
    !       - gaussian_loglikelihood_corr
    !       - gaussian_loglikelihood_cluster
    !       - twin_gaussian_loglikelihood 

    !print *, NDims, nDerived

    ! (ii) Set the dimensionality
    settings%nDims= NDims                 ! Dimensionality of the space
    settings%nDerived = nDerived             ! Assign the number of derived parameters

    ! (iii) Assign the priors
    ! call allocate_indices(settings) !!No longer done in V1.0

    ! (v) Set up priors
    allocate(minimums(settings%nDims))
    allocate(maximums(settings%nDims))
    allocate(physical_indices(settings%nDims))
    allocate(hypercube_indices(settings%nDims))

    !minimums=0.5-1d-2*50
    !maximums=0.5+1d-2*50
    minimums=PArray(1:nDims)
    maximums=PArray(nDims+1:2*nDims)

    do i=1,settings%nDims
        physical_indices(i)  = i
        hypercube_indices(i) = i
    end do

    call initialise_uniform(priors(1),hypercube_indices,physical_indices,minimums,maximums)


    !print *, minimums, maximums, Froot
    
    






    


    ! ------- (1d) Initialise the program settings -------
    settings%nlive                = Nlive                     !number of live points
    settings%num_repeats          = Nchords                   !Number of chords to draw

    !settings%num_babies           = settings%nDims*settings%num_repeats
    !settings%nstack               = settings%nlive*settings%num_babies*2

    settings%base_dir		  = '.'
    settings%file_root            =  Froot                  !file root

    settings%feedback             = 1                        !degree of feedback

    ! stopping criteria
    !settings%precision_criterion  =  1d-3                    !degree of precision in answer 
    !settings%max_ndead            = -1                       !maximum number of samples 
    ! posterior calculation
    settings%calculate_posterior  = .true.                   !calculate the posterior (slows things down at the end of the run)

    ! reading and writing
    settings%read_resume          = .true.                  !whether or not to resume from file
    settings%write_resume         = .true.                   !whether or not to write resume files
    settings%update_resume        = settings%nlive           !How often to update the resume files
    settings%write_live           = .true.                   !write out the physical live points?

    settings%do_clustering = .false.                          !whether or not to do clustering
    settings%ncluster = 30                                   !maximum number of clusters + 1
    !settings%SNN_k = 20                                      !maximum number of nearest neighbors to check

    settings%thin_posterior = 1




    ! Calculate all of the rest of the settings
    call initialise_settings(settings)   


        !print *, "set up"
	!print *, "settings:", settings%nDims,settings%num_repeats,settings%nlive
    ! Initialise the loglikelihood
    allocate(theta(settings%nDims),phi(settings%nDerived))
    theta=0
    loglike = Lfunc(nDims, theta, nDerived, phi,context)

    ! Sort out the grades
    !call allocate_grades(settings%grades,(/1,1,1,1,2,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4/) ) 
    !settings%grades%num_repeats(2)= 5
    !settings%grades%num_repeats(4)= 5
    !settings%num_babies = calc_num_babies(settings%grades)
    !settings%nstack               = settings%nlive*settings%num_babies*2
   ! settings%do_grades=.false.
   ! settings%do_timing=.false.
    !nest_settings%thin_posterior = max(0d0,&
    !    nest_settings%grades%num_repeats(1)*nest_settings%grades%grade_nDims(1)/&
    !    (sum(nest_settings%grades%num_repeats*nest_settings%grades%grade_nDims)+0d0)&
    !    )


    ! ======= (2) Perform Nested Sampling =======
    ! Call the nested sampling algorithm on our chosen likelihood and priors
 !   print *, "called like", loglike
   !     print *, "calling sampler"
  !  do i=1,1
      !  output_info = NestedSampling(Lfunc,priors,settings,MPI_COMM_WORLD) 
      !  write(*,'(2E17.8)') output_info(5),output_info(2)
   ! end do

    ! ======= (2) Perform Nested Sampling =======
    ! Call the nested sampling algorithm on our chosen likelihood and priors
#ifdef MPI
    output_info = NestedSampling(Lfunc,priors,settings,MPI_COMM_WORLD) 
#else
    output_info = NestedSampling(Lfunc,priors,settings,0) 
#endif

    ! ======= (3) De-initialise =======
    ! De-initialise the random number generator 
    !call deinitialise_random()

#ifdef MPI
    call MPI_FINALIZE(mpierror)
#endif

end subroutine

end module InitSampler