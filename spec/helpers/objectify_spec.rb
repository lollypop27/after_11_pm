require './helpers/objectify_utilities'

describe ObjectifyUtilities do
  let(:dummy_class){(Class.new{include ObjectifyUtilities}).new}


  xdescribe '#objectify' do

    it '2\times3' do
      expect(dummy_class.objectify('2\times3')).to eq mtp(2,3)
    end

    it '2\times123' do
      expect(dummy_class.objectify('2\times123')).to eq mtp(2,123)
    end

    it '2\timesx' do
      expect(dummy_class.objectify('2\timesx')).to eq mtp(2,'x')
    end

    it '2\times(-23)' do
      expect(dummy_class.objectify('2\times(-23)')).to eq mtp(2,-23)
    end

    it '-2+-3' do
      expect(dummy_class.objectify('-2+-3')).to eq add(-2,-3)
    end

    it '-2x+-3' do
      expect(dummy_class.objectify('-2x+-3')).to eq add(mtp(-2,'x'),-3)
    end

    it '-2x--3' do
      expect(dummy_class.objectify('-2x--3')).to eq sbt(mtp(-2,'x'),-3)
    end

    it 'a-b' do
      expect(dummy_class.objectify('a-b')).to eq sbt('a','b')
    end

    it '-2+a' do
      expect(dummy_class.objectify('-2+a')).to eq add(-2,'a')
    end

    it 'a+b-c' do
      expect(dummy_class.objectify('a+b-c')).to eq sbt(add('a','b'),'c')
    end

    it 'a+b-c-d' do
      expect(dummy_class.objectify('a+b-c-d')).to eq sbt(sbt(add('a','b'),'c'),'d')
    end

    it 'a-b+c+d' do
      expect(dummy_class.objectify('a-b+c+d')).to eq add(sbt('a','b'),'c','d')
    end

    it 'c+d-e+f+g' do
      expect(dummy_class.objectify'c+d-e+f+g').to eq add(sbt(add('c','d'),'e'),'f','g')
    end

    it 'z+a+b-c+d-e+f+g' do
      expect(dummy_class.objectify'z+a+b-c+d-e+f+g').to eq add(sbt(add(sbt(add('z','a','b'),'c'),'d'),'e'),'f','g')
    end

    it 'x+-12' do
      expect(dummy_class.objectify('x+(-12)')).to eq add('x',-12)
    end

    it 'x+y+2' do
      expect(dummy_class.objectify('x+y+2')).to eq add('x','y',2)
    end

    it 'x+(y+2)' do
      expect(dummy_class.objectify('x+(y+2)')).to eq add('x',add('y',2))
    end

    it '-12x' do
      expect(dummy_class.objectify('-12x')).to eq mtp(-12,'x')
    end

    it '(-12)^{-31x}' do
      expect(dummy_class.objectify('(-12)^{-31x}')).to eq pow(-12,mtp(-31,'x'))
    end

    it '3xyz' do
      expect(dummy_class.objectify('3xyz')).to eq mtp(3,'x','y','z')
    end

    it '-3x+-5' do
      expect(dummy_class.objectify('(-3)x+(-5)')).to eq add(mtp(-3,'x'),-5)
    end

    it '25+(-13)x' do
      expect(dummy_class.objectify('25+(-13)x')).to eq add(25,mtp(-13,'x'))
    end

    it '\frac{-14x}{25}' do
      expect(dummy_class.objectify('\frac{-14x}{25}')).to eq div(mtp(-14,'x'),25)
    end

    it '3(x+7)+4' do
      expect(dummy_class.objectify('3(x+7)+4')).to eq add(mtp(3,add('x',7)),4)
    end

    it '-13(x+7)(y+(5+(2a+9)))' do
      expect(dummy_class.objectify('-13(x+7)(y+5(-12a+9))')).to eq mtp(-13,add('x',7),add('y',mtp(5,add(mtp(-12,'a'),9))))
    end

    it '-13(x+7)(y+2)+4' do
      expect(dummy_class.objectify('13(x+7)+4')).to eq add(mtp(13,add('x',7)),4)
    end

    it '-13(x+7)+4' do
      expect(dummy_class.objectify('-13(x+7)+4')).to eq add(mtp(-13,add('x',7)),4)
    end

    it '-13(x+7)-4' do
      expect(dummy_class.objectify('-13(x+7)-4')).to eq sbt(mtp(-13,add('x',7)),4)
    end
    it '\frac{3}{x}' do
      expect(dummy_class.objectify('\frac{3}{x}')).to eq div(3,'x')
    end

    it '\frac{3x+5}{4+5+a}' do
      expect(dummy_class.objectify('\frac{3x+5}{4+5+a}')).to eq div(add(mtp(3,'x'),5),add(4,5,'a'))
    end

    it '3(x+\frac{3x+5}{4+5+a})+4' do
      expect(dummy_class.objectify('3(x+\frac{3x+5}{4+5+a})+4')).to eq add(mtp(3,add('x',div(add(mtp(3,'x'),5),add(4,5,'a')))),4)
    end

    it '\frac{3x+5}{4+5+a}' do
      expect(dummy_class.objectify('\frac{3x+3xyz}{4+5+a}')).to eq div(add(mtp(3,'x'),mtp(3,'x','y','z')),add(4,5,'a'))
    end

    it '3(x+\frac{3\frac{3}{x}+5}{4+5+a})+4' do
      expect(dummy_class.objectify('3(x+\frac{3\frac{3}{x}+5}{4+5+a})+4')).to eq add(mtp(3,add('x',div(add(mtp(3,div(3,'x')),5),add(4,5,'a')))),4)
      # puts dummy_class.objectify('3(x+\frac{3\frac{3}{x}+5}{4+5+a})+4').latex
    end

    it 'x^{ 3y}' do
      expect(dummy_class.objectify('x^{ 3y}')).to eq pow('x',mtp(3,'y'))
    end

    it '(2x)^3' do
      expect(dummy_class.objectify('(2x)^3)')).to eq pow(mtp(2,'x'),3)
    end

    it '(2x)^13' do
      expect(dummy_class.objectify('(2x)^13)')).to eq mtp(pow(mtp(2,'x'),1),3)
    end

    it '(2xy)^{3x +4}' do
      expect(dummy_class.objectify('(2x  y)^{3 x+ 4}')).to eq pow(mtp(2,'x','y'),add(mtp(3,'x'),4))
    end

    it '(2^{3xy})^{5x+4}' do
      expect(dummy_class.objectify('(2^{3xy})^{5x+4}')).to eq pow(pow(2,mtp(3,'x','y')),add(mtp(5,'x'),4))
    end

    it '2^{3xy}' do
      expect(dummy_class.objectify('2^{3xy}')).to eq pow(2,mtp(3,'x','y'))
    end

    it 'x^{1+1}' do
      expect(dummy_class.objectify('x^{1+1}')).to eq pow('x',add(1,1))
    end

    it '\frac{c}{d}(2x+4^x)' do
      expect(dummy_class.objectify('\frac{c}{d}(2x+4^x)')).to eq mtp(div('c','d'),add(mtp(2,'x'),pow(4,'x')))
    end

    it '\frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}}' do
      exp = dummy_class.objectify('\frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}}')
      expect(exp).to eq add(div('a','b'),pow(mtp(div('c','d'),add(mtp(2,'x'),pow(4,'x'))),div(5,'y')))
    end
  end


  describe 'objectify and olatex back' do
    it 'objectify and olatex back 2^{3xy}' do
      expect(dummy_class.objectify('2^{3xy}').latex.shorten).to eq '2^{3xy}'
    end
  end

  describe '#correct_latex?' do
    it 'is \frac{c}{d}(2x+4^x) correct_latex?' do
      expect('\frac{c}{d}(2x+4^x)'.correct_latex?).to be true
    end

    it 'is \frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}} correct_latex?' do
      expect('\frac{a}{b}+(\frac{c}{d}(2x+4^x))^{\frac{5}{y}}'.correct_latex?).to be true
    end
  end


  describe '#matching_brackets' do
    it 'matches outer brackets in \frac{frac{2}{y}}{x}' do
      expect(dummy_class.matching_brackets('\frac{frac{2}{y}}{x}','{','}')).to eq [5,16]
    end

    it 'matches 3rd brackets in (a+c(234)de((abc))))' do
      expect(dummy_class.matching_brackets('(a+c(234)de((abc))))','(',')', 3)).to eq [11,17]
    end

    it 'matches 2nd brackets in a+c(234)de((abc)))' do
      expect(dummy_class.matching_brackets('a+c(234)de((abc))','(',')', 2)).to eq [10,16]
    end

    it 'matches ($$$)^($$) 2nd brackets' do
      expect(dummy_class.matching_brackets('($$$)^($$)($$$)^4','(',')', 2)).to eq [6,9]
    end
  end

  describe '#empty_brackets' do
    it 'replace bracket (a+c{234}de((abc))) content with $ to ($$$$$$$$$$$$$$$$$)' do
      expect(dummy_class.empty_brackets(string: '(a+c(234)de((abc)))')).to eq '($$$$$$$$$$$$$$$$$)'
    end

    it 'replace bracket a+c{234}de[{abc}] content with $ to a+c{$$$}de[$$$$$]' do
      expect(dummy_class.empty_brackets(string: 'a+c{234}de[{abc}]')).to eq 'a+c{$$$}de[$$$$$]'
    end

    it 'replace bracket \frac((3(x))^(()4y))(x^2)(234)de((abc)) content with $ to \frac($$$$$$$$$$$$$)($$$)($$$)de($$$$$)' do
      expect(dummy_class.empty_brackets(string: '\frac{(3(x))^(()4y)}{x^2}(234)de((abc))')).to eq '\frac{$$$$$$$$$$$$$}{$$$}($$$)de($$$$$)'
    end
  end

  describe '#split_mtp_args' do
    it '' do
      str = '2\times3'
      expect(dummy_class.split_mtp_args(string:str)).to eq ["2","3"]
    end

    it '' do
      str = "x^{$$}"
      expect(dummy_class.split_mtp_args(string:str)).to eq ["x^{$$}"]
    end

    it '' do
      str = "-12x"
      expect(dummy_class.split_mtp_args(string:str)).to eq ["-12",'x']
    end

    it 'extract args from ($$) return ["$$"]' do
      expect(dummy_class.split_mtp_args(string: '($$)')).to eq ["($$)"]
    end

    it '' do
      str = '2x\frac{$$$}{$}($$$$)($$$)^{$$}'
      expect(dummy_class.split_mtp_args(string:str)).to eq [
        "2", "x", "\\frac{$$$}{$}", "($$$$)", "($$$)^{$$}"
      ]
    end

    it '' do
      str = '($$$$)($$$)^{$$}($$$)^4'
      expect(dummy_class.split_mtp_args(string:str)).to eq [
        "($$$$)", "($$$)^{$$}", "($$$)^4"
      ]
    end

    it '' do
      str = '($$$$)($$$)^{$$}4^{$$$}5'
      expect(dummy_class.split_mtp_args(string:str)).to eq [
        "($$$$)", "($$$)^{$$}", "4^{$$$}",'5'
      ]
    end

    it '' do
      str = '($$$)^{$$}4^{$$$}5'
      expect(dummy_class.split_mtp_args(string:str)).to eq [
        '($$$)^{$$}',"4^{$$$}",'5'
      ]
    end

    it '' do
      str = '($$$$)($$$)^{$$}4x'
      expect(dummy_class.split_mtp_args(string:str)).to eq [
        "($$$$)", "($$$)^{$$}", "4",'x'
      ]
    end

    it '' do
      str = "($$$)^{$$$$}"
      expect(dummy_class.split_mtp_args(string:str)).to eq ["($$$)^{$$$$}"]
    end

    it '' do
      str = "3^4x"
      expect(dummy_class.split_mtp_args(string:str)).to eq ["3^4",'x']
    end

    it '' do
      str = "12^{$$$}"
      expect(dummy_class.split_mtp_args(string:str)).to eq ["12^{$$$}"]
    end

    it '' do
      str = "($$$$$)^{$$$}"
      expect(dummy_class.split_mtp_args(string:str)).to eq ["($$$$$)^{$$$}"]
    end

    it '' do
      str = "xy"
      expect(dummy_class.split_mtp_args(string:str)).to eq ['x','y']
    end

    it '' do
      str = "x12^{$$$}"
      expect(dummy_class.split_mtp_args(string:str)).to eq ['x','12^{$$$}']
    end

    it '' do
      str = '\frac{$$$}{$$$$$}xy'
      expect(dummy_class.split_mtp_args(string:str)).to eq ['\frac{$$$}{$$$$$}','x','y']
    end

    it '' do
      str = "123x"
      expect(dummy_class.split_mtp_args(string:str)).to eq ['123','x']
    end
  end

  # describe '#reenter_str_content' do
  #   it '' do
  #     string = 'x(2-a)y3(5z)^4'
  #     dollar_array = ["x","($$$)",'y','3',"($$)^4"]
  #     dummy_class.reenter_str_content(string:string,dollar_array:dollar_array)
  #     expect(dollar_array).to eq ["x","(2-a)",'y','3',"(5z)^4"]
  #   end
  # end
  #
  # describe '#reenter_addition_str_content' do
  #   it '' do
  #     string = 'x+(2-a)+y+3+(5z)^4'
  #     dollar_array = ["x","($$$)",'y','3',"($$)^4"]
  #     dummy_class.reenter_addition_str_content(string:string,dollar_array:dollar_array)
  #     expect(dollar_array).to eq ["x","(2-a)",'y','3',"(5z)^4"]
  #   end
  # end
  #
  # describe '#remove_enclosing_bracks' do
  #   it '' do
  #     string_array = ["x","(2-a)",'y','3',"(5z)^4"]
  #     dummy_class.remove_enclosing_bracks(string_array:string_array)
  #     expect(string_array).to eq ["x","2-a",'y','3',"(5z)^4"]
  #   end
  # end
  #
  # describe '#_next_num_index' do
  #   it 'returns 2 for 123abc' do
  #     expect(dummy_class._next_num_index('123abc')).to eq 2
  #   end
  #
  #   it 'returns nil for 123^abc' do
  #     expect(dummy_class._next_num_index('123^abc')).to eq nil
  #   end
  #
  #   it 'returns nil for 123456' do
  #     expect(dummy_class._next_num_index('123456')).to eq 5
  #   end
  #
  #   it 'returns nil for ($$$$)123456' do
  #     expect(dummy_class._next_num_index('($$$$)123456')).to eq nil
  #   end
  # end
end
