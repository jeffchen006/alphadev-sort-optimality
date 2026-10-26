# n=5 model=out iset=I1 prefix14_class=8386
cmp P3, P2
cmovl S2, P3
mov S0, P1
cmovle P3, P2
cmovl P2, S2
mov S1, P3
cmp S0, P0
cmovg S0, P0
cmovge P0, P1
mov P1, S0
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmp P1, P2
