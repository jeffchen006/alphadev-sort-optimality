# n=5 model=out iset=I1 prefix14_class=1238
cmp P2, P3
cmovle S0, P3
cmovl P3, P2
mov S1, P0
cmovge S0, P2
cmp P0, P1
mov P2, S0
cmovl S1, P1
cmovge P0, P1
cmovle P1, P0
cmp S0, S1
cmovg P2, S1
cmovg S1, S0
mov S2, P2
