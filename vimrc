" ==============================================================================
"  LEADER & CORE CONFIG {{{
" ==============================================================================
let mapleader = " "

" Auto-enable marker folding whenever editing Vim config files
augroup vimrc_folding
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker foldlevel=0
augroup END

" Ensure modelines are allowed
set modeline
set modelines=5
" }}}

" ==============================================================================
"  PLUGINS (vim-plug) {{{
" ==============================================================================
call plug#begin('~/.vim/plugged')

" Appearance
Plug 'ghifarit53/tokyonight-vim'

" LSP & Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Editing & Utilities
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'

" Fuzzy Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()
" }}}

" ==============================================================================
"  UI & APPEARANCE {{{
" ==============================================================================
syntax on
filetype plugin indent on

set number
set cursorline
set scrolloff=5
set signcolumn=yes

" True color & Theme
if has('termguicolors')
    set termguicolors
endif
let g:tokyonight_style = 'night'
colorscheme tokyonight

" Cursor shapes (Pipe in Insert, Block in Normal)
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>[6 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
else
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
endif
" }}}

" ==============================================================================
"  BEHAVIOR, INDENTATION & COMPLETION {{{
" ==============================================================================
" Ensure swap folder exists & set directory
silent! call mkdir(expand('$HOME/.vim/swap'), 'p')
set directory^=$HOME/.vim/swap//

" Buffer switching & performance
set hidden
set updatetime=300

" Native popup menu for command-line completion (replaces Wilder cleanly)
set wildmenu
set wildmode=longest:full,full
if has('patch-8.2.0000') || has('nvim')
    set wildoptions=pum
endif

" Tabs & Indentation (4 spaces)
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Searching
set incsearch
set hlsearch

" System Clipboard
set clipboard=unnamedplus
" }}}

" ==============================================================================
"  PLUGIN: COC.NVIM (LSP & Autocomplete) {{{
" ==============================================================================
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-pyright',
  \ 'coc-tsserver',
  \ 'coc-java',
  \ 'coc-clangd'
  \ ]

" --- Autocomplete Confirmations ---
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" --- LSP Keymaps ---
nmap <silent> gd    <Plug>(coc-definition)
nmap <silent> gy    <Plug>(coc-type-definition)
nmap <silent> gi    <Plug>(coc-implementation)
nmap <silent> gr    <Plug>(coc-references)
nmap <silent> [g    <Plug>(coc-diagnostic-prev)
nmap <silent> ]g    <Plug>(coc-diagnostic-next)
nmap <leader>rn     <Plug>(coc-rename)
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" }}}

" ==============================================================================
"  CUSTOM KEYMAPPINGS {{{
" ==============================================================================
" --- Mode Escaping & Quick Actions ---
inoremap jj <Esc>
nnoremap <leader>s :w<CR>
nnoremap <leader>q :bd<CR>
nnoremap <leader>o :Explore<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>w :!git add %<CR>

" --- Fuzzy Search (fzf.vim) ---
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" --- Commenting (vim-commentary) ---
nmap <C-f> <Plug>CommentaryLine
vmap <C-f> <Plug>Commentary

" --- Folding Shortcuts ---
nnoremap <leader>zo zR
nnoremap <leader>zc zM

" --- Window Navigation (Ctrl + h/j/k/l) ---
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Undo / Redo Rebinds ---
nnoremap U u
nnoremap R <C-r>

" --- Select / Copy / Paste (Normal) ---
nnoremap <C-a> ggVG
nnoremap <leader>a ggyG

" --- Visual Mode Editing & Clipboard ---
vnoremap <Backspace> "_d
vnoremap <C-v> "_d"+P
vnoremap <C-x> "+y<Esc>gv"_d
" }}}

" ==============================================================================
"  FILETYPE SPECIFIC AUTOCOMMANDS {{{
" ==============================================================================
" Java: Compile and Run
autocmd FileType java nnoremap <buffer> <leader>r :w<CR>:!javac % && java %:r<CR>
" }}}

" vim: set foldmethod=marker foldlevel=0:
