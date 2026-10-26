# n=2 model=mem iset=I1 source=w10_partial_sat_translation
mov S0, P0
mov S1, P1
cmp S0, S1
cmovl S2, S0
cmovge S2, S1
mov P0, S2
cmovl S0, S1
mov P1, S0
