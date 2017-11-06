filetype plugin indent on

" Don't use fish in Vim {{{
" ====================================================================
if &shell =~# 'fish$'
  set shell=bash
endif
" }}}

" Make Space the leader
let g:mapleader = "\<Space>"

" Autoinstall vim-plug {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}

call plug#begin('~/.vim/plugged')

" Appearance
"============================================
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" {{{
let g:airline_powerline_fonts = 1
" }}}

" Mark trailing whitespace
Plug 'ntpeters/vim-better-whitespace'

" Automatically detect indentation options
Plug 'tpope/vim-sleuth'

" Syntax Checking
" ===========================================
Plug 'scrooloose/syntastic'
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = ' -std=c11'
let g:syntastic_quiet_messages = { "regex": 'mixed-indent' }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

" Debugging
" ===========================================
Plug 'vim-scripts/Conque-GDB'


" Completion
" ===========================================
Plug 'Chiel92/vim-autoformat'

" Python autocompletion
Plug 'davidhalter/jedi-vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" {{{
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>
" }}}

" Text Manipulation
" ===========================================
Plug 'tpope/vim-surround'
" Commenting
Plug 'tpope/vim-commentary'

" Git
" ====================================================================
Plug 'tpope/vim-fugitive'
" {{{
" Fix broken syntax highlight in gitcommit files
" (https://github.com/tpope/vim-git/issues/12)
let g:fugitive_git_executable = 'LANG=en_US.UTF-8 git'

nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
nnoremap <silent> <leader>gE :Gedit<space>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gR :Gread<space>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gW :Gwrite!<CR>
nnoremap <silent> <leader>gq :Gwq<CR>
nnoremap <silent> <leader>gQ :Gwq!<CR>

function! ReviewLastCommit()
  if exists('b:git_dir')
    Gtabedit HEAD^{}
    nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
  else
    echo 'No git a git repository:' expand('%:p')
  endif
endfunction
nnoremap <silent> <leader>g` :call ReviewLastCommit()<CR>

augroup fugitiveSettings
  autocmd!
  autocmd FileType gitcommit setlocal nolist
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END
" }}}

" Language Specific

" Clojure plugins
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-surround', { 'for': 'clojure' }

" Julia
Plug 'JuliaLang/julia-vim', { 'for': 'julia' }

" Fish shell
Plug 'dag/vim-fish'

call plug#end() " Plugin Installation finished

" General settings {{{
" ====================================================================
syntax on " syntax highlighting
set clipboard=unnamed,unnamedplus
set number         " show line numbers
set lazyredraw     " speed up on large files
set mouse=a        " enable mouse
set showcmd      " always show current command
set laststatus=2

" Indentation {{{ unneeded because of sleuth.vim
" ====================================================================
" set expandtab     " replace <Tab with spaces
" set tabstop=4     " number of spaces that a <Tab> in the file counts for
" set softtabstop=4 " remove <Tab> symbols as it was spaces
" set shiftwidth=4  " indent size for << and >>
" set shiftround    " round indent to multiple of 'shiftwidth' (for << and >>)
" }}}

" Search {{{
" ====================================================================
set ignorecase " ignore case of letters
set smartcase  " override the 'ignorecase' when there is uppercase letters
set gdefault   " when on, the :substitute flag 'g' is default on
" }}}

"" Colors and highlightings {{{
" ====================================================================
colorscheme solarized
set background=light

set cursorline
" highlight current line

" Remap esc to jk {{{
:inoremap jk <esc>
:inoremap <esc> <nop>
" }}}

" Autoformat on save
let g:formatdef_c_formatter = '"astyle --style=allman --indent=tab --align-pointer=name --max-code-length=80"'
set cinoptions=l1
let g:formatters_c = ['c_formatter']

" Quick way to save file
nnoremap <leader>w :w<CR>

" Creating splits with empty buffers in all directions
nnoremap <Leader>hn :leftabove  vnew<CR>
nnoremap <Leader>ln :rightbelow vnew<CR>
nnoremap <Leader>kn :leftabove  new<CR>
nnoremap <Leader>jn :rightbelow new<CR>

" If split in given direction exists - jump, else create new split
function! JumpOrOpenNewSplit(key, cmd, fzf) " {{{
  let current_window = winnr()
  execute 'wincmd' a:key
  if current_window == winnr()
    execute a:cmd
    if a:fzf
      Files
    endif
  else
    if a:fzf
      Files
    endif
  endif
endfunction " }}}
nnoremap <silent> <Leader>hh :call JumpOrOpenNewSplit('h', ':leftabove vsplit', 0)<CR>
nnoremap <silent> <Leader>ll :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 0)<CR>
nnoremap <silent> <Leader>kk :call JumpOrOpenNewSplit('k', ':leftabove split', 0)<CR>
nnoremap <silent> <Leader>jj :call JumpOrOpenNewSplit('j', ':rightbelow split', 0)<CR>

" Cursor configuration {{{
" ====================================================================
" Use a blinking upright bar cursor in Insert mode, a solid block in normal
" and a blinking underline in replace mode
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let &t_SI = "\<Esc>[5 q"
"let &t_SR = "\<Esc>[3 q"
let &t_EI = "\<Esc>[2 q"
" }}}


" Debugging config
" ==========================
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly
" ===========================================
"
" Jedi vim
if has('python3')
  let g:pymode_python = 'python3'
  let g:jedi#force_py_version = 3
endif

