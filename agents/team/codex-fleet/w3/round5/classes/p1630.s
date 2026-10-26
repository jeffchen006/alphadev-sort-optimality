# n=5 model=out iset=I1 prefix14_class=1630
cmp P2, P3
mov S2, P1
cmovg S0, P2
cmovle S0, P3
cmovg P2, P3
cmp P0, P1
cmovl S2, P0
cmovge P1, P0
cmp P2, S2
mov P0, S2
cmovle P0, P2
cmovl P2, S2
mov S1, S0
cmp S0, P1
