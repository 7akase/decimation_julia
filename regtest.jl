using Base.Test

include("reg.jl");
using Reg;

a = Reg8(10);
b = RegVar(10,8);

@test a.val == 10;
@test (a + a).val == 20;
@test (Reg8(255)+ Reg8(1)) == Reg8(0);
@test a ++ a ++ a == RegVar(657930, 8 * 3)
@test b ++ b ++ b == RegVar(657930, 8 * 3)
@test b ++ a ++ b == RegVar(657930, 8 * 3)
