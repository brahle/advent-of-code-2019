program hello
    ! n = 650
    character(len=650)::input

    integer, dimension (0:6500000) :: state
    integer :: sum

    skip = 5979191

    n = 650
    times = 10000
    read *, input
    do i = 1, n
        state(i-1) = iachar(input(i:i)) - 48
    end do
    do k = 1, times-1
        do i = 0, n-1
            state(n * k + i) = state(i)
        end do
    end do

    n = n * k

    state(n) = 0

    do k = 1, 100
        j = n - 1
        do while (j >= skip)
            state(j) = modulo(state(j) + state(j+1), 10)
            j = j - 1
        end do
    end do

    do i = skip, skip+7
        print *, state(i)
    end do
end program hello
