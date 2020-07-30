% \iffalse
%<*hack>
\ifx\undefined\@undefined\relax\else
%<*driver>
\documentclass[ltxdoc]{local}
\GetFileInfo{local.cls}
\title{\cls{\filename}の便覧及び実装}
\author{\(\bar{B}\)}
\date{\filedate\quad（\fileversion{}版）}
% \DeclareTextSymbol{\textquotesingle}{TS1}{'047}
% \DeclareTextSymbolDefault{\textquotesingle}{TS1}
% \makeatletter
% \begingroup
% \catcode`'=\active
% \addto@hook\every@verbatim{%
% \def'{\char13}}
% \endgroup
% \makeatother
\begin{document}
\maketitle
\tableofcontents
\DocInput{\filename}
\end{document}
%</driver>
\fi
%</hack>
% \fi
% \fi
% \part{便覧}
% \cls{\filename}は，俺の為の級譜である。
% 
% \section{要件}
% \begin{description}
% \item[対象機構] \upLaTeXe{}，\TeX~Live 2019以上。
% 
% \item[前提譜類]
% \cls{\filename}が前提とする譜類は次の通り。
% \begin{itemize}
% \item \pkg[http://texdoc.net/texmf-dist/doc/latex/plautopatch/plautopatch-ja.pdf]%
%       {plautopatch}。
% \item \cls[http://texdoc.net/texmf-dist/doc/latex/bxjscls/bxjscls-manual.pdf]%
%       {bxjs*}系の級譜。
% \end{itemize}
% \cls{\filename}と同一台録に位置する\pkg{local}を
% 除いて，全て\TeX~Live 2019の全体導入下であれば確実に利用できる。
% \end{description}
% 
% \clearpage
% \newgeometry{left=10pc}
% \onecolumn
% \StopEventually{}
% \part{実装}
% \section{全体}
% 処理系が(u)\pLaTeXe{}であることを要求。
%    \begin{macrocode}
\NeedsTeXFormat{pLaTeX2e}
\ProvidesClass{local}%
[2020/06/12 0.1.10
User local class file.]
%    \end{macrocode}
% \changes{v0.1.1}{2020/05/26}{\cmd{changes}による変更履歴記録開始。}
% \changes{v0.1.2}{2020/05/26}{情報の表記を少し変更。}
% \changes{v0.1.8}{2020/06/09}{解説文書をより構造的に。}
% 
% \subsection{応付子の設定}
% どういう文書形式か。規定はarticle（記事）。
% \changes{v0.1.6}{2020/06/03}{文書級を応付子で指定できるように。}
%    \begin{macrocode}
\newcommand*{\lcl@@documentclass}{}
\DeclareOption{article}%
{\renewcommand*{\lcl@@documentclass}{article}}
\DeclareOption{report}%
{\renewcommand*{\lcl@@documentclass}{report}}
\DeclareOption{book}%
{\renewcommand*{\lcl@@documentclass}{book}}
\ExecuteOptions{article}
%    \end{macrocode}
% （既定）数式を左揃えに。
% \changes{v0.1.4}{2020/05/27}{\cmd{documentclass}に指定した応付子じゃないと
% 広域応付子として認識されないので，
% \texttt{fleqn}応付子などを級譜応付子として指定するようにする。}
%    \begin{macrocode}
\DeclareOption{fleqn}%
{\g@addto@macro\@classoptionslist{,fleqn}%
\PassOptionsToClass{fleqn}%
{bxjs\lcl@@documentclass}}
\DeclareOption{nofleqn}{}
\ExecuteOptions{fleqn}
%    \end{macrocode}
% 描画機器を指定。
%    \begin{macrocode}
\DeclareOption{dvipdfmx}%
{\g@addto@macro\@classoptionslist{,dvipdfmx}%
\PassOptionsToClass{dvipdfmx}%
{bxjs\lcl@@documentclass}}
\ExecuteOptions{dvipdfmx}
%    \end{macrocode}
% \TikZ{}を使うか否か（既定は偽）。
% \pkg{local}に透過的に渡す。
%    \begin{macrocode}
\DeclareOption{usetikz}%
{\PassOptionsToPackage{usetikz}{local}}
%    \end{macrocode}
% \pkg{makeidx}を使うか否か（既定は偽）。
% \pkg{local}に透過的に渡す。
%    \begin{macrocode}
\DeclareOption{usemidx}%
{\PassOptionsToPackage{usemidx}{local}}
%    \end{macrocode}
% 解説文書態か否か（既定は偽）。
%    \begin{macrocode}
\newif\if@lcl@@ltxdoc@mode@
\@lcl@@ltxdoc@mode@false
\DeclareOption{ltxdoc}%
{\@lcl@@ltxdoc@mode@true}
%    \end{macrocode}
% 非認識応付子処理。
% \changes{v0.1.10}{2020/06/12}{応付子の設定を更に柔軟にして，
% 認識できない応付子を\cls{bxjs*}系列に廻すようにした。}
%    \begin{macrocode}
\DeclareOption*{%
\PassOptionsToClass{\CurrentOption}%
{bx\lcl@@documentclass}}
\ProcessOptions\relax
%    \end{macrocode}
% 段組設定。
% \changes{v0.1.5}{2020/05/29}{段組設定を広域指定するように。
% 今のところ上手くいっていない……。}
%    \begin{macrocode}
\PassOptionsToClass{twocolumn}%
{bxjs\lcl@@documentclass}
%    \end{macrocode}
% その他応付処理。
% \changes{v0.1.9}{2020/06/11}{基本的な応付子を広域応付子に。}
%    \begin{macrocode}
\g@addto@macro\@classoptionslist{,uplatex}%
\PassOptionsToClass{uplatex}%
{bxjs\lcl@@documentclass}
%    \end{macrocode}
%    \begin{macrocode}
\g@addto@macro\@classoptionslist{,a4paper}%
\PassOptionsToClass{a4paper}%
{bxjs\lcl@@documentclass}
%    \end{macrocode}
%    \begin{macrocode}
\g@addto@macro\@classoptionslist{,jis2004}
%    \end{macrocode}
%
% \section{主要}
% \subsection{梱包の読み込み}
% 前提梱包\pkg{plautopatch}を読み込む。
%    \begin{macrocode}
\RequirePackage{plautopatch}
%    \end{macrocode}
% \pkg{otf}を読み込んで，多書体化に備える。
% \changes{v0.1.3}{2020/05/26}{\pkg{otf}梱にぶら下げ組み応付子を追加。}
%    \begin{macrocode}
\RequirePackage[deluxe,burasage]{otf}
%    \end{macrocode}
% \cls{bxjsarticle}を適宜応付子を付けて読み込む。
% ^^A \verb|\lcl@@column|命令は段組設定の如何に依って分岐する。
%    \begin{macrocode}
\LoadClass[
    base=12pt,
    jbase=11pt,
    notitlepage,
    ja=standard,
    jafont=noto(-otc),
    japaram={jis2004=true,units=true},
    magstyle=nomag,
    paragraph-mark=,
    label-section=modern
]{bxjs\lcl@@documentclass}
%    \end{macrocode}
% 余白の設定。
% \cls{bxjsarticle}級の既定より狭くしている。
%    \begin{macrocode}
\setpagelayout+{hmargin=15mm,vmargin=12mm}
%    \end{macrocode}
% 日付表記を和暦に。
% 本当は\cmd{和暦}という命令を宣言しているのだが，
% \pkg{doc}の不具合により違了してしまうので，
% 手引き出力時には無効化している。
% \iffalse
\和暦
% \fi
%
% \pkg{local}を読み込む。
%    \begin{macrocode}
\RequirePackage{local}
%    \end{macrocode}
% 
% （実装終わり）
% 
% \restoregeometry
% \onecolumn
% \begingroup
% \hbadness=10000
% \newcount\hbadness
% \hfuzz=\maxdimen
% \PrintChanges
% \PrintIndex
% \endgroup
% \Finale
% 
% \appendix
% \newcommand*\latexmkrcfile{latexmkrc-tpl}
% \section{\fname{\latexmkrcfile}の解説}
% \begin{minipage}{0.9\linewidth}
% \MacroFont\selectfont
% \verbatiminput{\latexmkrcfile}
% \end{minipage}
\endinput