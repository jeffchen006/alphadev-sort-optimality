# n=5 model=out iset=I1 prefix14_class=13299
cmp P3, P2
cmovle S1, P3
cmovl P3, P2
mov S2, P0
cmovle P2, S1
cmp P1, P0
cmovle P0, P1
mov S0, P0
cmovl P1, S2
cmp S0, P2
cmovg P0, P2
cmovge P2, S0
mov S0, P1
cmp S0, P3
