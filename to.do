(do some kind of edge or contrast detection so that differently
 colored items still are recognized by the OCR engine)

(add a flag to redact all text)

(get the ocr-video-file.py or what not to accept cli options for
 which files to read and to write)

(another optimization, if A is in redacted, and B contains A, B
 is in redacted automatically??? i.e. on python side without
 querying through UniLang)

(double check super common tokens, since it seems to have a form
 of confirmation bias)

(python side: if previous frame is same as current frame, do not
 bother to OCR)

(should redact things that high have relative entropy)

(need to deal things where the text is split through a valid
 redactable term)

(could possibly use OCR certainty as a reflection of whether the
 text was garbled, so as to redact things that aren't very
 certain, so that like cropped text/edges and other "corner"
 cases are handled)

(see ~/koo5-notes-on-ocr-video-stream.txt for info on how to
 perform this into a video file.)

(possibly have VideoRedactor cache results, preferably on Python
 end, to reduce amount of info sent over, so it doesn't have to
 redo everything constantly)

(redact video, ala koo5's hackery2/data/ocr system. Bring that in
 here locally, have it redact our videos, copy all the
 conversations here and get it going)
(use this to redact videos of our AI systems in operation)
