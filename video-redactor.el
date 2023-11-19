(global-set-key "\C-cvrr" 'videor-redactor-restart-redacted-stream)

(defvar video-redactor-unilang-client-name "VideoRedactor")
(defvar video-redactor-buffer-name "*Video-Redactor*")

(defun videor-redactor-restart-redacted-stream ()
 ""
 (interactive)
 (kmax-assert-role "flpTerm")
 (if (get-buffer video-redactor-buffer-name)
  (kmax-kill-buffer-no-ask (get-buffer video-redactor-buffer-name)))
 (uea-manually-deregister-client video-redactor-unilang-client-name)
 (run-in-shell
  "cd /var/lib/myfrdcsa/sandbox/hackery2-20230422/hackery2-20230422/data/ocr && source venv/bin/activate && ./frdcsa.sh"
  video-redactor-buffer-name))

(defun uea-manually-deregister-client (client-name)
 ""
 (save-excursion
  (pop-to-buffer (get-buffer "*ushell*"))
  (insert (concat "UniLang, deregister " client-name))
  (eshell-send-input)))
