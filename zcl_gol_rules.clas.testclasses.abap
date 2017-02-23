*"* use this source file for your ABAP unit test classes
CLASS ltcl_test_gol_rules DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      setup,
      test_live_less_then_2_neigh FOR TESTING RAISING cx_static_check,
      test_live_2_or_3_neighbours FOR TESTING RAISING cx_static_check,
      test_live_more_than_3_neigh FOR TESTING RAISING cx_static_check,
      test_dead_3_neighbours FOR TESTING RAISING cx_static_check.

    DATA: gol_rules TYPE REF TO zcl_gol_rules.
ENDCLASS.


CLASS ltcl_test_gol_rules IMPLEMENTATION.



  METHOD test_live_less_then_2_neigh.
    DATA(cell) =
      VALUE zgol_grid_cell( cell_state = zif_gol_constants=>alive ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'Any live cell with fewer than two live neighbours should dies.'
      exp = zif_gol_constants=>dead
      act = gol_rules->calculate_new_cell_state(
        i_cell = cell
        i_num_of_alive_neighbours = 0 ) ).

    cl_abap_unit_assert=>assert_equals(
     msg = 'Any live cell with fewer than two live neighbours should dies.'
     exp = zif_gol_constants=>dead
     act = gol_rules->calculate_new_cell_state(
       i_cell = cell
       i_num_of_alive_neighbours = 1 ) ).
  ENDMETHOD.

  METHOD test_live_2_or_3_neighbours.
    DATA(cell) =
        VALUE zgol_grid_cell( cell_state = zif_gol_constants=>alive ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'Any live cell with two or three live neighbours should live on to the next generation.'
      exp = zif_gol_constants=>alive
      act = gol_rules->calculate_new_cell_state(
        i_cell = cell
        i_num_of_alive_neighbours = 2 ) ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'Any live cell with two or three live neighbours should live on to the next generation.'
      exp = zif_gol_constants=>alive
      act = gol_rules->calculate_new_cell_state(
        i_cell = cell
        i_num_of_alive_neighbours = 3 ) ).

  ENDMETHOD.

  METHOD setup.
    gol_rules = NEW zcl_gol_rules( ).
  ENDMETHOD.

  METHOD test_live_more_than_3_neigh.
    DATA(cell) =
      VALUE zgol_grid_cell( cell_state = zif_gol_constants=>alive ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'Any live cell with more than three live neighbours should die (overpopulation).'
      exp = zif_gol_constants=>dead
      act = gol_rules->calculate_new_cell_state(
        i_cell = cell
        i_num_of_alive_neighbours = 4 ) ).

    cl_abap_unit_assert=>assert_equals(
    msg = 'Any live cell with more than three live neighbours should die (overpopulation).'
    exp = zif_gol_constants=>dead
    act = gol_rules->calculate_new_cell_state(
      i_cell = cell
      i_num_of_alive_neighbours = 8 ) ).


  ENDMETHOD.

  METHOD test_dead_3_neighbours.
    DATA(cell) =
      VALUE zgol_grid_cell( cell_state = zif_gol_constants=>dead ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'Any dead cell with exactly three live neighbours should become a live cell (reproduction).'
      exp = zif_gol_constants=>dead
      act = gol_rules->calculate_new_cell_state(
        i_cell = cell
        i_num_of_alive_neighbours = 2 ) ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'Any dead cell with exactly three live neighbours should become a live cell (reproduction).'
      exp = zif_gol_constants=>alive
      act = gol_rules->calculate_new_cell_state(
        i_cell = cell
        i_num_of_alive_neighbours = 3 ) ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'Any dead cell with exactly three live neighbours should become a live cell (reproduction).'
      exp = zif_gol_constants=>dead
      act = gol_rules->calculate_new_cell_state(
        i_cell = cell
        i_num_of_alive_neighbours = 4 ) ).
  ENDMETHOD.

ENDCLASS.
