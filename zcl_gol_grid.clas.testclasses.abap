*"* use this source file for your ABAP unit test classes
CLASS ltcl_gol_grid DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      setup,
      test_initialize FOR TESTING RAISING cx_static_check,
      test_set_cell_state FOR TESTING RAISING cx_static_check,
      test_get_neighbours FOR TESTING RAISING cx_static_check,
      test_number_of_live_cells FOR TESTING RAISING cx_static_check,
      test_clear_grid for testing raising cx_Static_check.

    DATA grid TYPE REF TO zcl_gol_grid.
ENDCLASS.


CLASS ltcl_gol_grid IMPLEMENTATION.

  METHOD setup.
    me->grid = zcl_gol_grid=>initialize( i_rows = 9 i_cols = 10 ).
  ENDMETHOD.

  METHOD test_initialize.
    DATA(rows) = VALUE zgol_grid(
        FOR cell IN grid->grid_cells WHERE ( col = 1 ) (
            cell ) ).

    DATA(cols) = VALUE zgol_grid(
        FOR cell IN grid->grid_cells WHERE ( row = 1 ) (
            cell ) ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'After initialization the grid should have the correct number of rows.'
        exp = 9
        act = grid->rows ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'After initialization the grid should have the correct number of rows.'
        exp = 9
        act = lines( rows ) ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'After initialization the grid should have the correct number of rows.'
        exp = 10
        act = grid->cols ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'After initialization the grid should have the correct number of rows.'
        exp = 10
        act = lines( cols ) ).

  ENDMETHOD.


  METHOD test_set_cell_state.
    grid->set_cell_state( i_row = 5 i_col = 6 i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 1 i_col = 3 i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 9 i_col = 9 i_state = zif_gol_constants=>alive ).

    DATA(live_cells) = VALUE zgol_grid(
       FOR cell IN grid->grid_cells WHERE ( cell_state = zif_gol_constants=>alive ) (
           cell ) ).

    DATA(dead_cells) = VALUE zgol_grid(
        FOR cell IN grid->grid_cells WHERE ( cell_state = zif_gol_constants=>dead ) (
            cell ) ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'Setting the cell state should only influence the correct grid cells.'
        exp = 3
        act = lines( live_cells ) ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'Setting the cell state should not influence any other grid cells.'
        exp = 87
        act = lines( dead_cells ) ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'After setting the cell state to alive the cell should be alive.'
        exp = zif_gol_constants=>alive
        act = grid->grid_cells[ row = 5 col = 6 ]-cell_state ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'After setting the cell state to alive the cell should be alive.'
        exp = zif_gol_constants=>alive
        act = grid->grid_cells[ row = 1 col = 3 ]-cell_state ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'After setting the cell state to alive the cell should be alive.'
        exp = zif_gol_constants=>alive
        act = grid->grid_cells[ row = 9 col = 9 ]-cell_state ).

    grid->set_cell_state( i_row = 9 i_col = 9 i_state = zif_gol_constants=>dead ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'After setting the cell state to dead the cell should be dead.'
        exp = zif_gol_constants=>dead
        act = grid->grid_cells[ row = 9 col = 9 ]-cell_state ).
  ENDMETHOD.


  METHOD test_get_neighbours.
    DATA(neighbours) = grid->get_neighbours( VALUE zgol_grid_cell( row = 1 col = 1 ) ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'It should return the correct the set of neighbours'
      exp = 3
      act = lines( neighbours->grid_cells ) ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 2 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (1,1) should contain cell (1,2).'
    ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 1 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (1,1) should contain cell (2,1).'
    ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (1,1) should contain cell (2,2).'
    ).

    neighbours = grid->get_neighbours( VALUE zgol_grid_cell( row = 3 col = 3 ) ).
    cl_abap_unit_assert=>assert_equals(
      msg = 'It should return the correct the set of neighbours'
      exp = 8
      act = lines( neighbours->grid_cells ) ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (3,3) should contain cell (2,2).'
    ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 3 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (3,3) should contain cell (2,3).'
    ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (3,3) should contain cell (2,4).'
    ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 2 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (3,3) should contain cell (3,2).'
    ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 4 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (3,3) should contain cell (3,4).'
    ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 2 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (3,3) should contain cell (4,2).'
    ).
    cl_abap_unit_assert=>assert_table_contains(
     line  = VALUE zgol_grid_cell( row = 4 col = 3 )
     table = neighbours->grid_cells
     msg   = 'The neighbours of cell (3,3) should contain cell (4,3).'
   ).
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 4 )
      table = neighbours->grid_cells
      msg   = 'The neighbours of cell (3,3) should contain cell (4,4).'
    ).
  ENDMETHOD.

  METHOD test_number_of_live_cells.
    grid->set_cell_state( i_row = 5 i_col = 6 i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 1 i_col = 3 i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 9 i_col = 9 i_state = zif_gol_constants=>alive
       )->clear( ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'After clearing the grid should contain no living cells.'
      exp = 0
      act = grid->number_of_live_cells( ) ).
  ENDMETHOD.

  METHOD test_clear_grid.
    grid->set_cell_state( i_row = 5 i_col = 6 i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 1 i_col = 3 i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 9 i_col = 9 i_state = zif_gol_constants=>alive ).
  ENDMETHOD.

ENDCLASS.
