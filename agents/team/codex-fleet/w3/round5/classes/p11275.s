# n=5 model=out iset=I1 prefix14_class=11275
mov S0, P3
cmp P0, P1
mov S1, P0
cmovg S1, P1
cmovl P0, P1
cmp S0, P2
cmovge P3, P2
cmovl S0, P2
cmp S0, P0
mov S2, P3
cmovle P1, P0
cmovle P0, S0
cmovle S0, P1
cmp S1, S2
