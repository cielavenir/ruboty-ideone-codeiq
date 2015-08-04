#coding:utf-8
require 'open-uri'
require 'rubygems'
require 'cgi'

#クラス変数を使いたいので、Actionを切り出すことは不可能
module Ruboty
	module Handlers
		class Ideone_codeiq < Base
			#基本的にruboty-ideoneの古いバージョンから拾ってくれば大丈夫。念のためソース開いて照合を。
			LANGUAGES=[
	{:key=>"7", :value=>"Ada (gnat-4.9.2)"},
	{:key=>"45", :value=>"Assembler (gcc-4.9.2)"},
	{:key=>"13", :value=>"Assembler (nasm-2.11.05)"},
	{:key=>"104", :value=>"AWK (gawk) (gawk-4.1.1)"},
	{:key=>"105", :value=>"AWK (mawk) (mawk-3.3)"},
	{:key=>"28", :value=>"Bash (bash 4.3.30)"},
	{:key=>"110", :value=>"bc (bc-1.06.95)"},
	{:key=>"12", :value=>"Brainf**k (bff-1.0.5)"},
	{:key=>"11", :value=>"C (gcc-4.9.2)"},
	{:key=>"27", :value=>"C# (mono-3.10)"},
	{:key=>"41", :value=>"C++ 4.3.2 (gcc-4.3.2)"},
	{:key=>"1", :value=>"C++ 4.9.2 (gcc-4.9.2)"},
	{:key=>"44", :value=>"C++14 (gcc-4.9.2)"},
	{:key=>"34", :value=>"C99 strict (gcc-4.9.2)"},
	{:key=>"14", :value=>"CLIPS (clips 6.24)"},
	{:key=>"111", :value=>"Clojure (clojure 1.7)"},
	{:key=>"118", :value=>"COBOL (open-cobol-1.1)"},
	{:key=>"106", :value=>"COBOL 85 (tinycobol-0.65.9)"},
	{:key=>"32", :value=>"Common Lisp (clisp) (clisp 2.49)"},
	{:key=>"20", :value=>"D (gdc 4.9.2)"},
	{:key=>"102", :value=>"D (dmd) (dmd-2.042)"},
	{:key=>"36", :value=>"Erlang (erl-5.7.3)"},
	{:key=>"124", :value=>"F# (fsharp-3.10)"},
	{:key=>"123", :value=>"Factor (factor-0.93)"},
	{:key=>"125", :value=>"Falcon (falcon-0.9.6.6)"},
	{:key=>"107", :value=>"Forth (gforth-0.7.2)"},
	{:key=>"5", :value=>"Fortran (gfortran-4.9.2)"},
	{:key=>"114", :value=>"Go (1.4)"},
	{:key=>"121", :value=>"Groovy (groovy-2.4)"},
	{:key=>"21", :value=>"Haskell (ghc-7.6)"},
	{:key=>"16", :value=>"Icon (iconc 9.4.3)"},
	{:key=>"9", :value=>"Intercal (c-intercal 28.0-r1)"},
	{:key=>"10", :value=>"Java (sun-jdk-8u25)"},
	{:key=>"55", :value=>"Java7 (sun-jdk-1.7.0_10)"},
	{:key=>"35", :value=>"JavaScript (rhino) (rhino-1.7R4)"},
	{:key=>"112", :value=>"JavaScript (spidermonkey) (spidermonkey 24.2)"},
	{:key=>"26", :value=>"Lua (luac 5.2)"},
	{:key=>"30", :value=>"Nemerle (ncc 0.9.3)"},
	{:key=>"25", :value=>"Nice (nicec 0.9.6)"},
	{:key=>"122", :value=>"Nimrod (nimrod-0.8.8)"},
	{:key=>"56", :value=>"Node.js (0.10.35)"},
	{:key=>"43", :value=>"Objective-C (gcc-4.5.1)"},
	{:key=>"8", :value=>"Ocaml (ocamlopt 4.01.0)"},
	{:key=>"127", :value=>"Octave (3.6.2)"},
	{:key=>"119", :value=>"Oz (mozart-1.4.0)"},
	{:key=>"57", :value=>"PARI/GP (2.5.1)"},
	{:key=>"22", :value=>"Pascal (fpc) (fpc 2.6.4)"},
	{:key=>"2", :value=>"Pascal (gpc) (gpc 20070904)"},
	{:key=>"3", :value=>"Perl (perl 5.20.1)"},
	{:key=>"54", :value=>"Perl 6 (rakudo-2014.07)"},
	{:key=>"29", :value=>"PHP (php 5.6.4)"},
	{:key=>"19", :value=>"Pike (pike 7.8)"},
	{:key=>"108", :value=>"Prolog (gnu) (gprolog-1.3.1)"},
	{:key=>"15", :value=>"Prolog (swi) (swipl 5.6.64)"},
	{:key=>"4", :value=>"Python (python 2.7.9)"},
	{:key=>"99", :value=>"Python (Pypy) (Pypy)"},
	{:key=>"116", :value=>"Python 3 (python-3.4)"},
	{:key=>"117", :value=>"R (R-2.11.1)"},
	{:key=>"17", :value=>"Ruby (ruby-1.9.3)"},
	{:key=>"39", :value=>"Scala (scala-2.11.4)"},
	{:key=>"128", :value=>"Scheme (chicken) (4.9)"},
	{:key=>"33", :value=>"Scheme (guile) (guile 2.0.11)"},
	{:key=>"23", :value=>"Smalltalk (gst 3.2.4)"},
	{:key=>"40", :value=>"SQL (sqlite3-3.8.7)"},
	{:key=>"38", :value=>"Tcl (tclsh 8.6)"},
	{:key=>"62", :value=>"Text (text 6.10)"},
	{:key=>"115", :value=>"Unlambda (unlambda-2.0.0)"},
	{:key=>"101", :value=>"VB.NET (mono-3.10)"},
	{:key=>"6", :value=>"Whitespace (wspace 0.3)"},
			]

			def initialize(*__reserved__)
				super
				@input=nil
				@languages=LANGUAGES
			end
			def read_uri(uri)
				return nil if !uri||uri.empty?
				Kernel.open(uri){|f|
					return f.read
				}
			end

			on /ideone-codeiq languages/, name: 'languages', description: 'show languages'
			on /ideone-codeiq setinput ?(?<input_uri>\S*)/, name: 'setinput', description: 'set input'
			on /ideone-codeiq submit (?<language>\S+) (?<source_uri>\S+) ?(?<input_uri>\S*)/, name: 'submit', description: 'send code via uri'
			def languages(message)
				message.reply @languages.map{|e|"#{'%4d:'%e[:key]} #{e[:value]}\n"}.join
			end
			def setinput(message)
				#input_uri: 入力ファイル(空文字列ならクリア)
				if !message[:input_uri]||message[:input_uri].empty?
					@input=nil
					message.reply 'Input cleared.'
				else
					@input=read_uri(message[:input_uri])
					message.reply 'Input set.'
				end
			end
			def submit(message)
				#language: ID(数値)または言語名(文字列)。言語名の場合、記号類を除いて最大先頭一致のものを使用する。
				#source_uri: ソースファイル
				#input_uri: 入力ファイル(空文字列ならsetinputの内容を使用)
				input=message[:input_uri]&&!message[:input_uri].empty? ? read_uri(message[:input_uri]) : @input
				#guess lang
				lang=message[:language]
				if lang.to_i>0
					lang=lang.to_i
				else
					lang=lang.downcase.gsub(/[\s\(\)\.]/,'')
					lang=@languages.max_by{|e|
						_e=e[:value].downcase.gsub(/[\s\(\)\.]/,'')
						lang.size.downto(1).find{|i|_e.start_with?(lang[0,i])}||-1
					}[:key].to_i
				end
				uri=URI.parse('https://codeiq.jp/tools/connect.php')
				https=Net::HTTP.new(uri.host,uri.port)
				https.use_ssl=true
				https.start{
					resp=http.post(uri.path,'lang='+lang.to_s+'&source='+CGI.escape(read_uri(message[:source_uri]))+'&input='+CGI.escape(input),{
						'Content-Type'=>'application/x-www-form-urlencoded; charset=UTF-8',
					})
					json=JSON.parse(resp.body)
					if json['error']!='OK'
						message.reply '[Ruboty::Ideone::CodeIQ] '+json['error']
					else
						message.reply json['output']
					end
				}
			end
		end
	end
end
