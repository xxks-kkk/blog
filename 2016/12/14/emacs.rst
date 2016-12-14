.. _emacs.rst:

############################
Minimal Emacs Tutorial
############################

.. author:: default
.. categories:: emacs
.. tags:: emacs, tutorial, emacs-basic

*******************
Learn about Emacs
*******************

Here I will cover some basic manipulation with text files using emacs. It should be enough to get started working with
emacs.

==============
Terms in Emacs
==============

- Region: the highlighted area
- Kill: same as "cut"
- Yank: same as "paste"   

==================
Emacs Key Notation
==================

=======  ======================================================
Prefix   Meaning
=======  ======================================================
C-       (press and hold) the **Control** key
M-       the Meta key (the **Alt** key, on most keyboards)
S-       the **Shift** key (ie. ``S-TAB`` means Shift Tab)
DEL      the **Backspace** key (not the Delete key). 
RET      the Return or **Enter** key
SPC      the **Space bar** key
ESC      the **Escape** key
TAB	 the **TAB** key
ARR      the arrow keys
=======  ======================================================


===================
Common Usage
===================

System operation
================

- **C-g** keyboard-quit; cancels anything Emacs is executing. If you press
  any key sequence wrongly, **C-g** to cancel that incorrectly pressed key
  sequence and start again.
- **C-x C-c** close emacs
- **C-x b** Open a promt to enter a buffer name
- **C-h f** Describe a function (i.e., ``C-h f electric-indent-mode``, ``C-h f fboundp``)
- **C-x ARR** quickly switch between buffers

File Editing
===================

.. seealso::

        You need to set mark before you can use region operation. To know more about `The Mark and Region <https://www.cs.colorado.edu/~main/cs1300-old/cs1300/doc/emacs/emacs_13.html>`_ 

.. note::

         To move or copy a region of text in emacs, you must first "mark" it, then kill or copy the marked text, move the cu
         rsor to the desired location, and restore the killed or copied text. A region of text is defined by marking one end         of it, then moving the cursor to the other end. 

- **C-@** Set the mark here
- **C-SPC** Set the mark where point is
- **C-x-h** Select the whole text
- **C-w** kill the region
- **M-d** kill forward to the end of the next word (``kill-word``)
- **C-y** yank the region
- **M-w** copy the region
- **C-k** kill the whole line (note you need to put the cursor at the very beginning of the line)

.. note::

      To copy text, kill it, yank it back immediately (so it's as if you haven't killed it, except it's now in the kill ring
      ), move elsewhere and yank it back again. 

