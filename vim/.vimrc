set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'

call vundle#end()
filetype plugin indent on

let g:airline_theme='bubblegum'
let g:airline_powerline_fonts = 1

set tabstop=4
set shiftwidth=4
set expandtab
syntax on
