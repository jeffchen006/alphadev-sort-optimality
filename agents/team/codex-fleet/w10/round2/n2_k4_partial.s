# n=2 R=3 model=out iset=I1 source=w10_partial_sat
cmp P0, P1
cmovl S0, P0
cmovge S0, P1
out 0, S0
cmovl P0, P1
out 1, P0
