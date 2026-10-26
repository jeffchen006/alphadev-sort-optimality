# n=5 model=out iset=I1 prefix14_class=13697
mov S2, P0
cmp P0, P3
mov S0, P2
cmovg S2, P3
cmovl P0, P3
cmp P1, P2
cmovge P2, P1
cmovle S0, P1
mov S1, S0
cmp S0, S2
cmovl S1, S2
cmovge S0, S2
cmp P2, P0
cmovge S2, S1
