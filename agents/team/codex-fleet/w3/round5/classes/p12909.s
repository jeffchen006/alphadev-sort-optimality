# n=5 model=out iset=I1 prefix14_class=12909
cmp P3, P0
mov S1, P3
mov S0, P1
cmovge P3, P0
cmovle S1, P0
cmp S0, P2
cmovg P1, P2
mov S2, S1
cmovle S0, P2
cmp P1, P3
cmovle P0, P3
cmovl P3, P1
cmovl P1, P0
cmp S0, S2
