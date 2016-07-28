program plm

implicit none

real, parameter :: h_neglect = 1.E-30
integer, parameter :: n_cells = 3

real, dimension(n_cells) :: u, h, u_tgt, h_tgt
real, dimension(n_cells,2) :: ppoly_E, ppoly_C, ppoly_EP, ppoly_EC
real, dimension(n_cells,3) :: ppoly_CP
real :: PE_i, PE_f

! ascending values of density
! convention: first cell is at surface, moving downward
!u(:) = [31.0, 31.2, 32.4, 32.5, 33.0]
u(:) = [30.0, 31.0, 32.0]
! descending values
!u    = [3.0, 2.5, 2.0, 1.5, 1.0]

! initial thicknesses
!h(:) = [14.0, 8.0, 8.0] ! expanded surface layer
!h(:) = [8.0, 14.0, 8.0] ! expanded middle layer
!h(:) = [8.0, 8.0, 14.0] ! expanded abyssal layer

h(2) = 11.0
h(1) = (10.0 * n_cells - h(2)) / 2.0
h(3) = h(1)

! only change the interface between the first two cells
h(2) = 12.0
h(1) = 20.0 - h(2)
h(3) = 10.0

! target grid
!h_tgt = [5.0, 40.0/3.0, 40.0/3.0, 40.0/3.0, 5.0]
!h_tgt = [12.5, 12.5, 5.0]
! variable thickness middle cell
h_tgt(2) = 10.0
h_tgt(1) = (sum(h(:)) - h_tgt(2)) / 2.0
h_tgt(3) = h_tgt(1)

print *, 'regridding from', h, 'to', h_tgt


!h(:) = [9.5, 9.5, 9.5, 9.5, 12.0]

PE_i = potential_energy(n_cells, h, u)

print *, 'initial PE:', PE_i

! create reconstructions of source grid
call PLM_reconstruction(n_cells, h, u, ppoly_E, ppoly_C)
call PPM_reconstruction(n_cells, h, u, ppoly_EP, ppoly_CP)

print *, '**** PLM reconstruction ****'
print *, 'left edges:', ppoly_E(:,1)
print *, 'right edges:', ppoly_E(:,2)
print *, 'c(1):', ppoly_C(:,1)
print *, 'c(2):', ppoly_C(:,2)

print *, '**** PPM reconstruction ****'
print *, 'left edges:', ppoly_EP(:,1)
print *, 'right edges:', ppolY_EP(:,2)
print *, 'c(1):', ppoly_CP(:,1)
print *, 'c(2):', ppoly_CP(:,2)
print *, 'c(3):', ppoly_CP(:,3)

print *, '**** PCM remapping ****'
! perform PCM remapping
! set the edge values to the constant interior value
! we shouldn't need to set the polynomial coeffs because they're not used
ppoly_EC(:,1) = u(:)
ppoly_EC(:,2) = u(:)
call remap_via_sub_cells(n_cells, h, u, ppoly_EC, ppoly_C, n_cells, h_tgt, u_tgt, 0)
print *, 'final', u_tgt
print *, 'sums:', sum(u*h), sum(u_tgt*h_tgt)
PE_f = potential_energy(n_cells, h_tgt, u_tgt)
print *, 'final PE:', PE_f
print *, 'difference:', PE_f - PE_i

print *, '**** PLM remapping ****'
! perform PLM remapping
call remap_via_sub_cells(n_cells, h, u, ppoly_E, ppoly_C, n_cells, h_tgt, u_tgt, 1)
print *, 'final', u_tgt
print *, 'sums:', sum(u*h), sum(u_tgt*h_tgt)
PE_f = potential_energy(n_cells, h_tgt, u_tgt)
print *, 'final PE:', PE_f
print *, 'difference:', PE_f - PE_i

print *, '**** PPM remapping ****'
call remap_via_sub_cells(n_cells, h, u, ppoly_EP, ppoly_CP, n_cells, h_tgt, u_tgt, 2)
print *, 'final', u_tgt
print *, 'sums:', sum(u*h), sum(u_tgt*h_tgt)
PE_f = potential_energy(n_cells, h_tgt, u_tgt)
print *, 'final PE:', PE_f
print *, 'difference:', PE_f - PE_i

