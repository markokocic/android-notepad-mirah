package com.android.demo.notepad2

import android.app.Activity
import android.app.ListActivity
import android.content.Intent
import android.database.Cursor
import android.os.Bundle
import android.view.ContextMenu
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.view.ContextMenu.ContextMenuInfo
import android.widget.ListView
import android.widget.SimpleCursorAdapter


class Notepadv2 < ListActivity

  def self.initialize: void
    @@ACTIVITY_CREATE = 0
    @@ACTIVITY_EDIT = 1

    @@INSERT_ID = Menu.FIRST    
    @@DELETE_ID = Menu.FIRST + 1
  end

  def initialize
    @noteNumber = 1
    @notesCursor = nil
  end

  ## Called when the activity is first created.
  $Override
  def onCreate(savedInstanceState: Bundle): void
    super savedInstanceState
    setContentView R.layout.notes_list
    @dbHelper = NotesDbAdapter.new self
    @dbHelper.open
    fillData
  end
  
  $Override
  def onCreateOptionsMenu(menu: Menu): boolean
    result = super menu
    menu.add 0, @@INSERT_ID, 0, R.string.menu_insert
    true
  end
  
  $Override
  def onMenuItemSelected(featureId: int, item: MenuItem): boolean
    if item.getItemId == @@INSERT_ID
      createNote
      return true
    end
    super featureId, item
  end

  def createNote

  end

  def fillData: void
    @notesCursor = @dbHelper.fetchAllNotes
    startManagingCursor @notesCursor
    
    from = String[1]; from[0] = NotesDbAdapter.KEY_TITLE
    to = int[1]; to[0] = R.id.text1
    
    notes = SimpleCursorAdapter.new self, R.layout.notes_row, @notesCursor, from, to
    setListAdapter notes
  end

  $Override
  def onCreateContextMenu(menu: ContextMenu, v: View, menuInfo: ContextMenuInfo)
    super menu, v, menuInfo
    # TODO: fill in rest of method
  end

  $Override
  def onContextItemSelected(item: MenuItem): boolean
    # TODO: fill in rest of method
    super item
  end

  def createNote()
      # TODO: fill in implementation
  end
    
  $Override
  def onListItemClick(l: ListView, v: View, position: int, id: long): void
    super l, v, position, id
    # TODO: fill in rest of method
  end

  $Override
  def onActivityResult(requestCode: int, resultCode: int, intent: Intent): void
    super requestCode, resultCode, intent
    # TODO: fill in rest of method
  end

end
