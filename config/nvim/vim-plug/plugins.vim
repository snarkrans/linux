" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    "Plug 'jiangmiao/auto-pairs'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    " Plug 'rking/ag.vim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'tomasiser/vim-code-dark'
    Plug 'xiyaowong/transparent.nvim'

    " требует пакет xkb-switch
    Plug 'lyokha/vim-xkbswitch'
    let g:XkbSwitchLib = '/lib/libxkbswitch.so'
    let g:XkbSwitchEnabled = 1
    let g:XkbSwitchIMappings = ['ru']
 
    Plug 'MeanderingProgrammer/render-markdown.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter'

    " themes
    Plug 'ellisonleao/gruvbox.nvim'
    Plug 'catppuccin/nvim'
    Plug 'Mofiqul/dracula.nvim'
    
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'preservim/tagbar'

    Plug 'godlygeek/tabular'
    Plug 'preservim/vim-markdown'

    call plug#end()