contains

function potential_energy(N, h, u)
  real :: potential_energy
  integer,            intent(in) :: N
  real, dimension(N), intent(in) :: h, u

  ! local variables
  real, dimension(N+1) :: e ! interface positions
  real, dimension(N)   :: z ! layer positions
  integer :: k

  potential_energy = 0.0
  e(1) = 0
  do k = 1, N
    e(k+1) = e(k) - h(k)
    z(k) = (e(k) + e(k+1)) / 2.0
    !                   integrate:         g     rho0    S       z               dV
    potential_energy = potential_energy + 9.8 * (1000 + u(k)) * (z(k) + 30.0) * h(k)
  end do
end function potential_energy

subroutine PLM_reconstruction(N, h, u, ppoly_E, ppoly_C)
  ! arguments
  integer,            intent(in) :: N ! number of cells
  real, dimension(N), intent(in) :: h, u
  real, dimension(N,2), intent(inout) :: ppoly_E, ppoly_C ! polynomial values

  ! local variables
  integer :: k
  real    :: u_l, u_c, u_r
  real    :: h_l, h_c, h_r, h_cn
  real    :: sigma_l, sigma_c, sigma_r
  real    :: u_min, u_max
  real    :: e_l, e_r
  real    :: slope, edge
  real    :: almost_one, almost_two
  real, dimension(N) :: slp, mslp


  almost_one = 1. - epsilon(slope)
  almost_two = 2. * almost_one

  ! loop on interior cells
  do k = 2, N-1
    ! get cell averages
    u_l = u(k-1)
    u_c = u(k)
    u_r = u(k+1)

    ! get cell widths
    h_l = h(k-1)
    h_c = h(k)
    h_r = h(k+1)
    h_cn = max(h_c, h_neglect)

    ! side differences
    sigma_r = u_r - u_c
    sigma_l = u_c - u_l

    ! estimate of second order slope, multiplied by h_c
    sigma_c = 2.0 * (u_r - u_l) * (h_c / (h_l + 2.0*h_c + h_r + h_neglect))

    print *, 'plm slopes', sigma_l, sigma_c, sigma_r

    u_min = min(u_l, u_c, u_r)
    u_max = max(u_l, u_c, u_r)

    if ((sigma_l * sigma_r) > 0.0) then
      ! limit the slope so that edge values are bounded by the two cell averages
      ! spanning the edge
      slope = sign(min(abs(sigma_c), 2. * min(u_c - u_min, u_max - u_c)), sigma_c)
      print *, 'calculating limited slope at', k, slope
    else
      ! extrema have zero slope to avoid generating larger extremes
      slope = 0.0
    end if

    ! test whether roundoff causes edge values to be out of bounds
    if (u_c - 0.5*abs(slope) < u_min .or. u_c + 0.5*abs(slope) > u_max) then
      slope = slope * almost_one
    end if

    ! avoid unrepresentable values
    if (abs(slope) < 1.E-140) slope = 0.

    ! save slope value
    slp(k) = slope
    ! polynomial edge values
    ppoly_E(k,1) = u_c - 0.5 * slope
    ppoly_E(k,2) = u_c + 0.5 * slope
  end do

  print *, 'slopes', slp

  ! adjust slope so that edge values are monotonic
  do k = 2, N-1
    u_l = u(k-1) ; u_c = u(k) ; u_r = u(k+1)
    e_r = ppoly_E(k-1,2) ! right edge of cell k-1
    e_l = ppoly_E(k+1,1)   ! left edge of cell k

    mslp(k) = abs(slp(k)) ! slope magnitude
    u_min = min(e_r, u_c)
    u_max = max(e_r, u_c)

    edge =  u_c - 0.5 * slp(k)
    if ((edge - e_r) * (u_c - edge) < 0.) then
      print *, 'adjusting left monotonicity', k
      edge = 0.5 * (edge + e_r)
      mslp(k) = min(mslp(k), abs(edge - u_c) * almost_two)
    end if

    edge = u_c + 0.5 * slp(k)
    if ((edge - u_c) * (e_l - edge) < 0.) then
      print *, 'adjusting right monotonicity', k
      edge = 0.5 * (edge + e_l)
      mslp(k) = min(mslp(k), abs(edge - u_c) * almost_two)
    end if
  end do

  mslp(1) = 0.
  mslp(N) = 0.

  print *, 'monotonic slopes', mslp

  ! piecewise constant boundary cell
  ! u(1) = u(1) + 0*x (PCM)
  ppoly_E(1,1) = u(1)
  ppoly_E(1,2) = u(1)
  ppoly_C(1,1) = u(1)
  ppoly_C(1,2) = 0.

  do k = 2, N-1
    slope = sign(mslp(k), slp(k)) ! use monotonic slope value
    u_l = u(k) - 0.5 * slope
    u_r = u(k) + 0.5 * slope

    ! check that edge values are bounded
    u_min = min(u(k-1), u(k))
    u_max = max(u(k-1), u(k))
    if (u_l < u_min .or. u_l > u_max) then
      stop 'left edge out of bounds'
    end if

    u_min = min(u(k+1), u(k))
    u_max = max(u(k+1), u(k))
    if (u_r < u_min .or. u_r > u_max) then
      stop 'right edge out of bounds'
    end if

    ppoly_E(k,1) = u_l
    ppoly_E(k,2) = u_r
    ppoly_C(k,1) = u_l
    ppoly_C(k,2) = u_r - u_l

    ! check to see if this would be monotonic w.r.t. the next cell
    edge = ppoly_C(k,2) + ppoly_C(k,1)
    e_r = u(k+1) - 0.5 * sign(mslp(k+1), slp(k+1))
    if ((edge - u(k)) * (e_r - edge) < 0.) then
      ppoly_C(k,2) = ppoly_C(k,2) * almost_one
    end if
  end do

  ppoly_E(N,1) = u(N)
  ppoly_E(N,2) = u(N)
  ppoly_C(N,1) = u(N)
  ppoly_C(N,2) = 0.
