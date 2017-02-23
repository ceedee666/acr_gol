CLASS zcl_gol_game DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS calculate_next_generation IMPORTING i_grid                   TYPE REF TO zcl_gol_grid
                                                i_rules                  TYPE REF TO zcl_gol_rules
                                      RETURNING VALUE(r_next_generation) TYPE REF TO zcl_gol_grid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gol_game IMPLEMENTATION.

  METHOD calculate_next_generation.
    r_next_generation =
      zcl_gol_grid=>initialize( i_rows = i_grid->rows
                                i_cols = i_grid->cols ).

    LOOP AT i_grid->grid_cells ASSIGNING FIELD-SYMBOL(<cell>).
      r_next_generation->set_cell_state(
          i_row   = <cell>-row
          i_col   = <cell>-col
          i_state = i_rules->calculate_new_cell_state(
                      i_cell                    = <cell>
                      i_num_of_alive_neighbours =
                        i_grid->get_neighbours( <cell> )->number_of_live_cells( ) ) ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
