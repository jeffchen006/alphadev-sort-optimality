# n=5 model=out iset=I1 prefix14_class=47
mov S2, P2
mov S0, P1
cmp P0, P1
cmovle S0, P0
cmovl P0, P1
cmp P3, S2
cmovge P2, P3
mov S1, S0
cmovle S2, P3
cmp S1, S2
cmovl S0, S2
mov P1, P0
cmovg S1, S2
cmp P0, P2