end subroutine PLM_reconstruction

subroutine PPM_reconstruction(N, h, u, ppoly_E, ppoly_C)
  integer,              intent(in) :: N
  real, dimension(N),   intent(in) :: h, u
  real, dimension(N,3), intent(inout) :: ppoly_E, ppoly_C

  ! local variables
  integer :: k
  integer :: k0, k1, k2
  real    :: h_l, h_c, h_r
  real    :: u_l, u_c, u_r
  real    :: u0_l, u0_r
  real    :: u0_minus, u0_plus, um_minus, um_plus, u0_avg
  real    :: sigma_l, sigma_c, sigma_r
  real    :: slope
  real    :: expr1, expr2
  real    :: edge_l, edge_r

  ! start with the PPM limiter
  ! bound edge values
  do k = 1, N
    if (k == 1) then
      k0 = 1 ; k1 = 1 ; k2 = 2
    else if (k == N) then
      k0 = N-1 ; k1 = N; k2 = N
    else
      k0 = k-1 ; k1 = k ; k2 = k+1
    end if

    h_l = h(k0) ; h_c = h(k1) ; h_r = h(k2)
    u_l = u(k0) ; u_c = u(k1) ; u_r = u(k2)
    u0_l = ppoly_E(k,1) ; u0_r = ppoly_E(k,2)

    sigma_l = 2.0 * (u_c - u_l) / (h_c + 1.E-30)
    sigma_c = 2.0 * (u_r - u_l) / (h_l + 2.0 * h_c + h_r + 1.E-30)
    sigma_r = 2.0 * (u_r - u_c) / (h_c + 1.E-30)

    if ((sigma_l * sigma_r) > 0.0) then
      slope = sign(min(abs(sigma_l), abs(sigma_c), abs(sigma_r)), sigma_c)
    else
      slope = 0.0
    end if

    slope = slope * h_c * 0.5

    if ((u_l - u0_l) * (u0_l - u_c) < 0.0) then
      u0_l = u_c - sign(min(abs(slope), abs(u0_l - u_c)), slope)
    end if

    if ((u_r - u0_r) * (u0_r - u_c) < 0.0) then
      u0_r = u_c + sign(min(abs(slope), abs(u0_r - u_c)), slope)
    end if

    u0_l = max(min(u0_l, max(u_l, u_c)), min(u_l, u_c))
    u0_r = max(min(u0_r, max(u_r, u_c)), min(u_r, u_c))

    ppoly_E(k,1) = u0_l
    ppoly_E(k,2) = u0_r
  end do

  ! make discontinuous edge values monotonic
  do k = 1, N-1
    u0_minus = ppoly_E(k,2)
    u0_plus  = ppoly_E(k+1,1)

    um_minus = u(k)
    um_plus  = u(k+1)

    if ((u0_plus - u0_minus) * (um_plus - um_minus) < 0.0) then
      u0_avg = 0.5 * (u0_minus + u0_plus)
      u0_avg = max(min(u0_avg, max(um_minus, um_plus)), min(um_minus, um_plus))

      ppoly_E(k,2) = u0_avg
      ppoly_E(k+1,1) = u0_avg
    end if
  end do

  ! PPM limiter
  do k = 2, N-1
    u_l = u(k-1) ; u_c = u(k) ; u_r = u(k+1)
    edge_l = ppoly_E(k,1) ; edge_r = ppoly_E(k,2)

    if ((u_r - u_c) * (u_c - u_l) <= 0.0) then
      edge_l = u_c ; edge_r = u_c
    else
      expr1 = 3.0 * (edge_r - edge_l) * ((u_c - edge_l) + (u_c - edge_r))
      expr2 = (edge_r - edge_l) * (edge_r - edge_l)

      if (expr1 > expr2) then
        edge_l = u_c + 2.0 * (u_c - edge_r)
        edge_l = max(min(edge_l, max(u_l, u_c)), min(u_l, u_c))
      else if (expr1 < -expr2) then
        edge_r = u_c + 2.0 * (u_c - edge_l)
        edge_r = max(min(edge_r, max(u_r, u_c)), min(u_r, u_c))
      end if
    end if

    if (abs(edge_r - edge_l) < max(1.E-60, epsilon(u_c) * abs(u_c))) then
      edge_l = u_c ; edge_r = u_c
    end if

    ppoly_E(k,1) = edge_l
    ppoly_E(k,2) = edge_r
  end do

  ppoly_E(1,:) = u(1)
  ppoly_E(N,:) = u(N)

  do k = 1, N
    edge_l = ppoly_E(k,1)
    edge_r = ppoly_E(k,2)

    ppoly_C(k,1) = edge_l
    ppoly_C(k,2) = 4.0 * (u(k) - edge_l) + 2.0 * (u(k) - edge_r)
    ppoly_C(k,3) = 3.0 * ((edge_r - u(k)) + (edge_l - u(k)))
  end do