- **C-x C-s** save file
- **C-x C-v RET** reload a file (alternative way is **M-x revert-buffer**)
- **C-/** (**C-x u**) undo
- **C-r** invoke backward search (type search word thereafter. Use **C-r**
  to repeatedly travel through the matches backward)
- **C-s** similar to **C-r** but search forward
- **C-x r t** insert words to multiple lines highlighted (the same thing you typed will be entered on all the lines you've
  selected)
- **M-x clipboard-yank** paste the clipboard text to emacs (useful when using emacs GUI)
- **M-x clipboard-kill-region** paste emacs text to clipboard

Cursor Movement
====================

- **ESC-<** go to the beginning of the file 
- **ESC-a** go to beginning of the sentence 
- **ESC-e** go to end of the sentence
- **C-a** go to beginning of the line
- **C-e** go to the end of the line
- **M-x goto-line** go to the line specified
- **C-e RET** simulate ``o`` in vi
- **C-a RET** simulate ``O`` in vi
- **C-Up** go to the cursor location before a chunk of test pasted
- **C-v** page down
- **M-v** page up

Searching and Replacing
=======================

- **ESC-%** (query-replace) - ask before replacing each OLD STRING with NEW STRING. 

             - Type ``y`` to replace this one and go to the next one
	     - Type ``n`` to skip to next without replacing
	     - Type ``!`` to replace this one and remaining replacements without asking

- **Esc-x replace-string** replace all occurrences of OLD STRING with NEW STRING.

- **ESC-x list-matching-lines** lists all the lines matching your pattern in a separate buffer, along with their numbers. Use "ESC-x goto-line" to go to the occurrence you're interested in.  

Manage Split Windows
====================

- **C-x 2** split-window-below
- **C-x 3** split-window-right
- **C-x 1** delete-other-windows (unsplit all)
- **C-x 0** delete-window  (remove current pane)
- **C-x o** other-window (cycles among the opening buffers) 

File Management (dired mode)
=============================

- **M-x dired** start view directory
- **^** go to parent dir
- **g** refresh dir listing
- **q** Quit dired mode (buffer still exists)
- **RET** Open the file or directory
- **o** Open file in another window (move cursor to that window as well)
- **C-o** Open file in another window but stay on dired buffer
- **+** create new dir
- **C-x C-f** Create a new file (yes, the command is the same as opening a new file in non-dired mode)  

.. seealso::

  `Emacs: File Management on ergoemacs <http://ergoemacs.org/emacs/file_management.html>`_


Other
====================

- **M-x whitespace-mode** allows you to explicitly see white-space, tab, newline. Especially useful when work
  with python.


====================
HowTos
====================

.. topic:: Parent shell

        When running Emacs in a terminal, you can press **C-z**, type the shell command and then resume Emacs with **fg**

.. topic:: How can I get Emacs to reload all my definitions that I have updated in .emacs without restarting Emacs?

        You can use the command load-file (**M-x load-file**, then press return twice to accept the default filename, which         is the current file being edited).

	You can also just move the point to the end of any sexp and press **C-x C-e** to execute just that sexp. Usually it'
        s not necessary to reload the whole file if you're just changing a line or two.

	**M-x eval-buffer** immediately evaluates all code in the buffer, its the quickest method, if your ``.emacs`` is 
	idempotent. 

	You can usually just re-evaluate the changed region. Mark the region of ~/.emacs that you've changed, and then use 
	**M-x eval-region RET**. This is often safer than re-evaluating the entire file since it's easy to write a .emacs 
	file that doesn't work quite right after being loaded twice.

.. topic:: Shift multiple lines with TAB

        Select multiply lines, then type **C-u 8 C-x Tab**, it will indent the region by 8 spaces. **C-u -4 C-x Tab** will un-indent by 4 spaces.


.. topic::  Switch between windows when one windows open with term

        If you open two windows, and one window open a term (ie. **M-x term**), now you want to switch back to another
	window. You may find out "C-x o" may no longer work. In this case, you may want to use **C-c o** to switch to next
	window from term

.. topic:: Comment out multiple region

        Comment out multiple lines. Highlight the region and then **M-x comment-region**. To undo the comment,
	**M-x uncomment-region**

.. topic:: Error during download request: Not Found

        Happened when you try to install a package (M-x package-install). **M-x package-refresh-contents** to rescue.

.. topic:: Editing multiple lines at the same time

    suppose I have the following chunk of code that I want to edit::
           
            printf "%s=%s\n" "Database" "bool_db"
            printf "%s=%s\n" "Username"  "admin"
            printf "%s=%s\n" "Password"  "password"
            printf "%s=%s\n" "ReadOnly"  "false"
            printf "%s=%s\n" "ShowSystemTables" "false"
            printf "%s=%s\n" "LegacySQLTables" "false"
            printf "%s=%s\n" "LoginTimeout" "0"

    and I want to remove all ``printf "%s=%s\n"`` in each line. I can do the following:

    1. Mark the beginning of the region and invoke **M-x rectangle-mark-mode** (or **C-x SPC**) and select all the ``printf "%s=%s\n"``
    2. Delete them by **M-x kill-region** (or **C-x r k**)

    .. note::

       Instead of delete, you can use **C-x r t string RET** to replace rectangle contents with *string* con each line.
         
==================
Resources
==================

Personally reference them a lot. But there are ton online through google.

- `Stanford emacs basics <http://mally.stanford.edu/~sr/computing/emacs.html>`_
- `Xah Emacs Tutorial <http://ergoemacs.org/emacs/emacs_find_replace.html>`_
- `Emacs-Elisp-Programming <https://github.com/caiorss/Emacs-Elisp-Programming>`_

*******************
Emacs Configuration
*******************

This is my `personal emacs configuration <https://github.com/xxks-kkk/emacs-config>`_.
  
