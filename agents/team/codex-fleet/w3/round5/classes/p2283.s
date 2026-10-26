# n=5 model=out iset=I1 prefix14_class=2283
cmp P0, P2
mov S0, P3
cmovg S1, P2
cmovle S1, P0
cmovl P0, P2
mov S2, P0
cmp S0, P1
cmovle S0, P1
cmovge P3, P1
cmp S2, S0
cmovle P0, S0
mov P0, P3
cmovl S0, S2
cmp S1, P0