end subroutine PPM_reconstruction

subroutine remap_via_sub_cells(n0, h0, u0, ppoly_E, ppoly_C, n1, h1, u1, order)
  integer,               intent(in)  :: n0
  real, dimension(n0),   intent(in)  :: h0, u0
  real, dimension(n0,2), intent(in)  :: ppoly_E, ppoly_C

  integer,               intent(in)  :: n1
  real, dimension(n1),   intent(in)  :: h1
  real, dimension(n1),   intent(out) :: u1

  integer, intent(in) :: order ! remapping order (0 = pcm, 1 = plm, 2 = ppm)

  ! local variables
  integer :: i0, i1, i_sub ! loop indices
  integer :: i0_last_thick_cell, i_max
  integer :: i_start0, i_start1
  integer, dimension(n0) :: isrc_start, isrc_end, isrc_max ! source subcell indices
  integer, dimension(n1) :: itgt_start, itgt_end ! target subcell indices
  integer, dimension(n0+n1+1) :: isub_src

  real :: h0_supply, h1_supply ! amount of thickness for constructing subcells
  real :: dh, dh0_eff, dh_max, duh ! subcell thicknesses
  real :: xa, xb
  real, dimension(n0) :: u0_min, u0_max ! min/max reconstructions in source cell
  real, dimension(n0) :: h0_eff
  real, dimension(n0+n1+1) :: h_sub, uh_sub, u_sub

  logical :: src_has_volume, tgt_has_volume

  ! initialize with some source column information
  i0_last_thick_cell = 0
  do i0 = 1, n0
    u0_min(i0) = min(ppoly_E(i0,1), ppoly_E(i0,2))
    u0_max(i0) = max(ppoly_E(i0,1), ppoly_E(i0,2))

    ! update last cell with positive thickness
    if (h0(i0) > 0.) i0_last_thick_cell = i0
  end do

  ! initialize variables for main loop
  h0_supply = h0(1) ; h1_supply = h1(1)
  i0 = 1            ; i1 = 1
  i_start0 = 1      ; i_start1 = 1
  i_max = 1
  dh_max = 0.
  dh0_eff = 0.
  src_has_volume = .true.
  tgt_has_volume = .true.

  ! first subcell is always vanished
  isrc_start(1) = 1
  isrc_end(1) = 1
  isrc_max(1) = 1
  isub_src(1) = 1
  h_sub(1) = 0.

  ! loop over subcells
  do i_sub = 2, n0+n1+1
    ! calculate width of the subcell
    dh = min(h0_supply, h1_supply)
    ! running sum of source cell thickness
    dh0_eff = dh0_eff + min(dh, h0_supply)
    ! record source index of subcell
    isub_src(i_sub) = i0
    h_sub(i_sub) = dh

    ! record largest subcell within a source cell
    if (dh >= dh_max) then
      i_max = i_sub
      dh_max = dh
    end if

    ! determine which column (source or target) is supplying the subcell
    if (h0_supply <= h1_supply .and. src_has_volume) then
      ! source is supplying
      h1_supply = h1_supply - dh
      ! record subcell info
      isrc_start(i0) = i_start0
      isrc_end(i0) = i_sub
      i_start0 = i_sub + 1

      ! record the subcell that is the largest fraction of the source cell
      isrc_max(i0) = i_max
      i_max = i_sub + 1
      dh_max = 0.

      ! source cell thickness by summing subcells
      h0_eff(i0) = dh0_eff

      ! move the source index and see if we ran out of volume
      if (i0 < n0) then
        i0 = i0 + 1
        h0_supply = h0(i0)
        dh0_eff = 0.
      else
        h0_supply = 0.
        src_has_volume = .false.
      end if
    else if (h1_supply <= h0_supply .and. tgt_has_volume) then
      h0_supply = h0_supply - dh
      itgt_start(i1) = i_start1
      itgt_end(i1) = i_sub
      i_start1 = i_sub + 1

      if (i1 < n1) then
        i1 = i1 + 1
        h1_supply = h1(i1)
      else
        h1_supply = 0.
        tgt_has_volume = .false.
      end if
    else if (src_has_volume) then
      ! we ran out of target volume but still have source cells to consume
      h_sub(i_sub) = h0_supply
      isrc_start(i0) = i_start0
      isrc_end(i0) = i_sub
      i_start0 = i_sub + 1

      isrc_max(i0) = i_max
      i_max = i_sub + 1
      dh_max = 0.

      if (i0 < n0) then
        i0 = i0 + 1
        h0_supply = h0(i0)
        dh0_eff = 0.
      else
        h0_supply = 0.
        src_has_volume = .false.
      end if
    else if (tgt_has_volume) then
      ! we ran out of source volume but still have target cells to consume
      h_sub(i_sub) = h1_supply
      itgt_start(i1) = i_start1
      itgt_end(i1) = i_sub
      i_start1 = i_sub + 1

      if (i1 < n1) then
        i1 = i1 + 1
        h1_supply = h1(i1)
      else
        h1_supply = 0.
        tgt_has_volume = .false.
      end if
    else
      stop 'volume mismatch!'
    end if
  end do

  ! loop over subcells to calculate average/integral values
  xa = 0.
  dh0_eff = 0.
  uh_sub(1) = 0.
  u_sub(1) = ppoly_E(1,1)

  do i_sub = 2, n0+n1
    ! subcell thickness
    dh = h_sub(i_sub)
    ! source cell
    i0 = isub_src(i_sub)

    dh0_eff = dh0_eff + dh ! cumulative thickness
    if (h0_eff(i0) > 0.) then
      xb = dh0_eff / h0_eff(i0)
      xb = min(1., xb) ! needed when target column is wider than source

      select case (order)
        case (0)
          u_sub(i_sub) = u0(i0)
        case (1)
          u_sub(i_sub) = average_value(n0, u0, ppoly_E, ppoly_C, i0, xa, xb, .false.)
        case (2)
          u_sub(i_sub) = average_value(n0, u0, ppoly_E, ppoly_C, i0, xa, xb, .true.)
      end select

      print *, 'subcell', i_sub, 'has value', u_sub(i_sub), 'between', xa, 'and', xb
    else
      ! vanished cell
      xb = 1.
      u_sub(i_sub) = u0(i0)
    end if

    uh_sub(i_sub) = dh * u_sub(i_sub)

    if (isub_src(i_sub+1) /= i0) then
      ! reset if the next subcell is in a different source cell
      dh0_eff = 0.
      xa = 0.
    else
      xa = xb
    end if
  end do

  u_sub(n0+n1+1) = ppoly_E(n0,2)
  uh_sub(n0+n1+1) = ppoly_E(n0,2) * h_sub(n0+n1+1)

  ! substitute the integral for the thickest subcell with the residual
  ! of the source cell integral minus the other subcells
  do i0 = 1, i0_last_thick_cell
    i_max = isrc_max(i0)
    dh_max = h_sub(i_max)

    if (dh_max > 0.) then
      duh = 0.

      do i_sub = isrc_start(i0), isrc_end(i0)
        if (i_sub /= i_max) duh = duh + uh_sub(i_sub)
      end do

      uh_sub(i_max) = u0(i0) * h0(i0) - duh
    end if
  end do

  ! loop over target cells summing integrals from sub-cells within the target
  do i1 = 1, n1
    if (h1(i1) > 0.) then
      duh = 0. ; dh = 0.

      do i_sub = itgt_start(i1), itgt_end(i1)
        dh = dh + h_sub(i_sub)
        duh = duh + uh_sub(i_sub)
      end do

      u1(i1) = duh / dh
    else
      u1(i1) = u_sub(itgt_start(i1))
    end if
  end do
