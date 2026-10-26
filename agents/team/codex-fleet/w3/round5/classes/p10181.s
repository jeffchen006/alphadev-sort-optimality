# n=5 model=out iset=I1 prefix14_class=10181
cmp P1, P2
cmovle S1, P1
mov S0, P0
cmovle P1, P2
cmovle P2, S1
cmp P0, P3
cmovg S0, P3
cmovl P0, P3
mov P3, P0
cmp P0, P1
cmovg P3, P1
cmovge P1, P0
mov S2, P3
cmp S0, P2
