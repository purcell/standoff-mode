;;
;; Dummy backend
;;

(defun standoff-dummy-write-range-DEPRECATED (buf startchar endchar markup-name markup-id)
  "A dummy function that does nothing but fullfill the function
definition. The user should definitively replace it with a
function that persists the markup in some backend."
;; TODO: Check if markup with id is of markup-name! (Consistency)
  (let ((markup-identifier (cond
			    ((equal markup-id "n") (+ (standoff-dummy-markup-element-last-id) 1))
			    ((numberp markup-id) markup-id)
			    (t (string-to-number markup-id)))))
    (setq standoff-dummy-markup
	  (cons (list startchar endchar markup-name markup-identifier) 
		standoff-dummy-markup))
    markup-identifier))

(defun standoff-dummy-create-markup (buf startchar endchar markup-type)
  (let ((markup-inst-id (funcall standoff-dummy-create-id-function standoff-dummy-markup 0)))
    (setq standoff-dummy-markup
	  (cons (list markup-inst-id markup-type startchar endchar)
		standoff-dummy-markup))
    markup-inst-id))

(defun standoff-dummy-add-range (buf startchar endchar markup-inst-id)
  (let ((markup-data standoff-dummy-markup)
	(markup-type nil))
    (while markup-data
      (if (equal markup-inst-id (nth 0 (car markup-data)))
	  (progn
	    (setq markup-type (nth 1 (car markup-data)))
	    (setq markup-data nil))
	(setq markup-data (cdr markup-data))))
    (unless markup-type
      (error "Invalid ID"))
    (setq standoff-dummy-markup (cons (list markup-inst-id markup-type startchar endchar)
				      standoff-dummy-markup))
    markup-inst-id))

(defun standoff-dummy-read-ranges (buf &optional startchar endchar markup-name markup-id)
  "Return the dummy backend, apply filter given by STARTCHAR
ENDCHAR MARKUP-NAME MARKUP-ID."
  (let ((backend standoff-dummy-markup)
	(ranges-to-return nil)
	(range))
    (while backend
      (setq range (car backend))
      (when (and (or (not startchar) (> (nth 1 range) startchar))
		 (or (not startchar) (< (nth 0 range) endchar))
		 (or (not markup-name) (equal (nth 2 range) markup-name))
		 (or (not markup-id) (equal (nth 3 range) markup-id)))
	(setq ranges-to-return (cons range ranges-to-return)))
      (setq backend (cdr backend)))
    ranges-to-return))

(defun standoff-dummy-delete-range (buf startchar endchar markup-name markup-id)
  "Delete a markup range from the dummy backend."
  (let ((new-backend nil)
	(range))
    (while standoff-dummy-markup
      (setq range (car standoff-dummy-markup))
      (when (not (and (equal (nth 0 range) startchar)
		      (equal (nth 1 range) endchar)
		      (equal (nth 2 range) markup-name)
		      (equal (nth 3 range) markup-id)))
	(setq new-backend (cons range new-backend)))
      (setq standoff-dummy-markup (cdr standoff-dummy-markup)))
    (setq standoff-dummy-markup new-backend)))

(defun standoff-dummy-markup-element-names ()
  "Return the names of markup elements stored in the dummy backend."
  ;; TODO: remove duplicates
  (mapcar '(lambda (x) (nth 2 x)) standoff-dummy-markup))

(defun standoff-dummy-create-intid (data pos)
  "Create an integer ID for the next item in the dummy backend,
where the item's list is given by DATA and should ether be
standoff-dummy-markup or standoff-dummy-relations, and POS gives
the position (column) of the ID in lists, data is composed
of. E.g. 0 is the POS of the ids in standoff-dummy-markup."
  (if data
      (+ (apply 'max (mapcar '(lambda (x) (nth pos x)) data)) 1)
    1))

(defun standoff-dummy-create-uuid (&optional data pos)
  "Create a UUID. This uses a simple hashing of variable data.
Example of a UUID: 1df63142-a513-c850-31a3-535fc3520c3d

Note: this code uses https://en.wikipedia.org/wiki/Md5 , which is
not cryptographically safe. I'm not sure what's the implication
of its use here.

Written by Christopher Wellons, 2011, edited by Xah Lee and
other, taken from
http://ergoemacs.org/emacs/elisp_generate_uuid.html
"
  (let ((myStr (md5 (format "%s%s%s%s%s%s%s%s%s%s"
                            (user-uid)
                            (emacs-pid)
                            (system-name)
                            (user-full-name)
                            (current-time)
                            (emacs-uptime)
                            (garbage-collect)
                            (buffer-string)
                            (random)
                            (recent-keys)))))
    (format "%s-%s-4%s-%s%s-%s"
                    (substring myStr 0 8)
                    (substring myStr 8 12)
                    (substring myStr 13 16)
                    (format "%x" (+ 8 (random 4)))
                    (substring myStr 17 20)
                    (substring myStr 20 32))))
 
(defcustom standoff-dummy-create-id-function 'standoff-dummy-create-uuid
  "The function for creating IDs."
  :group 'standoff
  :type 'function)

(defun standoff-dummy-predicate-names (buf subj-id obj-id)
  "Returns a list of predicate names for relations between
subject given by SUBJ-ID and object given by OBJ-ID. Currently
this does not filter valid relation names for combination of
subject and object."
  (mapcar '(lambda (x) (nth 1 x)) standoff-dummy-relations))

(defun standoff-dummy-write-relation (buf subj-id predicate obj-id)
  "Store relation to the backend."
  (setq standoff-dummy-relations
	(cons (list subj-id predicate obj-id) standoff-dummy-relations)))

(defun standoff-dummy-backend-reset ()
  "Reset the dummy backend. It may be usefull during development
to make this an interactive function."
  (interactive)
  (when (yes-or-no-p "Do you really want to reset this buffer, which means that all markup information will be lost?")
    (standoff-dummy--backend-reset)))

(defun standoff-dummy--backend-reset ()
  "Reset the dummy backend."
  (setq-local standoff-dummy-checksum nil)
  (setq-local standoff-dummy-markup '())
  (setq-local standoff-dummy-relations '()))

(defun standoff-dummy-backend-setup ()
  ;; TODO: read from file if present
  (standoff-dummy-backend-reset))

(add-hook 'standoff-mode-hook 'standoff-dummy-backend-setup)

(defun standoff-dummy-backend-inspect ()
  "Display the dummy backend in the minibuffer. This may be
usefull for development."
  (interactive)
  (message "%s" (list standoff-dummy-checksum
		      standoff-dummy-markup
		      standoff-dummy-relations)))