end subroutine remap_via_sub_cells

function average_value(n0, u0, ppoly_E, ppoly_C, i0, xa, xb, ppm)
  real :: average_value
  integer,               intent(in) :: n0, i0
  real, dimension(n0),   intent(in) :: u0
  real, dimension(n0,2), intent(in) :: ppoly_E, ppoly_C
  real,                  intent(in) :: xa, xb
  logical,               intent(in) :: ppm

  real :: a_L, a_R
  real :: mx, my, u_c, Ya, Yb, xa2b2ab, Ya2b2ab, a_c

  if (xb > xa) then
    if (.not. ppm) then
      average_value = ppoly_C(i0,1) + ppoly_C(i0,2) * 0.5 * (xb + xa)
    else
      mx = 0.5 * (xa + xb)
      a_L = ppoly_E(i0, 1)
      a_R = ppoly_E(i0, 2)
      u_c = u0(i0)
      a_c = 0.5 * ((u_c - a_L) + (u_c - a_R))

      if (mx < 0.5) then
        xa2b2ab = (xa*xa + xb*xb) + xa*xb
        average_value = a_L + ((a_R - a_L) * mx + a_c * (3. * (xa + xb) - 2. * xa2b2ab))
      else
        Ya = 1. - xa
        Yb = 1. - xb
        my = 0.5 * (Ya + Yb)
        Ya2b2ab = (Ya*Ya + Yb*Yb) + Ya*Yb
        average_value = a_R + ((a_L - a_R) * my + a_c * (3. * (Ya + Yb) - 2. * Ya2b2ab))
      end if
    end if
  else
    if (.not. ppm) then
      ! plm
      a_L = ppoly_E(i0,1)
      a_R = ppoly_E(i0,2)
      if (xa < 0.5) then
        average_value = a_L + xa * (a_R - a_L)
      else
        average_value = a_R + (1. - xa) * (a_L - a_R)
      end if
    else
      ! ppm
      a_L = ppoly_E(i0, 1)
      a_R = ppoly_E(i0, 2)
      u_c = u0(i0)
      a_c = 3. * ((u_c - a_L) + (u_c - a_R))
      Ya = 1. - xa
      if (xa < 0.5) then
        average_value = a_L + xa * ((a_R - a_L) + a_c * Ya)
      else
        average_value = a_R + Ya * ((a_L - a_R) + a_c * xa)
      end if
    end if
  end if
end function average_value
end program
