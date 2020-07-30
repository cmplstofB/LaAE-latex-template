require './latexmkrc-tpl';

$makeindex = 'upmendex %O -f -g -s gind.ist -o %D %S';

add_cus_dep('glo', 'gls', 0, 'makechanges');
sub makechanges {
    return Run_subst ("upmendex %O -f -g -s gglo.ist -o %D %S");
}
push @generated_exts, 'glo', 'gls';