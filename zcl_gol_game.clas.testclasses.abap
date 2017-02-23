*"* use this source file for your ABAP unit test classes
CLASS ltcl_test_gol_game DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS: setup.

    METHODS:
      test_blinker FOR TESTING RAISING cx_static_check,
      check_blinker_generation1
        IMPORTING
          i_grid_new TYPE REF TO zcl_gol_grid,
      check_blinker_generation2
        IMPORTING
          i_grid_new TYPE REF TO zcl_gol_grid.

    METHODS:
      test_beacon FOR TESTING RAISING cx_static_check,
      check_beacon_generation1
        IMPORTING
          i_grid_new TYPE REF TO zcl_gol_grid,
      check_beacon_generation2
        IMPORTING
          i_grid_new TYPE REF TO zcl_gol_grid.

    METHODS:
      test_glider FOR TESTING RAISING cx_static_check,
      check_glider_generation1
        IMPORTING
          i_grid_new TYPE REF TO zcl_gol_grid,
      check_glider_generation2
        IMPORTING
          i_grid_new TYPE REF TO zcl_gol_grid,
      check_glider_generation3
        IMPORTING
          i_grid_new TYPE REF TO zcl_gol_grid.

    DATA grid TYPE REF TO zcl_gol_grid.
    DATA game TYPE REF TO zcl_gol_game.
    DATA rules TYPE REF TO zcl_gol_rules.
ENDCLASS.


