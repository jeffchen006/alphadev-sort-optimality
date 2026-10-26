# n=5 model=out iset=I1 prefix14_class=13739
cmp P3, P1
mov S0, P0
cmovle S1, P1
cmovl P1, P3
cmovl P3, S1
cmp S0, P2
cmovge P0, P2
cmovg P2, S0
mov S0, P2
cmp P2, P3
cmovge S0, P3
cmovle P2, P3
mov P2, P1
cmp P2, P0
