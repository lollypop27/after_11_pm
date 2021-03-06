describe Equation do
  describe '#initialize' do
    it 'initialise with a left hand side and a right hand side' do
      eqn = eqn('x',3)
      expect(eqn.ls).to eq 'x'
      expect(eqn.rs).to eq 3
    end
  end

  describe '#solve_one_var_eqn' do
    context '#one-step' do
      it 'reverses one step right addition' do
        eqn = eqn(add(3,'x'),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(3,'x'),5),
          eqn('x',sbt(5,3)),
          eqn('x',2)
        ]
      end

      it 'reverses one step left addition' do
        eqn = eqn(add('x',3),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add('x',3),5),
          eqn('x',sbt(5,3)),
          eqn('x',2)
        ]
      end

      it 'reverses one step right multiplication' do
        eqn = eqn(mtp('x',3),15)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(mtp('x',3),15),
          eqn('x',div(15,3)),
          eqn('x',5)
        ]
      end

      it 'reverses one step left multiplication' do
        eqn = eqn(mtp(3,'x'),15)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(mtp(3,'x'),15),
          eqn('x',div(15,3)),
          eqn('x',5)
        ]
      end

      it 'reverses one step right subtraction' do
        eqn = eqn(sbt('x',3),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(sbt('x',3),5),
          eqn('x',add(5,3)),
          eqn('x',8)
        ]
      end

      it 'reverse conventionalised right subtraction' do
        equation = eqn(add('x',-3),5)
        result = equation.solve_one_var_eqn
        expect(result).to eq [
          eqn(add('x',-3),5),
          eqn('x',add(5,3)),
          eqn('x',8)
        ]
      end

      it 'reverses one step left subtraction' do
        eqn = eqn(sbt(5,'x'),3)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(sbt(5,'x'),3),
          eqn('x',sbt(5,3)),
          eqn('x',2)
        ]
      end

      it 'reverses conventionalised one step left subtraction' do
        equation = eqn(add(9,mtp(-1,'x')),3)
        result = equation.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(9,mtp(-1,'x')),3),
          eqn('x',sbt(9,3)),
          eqn('x',6)
        ]
      end

      it 'reverses one step right division' do
        eqn = eqn(div('x',3),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(div('x',3),5),
          eqn('x',mtp(5,3)),
          eqn('x',15)
        ]
      end

      it 'reverses one step left division' do
        eqn = eqn(div(6,'x'),3)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(div(6,'x'),3),
          eqn('x',div(6,3)),
          eqn('x',2)
        ]
      end
    end

    context '#two-steps' do
      it 'solves 2x + 3 = 15' do
        eqn = eqn(add(mtp(2,'x'),3),15)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(mtp(2,'x'),3),15),
          eqn(mtp(2,'x'),sbt(15,3)),
          eqn(mtp(2,'x'),12),
          eqn('x',div(12,2)),
          eqn('x',6)
        ]
      end

      it 'solves 20 - 3x = 5' do
        eqn = eqn(sbt(20,mtp('x',3)),5)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(sbt(20,mtp('x',3)),5),
          eqn(mtp('x',3),sbt(20,5)),
          eqn(mtp('x',3),15),
          eqn('x',div(15,3)),
          eqn('x',5)
        ]
      end
    end

    context '#three-steps' do
      it 'solves 30/(16-2x) = 3' do
        eqn = eqn(div(30,sbt(16,mtp(2,'x'))),3)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(div(30,sbt(16,mtp(2,'x'))),3),
          eqn(sbt(16,mtp(2,'x')),div(30,3)),
          eqn(sbt(16,mtp(2,'x')),10),
          eqn(mtp(2,'x'),sbt(16,10)),
          eqn(mtp(2,'x'),6),
          eqn('x',div(6,2)),
          eqn('x',3)
        ]
      end
    end

    context '#four-steps' do
      it 'solves 9 + 36 / (7x - 2) = 12' do
        eqn = eqn(add(9,div(36,sbt(mtp(7,'x'),2))),12)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(9,div(36,sbt(mtp(7,'x'),2))),12),
          eqn(div(36,sbt(mtp(7,'x'),2)),sbt(12,9)),
          eqn(div(36,sbt(mtp(7,'x'),2)),3),
          eqn(sbt(mtp(7,'x'),2),div(36,3)),
          eqn(sbt(mtp(7,'x'),2),12),
          eqn(mtp(7,'x'),add(12,2)),
          eqn(mtp(7,'x'),14),
          eqn('x',div(14,7)),
          eqn('x',2)
        ]
      end

      it 'solves conventionalised 9 + 36 / (7x - 2) = 12' do
        eqn = eqn(add(9,div(36,add(mtp(7,'x'),-2))),12)
        result = eqn.solve_one_var_eqn
        expect(result).to eq [
          eqn(add(9,div(36,add(mtp(7,'x'),-2))),12),
          eqn(div(36,add(mtp(7,'x'),-2)),sbt(12,9)),
          eqn(div(36,add(mtp(7,'x'),-2)),3),
          eqn(add(mtp(7,'x'),-2),div(36,3)),
          eqn(add(mtp(7,'x'),-2),12),
          eqn(mtp(7,'x'),add(12,2)),
          eqn(mtp(7,'x'),14),
          eqn('x',div(14,7)),
          eqn('x',2)
        ]
      end
    end
  end
end
