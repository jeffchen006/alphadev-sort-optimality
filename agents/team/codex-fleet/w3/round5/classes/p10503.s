# n=5 model=out iset=I1 prefix14_class=10503
mov S0, P3
mov S2, P1
cmp P2, S2
cmovle P1, P2
cmovg S2, P2
cmp S0, P0
mov P2, P1
cmovle S0, P0
cmovg P3, P0
cmp S0, S2
cmovle S1, S0
cmovl S0, S2
cmovl S2, S1
mov S0, S2
