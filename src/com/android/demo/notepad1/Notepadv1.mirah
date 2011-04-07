package "com.android.demo.notepad1"

import "android.app.Activity"
import "android.os.Bundle"
import "android.view.Menu"
import "android.view.MenuItem"

import "com.android.demo.notepad1.NotesDbAdapter"

class Notepadv1 < Activity
  @mNoteNumber = 1

  ## Called when the activity is first created. */
  def onCreate(savedInstanceState: Bundle): void
    super savedInstanceState
  end
  
  def onCreateOptionsMenu(menu: Menu): boolean
    # TODO Auto-generated method stub
    super  menu
  end
  
  def onOptionsItemSelected(item: MenuItem): boolean
    # TODO Auto-generated method stub
    super item
  end
end
