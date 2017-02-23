CLASS zcl_gol_rules DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS calculate_new_cell_state IMPORTING i_cell                    TYPE zgol_grid_cell
                                               i_num_of_alive_neighbours TYPE i
                                     RETURNING VALUE(r_new_cell_state)   TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gol_rules IMPLEMENTATION.

  METHOD calculate_new_cell_state.
    CASE i_cell-cell_state.

      WHEN zif_gol_constants=>alive.
        IF i_num_of_alive_neighbours < 2.
          r_new_cell_state = zif_gol_constants=>dead.

        ELSEIF i_num_of_alive_neighbours = 2
            OR i_num_of_alive_neighbours = 3.
          r_new_cell_state = zif_gol_constants=>alive.

        ELSEIF i_num_of_alive_neighbours > 3.
          r_new_cell_state = zif_gol_constants=>dead.
        ENDIF.

      WHEN zif_gol_constants=>dead.
        IF i_num_of_alive_neighbours = 3.
          r_new_cell_state = zif_gol_constants=>alive.
        ENDIF.

      WHEN OTHERS.
        r_new_cell_state = zif_gol_constants=>dead.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
