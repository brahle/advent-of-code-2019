program hello
    ! n = 650
    character(len=650)::input

    integer, dimension (650) :: state
    integer, dimension (650) :: next_state
    integer, dimension (0:3) :: base_pattern
    integer :: sum

    base_pattern(0) = 0
    base_pattern(1) = 1
    base_pattern(2) = 0
    base_pattern(3) = -1

    read *, input
    do i = 1, 650
        state(i) = iachar(input(i:i)) - 48
    end do

    do k = 1, 100
        do i = 1, 650
            j = i
            sum = 0
            do while (j <= 650)
                ! print *, k, i, j, state(j), "*", base_pattern(modulo(j / i, 4)), j / i, modulo(j / i, 4)
                sum = sum + base_pattern(modulo(j / i, 4)) * state(j)
                j = j + 1
            end do
            if (sum < 0) then
                sum = -sum
            end if
            next_state(i) = modulo(sum, 10)
        end do
        do i = 1, 650
            state(i) = next_state(i)
        end do
    end do
    do i = 1, 8
        print *, state(i)
    end do
end program hello