CLASS ltcl_test_gol_game IMPLEMENTATION.

  METHOD setup.
    me->grid = zcl_gol_grid=>initialize( i_rows = 10 i_cols = 10 ).
    me->game = NEW zcl_gol_game( ).
    me->rules = NEW zcl_gol_rules( ).
  ENDMETHOD.

  METHOD test_blinker.
    "This test the blinker pattern
    "
    " - X -    - - -    - X -
    " - X - => X X X => - X -
    " - X -    - - -    - X -

    me->grid->set_cell_state( i_row = 2
                              i_col = 1
                              i_state = zif_gol_constants=>alive
         )->set_cell_state( i_row = 2
                            i_col = 2
                            i_state = zif_gol_constants=>alive
         )->set_cell_state( i_row = 2
                            i_col = 3
                            i_state = zif_gol_constants=>alive ).

    DATA(grid_new) =
      game->calculate_next_generation( i_grid = me->grid
                                       i_rules = me->rules ).

    check_blinker_generation1( grid_new ).
    grid_new = game->calculate_next_generation( i_grid = grid_new
                                                i_rules = me->rules ).

    check_blinker_generation2( grid_new ).

  ENDMETHOD.

  METHOD test_beacon.
    "This tests the beacon pattern
    "
    " X X - -    X X - -     X X - -
    " X - - - => X X - -  => X - - -
    " - - - X    - - X X     - - - X
    " - - X X    - - X X     - - X X

    grid->set_cell_state( i_row = 1
                          i_col = 1
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 1
                          i_col = 2
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 2
                          i_col = 1
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 3
                          i_col = 4
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 4
                          i_col = 3
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 4
                          i_col = 4
                          i_state = zif_gol_constants=>alive ).

    DATA(grid_new) =
      game->calculate_next_generation( i_grid = me->grid
                                       i_rules = me->rules ).

    check_beacon_generation1( grid_new ).
    grid_new = game->calculate_next_generation( i_grid = grid_new
                                                i_rules = me->rules ).

    check_beacon_generation2( grid_new ).

  ENDMETHOD.


  METHOD test_glider.
    "This tests the glider pattern
    "
    " - - X - -     - X - - -      - - X - -      - - - - -
    " X - X - -  => - - X X -  =>  - - - X -  =>  - X - X -
    " - X X - -     - X X - -      - X X X -      - - X X -
    " - - - - -     - - - - -      - - - - -      - - X - -

    grid->set_cell_state( i_row = 1
                          i_col = 3
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 2
                          i_col = 1
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 2
                          i_col = 3
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 3
                          i_col = 2
                          i_state = zif_gol_constants=>alive
       )->set_cell_state( i_row = 3
                          i_col = 3
                          i_state = zif_gol_constants=>alive ).

    DATA(grid_new) =
      game->calculate_next_generation( i_grid = me->grid
                                       i_rules = me->rules ).

    check_glider_generation1( grid_new ).

    grid_new = game->calculate_next_generation( i_grid = grid_new
                                                i_rules = me->rules ).

    check_glider_generation2( grid_new ).

    grid_new = game->calculate_next_generation( i_grid = grid_new
                                                i_rules = me->rules ).

    check_glider_generation3( grid_new ).

  ENDMETHOD.


  METHOD check_blinker_generation1.

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (2,1), (2,2), (2,3) results in (1,2), (2,2), (3,2) (blinker).'
    ).

  ENDMETHOD.

  METHOD check_blinker_generation2.
    cl_abap_unit_assert=>assert_table_contains(
                line  = VALUE zgol_grid_cell( row = 1 col = 1 cell_state = zif_gol_constants=>dead )
                table = i_grid_new->grid_cells
                msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
              ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 1 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test that (1,2), (2,2), (3,2) results in (2,1), (2,2), (2,3) (blinker).'
    ).

  ENDMETHOD.




  METHOD check_beacon_generation1.
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 1 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 1 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the first generation of the beacon pattern.'
      ).


    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 1 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 2 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the first generation of the beacon pattern.'
      ).



    cl_abap_unit_assert=>assert_table_contains(
    line  = VALUE zgol_grid_cell( row = 3 col = 1 cell_state = zif_gol_constants=>dead )
    table = i_grid_new->grid_cells
    msg   = 'Test the correctness of the first generation of the beacon pattern.'
  ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 3 col = 4 cell_state = zif_gol_constants=>alive )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the first generation of the beacon pattern.'
      ).


    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
      ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 4 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the beacon pattern.'
    ).
  ENDMETHOD.

  METHOD check_beacon_generation2.
    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 1 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 1 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the second generation of the beacon pattern.'
      ).


    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 1 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 2 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the second generation of the beacon pattern.'
      ).



    cl_abap_unit_assert=>assert_table_contains(
    line  = VALUE zgol_grid_cell( row = 3 col = 1 cell_state = zif_gol_constants=>dead )
    table = i_grid_new->grid_cells
    msg   = 'Test the correctness of the second generation of the beacon pattern.'
  ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 3 col = 4 cell_state = zif_gol_constants=>alive )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the second generation of the beacon pattern.'
      ).


    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
      ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 4 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the beacon pattern.'
    ).

  ENDMETHOD.

  METHOD check_glider_generation1.
    "This tests the glider pattern after 1 generation
    "
    "- X - - -
    "- - X X -
    "- X X - -
    "- - - - -
    cl_abap_unit_assert=>assert_table_contains(
          line  = VALUE zgol_grid_cell( row = 1 col = 1 cell_state = zif_gol_constants=>dead )
          table = i_grid_new->grid_cells
          msg   = 'Test the correctness of the first generation of the glider pattern.'
        ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 1 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the first generation of the glider pattern.'
      ).


    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 2 col = 4 cell_state = zif_gol_constants=>alive )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the first generation of the glider pattern.'
      ).



    cl_abap_unit_assert=>assert_table_contains(
    line  = VALUE zgol_grid_cell( row = 3 col = 1 cell_state = zif_gol_constants=>dead )
    table = i_grid_new->grid_cells
    msg   = 'Test the correctness of the first generation of the glider pattern.'
  ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the first generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 3 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the first generation of the glider pattern.'
      ).


  ENDMETHOD.

  METHOD check_glider_generation2.
    "This tests the glider pattern after 1 generation
    "
    "- - X - -
    "- - - X -
    "- X X X -
    "- - - - -
    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 1 col = 1 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the second generation of the glider pattern.'
      ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 1 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the second generation of the glider pattern.'
      ).


    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 2 col = 4 cell_state = zif_gol_constants=>alive )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the second generation of the glider pattern.'
      ).



    cl_abap_unit_assert=>assert_table_contains(
    line  = VALUE zgol_grid_cell( row = 3 col = 1 cell_state = zif_gol_constants=>dead )
    table = i_grid_new->grid_cells
    msg   = 'Test the correctness of the second generation of the glider pattern.'
  ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the second generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 3 col = 4 cell_state = zif_gol_constants=>alive )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the second generation of the glider pattern.'
      ).
  ENDMETHOD.

  METHOD check_glider_generation3.
    "Check the third generation of the glider pattern
    "
    "- - - - -
    "- X - X -
    "- - X X -
    "- - X - -

    cl_abap_unit_assert=>assert_table_contains(
    line  = VALUE zgol_grid_cell( row = 1 col = 1 cell_state = zif_gol_constants=>dead )
    table = i_grid_new->grid_cells
    msg   = 'Test the correctness of the third generation of the glider pattern.'
  ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 1 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 1 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the third generation of the glider pattern.'
      ).


    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 2 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 2 col = 3 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 2 col = 4 cell_state = zif_gol_constants=>alive )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the third generation of the glider pattern.'
      ).



    cl_abap_unit_assert=>assert_table_contains(
    line  = VALUE zgol_grid_cell( row = 3 col = 1 cell_state = zif_gol_constants=>dead )
    table = i_grid_new->grid_cells
    msg   = 'Test the correctness of the third generation of the glider pattern.'
  ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 3 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 3 col = 4 cell_state = zif_gol_constants=>alive )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the third generation of the glider pattern.'
      ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 1 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
      ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 2 cell_state = zif_gol_constants=>dead )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
      line  = VALUE zgol_grid_cell( row = 4 col = 3 cell_state = zif_gol_constants=>alive )
      table = i_grid_new->grid_cells
      msg   = 'Test the correctness of the third generation of the glider pattern.'
    ).

    cl_abap_unit_assert=>assert_table_contains(
        line  = VALUE zgol_grid_cell( row = 4 col = 4 cell_state = zif_gol_constants=>dead )
        table = i_grid_new->grid_cells
        msg   = 'Test the correctness of the third generation of the glider pattern.'
      ).

  ENDMETHOD.


ENDCLASS.
