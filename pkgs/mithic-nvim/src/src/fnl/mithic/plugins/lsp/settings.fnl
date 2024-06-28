{:lua_ls
   {:settings {:Lua {:workspace
                       {:library (vim.api.nvim_list_runtime_paths)}
                     :diagnostics {:globals [:vim]}}}}
 ; :fennel_language_server
 ;   {:settings {:fennel {:workspace
 ;                          {:library (vim.api.nvim_list_runtime_paths)}
 ;                        :diagnostics {:globals [:vim]}}}}
 :fennel_ls {:settings {:fennel-ls {:extra-globals :vim}}}

 :clangd {}
 :hls {}
 :nil_ls {}
 :rust_analyzer {}
 :zls {}

 :ruff {}
 :basedpyright {}


 :texlab
   {:settings {:texlab {:chktex {:onOpenAndSave true :onEdit true}
                        :latexFormatter :texlab}}}


 :ltex
   {:filetypes [:tex :bib :text :markdown]
    :settings
     {:ltex
       {:latex
         {:environments {:numcases :ignore
                         :subnumcases :ignore}
          :commands
           {"\\noeqref{}" :ignore
            "\\mathtoolsset{}" :ignore
            "\\titleformat{}{}{}{}{}" :ignore
            "\\titleformat{}[]{}{}{}{}" :ignore
            "\\RequirePackage[]{}" :ignore
            "\\ProvidesClass{}[]" :ignore
            "\\NewDocumentCommand{}{}{}" :ignore
            "\\RenewDocumentCommand{}{}{}" :ignore
            "\\ProvideDocumentCommand{}{}{}" :ignore
            "\\DeclareDocumentCommand{}{}{}" :ignore
            "\\NewDocumentEnvironment{}{}{}" :ignore
            "\\RenewDocumentEnvironment{}{}{}" :ignore
            "\\ProvideDocumentEnvironment{}{}{}" :ignore
            "\\DeclareDocumentEnvironment{}{}{}" :ignore
            "\\NewExpandableDocumentCommand{}{}{}" :ignore
            "\\RenewExpandableDocumentCommand{}{}{}" :ignore
            "\\ProvideExpandableDocumentCommand{}{}{}" :ignore
            "\\DeclareExpandableDocumentCommand{}{}{}" :ignore
            "\\IfNoValueT{}{}" :ignore
            "\\IfNoValueF{}{}" :ignore
            "\\IfNoValueTF{}{}{}" :ignore
            "\\IfValueT{}{}" :ignore
            "\\IfValueF{}{}" :ignore
            "\\IfValueTF{}{}{}" :ignore
            "\\IfBooleanT{}{}" :ignore
            "\\IfBooleanF{}{}" :ignore
            "\\IfBooleanTF{}{}{}" :ignore
            "\\texorpdfstring{}{}" :dummy
            "\\foreign{}" :dummy
            "\\etc" :dummy
            "\\ie" :dummy
            "\\eg" :dummy
            "\\nb" :dummy
            "\\cf" :dummy
            "\\afsoc" :dummy
            "\\afsoc*" :dummy}}
        :ltex-ls {:logLevel :config}
        :completionEnabled true
        :checkFrequency :edit}}}}
