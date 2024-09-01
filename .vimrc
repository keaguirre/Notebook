"Plugins here
call plug#begin()
  
  Plug 'tpope/vim-sensible'
  Plug 'itchyny/lightline.vim'
  Plug 'preservim/nerdtree'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'dense-analysis/ale'
  Plug 'airblade/vim-gitgutter'
  Plug 'terryma/vim-smooth-scroll'
  Plug 'ap/vim-css-color'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'rstacruz/vim-closer'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'joshdick/onedark.vim'
  Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

"Settings & configs here
syntax on
set number
set mouse=a
set hlsearch
set autoindent
set smartindent
set termguicolors
colorscheme onedark
set laststatus=2
set noshowmode
nnoremap <C-b> :NERDTreeToggle<CR>
let g:lightline = { 'colorscheme': 'one' }
let g:gitgutter_enabled = 1
let g:indent_guides_enable_on_vim_startup = 1
