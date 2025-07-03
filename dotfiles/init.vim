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

packadd minpac
set packpath^=~/.config/nvim
call minpac#init()
call minpac#add('dense-analysis/ale')
call minpac#add('editorconfig/editorconfig-vim')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('kana/vim-smartword')
call minpac#add('kana/vim-textobj-entire')
call minpac#add('kana/vim-textobj-user')
call minpac#add('mfussenegger/nvim-jdtls')
call minpac#add('mhinz/vim-grepper')
call minpac#add('neovim/nvim-lspconfig')
call minpac#add('nvim-treesitter/nvim-treesitter')
call minpac#add('psliwka/vim-smoothie')
call minpac#add('radenling/vim-dispatch-neovim')
call minpac#add('rose-pine/neovim')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-dispatch')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-obsession')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-scriptease', {'type': 'opt'})
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')
call minpac#add('williamboman/mason.nvim')
call minpac#add('williamboman/mason-lspconfig.nvim')

" ********** Indentation **********

set tabstop=4             " Tab character is 4 spaces wide
set shiftwidth=4          " Indentation width for << and >>
set smartindent           " Automatically indent new lines
set autoindent            " Copy indent from current line
set wrap                  " Enable line wrapping
set linebreak             " Wrap without cutting words
set expandtab             " Convert tabs to spaces

" ********** Essentials **********

syntax on                 " Enable syntax highlighting
set number                " Show line numbers
set relativenumber        " Show relative line numbers
set clipboard=unnamedplus " Link system clipboard to unnamed register
set ruler                 " Show cursor position
set cursorline            " Highlight current line
set ignorecase            " Case-insensitive search...
set smartcase             " ...unless uppercase is used
set incsearch             " Show matches as you type
set hlsearch              " Highlight all matches
set wildmenu              " Enhanced command-line completion
set title                 " Show filename in window title
set titlestring=%F        " Show full path of the file
set undofile              " Enables undo history recording
set undodir=$VIMDATA/undo " Sets the directory where the undo history will be saved

" ********** Mappings **********

" Multi mode mappings

map j gj
map k gk

" Normal mode mappings

nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]W <Plug>(ale_last)
nmap <silent> ]w <Plug>(ale_next)
nmap gs <plug>(GrepperOperator)
nmap w <Plug>(smartword-w)
nmap b <Plug>(smartword-b)
nmap e <Plug>(smartword-e)
nmap ge <Plug>(smartword-ge)
nnoremap <Leader>G :Grepper -tool rg<CR>
nnoremap <Leader>g :Grepper -tool git<CR>
nnoremap <M-h> <c-w>h
nnoremap <M-j> <c-w>j
nnoremap <M-k> <c-w>k
nnoremap <M-l> <c-w>l
nnoremap <M-w> <c-w>w
"Clears the search highlights
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap <C-p> :<C-u>FZF<CR>
nnoremap <Leader>l :<C-u>ALELint<CR>
" Search for current word
nnoremap <Leader>f :<C-u>Grepper -cword -noprompt<CR>
nnoremap <Up> <Plug>(SmoothieUpwards)
nnoremap <Down> <Plug>(SmoothieDownwards)

" Terminal mode mappings

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-v><Esc> <Esc>
    tnoremap <M-h> <C-\><C-n><C-w>h
    tnoremap <M-j> <C-\><C-n><C-w>j
    tnoremap <M-k> <C-\><C-n><C-w>k
    tnoremap <M-l> <C-\><C-n><C-w>l
    tnoremap <M-w> <C-\><C-n><C-w>w
endif

" Visual mode only mappings

xmap gs <plug>(GrepperOperator)
xnoremap <M-h> <C-w>h
xnoremap <M-j> <C-w>j
xnoremap <M-k> <C-w>k
xnoremap <M-l> <C-w>l
xnoremap <M-w> <C-w>w

" ********** Commands **********

command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

augroup jdtls_lsp
  autocmd!
  autocmd FileType java lua require('java_lsp')
augroup END

" ********** Functions **********

function! SetupCommandAlias(input, output)
    exec 'cabbrev <expr> '.a:input
                \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:input.'")'
                \ .'? ("'.a:output.'") : ("'.a:input.'"))'
endfunction
call SetupCommandAlias("grep", "GrepperGrep")

lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"java", "lua", "json"},
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    }
}
require("mason").setup()
require("mason-lspconfig").setup()
vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, { noremap = true, silent = true })
EOF

set background=light
colorscheme rose-pine
