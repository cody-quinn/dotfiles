set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'morhetz/gruvbox'
Plugin 'itchyny/lightline.vim'
Plugin 'andis-sprinkis/lightline-gruvbox-dark.vim'

call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Gruvbox Configuration
let g:gruvbox_transparent_bg = '1'
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_number_column = 'bg1'
set background=dark

autocmd vimenter * ++nested colorscheme gruvbox

" Status Bar Configuration (lightline)
let g:lightline = {}
let g:lightline.colorscheme = 'gruvboxdark'

" General Vim Configuration
syntax on
set laststatus=2 
set number
set noshowmode

