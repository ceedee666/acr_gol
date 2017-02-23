CLASS zcl_gol_gui DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING i_grid  TYPE REF TO zcl_gol_grid
                                  i_rules TYPE REF TO zcl_gol_rules
                                  i_game  TYPE REF TO zcl_gol_game.

    METHODS display.

    METHODS refresh_grid.

    METHODS next_gen.

    METHODS on_user_command FOR EVENT added_function OF cl_salv_events
      IMPORTING e_salv_function.

    METHODS on_double_click FOR EVENT double_click OF cl_salv_events_table
      IMPORTING row column.

    METHODS init_gui
      IMPORTING
                i_container_name TYPE string
      RETURNING VALUE(r_gui)     TYPE REF TO zcl_gol_gui.

  PROTECTED SECTION.
    DATA: grid  TYPE REF TO zcl_gol_grid,
          rules TYPE REF TO zcl_gol_rules,
          game  TYPE REF TO zcl_gol_game.

    DATA output_tab_ref TYPE REF TO data.

    DATA alv_table TYPE REF TO cl_salv_table.

    METHODS init_grid_with_life_forms.

    METHODS build_output_tab.

    METHODS fill_output_tab.

    METHODS create_alv_grid
      IMPORTING
        i_container_name TYPE string.

    METHODS get_index_from_alv_column
      IMPORTING alv_column TYPE salv_de_column
      RETURNING VALUE(col) TYPE i.
  PRIVATE SECTION.


ENDCLASS.



CLASS zcl_gol_gui IMPLEMENTATION.


  METHOD build_output_tab.
    DATA output_struct_components TYPE abap_component_tab.

    FIELD-SYMBOLS <output_table> TYPE table.

    DO me->grid->cols TIMES.
      APPEND INITIAL LINE TO output_struct_components ASSIGNING FIELD-SYMBOL(<component>).
      <component>-name = |C{ sy-index }|.
      <component>-type ?= cl_abap_typedescr=>describe_by_name( p_name = 'ICON_D' ).
    ENDDO.

    DATA(output_struct_descr) = cl_abap_structdescr=>create( output_struct_components ).
    DATA(output_table_descr) = cl_abap_tabledescr=>create( output_struct_descr ).

    CREATE DATA me->output_tab_ref TYPE HANDLE output_table_descr.

    ASSIGN me->output_tab_ref->* TO <output_table>.

    DO me->grid->rows TIMES.
      DATA(row_index) = sy-index.
      APPEND INITIAL LINE TO <output_table> ASSIGNING FIELD-SYMBOL(<row>).

      DO me->grid->cols TIMES.
        DATA(col_index) = sy-index.
        ASSIGN COMPONENT col_index OF STRUCTURE <row> TO FIELD-SYMBOL(<cell>).
      ENDDO.
    ENDDO.
  ENDMETHOD.


  METHOD constructor.
    me->grid = i_grid.
    me->rules = i_rules.
    me->game = i_game.
  ENDMETHOD.


  METHOD create_alv_grid.

    ASSIGN me->output_tab_ref->* TO FIELD-SYMBOL(<output_tab>).

    cl_salv_table=>factory(
      EXPORTING
        container_name = i_container_name
      IMPORTING
        r_salv_table   = me->alv_table
      CHANGING
        t_table        = <output_tab> ).

    me->alv_table->set_screen_status(
      EXPORTING
        report        = |Z_GOL|
        pfstatus      = |ALV_TABLE_STATUS|
        set_functions = me->alv_table->c_functions_all ).

    SET HANDLER me->on_user_command FOR alv_table->get_event( ).
    SET HANDLER me->on_double_click FOR alv_table->get_event( ).
  ENDMETHOD.


  METHOD display.
    me->alv_table->display( ).
  ENDMETHOD.


  METHOD fill_output_tab.
    FIELD-SYMBOLS <output_tab> TYPE table.
    ASSIGN output_tab_ref->* TO <output_tab>.

    DO me->grid->rows TIMES.
      DATA(row_index) = sy-index.
      READ TABLE <output_tab> INDEX row_index ASSIGNING FIELD-SYMBOL(<row>).

      DO me->grid->cols TIMES.
        DATA(col_index) = sy-index.
        ASSIGN COMPONENT col_index OF STRUCTURE <row> TO FIELD-SYMBOL(<cell>).

        IF me->grid->grid_cells[ row = row_index col = col_index ]-cell_state = zif_gol_constants=>alive.
          <cell> = zif_gol_constants=>live_cell_icon.
        ELSE.
          <cell> = ||.
        ENDIF.
      ENDDO.
    ENDDO.

  ENDMETHOD.


  METHOD init_grid_with_life_forms.
    "a beacon
    me->grid->set_cell_state( i_row = 5
                              i_col = 5
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 5
                              i_col = 6
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 6
                              i_col = 5
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 7
                              i_col = 8
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 8
                              i_col = 7
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 8
                              i_col = 8
                              i_state = zif_gol_constants=>alive ).

    "a glider
    me->grid->set_cell_state( i_row = 10
                              i_col = 7
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 11
                              i_col = 5
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 11
                              i_col = 7
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 12
                              i_col = 6
                              i_state = zif_gol_constants=>alive
           )->set_cell_state( i_row = 12
                              i_col = 7
                              i_state = zif_gol_constants=>alive ).

  ENDMETHOD.


  METHOD init_gui.

    me->init_grid_with_life_forms( ).
    me->build_output_tab( ).
    me->fill_output_tab( ).

    me->create_alv_grid( i_container_name ).

    r_gui = me.
  ENDMETHOD.


  METHOD next_gen.
    me->grid =
      me->game->calculate_next_generation(
          i_grid            = me->grid
          i_rules           = me->rules
      ).
  ENDMETHOD.


  METHOD on_user_command.
    CASE e_salv_function.
      WHEN 'STEP'.
        me->next_gen( ).

      WHEN 'REFRESH'.
        me->grid->clear( ).
        me->init_grid_with_life_forms( ).

      WHEN 'CLEAR'.
        me->grid->clear( ).
    ENDCASE.
    me->refresh_grid( ).
  ENDMETHOD.


  METHOD refresh_grid.
    me->fill_output_tab( ).
    me->alv_table->refresh( refresh_mode = if_salv_c_refresh=>full ).
  ENDMETHOD.

  METHOD on_double_click.
    DATA(col) = me->get_index_from_alv_column( column ).
    IF me->grid->grid_cells[ row = row col = col ]-cell_state = zif_gol_constants=>dead.
      me->grid->set_cell_state(
          i_row   = row
          i_col   = col
          i_state = zif_gol_constants=>alive ).
    ELSE.
      me->grid->set_cell_state(
          i_row   = row
          i_col   = col
          i_state = zif_gol_constants=>dead ).
    ENDIF.
    me->refresh_grid( ).
  ENDMETHOD.

  METHOD get_index_from_alv_column.
    col = substring( val = alv_column off = 1 ).
  ENDMETHOD.

ENDCLASS.
