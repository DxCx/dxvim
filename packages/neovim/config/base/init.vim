set nocompatible

" A helper to preserve the cursor location with filters
function! Preserve(command)
  let w = winsaveview()
  execute a:command
  call winrestview(w)
endfunction
