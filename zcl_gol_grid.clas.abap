CLASS zcl_gol_grid DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS initialize IMPORTING i_rows        TYPE i
                                       i_cols        TYPE i
                             RETURNING VALUE(r_grid) TYPE REF TO zcl_gol_grid.
    METHODS set_cell_state IMPORTING i_row         TYPE i
                                     i_col         TYPE i
                                     i_state       TYPE abap_bool
                           RETURNING VALUE(r_grid) TYPE REF TO zcl_gol_grid.
    METHODS clear RETURNING VALUE(r_grid) TYPE REF TO zcl_gol_grid.

    METHODS get_neighbours IMPORTING i_cell                  TYPE zgol_grid_cell
                           RETURNING VALUE(r_neighbour_grid) TYPE REF TO  zcl_gol_grid.

    METHODS number_of_live_cells RETURNING VALUE(r_number_live_cells) TYPE i.

    DATA grid_cells TYPE zgol_grid READ-ONLY.
    DATA rows TYPE i READ-ONLY.
    DATA cols TYPE i READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gol_grid IMPLEMENTATION.

  METHOD initialize.
    r_grid = NEW zcl_gol_grid( ).
    r_grid->rows = i_rows.
    r_grid->cols = i_cols.
    r_grid->grid_cells = VALUE #(
        FOR i = 1 THEN i + 1 WHILE i <= i_rows
        FOR j = 1 THEN j + 1 WHILE j <= i_cols (
            row = i
            col = j
            cell_state = zif_gol_constants=>dead
        ) ).
  ENDMETHOD.

  METHOD set_cell_state.
    me->grid_cells[ row = i_row col = i_col ]-cell_state = i_state.
    r_grid = me.
  ENDMETHOD.

  METHOD get_neighbours.
    r_neighbour_grid = NEW zcl_gol_grid( ).
    r_neighbour_grid->grid_cells = VALUE #(
      FOR cell IN me->grid_cells
        WHERE ( row >= i_cell-row - 1
            AND row <= i_cell-row + 1
            AND col >= i_cell-col - 1
            AND col <= i_cell-col + 1 )
            ( cell ) ).

    DELETE TABLE r_neighbour_grid->grid_cells FROM i_cell.
  ENDMETHOD.

  METHOD number_of_live_cells.
    r_number_live_cells =
      REDUCE #(
        INIT count = 0
        FOR cell IN me->grid_cells
        NEXT
          count = COND i(
            WHEN cell-cell_state = zif_gol_constants=>alive THEN
              count + 1
            ELSE
              count ) ).

  ENDMETHOD.



  METHOD clear.
    LOOP AT me->grid_cells ASSIGNING FIELD-SYMBOL(<cell>).
      <cell>-cell_state = zif_gol_constants=>dead.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
