package "com.android.demo.notepad1"

import "android.content.ContentValues"
import "android.content.Context"
import "android.database.Cursor"
import "android.database.SQLException"
import "android.database.sqlite.SQLiteDatabase"
import "android.database.sqlite.SQLiteDatabase.CursorFactory"
import "android.database.sqlite.SQLiteOpenHelper"
import "android.util.Log"

## Simple notes database access helper class. Defines the basic CRUD operations
## for the notepad example, and gives the ability to list all notes as well as
## retrieve or modify a specific note.
 
## This has been improved from the first version of this tutorial through the
## addition of better error handling and also using returning a Cursor instead
## of using a collection of inner classes (which is less scalable and not
## recommended).

class NotesDbAdapter
  
  def self.initialize
    Log.w "WWW", "Notesdbadapter.self.initialize called"
    @@DATABASE_TABLE = "notes"
    @@KEY_TITLE = "title"
    @@KEY_BODY = "body"
    @@KEY_ROWID = "_id"
  end

  ## Constructor - takes the context to allow the database to be
  ## opened/created
  ## 
  ## @param ctx the Context within which to work
  def initialize (ctx: Context)
    @ctx = ctx
    @db = SQLiteDatabase(nil)
    @dbHelper = DatabaseHelper(nil)
    # @db: SQLiteDatabase = nil
    # @dbHelper: DatabaseHelper = nil
  end
  
  ## Open the notes database. If it cannot be opened, try to create a new
  ## instance of the database. If it cannot be created, throw an exception to
  ## signal the failure
  ## 
  ## @return this (self reference, allowing this to be chained in an
  ##         initialization call)
  ## @throws SQLException if the database could be neither opened or created
  def open: NotesDbAdapter
    @dbHelper = DatabaseHelper.new @ctx
    @db = @dbHelper.getWritableDatabase
    self
  end
  
  def close(): void
    @dbHelper.close
  end

  def self.KEY_TITLE
    @@KEY_TITLE
  end
  
  ## Create a new note using the title and body provided. If the note is
  ## successfully created return the new rowId for that note, otherwise return
  ## a -1 to indicate failure.
  ## 
  ## @param title the title of the note
  ## @param body the body of the note
  ## @return rowId or -1 if failed
  def createNote(title: String, body: String): long
    initialValues = ContentValues.new
    initialValues.put @@KEY_TITLE, title
    initialValues.put @@KEY_BODY, body
    
    return @db.insert @@DATABASE_TABLE, null, initialValues
  end
  
  ## Delete the note with the given rowId
  ## 
  ## @param rowId id of note to delete
  ## @return true if deleted, false otherwise
  def deleteNote(rowId: long) : boolean
    (@db.delete @@DATABASE_TABLE, @@KEY_ROWID + "=" + rowId, null) > 0
  end

  def toStringArray(list: java.util.List): String[]
    strings = String[list.size]
    list.size.times { |i| strings[i] = String(list.get(i)) }
    strings
  end

  ## Return a Cursor over the list of all notes in the database
  ## 
  ## @return Cursor over all notes
  def fetchAllNotes() : Cursor
    return @db.query @@DATABASE_TABLE, toStringArray([@@KEY_ROWID, @@KEY_TITLE, @@KEY_BODY]), null, null, null, null, null
  end
  
  ## Return a Cursor positioned at the note that matches the given rowId
  ## 
  ## @param rowId id of note to retrieve
  ## @return Cursor positioned to matching note, if found
  ## @throws SQLException if note could not be found/retrieved
  def fetchNote(rowId: long): Cursor
    mCursor = @db.query true, @@DATABASE_TABLE, toStringArray([@@KEY_ROWID, @@KEY_TITLE, @@KEY_BODY]), @@KEY_ROWID + "=" + rowId, null, null, null, null, null
    if !mCursor.nil?
      mCursor.moveToFirst
    end
    mCursor
  end

  ## Update the note using the details provided. The note to be updated is
  ## specified using the rowId, and it is altered to use the title and body
  ## values passed in
  ## 
  ## @param rowId id of note to update
  ## @param title value to set note title to
  ## @param body value to set note body to
  ## @return true if the note was successfully updated, false otherwise
  def updateNote(rowId: long, title: String, body: String): boolean
    args = ContentValues.new
    args.put @@KEY_TITLE, title
    args.put @@KEY_BODY, body
    return (@db.update @@DATABASE_TABLE, args, @@KEY_ROWID + "=" + rowId, null) > 0;
  end
end

class DatabaseHelper < SQLiteOpenHelper
  
  def self.initialize
    Log.w nil, "DatabaseHelper.self.initialize called"
    @@TAG = "NotesDbAdapter"    
    ## Database creation sql statement
    @@DATABASE_CREATE = "create table notes (_id integer primary key autoincrement, " + "title text not null, body text not null);"
    @@DATABASE_NAME = "data"
    @@DATABASE_VERSION = 2
    Log.w "WWW", "db version self.init #{@@DATABASE_VERSION}"
  end
  
  def initialize (context: Context)
    super context, @@DATABASE_NAME, CursorFactory(nil), @@DATABASE_VERSION
    Log.w @@TAG, "db version init " + @@DATABASE_VERSION
  end
  
  def onCreate(db: SQLiteDatabase):void
    db.execSQL @@DATABASE_CREATE
  end
  
  def onUpgrade(db: SQLiteDatabase, oldVersion: int, newVersion: int): void
    Log.w @@TAG, "Upgrading database from version " + oldVersion + " to " + newVersion + ", which will destroy all old data"
    db.execSQL "DROP TABLE IF EXISTS notes"
    onCreate db
  end
end

