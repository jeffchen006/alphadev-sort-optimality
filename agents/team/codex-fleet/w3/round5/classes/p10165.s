# n=5 model=out iset=I1 prefix14_class=10165
mov S2, P3
cmp P3, P0
cmovl P3, P0
cmovle P0, S2
mov S1, P2
cmp S1, P1
cmovge P2, P1
cmovg P1, S1
mov S2, P0
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
cmovle P3, S0
mov P3, P1
