package com.android.demo.notepad1

import android.app.Activity
import android.app.ListActivity
import android.widget.SimpleCursorAdapter
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem

# import "com.android.demo.notepad1.NotesDbAdapter"

class Notepadv1 < ListActivity

  def self.initialize: void
    @@INSERT_ID = Menu.FIRST
  end

  def initialize
    @noteNumber = 1
  end

  ## Called when the activity is first created.
  def onCreate(savedInstanceState: Bundle): void
    super savedInstanceState
    setContentView R.layout.notepad_list
    @dbHelper = NotesDbAdapter.new self
    @dbHelper.open
  end
  
  def onCreateOptionsMenu(menu: Menu): boolean
    result = super menu
    menu.add 0, @@INSERT_ID, 0, R.string.menu_insert
    result
  end
  
  def onOptionsItemSelected(item: MenuItem): boolean
    if item.getItemId == @@INSERT_ID
      createNote
      return true
    end
    super item
  end

  def createNote
    @noteNumber = @noteNumber + 1
    @dbHelper.createNote "Note " + @noteNumber, ""
    fillData
  end

  def fillData
    c = @dbHelper.fetchAllNotes
    startManagingCursor c
    
    from = String[1]; from[0] = NotesDbAdapter.KEY_TITLE
    to = int[1]; to[0] = R.id.text1
    
    notes = SimpleCursorAdapter.new self, R.layout.notes_row, c, from, to
    setListAdapter notes
  end
end
