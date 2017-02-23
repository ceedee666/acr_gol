*&---------------------------------------------------------------------*
*& Report z_gol
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_gol.

DATA gol_gui TYPE REF TO zcl_gol_gui.

SELECTION-SCREEN BEGIN OF BLOCK grid_size WITH FRAME TITLE TEXT-001.
PARAMETERS p_rows TYPE i DEFAULT 20.
PARAMETERS p_cols TYPE i DEFAULT 25.
SELECTION-SCREEN END OF BLOCK grid_size.


START-OF-SELECTION.
  gol_gui = NEW zcl_gol_gui( i_grid = zcl_gol_grid=>initialize( i_rows = p_rows
                                                                i_cols = p_cols )
                             i_rules = NEW zcl_gol_rules( )
                             i_game = NEW zcl_gol_game( ) ).
  gol_gui->init_gui( i_container_name = |CC_GRID| )->display( ).
