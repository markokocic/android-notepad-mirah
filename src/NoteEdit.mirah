package com.android.demo.notepad3

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.util.Log

class NoteEdit < Activity

  def initialize
    @titleText = EditText(nil)
    @bodyText = EditText(nil)
    @rowId = long(0)
    @dbHelper = NotesDbAdapter(nil)
  end

  $Override
  def onCreate(savedInstanceState: Bundle): void
    super savedInstanceState
    @dbHelper = NotesDbAdapter.new self
    @dbHelper.open

    setContentView R.layout.note_edit
    # setTitle R.string.edit_note
    
    @titleText = EditText (findViewById(R.id.title))
    @bodyText = EditText (findViewById(R.id.body))

    confirmButton = Button (findViewById(R.id.confirm))

    @rowId = long(0)
    if !savedInstanceState.nil?
      @rowId = savedInstanceState.getLong NotesDbAdapter.KEY_ROWID
    end
    if @rowId == 0
      extras = getIntent().getExtras
      if !extras.nil?
        @rowId = extras.getLong NotesDbAdapter.KEY_ROWID
      end
    end

    populateFields
        
    this = self
    confirmButton.setOnClickListener do | view |
      this.setResult Activity.RESULT_OK
      this.finish
    end
  end

  $Override
  def onSaveInstanceState(outState: Bundle): void
    super outState
    saveState
    outState.putLong NotesDbAdapter.KEY_ROWID, @rowId
  end

  $Override
  def onPause(): void
    super
    saveState
  end

  $Override
  def onResume(): void
    super
    populateFields
  end

  def saveState: void
    title = @titleText.getText().toString
    body = @bodyText.getText().toString
    
    if @rowId == 0
      id = @dbHelper.createNote title, body
      if id > 0
        @rowId = id
      end
    else
      @dbHelper.updateNote @rowId, title, body
    end
  end

  def populateFields
    if @rowId > 0
      note = @dbHelper.fetchNote @rowId
      startManagingCursor note
      @titleText.setText note.getString(note.getColumnIndexOrThrow NotesDbAdapter.KEY_TITLE)
      @bodyText.setText note.getString(note.getColumnIndexOrThrow NotesDbAdapter.KEY_BODY)
    end
  end

end

