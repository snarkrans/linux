source $HOME/.config/nvim/vim-plug/plugins.vim

colorscheme codedark

syntax on
set number
set clipboard=unnamedplus
set linebreak
set ignorecase
set ttyfast                 " Speed up scrolling in Vim
set nohlsearch
set scrolloff=7
set tabstop=4
lua vim.o.ch = 0
let g:ackprg = 'ag --nogroup --nocolor --column'

set termguicolors
let g:codedark_italics = 1

map <F10> :colorscheme
map <F1> :FZF
map <F2> :Rg 
map <F3> :BLines #
map <F4> :Ag
map <F5> :'<,'>write! >> ~/kindle/vim.txt
map <F6> :'<,'>write! >> ~/data/share_mimax/sn/
map <F7> :Telescope
map <F8> :set ft=bash
"map <F9> :! ~/flibusta/unzip 
map <F9> :setlocal tabstop=4
"map < > :Telescope live_grep
"map < > :NERDTreeToggle<CR>
"map j gj
"map k gk

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
