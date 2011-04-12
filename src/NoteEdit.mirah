package com.android.demo.notepad2

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
  end

  $Override
  def onCreate(savedInstanceState: Bundle): void
    super savedInstanceState
    setContentView R.layout.note_edit
    setTitle R.string.edit_note
    
    @titleText = EditText (findViewById(R.id.title))
    @bodyText = EditText (findViewById(R.id.body))

    confirmButton = Button (findViewById(R.id.confirm))

    @rowId = long(0)
    extras = getIntent().getExtras
    if !extras.nil?
      title = extras.getString NotesDbAdapter.KEY_TITLE
      body = extras.getString NotesDbAdapter.KEY_BODY
      @rowId = extras.getLong NotesDbAdapter.KEY_ROWID
        
      if !title.nil?
        @titleText.setText title
      end
      if !body.nil?
        @bodyText.setText body
      end
    end
        
    this = self
    titleText = @titleText
    bodyText = @bodyText
    rowId = @rowId
    confirmButton.setOnClickListener do | view |
      bundle = Bundle.new
      bundle.putString NotesDbAdapter.KEY_TITLE, titleText.getText().toString
      bundle.putString NotesDbAdapter.KEY_BODY, bodyText.getText().toString
      if rowId != 0
        bundle.putLong NotesDbAdapter.KEY_ROWID, rowId
      end
      
      mIntent = Intent.new
      mIntent.putExtras bundle
      this.setResult Activity.RESULT_OK, mIntent
      this.finish
    end
  end
end

