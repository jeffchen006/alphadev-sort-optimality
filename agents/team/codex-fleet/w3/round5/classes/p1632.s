# n=5 model=out iset=I1 prefix14_class=1632
cmp P0, P3
mov S2, P1
cmovge S0, P0
cmovge P0, P3
cmovle S0, P3
cmp P2, P1
cmovl P1, P2
cmovg S2, P2
cmp P0, P1
cmovle P2, P0
cmovg P2, P1
cmovl P0, P1
mov P1, S0
cmp S0, S2
