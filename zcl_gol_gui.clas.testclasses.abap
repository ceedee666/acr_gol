CLASS ltcl_gol_gui DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      setup,
      test_build_output_tab FOR TESTING RAISING cx_static_check,
      test_fill_output_tab FOR TESTING RAISING cx_static_check,
      test_get_index_from_alv_col FOR TESTING RAISING cx_static_check.

    DATA gui TYPE REF TO zcl_gol_gui.
ENDCLASS.


CLASS ltcl_gol_gui IMPLEMENTATION.

  METHOD test_build_output_tab.
    FIELD-SYMBOLS <table> TYPE ANY TABLE.

    gui->build_output_tab( ).

    ASSIGN gui->output_tab_ref->* TO <table>.
    cl_aunit_assert=>assert_equals( exp = 10
                                    act = lines( <table> )
                                    msg = 'The output table should should have 10 lines.' ).

    LOOP AT <table> ASSIGNING FIELD-SYMBOL(<table_line>).
      EXIT.
    ENDLOOP.

    DATA(struct_descr) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( <table_line> ) ).
    DATA(components) = struct_descr->get_components( ).

    cl_aunit_assert=>assert_equals( exp = 15
                                    act = lines( components )
                                    msg = 'Each output table line should have 15 components.' ).

    LOOP AT components ASSIGNING FIELD-SYMBOL(<component>).
      cl_aunit_assert=>assert_equals( exp = |C{ sy-tabix }|
                                      act = <component>-name
                                      msg = 'Each componente should be named C*' ).
      cl_aunit_assert=>assert_equals( exp = |ICON_D|
                                      act = <component>-type->get_relative_name( )
                                      msg = 'Each component should be of type ICON_D' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD setup.
    gui = NEW zcl_gol_gui( i_grid = zcl_gol_grid=>initialize( i_rows = 10
                                                              i_cols = 15 )
                           i_rules = NEW zcl_gol_rules( )
                           i_game = NEW zcl_gol_game( ) ).
  ENDMETHOD.

  METHOD test_fill_output_tab.
    FIELD-SYMBOLS <output_table> TYPE table.

    gui->grid->set_cell_state( i_row = 1
                               i_col = 1
                               i_state = zif_gol_constants=>alive ).
    gui->grid->set_cell_state( i_row = 1
                               i_col = 4
                               i_state = zif_gol_constants=>alive ).

    gui->build_output_tab( ).
    gui->fill_output_tab( ).

    ASSIGN gui->output_tab_ref->* TO <output_table>.

    READ TABLE <output_table> INDEX 1 ASSIGNING FIELD-SYMBOL(<table_row>).
    DO gui->grid->rows TIMES.
      ASSIGN COMPONENT sy-index OF STRUCTURE <table_row> TO FIELD-SYMBOL(<element>).
      IF sy-index = 1 OR sy-index = 4.
        cl_abap_unit_assert=>assert_equals(
          msg = 'The correct icon should be assigned to each grid cells.'
          exp = zif_gol_constants=>live_cell_icon
          act = <element> ).
      ELSE.
        cl_abap_unit_assert=>assert_equals(
          msg = 'The correct icon should be assigned to each grid cells.'
          exp = ||
          act = <element> ).
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD test_get_index_from_alv_col.
    cl_abap_unit_assert=>assert_equals(
      msg = 'The method should return the correct column index.'
      exp = 5
      act = gui->get_index_from_alv_column( |C5| ) ).

    cl_abap_unit_assert=>assert_equals(
      msg = 'The method should return the correct column index.'
      exp = 25
      act = gui->get_index_from_alv_column( |C25| ) ).
  ENDMETHOD.

ENDCLASS.
