# n=5 model=out iset=I1 prefix14_class=2742
mov S1, P0
cmp S1, P2
cmovge S1, P2
cmovg P2, P0
mov S2, P1
cmp P3, P1
cmovl P1, P3
cmovl P3, S2
cmp P3, P2
mov P0, P1
cmovle S0, P3
cmovle P3, P2
cmovle P2, S0
mov P3, P2
