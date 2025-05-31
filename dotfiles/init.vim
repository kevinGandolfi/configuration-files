let mapleader=","

set nocompatible
filetype plugin on

" ********** Environment variables **********

let g:airline_powerline_fonts = 1
let g:airline_theme = 'deus'
let g:ale_lint_on_text_changed = 'always'
let g:ale_linters = {
\   'javascript': ['eslint'],
\ }
let g:grepper = {}
let g:grepper.tools = ['grep', 'git', 'rg']

" ********** Plugins **********

set packpath^=~/.config/nvim
packadd minpac
call minpac#init()
call minpac#add('dense-analysis/ale')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('kana/vim-textobj-entire')
call minpac#add('kana/vim-textobj-user')
call minpac#add('mhinz/vim-grepper')
call minpac#add('radenling/vim-dispatch-neovim')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-dispatch')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-scriptease', {'type': 'opt'})
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')

" ********** Indentation **********

set tabstop=4          " Tab character is 4 spaces wide
set shiftwidth=4       " Indentation width for << and >>
set smartindent        " Automatically indent new lines
set autoindent         " Copy indent from current line
set wrap               " Enable line wrapping
set linebreak          " Wrap without cutting words
set expandtab          " Convert tabs to spaces

" ********** Essentials **********

syntax on              " Enable syntax highlighting
set number             " Show line numbers
set relativenumber     " Show relative line numbers
set clipboard=unnamedplus  " Link system clipboard to unnamed register
set ruler              " Show cursor position
set cursorline         " Highlight current line
set ignorecase         " Case-insensitive search...
set smartcase          " ...unless uppercase is used
set incsearch          " Show matches as you type
set hlsearch           " Highlight all matches
set wildmenu           " Enhanced command-line completion
set title              " Show filename in window title
set titlestring=%F     " Show full path of the file

" ********** Mappings **********

" Normal mode mappings

nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]W <Plug>(ale_last)
nmap <silent> ]w <Plug>(ale_next)
nmap gs <plug>(GrepperOperator)
nnoremap <Leader>G :Grepper -tool rg<CR>
nnoremap <Leader>g :Grepper -tool git<CR>
"Clears the search highlights
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
" Launches the FZF wrapper
nnoremap <C-p> :<C-u>FZF<CR>
" Use the ALE Lint plugin
nnoremap <Leader>l :<C-u>ALELint<CR>
" Search for current word
nnoremap <Leader>f :<C-u>Grepper -cword -noprompt<CR>

" Terminal mode mappings

tnoremap <Esc> <C-\><C-n>

" Visual mode only mappings

xmap gs <plug>(GrepperOperator)

" ********** Commands **********

command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

" ********** Functions **********

function! SetupCommandAlias(input, output)
  exec 'cabbrev <expr> '.a:input
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:input.'")'
        \ .'? ("'.a:output.'") : ("'.a:input.'"))'
endfunction
call SetupCommandAlias("grep", "GrepperGrep")
