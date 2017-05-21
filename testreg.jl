using Base.Test

include("reg.jl");
using Reg;

a = Reg8(10);

@test a.val == 10;
@test (a + a).val == 20;
@test (Reg8(255)+ Reg8(1)) == Reg8(0);
